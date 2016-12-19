---
layout: post
title:  "Deep Neural Net Acoustic Modeling with Kaldi"
date:   2016-12-15
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


If you want to take a step back and learn about Kaldi in general, I have posts on [how to install Kaldi][kaldi-install] or some [miscellaneous Kaldi notes][kaldi-notes] which contain some documentation.

## Introduction

{% highlight bash %}
{% endhighlight %}


## Conclusion

I hope this was helpful!

If you have any feedback or questions, don't hesitate to leave a comment!


## Relevant Papers

### Maas et al. (2013) [*Building DNN Acoustic Models for Large Vocabulary Speech Recognition*][maas-2014]

From the abstract:

> Building  neural  network  acoustic  models  requires  several
> design decisions including network architecture, size, and train-
> ing loss function. This paper offers an empirical investigation on
> which aspects of DNN acoustic model design are most important
> for speech recognition system performance. We report DNN clas-
> sifier performance and final speech recognizer word error rates,
> and  compare  DNNs  using  several  metrics  to  quantify  factors
> influencing differences in task performance.


Co-authors include Dan Jurafsky and Andrew Ng, among others. This is a longer paper (22 pages) and is a very thorough 

[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[kaldi-notes]: http://jrmeyer.github.io/kaldi/2016/02/01/Kaldi-notes.html
[maas-2014]: https://arxiv.org/pdf/1406.7806.pdf