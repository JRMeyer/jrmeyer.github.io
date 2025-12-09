---
layout: post
title:  "Kaldi Hyperparameter Cheatsheet"
date:   2019-08-17
categories: ASR
comments: True
---
<img src="/misc/kaldi_text_and_logo.png" align="right" style="width: 300px;"/>

## Introduction

The following is a cheatsheet for common hyperparameters in Kaldi.

If you're looking to get started with Kaldi, here's an [installation guide][install-kaldi] and [DNN training guide][train-kaldi]. If you'd like a simple, easy to understand Kaldi recipe, you can check out the [`easy-kaldi` GitHub repo][easy-kaldi]. You probably won't get state-of-the-art results with `easy-kaldi`, but you will hopefully be able to understand the pipeline.

If you're looking for more in-depth troubleshooting, check out [Kaldi Troubleshooting from Head-to-Toe][troubleshooting].

<br/>
<br/>

## Hyperparameter Cheatsheet 

The following parameter ranges are what I would recommend as a good starting place. However, what works for your data and your application may differ.

<br/>

### GMM-HMM Alignment

Each of these following steps depends on the previous step. If you have bad monophone alignments, you will have bad triphone alignments. If you have bad triphone alignments, then you will train a bad neural net. As such, you should take some time to tweak parameters on each stage, to make sure your model and alignments are good to pass on to the next stage.

The parameters listed here have two values associated with them, `N → M`. Good model parameters for your data should be somewhere in between the extremes of `N` and `M`, so I’d advise some binary search to find good settings for you. Optimize for number of training iterations only after you’ve gotten good numbers for `numleaves` and `totgauss`.

{% highlight bash %}
Monophones (steps/train_mono.sh)
boost_silence=1.25
num_iters= 20 → 40
totgauss= 1000 → 2000

Triphones (steps/train_deltas.sh)
boost_silence= 1.25
num_iters= 20 → 40
numleaves= 2000 → 5000
totgauss= 10000 → 50000

# Triphones + LDA + MLLT (steps/train_lda_mllt.sh)
--left-context= 2 → 10
--right-context= 2 → 10
num_iters= 20 → 40
numleaves= 2500 → 7500
totgauss= 15000 → 75000

# Triphones + LDA + MLLT + SAT (steps/train_sat.sh)
num_iters= 20 → 40
numleaves= 2500 → 10000
totgauss= 15000 → 200000
{% endhighlight %}

<br/>

### DNN Training

You should ideally be using `nnet3` instead of `nnet2`. At this point, `nnet3` is tried and tested more, and will have better support moving forward.

Long-skinny nets are better than short fat ones. Monitor your training progress with information from `compute_prob_train.*.log` and `compute_prob_valid.*.log`.

{% highlight bash %}
Number of epochs: 1 → 20
Number of Hidden Layers: 5 → 15
Dimension of Hidden Layers: 512 → 1280
Kind of Neural Network: TDNN or LSTM
Kind of non-linearity: ReLU or tanh
{% endhighlight %}

<br/>

### Decoding

There’s a speed / accuracy trade-off at decoding time. You can decode faster by considering fewer possible words / phrases, but if you don’t consider the correct word, then you’ve missed it.

{% highlight bash %}
max_active= 2000 → 7000
min_active= 50 → 200
beam= 5.0 → 15.0
lattice_beam= 1.0 → 8.0
{% endhighlight %}

<br/>
<br/>

## Conclusion


If you still are running into issues, look on `kaldi-help` to see if someone else has had your problem (often they have). As far as I know, `kaldi-help` is the only forum for these kinds of questions. Unfortunately, the atmosphere on `kaldi-help` can be unwelcoming to newcomers. If you post a question and get a critical response, don’t let it upset you. The forum can be un-welcoming, and it has nothing to do with you or your abilities to do good ASR! I was afraid to post on `kaldi-help` for a long time because of this atmosphere, and indeed my first post was not received kindly. Alternatively, you can post questions here on my blog. However, the community here is not as large as `kaldi-help`.

I hope this was helpful, and happy Kaldi-ing!

Let me know if you have comments or suggestions and you can always leave a comment below. 

[install-kaldi]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[train-kaldi]: http://jrmeyer.github.io/kaldi/2016/12/15/DNN-AM-Kaldi.html
[format-acc]: https://github.com/JRMeyer/multi-task-kaldi/blob/master/mtk/utils/format_accuracy_for_plot.sh
[plot-acc]: https://github.com/JRMeyer/multi-task-kaldi/blob/master/mtk/utils/plot_accuracy.py
[nnet2]: https://github.com/kaldi-asr/kaldi/blob/3f95ed9185d8f8f76f9fb71c915119bf8b945a66/egs/wsj/s5/steps/nnet2/train_pnorm.sh#L92
[nnet3]: https://github.com/kaldi-asr/kaldi/blob/3f95ed9185d8f8f76f9fb71c915119bf8b945a66/egs/wsj/s5/steps/nnet3/train_tdnn.sh#L92
[show-alignments]: https://github.com/kaldi-asr/kaldi/blob/master/src/bin/show-alignments.cc
[easy-kaldi]: https://github.com/JRMeyer/easy-kaldi
[wsj]: https://github.com/kaldi-asr/kaldi/blob/master/egs/wsj/s5/run.sh
[ctm]: https://github.com/kaldi-asr/kaldi/blob/master/egs/wsj/s5/steps/get_train_ctm.sh
[troubleshooting]: http://jrmeyer.github.io/asr/2019/08/17/Kaldi-troubleshooting.html
