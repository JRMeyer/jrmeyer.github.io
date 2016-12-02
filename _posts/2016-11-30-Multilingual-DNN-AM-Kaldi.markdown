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

Bourlard et al. (2011) [*Current trends in multilingual speech processing*], a survey paper.

Heigold et al. (2013) [*Multilingual Acoustic Models Using Distributed Deep Neural Networks*][heigold-2013], a Google Research Paper on their approach.

Ghoshal et al. (2013) [*Multilingual Training of Deep Neural Networks*][ghoshal-2013], this paper investigates language-sequential training, where the hidden layers of a DNN get passed from one language to the next, fine-tuned on each language's data in sequence.

Vu et al. (2014) [*Multilingual deep neural network based acoustic modeling for rapid language adaptation*][vu-2014], a paper co-authored by Dan Povey which explains Kaldi's approach to multilingual DNN AM training.


[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[kaldi-notes]: http://jrmeyer.github.io/kaldi/2016/02/01/Kaldi-notes.html
[heigold-2013]:http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/40807.pdf
[vu-2014]:https://pdfs.semanticscholar.org/df92/0708f2e8d075223f9169b6cb7126f9aba17d.pdf
[ghoshal-2013]:http://www.cstr.ed.ac.uk/downloads/publications/2013/Ghoshal_ICASSP2013.pdf
[bourlard-2011]:http://s3.amazonaws.com/academia.edu.documents/43939925/Current_Trends_in_Multilingual_Speech_Pr20160321-13554-co75ru.pdf?AWSAccessKeyId=AKIAJ56TQJRTWSMTNPEA&Expires=1480700304&Signature=uk5%2FHJcN9Q%2BacktLKqv5vHsJmdM%3D&response-content-disposition=inline%3B%20filename%3DCurrent_trends_in_multilingual_speech_pr.pdf