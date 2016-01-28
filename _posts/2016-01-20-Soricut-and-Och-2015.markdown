---
layout: post
title:  "Soricut & Och (2015): Unsupervised Morphology Induction Using Word Embeddings"
date:   2016-01-20 22:03:04 -0700
categories: review
comments: True
---


## Introduction

Representing words in vector space can tell us a lot about a word's syntax and semantics. This paper shows that one can uncover morphological transformations (i.e. suffixation and prefixation) from these vectors. 

This paper is different from past work because they don't assume any knowledge about the morphology, and don't use any parser (e.g. Morfessor) before embedding. The morphology is induced from the embeddings themselves. The SkipGram model (Mikolov et al., 2013) is at the core of their method.

Main contributions of this study:

1. the method is language agnostic
2. the method works for known words
3. the method can be applied to rare and unseen words

They present results from English, German, French, Spanish, Romanian, Arabic, and Uzbek.


## Previous Work

Vector representations are nice because they can be (1) trained in an unsupervised way and (2) tuned with labeled data. However, past work treats words as mono-morphemic units rather than possibly multi-morphemic. If past work ever incorporated affixes into their models, they used hand-tuned features.

There is some past work that used vector-space representations and morphemes, combining them to represent both known and unknown words, but it was in a pre-processing step before the embeddings are generated. 

This current study uses the same vector-space to do the morphological analysis and represent the words.


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

Given two words $$(w_1,w_2) \in V^2$$, find all possible prefixes and suffixes in the pair, given a character-length limitation.

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

To avoid over-applying these morphological rules (e.g. applying $$\texttt{suffix:ly:$\epsilon$}$$ to *only* to get *on*), they restrict application to word pairs which passed the meaning-preservation criterion.

The direction vectors for different subsets of the support set are computed as follows: 

1. Find the direction vector which best describes the largest number of pairs in $$S$$. 
2. Remove those pairs from $$S$$ which are described by the rule found in (1).
3. Find a new best direction vector which explains the most pairs in the new $$S$$. 

This process repeats until the best direction vector explains too small a set of pairs (a predefined number, 10).

This method allows us to capture ambiguous rules, like $$\texttt{suffix:s:$\epsilon$}$$ which applies to verbs like (walks,walk) as well as nouns like (cats,cat).

Here's how I understand the algorithm:

For a candidate rule, $$r$$, (e.g. $$r$$ = suffix:ed:ing), do the following to determine how likely it is that $$r$$ is a real rule in the language:

For one pair of words, $$(w_1,w_2)$$, in the support set, $$S$$ of $$r$$ (e.g. $$(loved, loving)$$), take every other pair of words in $$r$$'s support set, $$(w,w')$$, one pair at a time and add the difference between $$w$$ and $$w'$$ (i.e. $$\uparrow d$$) to $$loved$$. 

Conceptually, if $$r$$ is a real rule then the support set will have lots of good examples of the rule, and the vector we get from adding $$\uparrow d$$ to $$loved$$ should be close in vector space to the vector for $$loving$$. We measure the distance between $$\uparrow d + loved$$ and $$loving$$ with cosine similarity. Using this algoritm, we iterate over all word pairs $$(w,w')$$ in the support set, $$S$$ of $$r$$. For example, if the authors capped the support set at 1,000 pairs of words per rule, then this iterations involves all 999 other word pairs besides the one pair in question, $$(w_1,w_2)$$. In this example of 1,000 rules, we would end up with a total of up to 999 cosines for a single word pair, $$(w_1,w_2)$$. 

Then we sum up all the attained cosines for that word pair. That sum of cosines is the $$t_{rank}$$ of that word pair. The $$t_{rank}$$ equation is shown below:

$$ t_{rank_{(w_1,w_2)}} = \Sum\limits_{(w_i,w_j) \in S_r} F_E (w_2, w_1 + (w_i-w_j)) $$

To get the *hit rate* for a candidate rule, we then count up how many pairs in the support set for that rule have a $$t_{rank}$$ over $$100$$, and divide that number by the total number of pairs of words in the support set. In the case that the support set had a total of 1000 word pairs, the denominator in this equation would be 100.

$$ hitRate_r = \frac{ number\ of\ rank_{(w_1,w_2)} < 100}{\left\vert{S}\right\vert}\ for\ (w_1,w_2)\ \in\ S_r $$


### Inducing 1-to-1 Morphological Mappings

The morphological rules generated above can be interpreted as a graph, where the nodes are words and edges are transformations. 

Taking this graph built from all transformations and words in $$V$$, there are a lot of redundancies in rules. We want to keep all the nodes (words), but throw out extra edges. For example the word pair *(create,creates)* could have rules $$\texttt{suffix:s:$\epsilon$}$$ or $$\texttt{suffix:ates:ate}$$. One obviously is better.


### Morphological Transformations for Rare and Unknown Words

Given some word which does not occur in $$V$$, $$w'$$, find the possible sequence of rules in the directed graph (generated in the previous section) which maps $$w'$$ onto an existing node, $$w$$. 


## Empirical Results

### Quality of Morphological Analysis

The model was evaluated on a word similarity task. If the word in question was found and trained in the SkipGram model, they simply used the existing vector representation. If the word was not in the original training set, then they morphologically decomposed it as outlined above and used the vector representation of the closest word which already existed in their directed graph. In either case, the similarity of two words was measured as the cosine between the two vectors.


#### Data

They used Wikipedia, GigaWord, and Web-scraping.


#### Results

On word similarity tasks, they out-performed all reviewed past works (even without taking into account the morphological rules for OOV words). They don't have results for Uzbek though.


### Quality of Morphological Analysis for Unknown/Rare Words

To test performance on OOV words, they threw out low frequency words from the data, trained a model, and tested performance on those low-frequency words. Of these held-out words, they had words with some mapping onto the directed graph generated, and other words without any mapping at all (e.g. common nouns in English). There should be an analysis for the former but not the latter. The results were mostly in the 80% and 90% range, with Arabic being the lowest at 69%.
 

### Morphology and Training Data Size

This technique on English benefitted from more training data, but more training data had little impact on the German language. 


## Conclusions and Future Work

Overall they did better than any other state-of-the-art models, but they comclude that some languages' morphology may require a more refined approach.


[word2vec]: code.google.com/p/word2vec

