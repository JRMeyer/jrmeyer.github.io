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

To ground this tutorial in some real-world application, we decided to use a common beginner problem from Natural Langauge Processing: email classification. The idea is simple - given an email you've never seen before, determine whether or not that email is **Spam** or not (**Ham**). This is a pretty easy thing for us humans to do. If you see the words *Nigerian prince* or *weight-loss magic* in the first few lines, you don't need to read the rest of the email because you know it's Spam. However, it's much harder to write a program that can detect **Spam** emails for you. 

You could collect a list of words you think are highly correlated with Spam emails, and then check every email for those words, but this won't work well. There's lots of words you will miss, and some of those words will occur in regular, **Ham** emails. Not only will it work poorly, it will take you a long time to compose a good list of **Spam** words by hand. Why don't we do something a little smarter by using machine learning? Instead of *telling* the program which words we think are important, let's let the program *learn* which words are important.

To tackle this problem, we start with a collection of sample emails (i.e. a text corpus). In this corpus, each email has already been labeled as "'Spam'" or **Ham**. Since we are making use of these labels in the training phase, this is a *supervised learning* task. This is called *supervised learning* because we are (in a sense) supervising the program as it learns what **Spam** emails *look like* and what **Ham** email *look like*. 

During the training phase, we present these labeled emails to the program. For each email, the program says whether it thought the email was **Spam** or **Ham**. After the program makes a prediction, we tell the program what the label of the email *actually* was. Whenever the program was wrong, it changes its configuration so as to make a better prediction the next time around. This process is done iteratively until either the program can't do any better or we get impatient and just tell the program to stop.

Things we will cover in this tutorial:

1. The idea 
2. thing 2 
3. thing 3

[ufldl]: http://ufldl.stanford.edu/wiki/index.php/Neural_Networks
