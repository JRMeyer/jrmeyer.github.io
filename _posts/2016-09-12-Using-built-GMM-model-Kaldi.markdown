---
layout: post
title:  "How to use an Existing GMM Recognizer for Decoding in Kaldi"
date:   2016-09-12
categories: ASR
comments: True
redirect_from: "/kaldi/2016/09/12/Using-built-GMM-model-Kaldi.html"
---

<img src="/misc/kaldi_text_and_logo.png" align="right" alt="logo" style="width: 400px;"/>

<br/>
<br/>
<br/>
<br/>

This post is essentially a walk through of [this shell script]({{ site.url }}/misc/gmm-decode.sh).

## Introduction

If you're reading this, I'm assuming that you've already [downloaded and installed Kaldi][kaldi-install] and successfully trained a GMM acoustic model along with a decoding graph. 

If you've run one of the Kaldi **run.sh** scripts from the example directory **egs/**, then you should be ready to go.

This post was prompted by a comment on my [Kaldi notes][kaldi-notes] post, which basically asked, "Now that I've trained a [GMM] model, how can I start using it?". I think this is a very relevant question for the people who want to use Kaldi to create and implement a speech recognition system for some application. The Kaldi scripts are currently set up in a researcher-focused way, and so I think this more applied question is a good one. With this in mind, I decided to write a small post on how to use an existing Kaldi model and graph to generate transcriptions for some new audio.

We normally generate transcriptions for new audio with the Kaldi testing and scoring scripts, so I just simply dug out the most important parts of these scripts to demonstrate in a concise way how decoding can work. 

What you see here is what I gather to be the *simplest* way to do decoding in Kaldi - it is by no means garanteed to be the *best* way to do decoding.


## Things you need

{% highlight bash %}
# INPUT:
#    transcriptions/
#        wav.scp
#
#    config/
#        mfcc.conf
#
#    experiment/
#        triphones_deldel/
#            final.mdl
#
#            graph/
#                HCLG.fst
#                words.txt
{% endhighlight %}

### wav.scp

The first file you need is **wav.scp**. This is the only file that you need to make for your new audio files. All the other files listed below should have already been created during the training phase.

This should be the same format as the **wav.svp** file generated during training and testing. It will be a two-column file, with the utterance ID on the left column and the path to the audio file on the right column.

I'm just going to decode one audio file, so my **wav.scp** file is one line long, and it looks like this:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/transcriptions$ cat wav.scp 
atai_45 input/audio/atai_45.wav
{% endhighlight %}

### mfcc.conf

Next, you should have a configuration file specifying how to extract MFCCs. You need to extract the exact same number of features for this new audio file as you did in training. If not, the existing GMM acoustic model and new audio feature vectors will have a different number of parameters. Comparing these two would be like asking where a 3-D point exists in 2-D space, it doesn't make sense. So, you don't need to adjust anything in the config file. I used MFCCs, and my config file looks like this:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/config$ cat mfcc.conf 
--sample-frequency=16000
--num-mel-bins=40 # similar to Google's setup.
--frame-length=25 # the default is 25
--frame-shift=10 # default is 10
--high-freq=0 # relative to Nyquist (ie. 8000 +/- x for 16k sampling rate)
--low-freq=0 # low cutoff frequency for mel bins
--num-ceps=13
--window-type=hamming # Dans window is default
--use-energy=true
{% endhighlight %}

### final.mdl

Next, you need a trained GMM acoustic model, such as **final.mdl**. This should have been produced in your training phase, and should be located somewhere like **egs/your-model/your-model-1/exp/triphones_deldel/final.mdl**. It doesn't make too much sense to a human, but here's what the head of the file looks like:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/experiment/triphones_deldel$ head final.mdl 
B<TransitionModel> <Topology> 


 ����@?�>@?�>@?�>�����>�>�>�>�>�>�>�>�>�>�>�>�>�>�>�>@?�>����</Topology> <Triples> x""5;BF5;BF5;BFPPP   -,21		)	D
	
	
	
         

 

 Q
      
        
         %
              
                 
                9

'E&<=<=J.M*$OC:033++N87/A/A>(G#@!4LK?I6</Triples> <LogProbs> FV �b���
WE���r��r��r��r�����g�����ɿr��r��r��r��u޾���K��r��K��r��K��r����V�$�E�׽�Z8��޳u���V�$���V�$���V�$�K��r����V�$���V�$���V�$�K��r����V�$�([�F�@Bپ�쇿��V�$���V�$���V�$���V�$�Q����{�d
                                                                                                                                                                                                        ;�荿K��r�����3b���οK��r��K��r��K��r��ę��y6r���V�$��oþ�풿����Iց�Dh�uQ�3���r1�r1���V�$�քľ<Y��X����au�Q����`��1��������`���T���V�$�p���^���g辠
�m�^���V�$���V�$��x?�g��&���z4��ʋ>���E��������6��OZ�2���}����w���|��w������P\�p���)��R9���྇\����R��C׿�|;D���K��r��l곾ز�����S�k���V�$��h��͢�Xn�$Tɿ��Ai���V�$�<��LE�j-���5�������(h��*���e)�l���^�ݾLⅿy#%������V�$���V�$�:�^�4
D����쾏�~����!S��-�,���]c��qĿ����cg��`���T���/�
                           ���N��K��r��K��r��:8��T�
                                                       �Z�{R��Bþ���j�w����V�$�Q����{��sԾ�:���d��bH���� z�Z�������</LogProbs> </TransitionModel> <DIMENSION> $<NUMPDFS> R<DiagGMM> <GCONSTS> FV CYm��0�����������6[�����9��;��Ţ���E�ny��
����A�����K/ �����Ӏ�§�           �������4]��E���1P���GÞ<��������B��ª��B(cçJ�¿��t���D��Fu��A������#���8�'ôg�¨�ñi��2-��^��m�����������U��������j�6ú����q�������ŉ��Y5�|��&p���
                         ñ
ZF�<$R�<��_<�=t<�g<�wr<iJ�<��<?dp<QV�<�n�<��u<#��<W�e<1CO<Mx�<a�r<Z<�(<f��<��O<LN<>t�<�r2<g�B<<���<�r<��=<i�U<�,Y<��M< �L<XxB<hP<�3<�#P<l�<���<Y}�<Ȃ<�ٷ<���<N9*<��t<��)<���<W��<*4�<�M�<C�r<��5<9Zt<�p|<<MEANS_INVVARS> FM C$h(���j����zg�	?�}�>�>�:>���>zg<<�"� bp>�����R�_��>P=�������=�;C>�`�>7�K>���?>��>��>H|MASO(�ñU��>U�H?Hֿ�� �9�ԿK�.�[f��Y�9?צ?g-���G�R��b<��>�!�1|Z=^�>W�D?M6>7=��>��B>� ־e,4�+񛾝w�=������A�=ߐ�=hĶ=���]��}_ݽ
{% endhighlight %}

### HCLG.fst

The compiled decoding graph, **HCLG.fst** is a key part of the decoding process, as it combines the acoustic model (**HC**), the pronunciation dictionary (**lexicon**), and the language model (**G**). This file, like the acoustic model shown above, doesn't make too much sense to humans, but in any case, here's what the head of mine looks like:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/experiment/triphones_deldel/graph$ head HCLG.fst 
���~vectostandardB�= ��@5�@�� �<@��6��@��8V@��D��@��N��@��T��@��l�ȶ@���@���pw@��� M@���8�@���x�@���X�@���0]@����h�@������@���X@���A@�@�?��A@�Pg@0�@ H�@6�@8p�@D��@Np�@T��ZHA	`�@
l �@
    r@�@
���@�X�@     鞆䀐 *    ┼䀑 0    霈䀒 6 oȀ 搓䄓 D    堞䀔 N    戸䀕 T    㠈䀖 Z    砸䀗 h    F䀘 n    懌䀙 t    倂䀚    
{% endhighlight %}
 
### words.txt

Lastly, if we want to be able to read our transcriptions as an utterance of words instead of a list of intergers, we need to provide the mapping of word-IDs to words themselves. **HCLG.fst** uses the intergers representing words without worrying about what the words are. As such, we need **words.txt** to map from the list of intergers we get from decoding to something readable.

This file should have been generated during the data preparation (training) phase.

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/experiment/triphones_deldel/graph$ head words.txt 
<eps> 0
<SIL> 1
<unk> 2
абайлап 3
абалы 4
абдыракман 5
абдыракманды 6
абдыракмандын 7
абдырахман 8
абышка 9
{% endhighlight %}

## Step-by-Step Decoding

Assuming you've got all the files listed above in the right place, I'm now going to go step-by-step through the decoding process.

### Audio --> Feature Vectors

First, we're going to extract MFCCs from the audio according to the specifications listed in the **mfcc.conf** file. At this point, we give as input (1) our configuration file and (2) our list of audio files, and we get as output (1) ark and scp feature files.

{% highlight bash %}
compute-mfcc-feats \
    --config=config/mfcc.conf \
    scp:transcriptions/wav.scp \
    ark,scp:transcriptions/feats.ark,transcriptions/feats.scp
{% endhighlight %}

Next, since I trained my GMM acoustic model with delta + delta-delta features, we need to add them to our vanilla MFCC feature vectors. We give as input (1) the MFCC feature vectors generated above and receive as output (1) extended feature vectors with delta + delta-delta features.
 
{% highlight bash %}
add-deltas \
    scp:transcriptions/feats.scp \
    ark:transcriptions/delta-feats.ark
{% endhighlight %}

### Trained GMM-HMM + Feature Vectors --> Lattice

Now that we have feature vectors from our new audio in the appropriate shape, we can use our GMM acoustic model and decoding graph to generate lattices of hypothesized transcriptions. This program takes as input (1) our word-to-symbol table, (2) a trained acoustic model, (3) a compiled decoding graph, and (4) the features from our new audio, and we are returned (1) a file of lattices.

{% highlight bash %}
gmm-latgen-faster \
    --word-symbol-table=experiment/triphones_deldel/graph/words.txt \
    experiment/triphones_deldel/final.mdl \
    experiment/triphones_deldel/graph/HCLG.fst \
    ark:transcriptions/delta-feats.ark \
    ark,t:transcriptions/lattices.ark
{% endhighlight %}

### Lattice --> Best Path Through Lattice

Some people might be happy to stop with the lattice, and do their own post-processing, but I think many people will want a single *best-guess* transcription for the audio. The following program takes as input (1) the generated lattices from above and (2) the word-to-symbol table and returns (1) the best path through the lattice.

{% highlight bash %}
lattice-best-path \
    --word-symbol-table=experiment/triphones_deldel/graph/words.txt \
    ark:transcriptions/lattices.ark \
    ark,t:transcriptions/one-best.tra
{% endhighlight %}

### Best Path Intergers --> Best Path Words

The best path that we get above will display a line of intergers for each transcription. This isn't very useful for most applications, so here is how we can substitute the intergers for the words they represent.

{% highlight bash %}
utils/int2sym.pl -f 2- \
    experiment/triphones_deldel/graph/words.txt \
    transcriptions/one-best.tra \
    > transcriptions/one-best-hypothesis.txt
{% endhighlight %}

## Conclusion

If you run all the above programs successfully, you should end up with a new file **transcriptions/one-best-hypothesis.txt**, which will list your files and their transcriptions.

I hope this was helpful!

If you have any feedback or questions, don't hesitate to leave a comment!


[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[kaldi-notes]: http://jrmeyer.github.io/kaldi/2016/02/01/Kaldi-notes.html