---
layout: post
title:  "An Overview of Multi-Task Learning in Speech Recognition"
date:   2020-03-21
categories: ASR
comments: True
---

<br><br>

## Roadmap

In this overview of Multi-Task Learning in Automatic Speech Recognition (ASR), we're going to cover a lot of ground quickly. First, we're going to define Multi-Task Learning and walk through a very simple example from image recognition[^1]. Then, once we have a base as to what Multi-Task Learning is and what constitutes a task, we will move into a survey of the speech recognition literature[^2].

The literature survey focuses on acoustic modeling in particular. Speech Recognition has a long history, but this overview is limited in scope to the Hybrid (i.e. DNN-HMM) and End-to-End approaches. Both approaches involve training Deep Neural Networks, and we will focus on how Multi-Task Learning has been used to train them. We will divide up the literature along monolingual and multilingual models, and then finally we will touch on Multi-Task Learning in other speech technologies such as Speech Synthesis and Speaker Verification.

"Multi-Task Learning" denotes more than a model which can perform multiple tasks at inference time. Multi-Task Learning can be useful even when there is just *one* target task of interest. Especially with regards to small datasets, a Multi-Task model can beat out a model which was trained to optimize the performance of just one task. Moreover, Multi-Task Learning can be used even when there is one task explicitly labeled in the training data.

[^1]: Yes, there will be pictures of dogs!
[^2]: For a more complete overview of Multi-Task Learning itself: [Ruder (2017)](https://ruder.io/multi-task/)

<br><br>

## An Introduction to Multi-Task Learning

### Definition

Before we can define *Multi-Task Learning*, we first need to define what counts as a *task*. Some researchers may define a task as a set of data and corresponding target labels (i.e. a task is merely $$(X,Y)$$). Other definitions may focus on the statistical function that performs the mapping of data to targets (i.e. a task is the function $$f: X \rightarrow Y$$). In order to be precise, in this overview a task is defined as the combination of data, targets, and mapping function.

<br><br>

A *task* is the combination of:

1. Data: $$X$$, a sample of data from a certain domain
2. Targets: $$Y$$, a sample of targets from a certain domain
3. Mapping Function: $$f: X \rightarrow Y$$, a function which maps data to targets 

<br><br>

 The *targets* can be distinct label categories represented by one-hot vectors (e.g. classification labels), or they can be $$N$$-dimensional continuous vectors (e.g. a target for regression)[^3].

[^3]: In reality these two kinds of targets are the same with regards to training neural networks via backpropagation. The targets for classification are just a special case of regression targets, where the values in the vector are $$1.0$$ or $$0.0$$.
  
Given this definition of *task}, in this overview we define Multi-Task Learning as a training procedure which updates model parameters such that the parameters optimize performance on multiple tasks in parallel[^4]. At its core, Multi-Task Learning is an approach to parameter estimation for statistical models[^5]. Even though we use multiple tasks during training, we will produce only one model. A subset of the model's parameters will be task-specific, and another subset will be shared among all tasks. Shared model parameters are updated according to the error signals of all tasks, whereas task-specific parameters are updated according to the error signal of only one task. It is important to note that a Multi-Task model will have both *task-dependent} and *task-independent} parameters. The main intuition as to why the Multi-Task approach works is the following: if tasks are related, they will rely on a common underlying representation of the data. As such, learning related tasks together will bias the shared parameters to encode robust, task-independent representations of the data. 

[^4]: An exception to this is Multi-Task Adversarial Learning, in which performance on an auxiliary task is encouraged to be as poor as possible. In domain adaptation, an example of this may be forcing a neural net to be blind to the difference between domains. The Adverserial auxiliary task would be classification of **domain-type**, and the weights would be updated in a way to increase error as much as possible.

[^5]: caruana1998multitask, caruana1996algorithms

Given this definition of \textit{task} and this definition of \textit{Multi-Task Learning}, we can start to think about the different ways in which a Multi-Task model can be trained. Probably the most common Multi-Task use-case is the classification of a single dataset $$(X)$$ as multiple sets of target labels $$(Y_{1}, Y_{2} \dots Y_{N})$$. This model will perform mappings from $$(X)$$ into each of the label spaces separately. Another approach is the classification of multiple datasets sampled from various domains $$(X_{1}, X_{2} \dots X_{N})$$ as their own, dataset-specific targets $$(Y_{1}, Y_{2} \dots Y_{N})$$. Less commonly, it is possible to classify multiple datasets using one super-set of labels. These different approaches are represented with regards to vanilla feed-forward neural networks in the following Figure (1).

<br><br>
<img src="/misc/figs/color-si-mo.png" align="left" style="width: 225px;"/>
<img src="/misc/figs/color-mi-so.png" align="center" style="width: 225px;"/>
<img src="/misc/figs/color-mi-mo.png" align="right" style="width: 200px;"/>
<center>**Figure 1**: Possible Neural Multi-Task Architectures. Black layers are task-independent layers, blue layers are task-dependent input layers, and red layers are task-dependent output layers. These figures are modified versions of a figure from heigold2013.</center>
<br><br>



 With regards to neural approaches (c.f. Figure (1), Multi-Task models are comprised of three component parts: (1) **shared hidden layers** which serve as a task-independent feature extractor; (2) &#x1F534; **task-specific output layers** which serve as task-dependent classifiers or regressors; (3) &#x1F535; **task-specific input layers** which serve as feature transformations from domain-specific to domain-general representations. Neural Multi-Task models will always have some hidden layers shared among tasks. This view of a Multi-Task neural network highlights the intuition behind the shared hidden layers - to encode robust representations of the input data.

With regards to domains in which we have very limited data (i.e. low-resource environments), Multi-Task parameter estimation promises gains in performance which do not require us to collect more in-domain data, as long as we can create new tasks. In the common scenario where an engineer has access to only a small dataset, the best way she could improve performance would be by collecting more data. However, data collection takes time and money. This is the promise of Multi-Task Learning in low-resource domains: if the engineer can create new tasks, then she does not need to collect more data.

<br><br>

