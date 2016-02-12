        ---
layout: post
title:  "A TensorFlow Tutorial: Email Classification"
date:   2016-02-01 22:03:04 -0700
categories: tutorial
comments: True
---


## Introduction

This tutorial is meant for those who want to get to know the *Flow* of TensorFlow. Ideally, you already know some of the *Tensor* of TensorFlow. That is, it's better if you have some handle of linear algebra and machine learning. 

Don't worry though, if you don't have that background you should still be able to follow this tutorial. If you're interested in learning more about the math, there's a ton of good places to get an introduction to the algorithms used in machine learning. For artificial neural nets [this one from Stanford][ufldl] is especially good.

## Email Classification

To ground this tutorial in some real-world application, we decided to use a common beginner problem from Natural Language Processing (NLP): email classification. The idea is simple - given an email you've never seen before, determine whether or not that email is **Spam** or not (aka **Ham**). 

For us humans, this is a pretty easy thing to do. If you open an email and see the words *Nigerian prince* or *weight-loss magic* in the first few lines, you don't need to read the rest of the email because you already know it's **Spam**. 

While this task is easy for humans, it's much harder to write a program that can correctly classify an email as **Spam** or **Ham**. You could collect a list of words you think are highly correlated with **Spam** emails, give that list to the computer, and tell the computer to check every email for those words. If the computer finds a word from the list in an email, then that email gets classified as **Spam**. If the computer did not find any of those words in an email, then the email gets classified as **Ham**.

Sadly, this simple approach doesn't work well. There's lots of "Spam" words you will miss, and some of the "Spam" words in your list will also occur in regular, **Ham** emails. Not only will it work poorly, it will take you a long time to compose a good list of **Spam** words by hand. Why don't we do something a little smarter by using machine learning? Instead of *telling* the program which words we think are important, let's let the program *learn* which words are important.

To tackle this problem, we start with a collection of sample emails (i.e. a text corpus). In this corpus, each email has already been labeled as **Spam** or **Ham**. Since we are making use of these labels in the training phase, this is a *supervised learning* task. This is called *supervised learning* because we are (in a sense) supervising the program as it learns what **Spam** emails *look like* and what **Ham** email *look like*. 

During the training phase, we present these emails and their labels to the program. For each email, the program says whether it thought the email was **Spam** or **Ham**. After the program makes a prediction, we tell the program what the label of the email *actually* was. Whenever the program was wrong, it changes its configuration so as to make a better prediction the next time around. This process is done iteratively until either the program can't do any better or we get impatient and just tell the program to stop.


## On to the Script

The beginning of our script starts with importing a few needed dependencies (Python packages and modules). If you want to see where these packages get used, just do a CTRL+F search for them in the script.

{% highlight python %}
################
### PREAMBLE ###
################

from __future__ import division
import tensorflow as tf
import numpy as np
import tarfile
import os
import matplotlib.pyplot as plt
import time
{% endhighlight %}


Next, we have some code for importing the data for our **Spam** and **Ham** emails. For the sake of this tutorial, we have pre-processed the emails to be in an easy to work with format. As such, you'll see in this following block of code we are expecting specific files like "data/trainX.csv". 

The **import_data()** function first checks if the data directory "data/" exists in your current working directory or not. If it doesn't exist, the code tries to unzip the tarred data from the file "data.tar.gz", which is expected to be in your current working directory. 

>You need to have either the "data/" directory or the tarred file "data.tar.gz" in your working directory for the script to work. The neural net does need data to train on after all.


{% highlight python %}
###################
### IMPORT DATA ###
###################

def csv_to_numpy_array(filePath, delimiter):
    return np.genfromtxt(filePath, delimiter=delimiter, dtype=None)

def import_data():
    if "data" not in os.listdir(os.getcwd()):
        # Untar directory of data if we haven't already
        tarObject = tarfile.open("data.tar.gz")
        tarObject.extractall()
        tarObject.close()
        print("Extracted tar to current directory")
    else:
        # we've already extracted the files
        pass

    print("loading training data")
    trainX = csv_to_numpy_array("data/trainX.csv", delimiter="\t")
    trainY = csv_to_numpy_array("data/trainY.csv", delimiter="\t")
    print("loading test data")
    testX = csv_to_numpy_array("data/testX.csv", delimiter="\t")
    testY = csv_to_numpy_array("data/testY.csv", delimiter="\t")
    return trainX,trainY,testX,testY

trainX,trainY,testX,testY = import_data()
{% endhighlight %}


Now that we can load in the data, let's move on to the code that sets our global parameters. These are values that are either (a) specific to the data set or (b) specific to the training procedure. Practically speaking, if you're using the provided email data set, you will only be interested in adjusting the training session parameters.


{% highlight python %}
#########################
### GLOBAL PARAMETERS ###
#########################

# DATA SET PARAMETERS
# Get our dimensions for our different variables and placeholders:
# numFeatures = the number of words extracted from each email
numFeatures = trainX.shape[1]
# numLabels = number of classes we are predicting (here just 2: Ham or Spam)
numLabels = trainY.shape[1]

# TRAINING SESSION PARAMETERS
# number of times we iterate through training data
# tensorboard shows that accuracy plateaus at ~25k epochs
numEpochs = 27000
# here we set the batch size to be the total number of emails in our training
# set... if you have a ton of data you can adjust this so you don't load
# everything in at once
batchSize = trainX.shape[0]
# a smarter learning rate for gradientOptimizer
# learningRate = tf.train.exponential_decay(learning_rate=0.001,
learningRate = tf.train.exponential_decay(learning_rate=0.0008,
                                          global_step= 1,
                                          decay_steps=trainX.shape[0],
                                          decay_rate= 0.95,
                                          staircase=True)
{% endhighlight %}

Next we have a block of code for defining our TensorFlow placeholders. These placeholders will hold our email data (both the features and labels), and help pass them along to different parts of the algorithm. You can think of placeholders as empty shells (i.e. empty tensors) into which we insert our data. As such, when we define the placeholders we need to give them shapes which correspond to the shape of our data. 

The way TensorFlow allows us to insert data into these placeholders is by "feeding" them. You if you do a CTRL+F search for "feed" you will see that this happening in the actual training step.

This is a nice feature of TensorFlow because we can create an algorithm which accepts data and knows something about the shape of the data while still being agnostic about the amount of data going in. This means that when we insert "batches" of data in training, we can easily adjust how many examples we train on in a single step without changing the entire algorithm. 

In TensorFlow terms, we build the computation graph and then insert data as we wish. This keeps a clean division between the computations of our algoritm and the data we're doing the computations on.

{% highlight python %}
####################
### PLACEHOLDERS ###
####################

# X = X-matrix / feature-matrix / data-matrix... It's a tensor to hold our email
# data. 'None' here means that we can hold any number of emails
X = tf.placeholder(tf.float32, [None, numFeatures])
# yGold = Y-matrix / label-matrix / labels... This will be our correct answers
# matrix. Every row has either [1,0] for SPAM or [0,1] for HAM. 'None' here 
# means that we can hold any number of emails
yGold = tf.placeholder(tf.float32, [None, numLabels])
{% endhighlight %}




[ufldl]: http://ufldl.stanford.edu/wiki/index.php/Neural_Networks
