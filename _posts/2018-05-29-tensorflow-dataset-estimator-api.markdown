---
layout: post
title:  "How to Train (practically) any Model from (practically) any Data with TensorFlow"
date:   2019-05-29
categories: MachineLearning
comments: True
---

<br/>

<img src="/misc/tf-logo.png" align="right" alt="logo" style="width: 225px;"/>

<br/>
<br/>
<br/>
<br/>

THIS POST IS IN PROGRESS

<br/>
<br/>
<br/>
<br/>


## Objectives

This post will guide you on how to take your data (in a CSV file) to a trained TensorFlow model of your choosing. I've decided to write this post because after spending many hours searching for this simple answer, I found that every post I found was too specific to one dataset to be usefully portable to my data.

You're not going to find any tricks or hacks here. The title to this blog post is so general because the TensorFlow developers have done all the work and created a very general API for importing data and training standard models. If you follow all the suggestions of the official TensorFlow docs, you should come to the same conclusions I did. However, it's tempting to write code that quickly works for only your own data. If you take a little extra time to study the API and write something generalizable, you will save yourself headaches in the future. If you follow the instructions I show here, you will be able to easily train one model architecture on different datasets, or you can train multiple models with your one dataset.

<br/>
<br/>



## Pre-requisites

1. A working, new version of TensorFlow installed.
2. Your data in CSV format. The reason I choose CSV data as the starting point is that most any data can be formatted as a CSV file. Getting from your raw data to a CSV file is on you, but once you get there, the rest is smooth sailing:) From CSV data, I show you how to get your data into `tfrecords` format, which is the prefered TF data format. So, if your data is already in tfrecords, you're already ahead of the curve!

<br/>
<br/>



## Data in CSV

For this post, I'm going to be working with my own labeled data. Each training data example is represented as a single row in the CSV file, where the first column represents the label (an integer), all the following columns represent the features for that example (floating point numbers). I'm working with audio (speech) data, and the features are something like amplitudes at various frequency ranges - not important to your task, but it may help to ground the example more. The labels (the first column) represent categories of speech sounds, for example, label 45 might be the vowel "oh" and label 7 might be the consonant "k".

Here's what four lines of my data CSV file look like (where the delimiter is a single space):

```
95 21.50192 -2.16182 -1.591426 0.06965831 0.6690025  ...  -0.7368361 -1.385849 0.7551874 -0.8878949 -0.4799456 
7 22.23698 -1.177924 -1.368747 -0.6289141 0.009075502  ... -0.9235415 -1.74792 0.2629939 -2.119366 -0.539937
45 22.83421 -0.9043457 -1.591426 -0.816999 -0.3035215  ...  -0.5301266 -1.456303 -0.1479924 -1.641482 -0.04098308 
27 -0.9376022 -0.05841255 0.3308391 -0.7141842 -0.3867566  ...  -1.263647 23.4316 -0.0009118451 -1.035212 -1.635385
```

<br/>
<br/>

## Convert CSV to TFRecords

`TFRecords` is the preferred file format for TensorFlow. These tfrecords files take up a lot of space on disk, but they can be easily sharded across machines, and the entire TensorFlow pipeline is optimized with tfrecords in mind. There are ways to read CSV files directly into Tensorflow, but having a tfrecords file on disk is better for reuse. Here I show you an example Python script to read in a `.csv` data file (as described above) and save to a `.tfrecords` file.

You can find the original version of the following `csv-to-records.py` on my GitHub [here][csv-to-tfrecords].

```
import tensorflow as tf
import numpy as np
import pandas
import sys


# 
# USAGE: $ python3 csv-to-tfrecords.py data.csv data.tfrecords
#


infile=sys.argv[1]
outfile=sys.argv[2]

csv = pandas.read_csv(infile, header=None).values


with tf.python_io.TFRecordWriter(outfile) as writer:
    for row in csv:
        
        ## READ FROM CSV ##
        
        # row is read as a single char string of the label and all my floats, so remove trailing whitespace and split
        row = row[0].rstrip().split(' ')
        # the first col is label, all rest are feats
        label = int(row[0])
        # convert each floating point feature from char to float to bytes
        feats = np.array([ float(feat) for feat in row[1:] ]).tostring()

        ## SAVE TO TFRECORDS ##

        # A tfrecords file is made up of tf.train.Example objects, and each of these
        # tf.train.Examples contains one or more "features"
        # use SequenceExample if you've got sequential data
        
        example = tf.train.Example()
        example.features.feature["feats"].bytes_list.value.append(feats)
        example.features.feature["label"].int64_list.value.append(label)
        writer.write(example.SerializeToString())
```


There's a good amount of resources on tfrecords out there, so if you have more questions you should check out the official TF docs on [reading data][reading-data], [Python-IO][python-io], and [importing data][importing-data].

<br/>
<br/>


## Pause

If you've gotten to this point, you should have successfully converted your data and saved it in `TFRecords` format. Take a pause and pat yourself on the back, because you've accomplished the most time-consuming and boring part of machine learning: data formatting.

Now that you have your data in a format TensorFlow likes, we need to read that data in and train some models. Before we jump into training code, you'll want a little background on TensorFlow's awesome APIs for working with data and models: `tf.data` and `tf.estimator`.


<br/>
<br/>

## Datasets and Estimators

The official TensorFlow docs push hard for you to use their [Dataset][tf-dataset] and [Estimator][tf-estimator] APIs. In general, if the docs explicitly tell you there is a preferred way to do something, you should do that because all the newest features will surely work for this format but maybe not others.


<br/>

### [`tf.data.Dataset`][tf-dataset]

The `Dataset` Class allows you to easily import, shuffle, transform, and batch your data. The `Dataset` API makes any pre-processing operation on your data just another part of the pipeline, and it's optimized for large, distributed datasets. Your entire pre-processing pipeline can be as simple as this:


```
dataset = (
    tf.data.TFRecordDataset('/your/path/to/data/my-data.tfrecords')
    .map(parser)
    .shuffle(buffer=1024)
    .batch(32)
)
```

In the above definition of `dataset`, you can see there's a line where you point TensorFlow to your data on disc, and read the data via `tf.data.TFRecordDataset`. The `.shuffle()` and `.batch()` functions are optional, but you will need the `.map()` function.

The `.map()` function provides the methods for parsing your data into meaningful pieces like "labels" and "features". However, `.map()` is a super general function, and it doesn't know anything about your data, so we have to pass a special parsing function which `.map()` then applies to the data. This `parser` function is probably the main thing you have to create for your own dataset, and it should exactly mirror the way you saved your data to TFRecords above with the `tf.Example` object (in the CSV to TFRecords section).


Here's an example of such a `parser` function:

```
def parser(record):
    '''
    This is a parser function. It defines the template for
    interpreting the examples you're feeding in. Basically, 
    this function defines what the labels and data look like
    for your labeled data. 
    '''

    # the 'features' here include your normal data feats along
    # with the label for that data
    features={
      'feats': tf.FixedLenFeature([], tf.string),
      'label': tf.FixedLenFeature([], tf.int64),
    }

    parsed = tf.parse_single_example(record, features)

    # some conversion and casting to get from bytes to floats and ints
    feats= tf.convert_to_tensor(tf.decode_raw(parsed['feats'], tf.float64))
    label= tf.cast(parsed['label'], tf.int32)

    # since you can have multiple kinds of feats, you return a dictionary for feats
    # but only an int for the label
    return {'feats': feats}, label
```

To get into the details of this function and how you can define one for your data, take a look at the [official parse function docs][parse-fn]. Remember that if you have labeled training data, the `features` definition above includes the data features (`feats`) as well as the labels (`label`). If you're doing something like k-means clustering (where labels aren't used), you won't return a label.






<br/>



### [`tf.estimator.Estimator`][tf-estimator]

The `Estimator` class gives you an API for interaction with your model. It's like a wrapper for a model which allows you to train, evaluate, and export the model as well as make inferences on new data. Usually you won't be interacting directly with the base class `tf.estimator.Estimator`, but rather with the `Estimator` Classes which directly inherit from it, such as the [`DNNClassifier`][tf-dnnclassifier] Class. There are a whole set of pre-defined, easy to use `Estimator`s which you can start working with out of the box, such as [`LinearRegressor`][tf-linearregressor] or [`BoostedTreesClassifier`][tf-boostedtreesclassifier]

You can instantiate an `Estimator` object with minimal, readable code. If you decide to use the pre-existing `Estimator`s from TensorFlow (i.e. "pre-canned" models), you can get started without digging any deeper than the `__init__()` function! I've defined a 4-layer Deep Neural Network which accepts as input my input data (377-dimensional feature vectors) and predicts one of my 96 classes as such:

```
DNNClassifier = tf.estimator.DNNClassifier(

   # for a DNN, this feature_columns object is really just a definition
   # of the input layer
   feature_columns = [tf.feature_column.numeric_column(key='feats',
                                                       shape=(377,),
                                                       dtype=tf.float64)],

   # four hidden layers with 256 nodes in each layer
   hidden_units = [256, 256, 256, 256],
   
   # number of classes (aka number of nodes on the output layer)
   n_classes = 96,

)
```

We've just defined a new DNN Classifier with an input layer (`feature_columns`), four hidden layers (`hidden_units`), and an output layer (`n_classes`). Pretty easy, yeah?


You will probably agree that each of these three arguments is very clear expect for maybe the `feature_columns` argument. You can think of "feature_columns" as being identical to "input_layer". However, `feature_columns` allows you to do a whole lot of pre-processing that a traditional input layer would never allow. The [official documentation on `feature_columns`][tf-feature_columns] is really good, and you should take a look. In a nutshell, think of these `feature_columns` as a set of instructions for how to squeeze your raw data into the right shape for a neural net (or whatever model you're training). Neural nets cannot take as input words, intergers, or anything else that isn't a floating point number.

The `feature_columns` API helps you not only get your data into floats, but it helps you find floats that actually make sense for your task at hand. You can easily encode words or categories as one-hot vectors, but one-hot vectors are not practical if you have a billion different words in your data. Instead of using [one-hot vector `feature_columns`][tf-one_hot], you can use the `feature_column` type [`embedding_column`][tf-embedding_column] to find a lower-dimensional representation of your data. In the example above, I use the [`feature_column.numeric_column`][tf-numeric_column] because my input data is already encoded as floating point numbers.














[parser-fn]: https://www.tensorflow.org/programmers_guide/datasets#preprocessing_data_with_datasetmap
[tf-numeric_column]: https://www.tensorflow.org/api_docs/python/tf/feature_column/numeric_column
[tf-one_hot]: https://www.tensorflow.org/api_docs/python/tf/feature_column/categorical_column_with_vocabulary_list
[tf-embedding_column]: https://www.tensorflow.org/api_docs/python/tf/feature_column/embedding_column
[tf-feature_columns]: https://www.tensorflow.org/get_started/feature_columns
[tf-boostedtreesclassifier]: https://www.tensorflow.org/api_docs/python/tf/estimator/BoostedTreesClassifier
[tf-linearregressor]: https://www.tensorflow.org/api_docs/python/tf/estimator/LinearRegressor
[tf-dnnclassifier]: https://www.tensorflow.org/api_docs/python/tf/estimator/DNNClassifier
[tf-estimator]: https://www.tensorflow.org/api_docs/python/tf/estimator/Estimator
[tf-dataset]: https://www.tensorflow.org/api_docs/python/tf/data/Dataset
[tf-docs]: https://www.tensorflow.org/versions/r0.7/get_started/basic_usage.html
[csv-to-tfrecords]: https://github.com/JRMeyer/kaldi-tf/blob/master/csv-to-tfrecords.py
[reading-data]: https://www.tensorflow.org/versions/r1.0/programmers_guide/reading_data#file_formats
[python-io]: https://www.tensorflow.org/versions/r1.0/api_guides/python/python_io#tfrecords_format_details
[importing-data]: https://www.tensorflow.org/programmers_guide/datasets#consuming_tfrecord_data