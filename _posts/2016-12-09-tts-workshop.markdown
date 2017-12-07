---
layout: post
title:  "Let's make a Chuvash voice! : Moscow Higher School of Economics Speech Synthesis Workshop"
date:   2016-12-09
categories: TTS
comments: True
---



## Logistics

### Time & Place

Вышка // Старая Басманная 24/1 // Room 509

December 9, 2017 // 13:40 - 21:00

### Must Do Before

0. Register: https://goo.gl/forms/6N4uYpkzd2c2Xz7L2
1. Bring a computer with you (with Linux if possible).
2. If you only have Windows, you must email < ftyers AT hse TOCHKA ru > by December 7th.


### Recommended Do Before

1. Install official version of Ossian 
2. Download Data






<br/>
<br/>
<br/>


## Introduction

The general idea of the workshop is twofold, the `first` is to introduce the field of speech
synthesis and some free/open-source tools based on machine learning with neural networks. The
`second` is to use newly collected data for Chuvash to make the first Chuvash speech synthesis
system.

Speech synthesis is the task of taking written text and having the computer pronounce it. It
is widely used for different applications, such as screenreaders, automatic telephone answering
systems, virtual assistants etc. While systems are widely available for larger languages
such as English [1], Russian, and Catalan [2], there has yet to be a system created for Chuvash.

1. http://homepages.inf.ed.ac.uk/jyamagis/demos/page35/page35.html
2. http://festcat.talp.cat/



<br/>

## Dependencies

Before we can get started with Ossian, let's download and install its dependencies. Thankfully, there aren't too many, and they're all very easy to get working fast.


### HTK

Ossian requires HTK to generate the alignments for training your DNN in Merlin. To get access to HTK, you need to register an account with the University of Cambridge. Thankfully, registration is really easy! Just go to this link:

```
http://htk.eng.cam.ac.uk/register.shtml
```
{: style="text-align: center;"}

<br/>


Fill out some information:

<div style="display: flex; justify-content: center;">
<img src="/misc/htk-register-1.png" style="width: 400px;"/>  
</div>
<br/>

And accept the terms of the license:

<div style="display: flex; justify-content: center;">
<img src="/misc/htk-register-2.png" style="width: 500px;"/>  
</div>
<br/>


You will receive your password in a very short email from `htk-mgr@eng.cam.ac.uk` that looks something like this:

<div style="display: flex; justify-content: center;">
<img src="/misc/htk-register-3.png" style="width: 800px;"/>  
</div>
<br/>

The password you receive will be some random string, so if you prefer a password that isn't gibberish, you can easily change it here: ```http://htk.eng.cam.ac.uk/change_pass.shtml```.

At this point, don't worry about downloading HTK yourself. Soon, we will take your beautiful new username and password and feed them into Ossian's installation script. The installation script is designed to take care of all the downloading, compilation and formatting for HTK, so you don't have to! This means less time worrying about file structure and more time working on speech synthesis!

<br/>


### Compilation Dependencies

These are some dependencies you may need for compiling Ossian on Linux:

{% highlight bash %}
sudo apt-get install software-properties-common
sudo apt-add-repository universe
sudo apt-get update
sudo apt-get install python-pip clang libsndfile1-dev gsl-bin libgsl0-dev libconfig-dev
{% endhighlight %}


<br/>

### Python Dependencies

Next we will install some Python dependencies:

{% highlight bash %}
# for Ossian
sudo pip install numpy scipy regex argparse lxml scikit-learn regex configobj

# for Merlin
sudo pip install bandmat theano matplotlib
{% endhighlight %}

That's it! You should be good to go on dependencies.

<br/>
<br/>

## Install Ossian / Merlin / HTK

Now we're ready to install Ossian itself! Huzzah! First let's clone Ossian from github, then compile it.

### Clone Ossian (bundled w/ Merlin and HTK)

{% highlight bash %}
git clone https://github.com/CSTR-Edinburgh/Ossian.git
{% endhighlight %}


<br/>

### Compile Ossian (bundled w/ Merlin and HTK)

Our configuration and compiling will be done by the `./tools/setup_tools.sh` script. 

In fact this one script will download and compile both `HTK` and `Merlin` in addition to `Ossian`. 

This script takes two arguments, `HTK_USERNAME` and `HTK_PASSWORD`.

{% highlight bash %}
./scripts/setup_tools.sh $HTK_USERNAME $HTK_PASSWORD
{% endhighlight %}


This script has compiled `Ossian`, cloned and compiled `Merlin`, downloaded and compiled `HTK`, and put everything in the `tools` directory. At this point, if you didn't run into any problems, you should have a working installation of Ossian which can call both Merlin and HTK.


<br/>
<br/>





## Train a voice for Chuvash

We got recordings, and even though there's only about an hour, we can still train something.

### Get Some Data

First let's download the CSTR corpus:

{% highlight bash %}
git clone https://github.com/ftyers/Turkic_TTS.git
{% endhighlight %}



Now let's take a look at the file structure of this Romanian corpus. When building your own language, you should have your file structure be exactly the same.

{% highlight bash %}
tree corpus/
corpus/
└── chv
    ├── speakers
    │   └── news
    │       ├── README
    │       ├── txt
    │       │   ├── .txt
    │       │   ├── .txt
    │       │   └── .txt
    │       └── wav
    │           ├── .wav
    │           ├── .wav
    │           └── .wav
    └── text_corpora
        └── wikipedia????
            └── text.txt

{% endhighlight %}

I'm only showing a few audio (`*.wav`) and text (`*.txt`) files here, but you get the idea. The filenames for each utterance and its transcript are the same. You see we have a `adr_diph1_001.wav` as well as a `adr_diph1_001.txt`. If you have mismatches or missing files, you will have issues later on in training.

For this demo, remember that we're working with the Chuvash language, hence the main directory label `chv` for "Chuvash". One level down we have a `speakers` directory and a `text_corpora` directory. We can have multiple speakers (i.e. voices) per language, so you can imagine having multiple subdirs under `speakers/*`, one for each voice or corpus. Here the speaker dir we're working with is labeled `chuvash_news`, but it could easily be the actual speaker's name.

Next, we have a text corpus directory called `text_corpora`. We could have multiple text corpora (just like we could have multiple speakers).

So, now that we've downloaded our data and taken a look, let's use it to make a speech synthesizer!

<br/>



### Train Ossian Model

There's a main Ossian `train.py` script which takes three main arguments:

1. the speaker dir name after the `-s` flag: `-s speaker_dir`
2. the language dir name after the `-l` flag: `-l language_dir`
3. the recipe configuration file name (without extention): `naive_01_nn`


{% highlight bash %}
josh@yoga:~/git/Ossian$ python ./scripts/train.py -l chv -s news naive_01_nn
{% endhighlight %}

<br/>

### Train Merlin Model

To train fancy-dancy DNNs for our speech synthesizer, we can use Merlin (built on top of Theano).

We're going to train both an `acoustic` and `duration` model here. Since this is a Ossian demo and not Merlin, we aren't going to get into detail on Merlin, but if you're interested, here's a beginner's [Merlin walkthrough][merlin-post]. 

Just run the following commands:

{% highlight bash %}
export THEANO_FLAGS=""
# train duration model
python ./tools/merlin/src/run_merlin.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/duration_predictor/config.cfg
# train acoustic model
python ./tools/merlin/src/run_merlin.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/acoustic_predictor/config.cfg
{% endhighlight %}


<br/>

### Store Merlin Model

Now we will take the Merlin DNNs we just made and format them for Ossian. NB - if you trained your DNNs on a GPU machine, they can only be used on a GPU machine.

We call the conversion script with:

1. the same config file you used for training: `config.cfg`
2. the directory name for newly formatted model: `acoustic_predictor` or `duration_predictor`

{% highlight bash %}
# store duration model
python ./scripts/util/store_merlin_model.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/duration_predictor/config.cfg /home/josh/git/Ossian/voices/rm/rss_toy_demo/naive_01_nn/processors/duration_predictor
# store acoustic model
python ./scripts/util/store_merlin_model.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/acoustic_predictor/config.cfg /home/josh/git/Ossian/voices/rm/rss_toy_demo/naive_01_nn/processors/acoustic_predictor
{% endhighlight %}


<br/>

### Synthesize New Audio

Now you've got everything in place to synthesize some speech with Ossian! We can use a sample Romainian sentence (text) provided by CSTR to make a sample as such:

{% highlight bash %}
mkdir ./test/txt/
echo "SOME CHUVASH HERE" > ./test/txt/chuvash_test.txt
mkdir ./test/wav/
python ./scripts/speak.py -l chv -s news -o ./test/wav/chuvash_test.wav naive_01_nn ./test/txt/chuvash_test.txt
{% endhighlight %}

And there you go! You can listen to your beautiul new Romainian speech in the file `./test/wav/romanian_test.wav`.



<br/>

## Conclusion


<br/>

## Resources

Here's a [tutorial][king-tutorial] on Statistical parametric speech synthesis writen by Simon King, one of the creators of Merlin.







[merlin-post]: http://jrmeyer.github.io/merlin/2017/02/14/Installing-Merlin.html
[ossian-github]: https://github.com/CSTR-Edinburgh/Ossian
[merlin-github]: https://github.com/CSTR-Edinburgh/merlin
[merlin-cstr]: http://www.cstr.ed.ac.uk/projects/merlin/
[king-tutorial]: http://www.cstr.ed.ac.uk/downloads/publications/2010/king_hmm_tutorial.pdf
[pip-install]: https://pip.pypa.io/en/stable/installing/
[merlin-demo-paper]: http://homepages.inf.ed.ac.uk/s1432486/papers/Merlin_demo_paper.pdf
[ronanki]: http://104.131.174.95/
