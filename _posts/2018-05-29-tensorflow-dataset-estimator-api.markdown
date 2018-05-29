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

You're not going to find any tricks or hacks here. The title to this blog post is so general because the TensorFlow developers have done all the work and created a very general API for importing data and training standard models. If you follow all the suggestions of the official TensorFlow docs, you should come to the same conclusions I did. However, it's tempting to write code that quickly works for only your own data. If you take a little extra time to study the API and write something generalizable, you will save yourself headaches in the future. If you follow the instructions I show here, you will be able to easily train one model architecture on different datasets, or you can train multiple models with your one dataset.

## Pre-requisites

1. A working, new version of TensorFlow installed.
2. Your data in CSV format. The reason I choose CSV data as the starting point is that most any data can be formatted as a CSV file. Getting from your raw data to a CSV file is on you, but once you get there, the rest is smooth sailing:) From CSV data, I show you how to get your data into `tfrecords` format, which is the prefered TF data format. So, if your data is already in tfrecords, you're already ahead of the curve!



## Datasets and Estimators

The official TensorFlow docs push hard for you to use their [Dataset][tf-dataset] and [Estimator][tf-estimator] APIs. In general, if the docs explicitly tell you there is a preferred way to do something, you should do that!


### `tf.data.Dataset`

The `Dataset` Class allows you to easily import, shuffle, transform, and batch your data. The `Dataset` API makes any pre-processing operation on your data just another part of the pipeline, and it's optimized for large, distributed datasets. Your entire pre-processing pipeline can be as simple as this:


```
dataset = (
    tf.data.TFRecordDataset(tfrecords_path)
    .map(parser)
    .shuffle(buffer=1024)
    .batch(32)
)
```


### `tf.estimator.Estimator`

The `Estimator` class gives you an API for interaction with your model. It's like a wrapper for a model which allows you to train, evaluate, and export the model as well as make inferences on new data. Usually you won't be interacting directly with the base class `tf.estimator.Estimator`, but rather with the `Estimator` Classes which directly inherit from it, such as the [`DNNClassifier`][tf-dnnclassifier] Class. There are a whole set of pre-defined, easy to use `Estimator`s which you can start working with out of the box, such as [`LinearRegressor`][tf-linearregressor] or [`BoostedTreesClassifier`][tf-boostedtreesclassifier]


[tf-boostedtreesclassifier]: https://www.tensorflow.org/api_docs/python/tf/estimator/BoostedTreesClassifier
[tf-linearregressor]: https://www.tensorflow.org/api_docs/python/tf/estimator/LinearRegressor
[tf-dnnclassifier]: https://www.tensorflow.org/api_docs/python/tf/estimator/DNNClassifier
[tf-estimator]: https://www.tensorflow.org/api_docs/python/tf/estimator/Estimator
[tf-dataset]: https://www.tensorflow.org/api_docs/python/tf/data/Dataset
[tf-docs]: https://www.tensorflow.org/versions/r0.7/get_started/basic_usage.html
