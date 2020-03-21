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

``Multi-Task Learning'' denotes more than a model which can perform multiple tasks at inference time. Multi-Task Learning can be useful even when there is just **one** target task of interest. Especially with regards to small datasets, a Multi-Task model can beat out a model which was trained to optimize the performance of just one task. Moreover, Multi-Task Learning can be used even when there is one task explicitly labeled in the training data.

[^1]: Yes, there will be pictures of dogs!
[^2]: For a more complete overview of Multi-Task Learning itself: ruder2017overview

<br><br>

## An Introduction to Multi-Task Learning

<br><br>
<br><br>


