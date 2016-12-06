---
layout: post
title:  "Multilingual Deep Neural Net Acoustic Modeling with Kaldi"
date:   2016-11-30
categories: kaldi
comments: True
---

<img src="/misc/kaldi_text_and_logo.png" align="right" alt="logo" style="width: 400px;"/>

<br/>
<br/>
<br/>
<br/>

========================
<br/> 
THIS POST IS IN PROGRESS
<br/>
========================


If you want to take a step back, I have posts on [how to install Kaldi][kaldi-install] or some [miscellaneous Kaldi notes][kaldi-notes] which contain some documentation.

## Introduction

{% highlight bash %}
{% endhighlight %}


## Conclusion

I hope this was helpful!

If you have any feedback or questions, don't hesitate to leave a comment!


## Relevant Papers

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


### Ghoshal et al. (2013) [*Multilingual Training of Deep Neural Networks*][ghoshal-2013]

This paper investigates language-sequential training, where the hidden layers of a DNN get passed from one language to the next, fine-tuned on each language's data in sequence.


### Vu et al. (2014) [*Multilingual deep neural network based acoustic modeling for rapid language adaptation*][vu-2014]

This paper is co-authored by Dan Povey and explains Kaldi's approach to multilingual DNN AM training.


[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[kaldi-notes]: http://jrmeyer.github.io/kaldi/2016/02/01/Kaldi-notes.html
[heigold-2013]: http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/40807.pdf
[vu-2014]: https://pdfs.semanticscholar.org/df92/0708f2e8d075223f9169b6cb7126f9aba17d.pdf
[ghoshal-2013]: http://www.cstr.ed.ac.uk/downloads/publications/2013/Ghoshal_ICASSP2013.pdf
[bourlard-2011]: https://www.researchgate.net/profile/Philip_Garner/publication/230608454_Current_Trends_in_Multilingual_Speech_Processing/links/00b49537209f578796000000.pdf
[huang-2013]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.368.5160&rep=rep1&type=pdf