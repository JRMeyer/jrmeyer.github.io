---
layout: post
title:  "How to use an Existing DNN Recognizer for Decoding in Kaldi"
date:   2017-01-10
categories: ASR
comments: True
---

<img src="/misc/kaldi_text_and_logo.png" align="right" alt="logo" style="width: 400px;"/>

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

This post is essentially a walk through of [this shell script]({{ site.url }}/misc/dnn-decode.sh).



<br/>

## Introduction

If you're reading this, I'm assuming that you've already [downloaded and installed Kaldi][kaldi-install] and successfully trained a DNN-HMM acoustic model along with a decoding graph. 

If you've run one of the DNN Kaldi `run.sh` scripts from the example directory `egs/`, then you should be ready to go. You may want to start with the baseline script for nnet2 in the Wall Street Journal example. The script is `run_nnet2_baseline.sh`

I originally wrote this very [same post for GMM models]({{site.url}}/kaldi/2016/09/12/Using-built-GMM-model-Kaldi.html), and now I want to make it for DNN.  

We normally generate transcriptions for new audio with the Kaldi testing and scoring scripts, so I just simply dug out the most important parts of these scripts to demonstrate in a concise way how decoding can work. 

What you see here is what I gather to be the *simplest* way to do decoding with a DNN in Kaldi - it is by no means garanteed to be the *best* way to do decoding.


<br/>
<br/>

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
#        nnet2_online/
#            nnet_a_baseline/
#                final.mdl
#
#        triphones_lda_mllt_sat/
#            graph/
#                HCLG.fst
#                words.txt
{% endhighlight %}


<br/>
<br/>

### wav.scp

The first file you need is `wav.scp`. This is the only file that you need to make for your new audio files. All the other files listed below should have already been created during the training phase.

This should be the same format as the `wav.svp` file generated during training and testing. It will be a two-column file, with the utterance ID on the left column and the path to the audio file on the right column.

I'm just going to decode one audio file, so my `wav.scp` file is one line long, and it looks like this:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/transcriptions$ cat wav.scp 
atai_45 input/audio/atai_45.wav
{% endhighlight %}

<br/>
<br/>

### mfcc.conf

Next, you should have a configuration file specifying how to extract MFCCs. You need to extract the exact same number of features for this new audio file as you did in training. If not, the existing acoustic model and new audio feature vectors will have a different number of parameters. Comparing these two would be like asking where a 3-D point exists in 2-D space, it doesn't make sense. So, you don't need to adjust anything in the config file. I used MFCCs, and my config file looks like this:

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

<br/>
<br/>

### final.mdl

Next, you need a trained DNN acoustic model, such as `final.mdl`. This should have been produced in your training phase, and should be located somewhere like `egs/your-model/your-model-1/exp/nnet2/final.mdl`. It doesn't make too much sense to a human, but here's what the head of the file looks like:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/experiment/nnet2_online/nnet_a_baseline$ head final.mdl 
B<TransitionModel> <Topology> 


����@?�>@?�>@?�>�����>�>�>�>�>�>�>�>�>�>�>�>�>�>�>�>@?�>����</Topology> <Triples> �% �������&(NS^���<����#������u���-2r|.a�x�����>_bkl����'7?DT�������Eip�������$R{����_klmn���������'=LM_i�������	Fj�����#CQTr�����+>HQv���
                                                                                                                                                          *TV�����%'27_������8d����Dhq�����BE������
                                                                        2[��0��P���i"K7di���Sf��-b��\�abl����N����6>78��]�������2Q[��0�� ����3@T\w��t�3JQ��������,�.R��
                                                                  �C��
                                                                                                          �9f��
S���#)Njk�����������0J�,-a���U`r�Yv���/W{~��R����e����n��\�f����� 8��!n��^����������8����9�3c��&��			
	
u
w
�

  
|
�
{% endhighlight %}

<br/>
<br/>

### HCLG.fst

The compiled decoding graph, `HCLG.fst` is a key part of the decoding process, as it combines the acoustic model (`HC`), the pronunciation dictionary (`lexicon`), and the language model (`G`). 

You will notice this graph is not located in the same directory as the trained DNN acoustic model. This is not a mistake. You must train a GMM-HMM before you train a DNN-HMM, and you use the graph from the GMM-HMM in decoding.

This file, like the acoustic model shown above, doesn't make too much sense to humans, but in any case, here's what the head of mine looks like:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/experiment/triphones_lda_mllt_sat/graph$ head HCLG.fst 
���~vectostandardB�o*��@�p@v���w@w��`�@x��T@y�@��@z��`�@{��Pl@|���@#A}���A~����%A��pA��
                                                                                                                         A�� ��@��@h�@��F��@��0A��"P�@��:HA��F7O�A��4�Q� A�����@���{@�� �@��`�@���XA��/\"APa@���3L$A�� 	�30$A��"	8�@���	TA��
�@���
x�@��4
       ��@��~
              )7$A���
                       (�@��
                              j@��v
                                     (�@���
p�@��D��@��bh�@��zA����@���@��j�o@��p\@%�p\@&� �?'�p(�@����A����
                                                                                         &A����A���#8-A��#(6A(�0�A��
�3��@���
         7�$A���
                  h<0'A��D��&A��@�@�@�H�@�0�@)��P�@@(�@*����@�P���,A	�P�@
�hKA
     �HA+���1A,���>A-��,A |A@�AF�@�N@XAP	A"��@:HAF�4A4�:A��JA�P�@.���@��@/�0�@0���$A��/�PA1���/�VA��@2��!A  	�3YA3�"	P�@!�	GA4�
h�@"�
��@#4
     �A$~
         �6A%�
              �A&
                   ��@5�v
                          ��@6��
��@)DXA*Tp/A+b��@,zH             �@7�b
                     A-���@.LA8�j��@/8�@9�8�@:��@;�plA���d:A<����FA����T;A=�#CA30�9A��
�30A���
         7`EA>��
                  h<�FA?�D��GA�� �@}p8/A@��XGAA���D\AB��FO�[AC����QAD�@4mAE�H�bA1�#0VA2#_A3��/�\A40TAF�	�2�cA5 	�2�nAG�
�3H;A6�
       7,[AH��
                h<�UAI�D��\A9b�QtRA:j�|LAJ�p�A;�րA<��sAK���FA=��`GA>��چA@��lpAA��h�AB���zAL���lLAD����AM��#lWAH�#�~AI#4RAJ#<xAN�#�mAO�0x<AP�
�3�'AS~
       7�AT�
              7�GAU�
                     h<GAQ�D�`GAVp|CA;��<�z�AK��(bA=���mA>�FO�mA?��
                                                                                �A@��h�AA����AB���L����pAD��ڗAM� ��AE@�~AFF�tAG�#�sAH�#V�AI#HnAJ#(�AN�#܄AO���/t�AK��/�tAL��/�M0XgAP��2�O	�2&�AR�
                	�2ڎAP	�26�AQ 	�2�AS�"	�2r�AR

{% endhighlight %}
 

<br/>
<br/>

### words.txt

Lastly, if we want to be able to read our transcriptions as an utterance of words instead of a list of intergers, we need to provide the mapping of word-IDs to words themselves. `HCLG.fst` uses the intergers representing words without worrying about what the words are. As such, we need `words.txt` to map from the list of intergers we get from decoding to something readable.

This file should have been generated during the data preparation (training) phase.

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model/experiment/triphones_lda_mllt_sat/graph$ head words.txt 
<eps> 0
<SIL> 1
<unk> 2
а 3
аа 4
аалы 5
аарчы 6
аарчып 7
аарчысы 8
аарчысын 9
{% endhighlight %}



<br/>
<br/>
<br/>
<br/><br/>
<br/>
<br/>
<br/>

## Step-by-Step Decoding

Assuming you've got all the files listed above in the right place, I'm now going to go step-by-step through the decoding process.

<br/>
<br/>

### Audio --> Feature Vectors

First, we're going to extract MFCCs from the audio according to the specifications listed in the `mfcc.conf` file. At this point, we give as input (1) our configuration file and (2) our list of audio files, and we get as output (1) ark and scp feature files.

{% highlight bash %}
compute-mfcc-feats \
    --config=config/mfcc.conf \
    scp:transcriptions/wav.scp \
    ark,scp:transcriptions/feats.ark,transcriptions/feats.scp
{% endhighlight %}

Next, we can go straight to decoding from the MFCCs, because even though you probably trained your GMM-HMM with deltas and delta+deltas, DNN acoustic models typically don't use them, because they splice frames at the input layer to take into acount time information.


<br/>
<br/>

### Trained DNN-HMM + Feature Vectors --> Lattice

Now that we have feature vectors from our new audio in the appropriate shape, we can use our acoustic model and decoding graph to generate lattices of hypothesized transcriptions. This program takes as input (1) our word-to-symbol table, (2) a trained acoustic model, (3) a compiled decoding graph, and (4) the features from our new audio, and we are returned (1) a file of lattices.

{% highlight bash %}
nnet-latgen-faster \
    --word-symbol-table=experiment/triphones_lda_mllt_sat/graph/words.txt \
    experiment/nnet2_online/nnet_a_baseline/final.mdl \
    experiment/triphones_lda_mllt_sat/graph/HCLG.fst \
    ark:transcriptions/feats.ark \
    ark,t:transcriptions/lattices.ark;
{% endhighlight %}


<br/>
<br/>

### Lattice --> Best Path Through Lattice

Some people might be happy to stop with the lattice, and do their own post-processing, but I think many people will want a single *best-guess* transcription for the audio. The following program takes as input (1) the generated lattices from above and (2) the word-to-symbol table and returns (1) the best path through the lattice.

{% highlight bash %}
lattice-best-path \
    --word-symbol-table=experiment/triphones_lda_mllt_sat/graph/words.txt \
    ark:transcriptions/lattices.ark \
    ark,t:transcriptions/one-best.tra;
{% endhighlight %}



<br/>
<br/>

### Best Path Intergers --> Best Path Words

The best path that we get above will display a line of intergers for each transcription. This isn't very useful for most applications, so here is how we can substitute the intergers for the words they represent.

{% highlight bash %}
utils/int2sym.pl -f 2- \
    experiment/triphones_lda_mllt_sat/graph/words.txt \
    transcriptions/one-best.tra \
    > transcriptions/one-best-hypothesis.txt;
{% endhighlight %}


<br/>
<br/>

## Conclusion

If you run all the above programs successfully, you should end up with a new file `transcriptions/one-best-hypothesis.txt`, which will list your files and their transcriptions.

I hope this was helpful!

If you have any feedback or questions, don't hesitate to leave a comment!

<br/>
<br/><br/>
<br/><br/>
<br/>


[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[kaldi-notes]: http://jrmeyer.github.io/kaldi/2016/02/01/Kaldi-notes.html