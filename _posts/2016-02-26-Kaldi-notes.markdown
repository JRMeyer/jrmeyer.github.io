---
layout: post
title:  "Some Kaldi Notes"
date:   2016-02-01
categories: kaldi
comments: True
---

<img src="/misc/kaldi_text_and_logo.png" align="right" alt="logo" style="width: 400px;"/>

<br/>
<br/>
<br/>

Here's "[Kaldi For Dummies][kaldi-for-dummies]".

Here's a good [blog][good-blog].

Here's a good [tutorial][tutorial1].

Another [tutorial][tutorial2].

## Bayes Rule and ASR

This is from a slide in the [first set of slides][slides] from Dan Povey's lectures on using Kaldi.

$$ P(\text{ utterance } \vert \text{ audio })=\frac{p(\text{ audio } \vert \text{ utterance }) \cdot P(\text{ utterance })}{p(\text{ audio })} $$

1. $$ P(\text{ utterance })$$ comes from our language model (i.e. n-gram)
2. $$ p(\text{ audio } \vert \text{ utterance }) $$ is a sentence-dependent statistical model of audio production, trained from data
3. Given a test utterance, we pick 'utterance' to maximize $$ P(\text{ utterance } \vert \text{ audio }) $$.
4. Note: $$ p(\text{ audio }) $$ is a normalizer that doesn’t matter

## WFST Key Concepts

1. determinization
2. minimization
3. composition
4. equivalent
5. epsilon-free
6. functional
7. on-demand algorithm
8. weight-pushing
9. epsilon removal


## HMM Key Concepts

1. Markov Chain
2. Hidden Markov Model
3. Forward-backward algorithm
4. Viterbi algorithm
5. E-M for mixture of Gaussians


## L.fst: The Phonetic Dictionary FST

L maps monophone sequences to words.

The file L.fst is the Finite State Transducer form of the lexicon with phone symbols on the input and word symbols on the output.

<img src="/misc/Lfst.png" style="width: 500px;"/>

See "Speech Recognition with Weighted Finite-State Transducers" by Mohri, Pereira and Riley, in Springer Handbook on SpeechProcessing and Speech Communication, 2008 for more information.

Here's an example with two words:

<img src="/misc/Lfst-big.png" style="width: 1000px;"/>

The following section comes from [the documentation][graph-test-recipe].

>The structure of the lexicon is roughly as one might expect. There is one state (the "loop state") which is final. There is a start state that has two transitions to the loop state: one with silence and one without. From the loop state there is a transition corresponding to each word, and that word is the output symbol on the transition; the input symbol is the first phone of that word. It is important both for the efficiency of composition and the effectiveness of minimization that the output symbol should be as early as possible (i.e. at the beginning not the end of the word). At the end of each word, to handle optional silence, the transition corresponding to the last phone is in two forms: one to the loop state and one to the "silence state" which has a transition to the loop state. We don't bother putting optional silence after silence words, which we define as words that have just one phone that is the silence phone.

## L_disambig.fst: The Phonetic Dictionary with Disambiguation Symbols FST

A lexicon with disambiguation symbols, see Mohri etal's work for more info.

In general, you need to have disambiguation symbols when you have one word that is a prefix of another (cat and cats in the same lexicon would need to have cat being pronounced “k ae t #1”) or a homophone of another word (red: “r eh d #1”, read: “r eh d #2”). If you don’t have these then the models become nondeterministic.

Symbols like #1 and #2 that go on the ends of words to ensure determinizability.

## G.fst: The Language Model FST

FSA grammar (can be built from an n-gram grammar).

## C.fst: The Context FST

C maps triphone sequences to monophones.

Expands the phones into context-dependent phones.

## H.fst: The HMM FST

H maps multiple HMM states (a.k.a. transition-ids in Kaldi-speak) to context-dependent triphones.

Expands out the HMMs. On the right are the context-dependent phones and on the left are the pdf-ids.

## HCLG.fst: final graph

<img src="/misc/HCLGFst.png" style="width: 500px;"/>


### mkgraph.sh: Graph compilation

>This script creates a fully expanded decoding graph (HCLG) that represents the language-model, pronunciation dictionary (lexicon), context-dependency, and HMM structure in our model.  The output is a Finite State Transducer that has word-ids on the output, and pdf-ids on the input (these are indexes that resolve to Gaussian Mixture Models).

The following files are required:

{% highlight bash %}
lang/
        L.fst
        G.fst
        phones.txt
        words.txt
        phones/
                silence.csl
                disambig.int

exp/
        mono0a/
                final.mdl
                tree
{% endhighlight %}

http://kaldi.sourceforge.net/graph_recipe_test.html



## OpenFst Symbol Tables

*Both words.txt and phones.txt are OpenFst Symbol Tables*

From [openfst.org][symboltables]:

>Symbol (string) to int and reverse mapping.
>
>The SymbolTable implements the mappings of labels to strings and reverse. SymbolTables are used to describe the alphabet of the input and output labels for arcs in a Finite State Transducer.
>
>SymbolTables are reference counted and can therefore be shared across multiple machines. For example a language model grammar G, with a SymbolTable for the words in the language model can share this symbol table with the lexical representation L o G.

For *every* FST the symbol '0' is reserved for $$\epsilon$$.

### words.txt

*An OpenFst symbol table.*

The file **words.txt** is created by **prepare_lang.sh** and is a list of all words in the vocabulary, in addition to silence markers, and the disambiguation symbol "#0" (used for epsilon on the input of G.fst).

Each word has a unique number.

{% highlight bash %}
<eps> 0
<SIL> 1
<unk> 2
а 3
аа 4
  .
  .
  .
өөрчүшөт 64714
өөрөнүнөн 64715
#0 64716
<s> 64717
</s> 64718
{% endhighlight %}


### phones.txt

{% highlight bash %}
<eps> 0
SIL 1
SIL_B 2
SIL_E 3
SIL_I 4
SIL_S 5
SPOKEN_NOISE_B 6
SPOKEN_NOISE_E 7
SPOKEN_NOISE_I 8
SPOKEN_NOISE_S 9
a_B 10
a_E 11
   .
   .
   .
zh_I 132
zh_S 133
#0 134
#1 135
#2 136
#3 137
#4 138
#5 139
{% endhighlight %}


## oov.txt

This file has a single line with the word (not the phone!) for out of vocabulary items.

In my case I'm using "\<unk\>" because that's what I get from IRSTLM in my language model (task.arpabo), and this entry has to be identical to that.


[symboltables]: http://www.openfst.org/doxygen/fst/html/classfst_1_1_symbol_table.html
[graph-test-recipe]: http://kaldi.sourceforge.net/graph_recipe_test.html
[good-blog]: http://white.ucc.asn.au/Kaldi-Notes/tidigits/train
[slides]: http://www.danielpovey.com/files/Lecture1.pdf
[tutorial1]: http://m.mr-pc.org/work/jsalt2015lab.pdf
[tutorial2]: http://pages.jh.edu/~echodro1/tutorial/kaldi/kaldi-intro.html
[kaldi-for-dummies]: http://www.dsp.agh.edu.pl/_media/pl:dydaktyka:kaldi_for_dummies.pdf