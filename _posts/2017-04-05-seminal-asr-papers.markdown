---
layout: post
title:  "Seminal Papers in ASR"
date:   2017-04-05
categories: asr
comments: True
published: True
---




## Context-Dependent Triphone State-Tying

### Young et al. (1994) [*Tree-based state tying for high accuracy acoustic modelling*][young-1994]

<br/>
<br/>


## MLLR Adaptation

### Leggetter & Woodland (1995) [*Maximum likelihood linear regression for speaker adaptation of continuous density hidden Markov models*][leggetter-1995]

> The parameters of the HMM system are adapted using transforms which are estimated in a maximum likelihood framework. The least squares regression calculation used by Hewett (1989) has been replaced by maximum likelihood estimation taking into account different state distributions. If only a small amount of adaptation data is presented a global transform is used for all models in the system, and if more data is available the number of transforms is increased. This ensures that all model states can be adapted even if no model-specific data is available. We refer to this method as maximum likelihood linear regression (MLLR) adaptation. The statistics used to estimate the transform matrices are generated using a forward–backward alignment of the adaptation data. Hence, the method has clear links with standard Baum–Welch HMM training.

<br/>
<br/>


## Hybrid DNN-HMM Approach

### Dahl et al. (2012) [*Context-Dependent Pre-Trained Deep Neural Networks for Large-Vocabulary Speech Recognition*][dahl-2012]


















<!--
## Multilingual Acoustic Modeling

### Bourlard et al. (2011) [*Current trends in multilingual speech processing*][bourlard-2011]

A survey paper (Section 5 relevant to multilingual DNN AMs)


### Heigold et al. (2013) [*Multilingual Acoustic Models Using Distributed Deep Neural Networks*][heigold-2013]

A Google Research Paper on their approach.

<br/>

<center><img src="/misc/heigold-2013-dnn.png" alt="Heigold (2013) DNN Architecture" style="width: 800px;"/>
</center>

<br/>


<br/>

<center><img src="/misc/heigold-2013-wer.png" alt="Heigold (2013) WER Table" style="width: 600px;"/>
</center>

<br/>
<br/>


### Huang et al. (2013) [*Cross-Language Knowledge Transfer Using Mulitlingual Deep Neural Network with Shared Hidden Layers*][huang-2013].

Below is the architecture of the DNN proposed by Huang et al. (2013).The image is taken directly from the paper. As you can see, the hidden layers are shared but each language has its own softmax classifier for the output. The idea being that the shared hidden layers learn something about phonemes in general, and the individual classifiers on the output learn language-specific phones. 

<br/>

<center><img src="/misc/huang-2013-dnn.png" alt="Huang (2013) DNN Architecture" style="width: 800px;"/>
</center>

<br/>

As you can see in the table below, this shared hidden layer multilingual training procedure always reduces WER, even when a large amount of target language data is present.

<br/>

<center><img src="/misc/huang-2013-wer.png" alt="Huang (2013) WER Table" style="width: 600px;"/>
</center>

<br/>
<br/>



### Huang et al. (2014) [*Multilingual Deep Neural Network*][huang-2014]. 

This is a United States patent application from Microsoft which is essentially a repetition of the Huang et al. (2013) paper. However, since it is a patent application is is more thorough with many more figures and outlines of the architecture.



### Ghoshal et al. (2013) [*Multilingual Training of Deep Neural Networks*][ghoshal-2013]

This paper investigates language-sequential training, where the hidden layers of a DNN get passed from one language to the next, fine-tuned on each language's data in sequence.


### Vu et al. (2014) [*Multilingual deep neural network based acoustic modeling for rapid language adaptation*][vu-2014]

This paper is co-authored by Dan Povey and explains Kaldi's approach to multilingual DNN AM training.

-->



[young-1994]: http://ucrel.lancs.ac.uk/acl/H/H94/H94-1062.pdf
[leggetter-1995]: http://www.eecs.yorku.ca/course_archive/2004-05/F/6328/Reading/Leg_MLLR.pdf
[heigold-2013]: http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/40807.pdf
[vu-2014]: https://pdfs.semanticscholar.org/df92/0708f2e8d075223f9169b6cb7126f9aba17d.pdf
[ghoshal-2013]: http://www.cstr.ed.ac.uk/downloads/publications/2013/Ghoshal_ICASSP2013.pdf
[bourlard-2011]: https://www.researchgate.net/profile/Philip_Garner/publication/230608454_Current_Trends_in_Multilingual_Speech_Processing/links/00b49537209f578796000000.pdf
[huang-2013]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.368.5160&rep=rep1&type=pdf
[huang-2014]: https://www.google.com/patents/US20140257805

[dahl-2012]: https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/dbn4lvcsr-transaslp.pdf