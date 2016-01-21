---
layout: post
title:  "Summary and Thoughts on Radu & Och (2015): Unsupervised Morphology Induction Using Word Embeddings"
date:   2016-01-20 22:03:04 -0700
categories: review
comments: True
---


# Outline


## Introduction

Representing words in vector space can tell us a lot about their semantics and syntax. This paper shows that we can uncover morphological transformations from these high-dimensional vectors. 

This paper is different from past work because we don't assume any knowledge about the morphology.

The SkipGram model (Mikolov et al., 2013) is at the core of their method.

Using inferences from related vectors, this study models prefix and sufix morphology.

Main contributions of this study: (1) the method is language agnostic, (2) it works for known words in known languages (3) can be applied to rare and unseen words.

They present results from English, German, French, Spanish, Romanian, Arabic, and Uzbek.


## Previous Work

Representing words as vectors has gained a lot of ground recently in different tasks.

Vector representations are nice because they can be (1) trained in an unsupervised way and (2) tuned with labeled data.

However, past work treats words as mono-morphemic units rather than possibly multi-morphemic. 

If past work incorporated affixes into their models, they used hand-tuned features.

There is some past work that used vector-space representations and morphemes, combining them to represent both known and unknown words.

All past work incorporate morphemes (if they model them at all) in a pre-processing step before the embeddings are generated. 

This current study uses the same vector-space embeddings to do the morphological analysis and represent the words.


## Morphology Induction using Embedding Spaces
### Morphological Transformations

This work only considers prefixes and suffixes.

Highlevel overview:

Given a finite vocabulary $$V$$

1. Extract candidate prefix/suffix rules from $$V$$
2. Train embedding space $$E^n \subset \R^n$$ for all words in $$V$$
3. Evaluate quality of candidate rules in $$E^n$$
4. Generate lexicalized morphological transformations

#### Extract candidate rules from V
#### Train embedding space
#### Evaluate quality candidate rules
#### Generate lexicalized morphological transformations

### Inducing 1-to-1 Morphological Mappings
### Morphological Transformations for Rare and Unknown Words

## Empirical Results
### Quality of Morphological Analysis
#### Data
#### Results

### Quality of Morphological Analysis for Unknown/Rare Words
### Morphology and Training Data Size

## Conclusions and Future Work

[libgtk]: http://packages.ubuntu.com/precise/libgtk2.0-dev
[libasound2]: https://packages.debian.org/sid/libasound2-dev

