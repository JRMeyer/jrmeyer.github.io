---
layout: post
title:  "Radu & Och (2015): Unsupervised Morphology Induction Using Word Embeddings"
date:   2016-01-20 22:03:04 -0700
categories: review
comments: True
---

=== POST IN PROGRESS ===

# Outline


## Introduction

Representing words in vector space can tell us a lot about their semantics and syntax. This paper shows that we can uncover morphological transformations from these high-dimensional vectors. 

This paper is different from past work because they don't assume any knowledge about the morphology, and don't use any parser (e.g. Morfessor) before embedding. The morphology is induced from the embeddings themselves.

The SkipGram model (Mikolov et al., 2013) is at the core of their method.

Using relations among related vectors, this study models prefix and sufix morphology.

Main contributions of this study:

1. the method is language agnostic
2. the method works for known words
3. the method can be applied to rare and unseen words

The method covers regularities and exceptions to morphological rules.

They present results from English, German, French, Spanish, Romanian, Arabic, and Uzbek.

## Previous Work

Representing words as vectors has worked well in various tasks. Vector representations are nice because they can be (1) trained in an unsupervised way and (2) tuned with labeled data. However, past work treats words as mono-morphemic units rather than possibly multi-morphemic. 

If past work ever incorporated affixes into their models, they used hand-tuned features.

There is some past work that used vector-space representations and morphemes, combining them to represent both known and unknown words.

If past work modeled morphemes, it was in a pre-processing step before the embeddings are generated. 

This current study uses the same vector-space embeddings to do the morphological analysis and represent the words.


## Morphology Induction using Embedding Spaces

Morphological transformations (e.g. *create* +ed = *created*) are learned from patterns in the word-embedding space.

### Morphological Transformations

This work only considers prefixes and suffixes.

Highlevel overview:

Given a finite vocabulary $$V$$:

1. Extract candidate prefix/suffix rules from $$V$$
2. Train embedding space $$E^n \subset \mathbb{R}^n$$ for all words in $$V$$
3. Evaluate quality of candidate rules in $$E^n$$
4. Generate lexicalized morphological transformations


#### Extract candidate rules from $$V$$

Given two words $$(w_1,w_2) \in V^2$$, find all possible prefixes and suffixes in the pair.

Examples of extracted candidate rules:

| $$\texttt{type:from:to}$$ | $$(w_1,w_2)$$ |
|:---------------------------|:---------------|
| $$\texttt{suffix:ed:ing}$$ | $$(crossed,crossing)$$ |
| $$\texttt{prefix:un:$\epsilon$}$$ | $$(unfriend,friend)$$ |
| $$\texttt{prefix:S:$\epsilon$}$$ | $$(Scope,cope)$$ |
{: align="center"}

<br>
As in these examples, sometimes there were errors.

#### Train embedding space

They trained an embedding space $$E^n$$ with a SkipGram model (Mikolov et al. 2013). It was very similar to [word2vec][word2vec].

#### Evaluate quality candidate rules

The support set for each candidate rule, $$r$$, is defined as:

$$ S_r = \{ (w_1,w_2) \in V^2 \mid w_1 \xrightarrow[]{r} w_2 \}$$

Where the rule applies to $$w_1$$ and results in $$w_2$$.

The evaluation function used to find the 'meaning-preservation property' of rule $$r$$ is defined as:

$$ Ev^F ((w_1, w_2), (w, w')) = F_E (w_2 , w_1 +  \uparrow d_w) $$

where

$$ (w_1, w_2), (w, w') \in S_r $$

and 

$$ \uparrow d_w = w' − w $$

$$F_E$$ is the cosine-similarity rank function in $$E^n$$.

In the author's own words:

>We can quantitatively measure the assertion 'car is to cars what dog is to dogs', as $$ rank_E(cars, car + \uparrow d_{dog\_}) $$


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




[word2vec]: code.google.com/p/word2vec

