---
layout: post
title:  "How to Visualize a Word Lattice with Kaldi"
date:   2016-12-15
categories: ASR
comments: True
redirect_from: "/kaldi/2016/12/15/Visualize-lattice-kaldi.html"
---


<img src="/misc/kaldi_text_and_logo.png" align="right" alt="logo" style="width: 300px;"/>

## Introduction

If you want to take a step back and learn about Kaldi in general, I have posts on [how to install Kaldi][kaldi-install] or some [miscellaneous Kaldi notes][kaldi-notes] which contain some documentation.

This is just a very short post on how to visualize a word lattice with Kaldi. 

Effectively, there is a simple script already included in the official Kaldi repository, within the Wall Street Journal example *utils* directory.


## Dependencies

You need to have install the [dot][dot] program provided by [Graphviz][graphviz]. This 

{% highlight bash %}
sudo apt-get install graphviz
{% endhighlight %}


## show_lattice.sh

After re-aranging the original Kaldi script a little bit and adding my own comments, here's what my version looks of *show_lattice.sh* like:

{% highlight bash %}
josh@yoga:~/git$ cat kaldi/egs/wsj/s5/utils/show_lattice.sh 
#!/bin/bash

. utils/parse_options.sh
. path.sh

format=pdf # pdf or svg
mode=save # display or save
lm_scale=0
acoustic_scale=0.1

if [ $# != 3 ]; then
   echo "usage: $0 [--mode display|save] [--format pdf|svg] <utterance-id> <lattice-ark> <word-list>"
   echo "e.g.:  $0 utt-0001 \"test/lat.*.gz\" tri1/graph/words.txt"
   exit 1;
fi

utterance_id=$1
lattice_file=$2
word_list=$3
tmp_dir=$(mktemp -d /tmp/kaldi.XXXX);


# Extract utterance_id lattice from lattice ark file and convert to FST
# and save new FST in tmp_dir
gunzip -c $lattice_file | \
    lattice-to-fst \
        --lm-scale=$lm_scale \
        --acoustic-scale=$acoustic_scale \
        ark:- "scp,p:echo $utterance_id $tmp_dir/$utterance_id.fst|" \
        || exit 1;

! [ -s $tmp_dir/$utterance_id.fst ] && \
    echo "Failed to extract lattice for utterance $utterance_id (not present?)" \
    && exit 1;


# draw FST and convert to image via dot program
fstdraw --portrait=true \
    --osymbols=$word_list \
    $tmp_dir/$utterance_id.fst | \
    dot -T${format} > $tmp_dir/$utterance_id.${format}


# some if statements relative to native OS
if [ "$(uname)" == "Darwin" ]; then
    doc_open=open

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    doc_open=xdg-open

elif [ $mode == "display" ] ; then
        echo "Can not automaticaly open file on your operating system"
        mode=save
fi


# save or display new image
[ $mode == "display" ] && \
    $doc_open \
    $tmp_dir/$utterance_id.${format}

[[ $mode == "display" && $? -ne 0 ]] \
    && echo "Failed to open ${format} format." \
    && mode=save

[ $mode == "save" ] \
    && echo "Saving to $utterance_id.${format}" \
    && cp $tmp_dir/$utterance_id.${format} .

exit 0
{% endhighlight %}


## Running the Script

When I run this script to display a lattice I generated for the Kyrgyz language, this is command I use:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/kgz/kyrgyz-model$ ./utils/show_lattice.sh \
                                            atai_81 \
                                            ./experiment/nnet2_online/nnet_a_baseline/decode/lat.1.gz \
                                            ./experiment/triphones_deldel/graph/words.txt; 
{% endhighlight %}


All the script takes is: 

1. the utterance ID of the lattice you want to visualize
2. the path to the (compressed) ark file of lattices in which the target utterance is located
3. the word list of the graph you used to decode the utterance

It's as simple as that!

There are a couple of parameters you can play around with while visualizing the lattice.

1. Acoustic model scale: **--acoustic-scale**
2. Language model scale: **--lm-scale**

The size of the vertices on the graph will change according to the values you insert for these two parameters. The default value for both parameters is **0.0**, and with that you will be shown a plain graph where all the vertices are the same size. All the edges will contain the word and the word ID, and vertices will have an ID as well. 

Here is a graph with **--acoustic-scale=0** and **--lm-scale=0**:

<br/>
<br/>

<center><img src="/misc/atai_81_lm0_am0.svg" style="width: 600px;"/>
</center>

<br/>
<br/>

Here is a graph with **--acoustic-scale=0.1** and **--lm-scale=0**:

<center><img src="/misc/atai_81_lm0_am0.1.svg" style="width: 600px;"/>
</center>

<br/>
<br/>

Here is a graph with **--acoustic-scale=0** and **--lm-scale=10**:

<center><img src="/misc/atai_81_lm10_am0.svg" style="width: 600px;"/>
</center>

<br/>
<br/>

Here is a graph with **--acoustic-scale=0.1** and **--lm-scale=10**:

<center><img src="/misc/atai_81_lm10_am0.1.svg" style="width: 600px;"/>
</center>

<br/>
<br/>

 
## Conclusion

I hope this was helpful!

If you have any feedback or questions, don't hesitate to leave a comment!


[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[kaldi-notes]: http://jrmeyer.github.io/kaldi/2016/02/01/Kaldi-notes.html
[graphviz]: http://www.graphviz.org/
[dot]: http://www.graphviz.org/content/dot-language