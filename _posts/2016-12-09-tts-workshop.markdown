---
layout: post
title:  "Вышка Speech Synthesis Workshop: Let's make a Chuvash voice!"
date:   2016-12-09
categories: TTS
comments: True
---



## Logistics

Place: Вышка // Старая Басманная 24/1 // Room 509

Time: 13:00 - 21:00

<br/>

## Must Do Before

0. Register: https://goo.gl/forms/6N4uYpkzd2c2Xz7L2
1. Bring a computer with you (with Linux if possible).
2. If you only have Windows, you must email < ftyers AT hse TOCHKA ru > by December 7th.

<br/>

## Recommended Do Before

1. Install Ossian (with Merlin)
2. Download Data






<br/>
<br/>
<br/>


## Introduction


<br/>

## Dependencies

Before we can get started with Ossian, let's download and install its dependencies. Thankfully, there aren't too many, and they're all very easy to get working fast.


### Compilation Dependencies

These are some dependencies you may need for compiling Ossian on Linux:

{% highlight bash %}
sudo apt-get install clang libsndfile1-dev gsl-bin libgsl0-dev libconfig-dev
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

## Install Ossian

Now we're ready to install Ossian itself! Huzzah! First let's clone Ossian from github, then compile it.

### Clone Ossian

{% highlight bash %}
josh@yoga:~/git$ git clone https://github.com/CSTR-Edinburgh/Ossian.git
Cloning into 'Ossian'...
remote: Counting objects: 377, done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 377 (delta 0), reused 1 (delta 0), pack-reused 372
Receiving objects: 100% (377/377), 389.73 KiB | 229.00 KiB/s, done.
Resolving deltas: 100% (154/154), done.
Checking connectivity... done.
{% endhighlight %}


<br/>

### Compile Ossian

Our configuration and compiling will be done by the `./tools/setup_tools.sh` script. This script takes two arguments, `HTK_USERNAME` and `HTK_PASSWORD`.

In fact this one script will download and compile both `HTK` and `Merlin` in addition to `Ossian`. 

{% highlight bash %}
josh@yoga:~/git/Ossian$ ./scripts/setup_tools.sh HTK_USERNAME HTK_PASSWORD 
Cloning into 'merlin'...
remote: Counting objects: 2568, done.
remote: Compressing objects: 100% (75/75), done.
remote: Total 2568 (delta 27), reused 54 (delta 17), pack-reused 2474
Receiving objects: 100% (2568/2568), 5.74 MiB | 217.00 KiB/s, done.
Resolving deltas: 100% (1360/1360), done.
Checking connectivity... done.
HEAD is now at 8aed278 Merge pull request #149 from shartoo/master
mkdir -p ./build/objs
g++ -O1 -g -Wall -fPIC -Isrc -o "build/objs/cheaptrick.o" -c "src/cheaptrick.cpp"
                             .
                             .
                             .
make[2]: Entering directory '/home/josh/git/Ossian/tools/downloads/SPTK-3.6'
make[2]: Nothing to be done for 'install-exec-am'.
test -z "/home/josh/git/Ossian/scripts/..//tools/include" || /bin/mkdir -p "/home/josh/git/Ossian/scripts/..//tools/include"
 /usr/bin/install -c -m 644 'include/SPTK.h' '/home/josh/git/Ossian/scripts/..//tools/include/SPTK.h'
make[2]: Leaving directory '/home/josh/git/Ossian/tools/downloads/SPTK-3.6'
make[1]: Leaving directory '/home/josh/git/Ossian/tools/downloads/SPTK-3.6'
164
{% endhighlight %}


This script has compiled `Ossian`, cloned and compiled `Merlin`, downloaded and compiled `HTK`, and put everything in the `tools` directory. At this point, if you didn't run into any problems, you should have a working installation of Ossian which can call both Merlin and HTK.


<br/>
<br/>





## Train a voice for Chuvash

We got recordings, and even though there's only about an hour, we can still train something.

### Get Some Data

First let's download the CSTR corpus:

{% highlight bash %}
josh@yoga:~/git/Ossian$ wget
{% endhighlight %}


Now we need to unpack the compressed corpus:

{% highlight bash %}
josh@yoga:~/git/Ossian$ tar xvf
{% endhighlight %}



Now let's take a look at the file structure of this Romanian corpus. When building your own language, you should have your file structure be exactly the same.

{% highlight bash %}
josh@yoga:~/git/Ossian$ tree corpus/
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

For this demo, remember that we're working with the Romainian language, hence the main directory label `rm` for "Romainian". One level down we have a `speakers` directory and a `text_corpora` directory. We can have multiple speakers (i.e. voices) per language, so you can imagine having multiple subdirs under `speakers/*`, one for each voice or corpus. Here the speaker dir we're working with is labeled `rss_toy_demo`, but it could easily be called `mary` or `john` for the actual speaker's name.

Next, we have a text corpus directory called `text_corpora`. We could have multiple text corpora (just like we could have multiple speakers), but in our case we're just working with a sample of Romainian Wikipedia, hence the filename `wikipedia_10k_words`.

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
josh@yoga:~/git/Ossian$ export THEANO_FLAGS=""
# train duration model
josh@yoga:~/git/Ossian$ python ./tools/merlin/src/run_merlin.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/duration_predictor/config.cfg
# train acoustic model
josh@yoga:~/git/Ossian$ python ./tools/merlin/src/run_merlin.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/acoustic_predictor/config.cfg
{% endhighlight %}


<br/>

### Store Merlin Model

Now we will take the Merlin DNNs we just made and format them for Ossian. NB - if you trained your DNNs on a GPU machine, they can only be used on a GPU machine.

We call the conversion script with:

1. the same config file you used for training: `config.cfg`
2. the directory name for newly formatted model: `acoustic_predictor` or `duration_predictor`

{% highlight bash %}
# store duration model
josh@yoga:~/git/Ossian$ python ./scripts/util/store_merlin_model.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/duration_predictor/config.cfg /home/josh/git/Ossian/voices/rm/rss_toy_demo/naive_01_nn/processors/duration_predictor
# store acoustic model
josh@yoga:~/git/Ossian$ python ./scripts/util/store_merlin_model.py /home/josh/git/Ossian/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/acoustic_predictor/config.cfg /home/josh/git/Ossian/voices/rm/rss_toy_demo/naive_01_nn/processors/acoustic_predictor
{% endhighlight %}


<br/>

### Synthesize New Audio

Now you've got everything in place to synthesize some speech with Ossian! We can use a sample Romainian sentence (text) provided by CSTR to make a sample as such:

{% highlight bash %}
josh@yoga:~/git/Ossian$ mkdir ./test/txt/
josh@yoga:~/git/Ossian$ echo "SOME CHUVASH HERE" > ./test/txt/chuvash_test.txt
josh@yoga:~/git/Ossian$ mkdir ./test/wav/
josh@yoga:~/git/Ossian$ python ./scripts/speak.py -l chv -s news -o ./test/wav/chuvash_test.wav naive_01_nn ./test/txt/chuvash_test.txt
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
