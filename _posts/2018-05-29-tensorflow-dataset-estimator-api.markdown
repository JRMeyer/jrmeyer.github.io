---
layout: post
title:  "How to Train (practically) any TensorFlow model from CSV data"
date:   2019-05-29
categories: MachineLearning
comments: True
---

<br/>

<img src="/misc/tf-logo.png" align="right" alt="logo" style="width: 225px;"/>

<br/>
<br/>



## Objectives

This post will guide you on how to take your data (in a CSV file) to a trained TensorFlow model of your choosing. I've decided to write this post because after spending many hours searching for this simple answer, I found that every post I found was too specific to one dataset to be usefully portable to my data.

You're not going to find any tricks or hacks here. The title to this blog post is so general because the TensorFlow developers have created a very general API for importing data and training standard models with it. If you follow all the suggestions of the official TensorFlow docs, you should come to the same conclusions I did. However, because it's so tempting to write code that works for your own data fast, taking the extra time to study the API and get something very generalizable is off-putting.

## Pre-requisites

1. Your data in CSV format. The reason I choose CSV data as the starting point is that most any data can be formatted as a CSV file. Getting from your raw data to a CSV file is on you, but once you get there, the rest is smooth sailing:)

2. A working, new version of TensorFlow installed.


## Datasets and Estimators

The official TensorFlow docs push hard for you to use their Dataset and Estimator APIs. The `Dataset` Class allows you to easily import, shuffle, transform, and batch your data. The Dataset API makes any pre-processing operation on your data just another part of the pipeline, and it's optimized for large, distributed datasets. Your entire pre-processing pipeline can be as simple as this:


```
dataset = (
    tf.data.TFRecordDataset(tfrecords_path)
    .map(parser)
    .shuffle(buffer=1024)
    .batch(32)
)
```


[tf-docs]: https://www.tensorflow.org/versions/r0.7/get_started/basic_usage.html
