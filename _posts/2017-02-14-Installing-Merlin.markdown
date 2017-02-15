---
layout: post
title:  "Getting started with the Merlin Speech Synthesis Toolkit"
date:   2017-02-14
categories: merlin
comments: True
---


## Introduction

Here's the official [Merlin GitHub repository][merlin-github].

Here's the official [CSTR Merlin webpage][merlin-cstr].

## Clone

Like good open-source software, the Merlin toolkit is hosted on GitHub and can be easily downloaded (cloned) with a single line of code:

{% highlight bash %}
josh@yoga:~/git$ git clone https://github.com/CSTR-Edinburgh/merlin.git
Clonage dans 'merlin'...
remote: Counting objects: 1515, done.
remote: Total 1515 (delta 0), reused 0 (delta 0), pack-reused 1514
Réception d'objets: 100% (1515/1515), 5.06 MiB | 682.00 KiB/s, done.
Résolution des deltas: 100% (734/734), done.
Vérification de la connectivité... fait.
{% endhighlight %}

Easy as that! Now let's take a peek into what we just downloaded.

{% highlight bash %}
josh@yoga:~/git$ cd merlin/
josh@yoga:~/git/merlin$ ls
COPYING  CREDITS.md  doc  egs  INSTALL  LICENSE  misc  README.md  src  test  tools
{% endhighlight %}

We see some common files and dirs, like `doc` for documentation, `egs` for examples, `src` for source code, etc. 

First things first, we should always start with the `README` file, so lets take a look:

{% highlight bash %}
josh@yoga:~/git/merlin$ cat README.md 
The Neural Network (NN) based Speech Synthesis System
=====================================================
  
This repository contains the Neural Network (NN) based Speech Synthesis System  
developed at the Centre for Speech Technology Research (CSTR), University of 
Edinburgh. 

To build the toolkit: see `./INSTALL`.  These instructions are valid for UNIX
systems including various flavors of Linux;

To run the example system builds, see `egs/README.txt`

As a first demo, please follow the scripts in `egs/slt_arctic`

Synthetic speech samples
------------------------

Listen to [synthetic speech samples](https://cstr-edinburgh.github.io/merlin/demo.html) from our demo voice.

Development pattern for contributors
------------------------------------

1. [Create a personal fork](https://help.github.com/articles/fork-a-repo/)
   of the [main Merlin repository] (https://github.com/CSTR-Edinburgh/merlin) in GitHub.
2. Make your changes in a named branch different from `master`, e.g. you create
   a branch `my-new-feature`.
3. [Generate a pull request](https://help.github.com/articles/creating-a-pull-request/)
   through the Web interface of GitHub.

Contact Us
----------

Post your questions, suggestions, and discussions to [GitHub Issues](https://github.com/CSTR-Edinburgh/merlin/issues).

Citation
--------

If you publish work based on Merlin, please cite: 

Zhizheng Wu, Oliver Watts, Simon King, "Merlin: An Open Source Neural Network Speech Synthesis System" in Proc. 9th ISCA Speech Synthesis Workshop (SSW9), September 2016, Sunnyvale, CA, USA.

Srikanth Ronanki, Zhizheng Wu, Oliver Watts, Simon King, "A Demonstration of the Merlin Open Source Neural Network Speech Synthesis System" in Proc. special demo session, 9th ISCA Speech Synthesis Workshop (SSW9), 2016, Sunnyvale, CA, USA.
{% endhighlight %}


For us right now, since we're trying to get Merlin installed and run the demo, let's take a look into the `INSTALL` file, which is suggested by the `README`.


{% highlight bash %}
josh@yoga:~/git/merlin$ cat ./INSTALL 
INSTALL
=======

(1) go to tools/  and follow INSTALL instructions there.

(2) Merlin is coded in python and need third-party python libraries such as:

numpy, scipy, matplotlib, lxml
    Usually shipped with your python packages
    Available in Ubuntu packages
theano
    Can be found on pip
    Need version 0.6 and above
    http://deeplearning.net/software/theano/
bandmat
    Can be found on pip
    https://pypi.python.org/pypi/bandmat

For running on NVIDIA GPU, you will need also CUDA
    https://developer.nvidia.com/cuda-zone
and you might want also CUDNN [optionnal]
    https://developer.nvidia.com/cudnn
    
Computationnal efficiency is obviously greatly improved using GPU.
It is also improved using the latest versions of theano.
josh@yoga:~/git/merlin$ cd tools/
josh@yoga:~/git/merlin/tools$ ls
compile_tools.sh  INSTALL  WORLD  WORLD_v2

{% endhighlight %}

So, we find that to install Merlin succesfully, we have to:

1. Follow the instructions in the `tools/INSTALL` file
2. Install some Python dependencies

Let's follow those instructions in the order suggested, and start with the instructions in the `tools/INSTALL` file:

## Compile

{% highlight bash %}

josh@yoga:~/git/merlin/tools$ cat ./INSTALL 
INSTALL
=======

./compile_tools.sh

{% endhighlight %}

They cut straight to the point! We have to just run that one `compile_tools.sh` script and we should be good apart from Python dependencies. 

So, when we run that script, we see something like this:

{% highlight bash %}
josh@yoga:~/git/merlin/tools$ ./compile_tools.sh 
downloading SPTK-3.9...
--2017-02-14 10:31:33--  http://downloads.sourceforge.net/sp-tk/SPTK-3.9.tar.gz
Résolution de downloads.sourceforge.net (downloads.sourceforge.net)… 216.34.181.59
Connexion à downloads.sourceforge.net (downloads.sourceforge.net)|216.34.181.59|:80… connecté.
requête HTTP transmise, en attente de la réponse… 301 Moved Permanently
Emplacement : http://downloads.sourceforge.net/project/sp-tk/SPTK/SPTK-3.9/SPTK-3.9.tar.gz [suivant]
--2017-02-14 10:31:34--  http://downloads.sourceforge.net/project/sp-tk/SPTK/SPTK-3.9/SPTK-3.9.tar.gz
Réutilisation de la connexion existante à downloads.sourceforge.net:80.
requête HTTP transmise, en attente de la réponse… 302 Moved Temporarily
Emplacement : https://netix.dl.sourceforge.net/project/sp-tk/SPTK/SPTK-3.9/SPTK-3.9.tar.gz [suivant]
--2017-02-14 10:31:34--  https://netix.dl.sourceforge.net/project/sp-tk/SPTK/SPTK-3.9/SPTK-3.9.tar.gz
Résolution de netix.dl.sourceforge.net (netix.dl.sourceforge.net)… 87.121.121.2
Connexion à netix.dl.sourceforge.net (netix.dl.sourceforge.net)|87.121.121.2|:443… connecté.
requête HTTP transmise, en attente de la réponse… 200 OK
Taille : 1077702 (1.0M) [application/x-gzip]
Enregistre : «SPTK-3.9.tar.gz.1»

100%[===========================================================================================================================================================================>] 1,077,702    262KB/s   ds 4.0s   

2017-02-14 10:31:39 (262 KB/s) - «SPTK-3.9.tar.gz.1» enregistré [1077702/1077702]

compiling SPTK...
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking whether gcc understands -c and -o together... yes
checking for style of include used by make... GNU
                                .
                                .
                                .
test/audioio.cpp:92:38: warning: ignoring return value of ‘size_t fread(void*, size_t, size_t, FILE*)’, declared with attribute warn_unused_result [-Wunused-result]
       fread(&data_check[1], 1, 3, fp);
                                      ^
test/audioio.cpp:104:34: warning: ignoring return value of ‘size_t fread(void*, size_t, size_t, FILE*)’, declared with attribute warn_unused_result [-Wunused-result]
   fread(for_int_number, 1, 4, fp);  // "data"
                                  ^
mkdir -p ./build/objs/test
g++ -O1 -g -Wall -fPIC -Isrc -o "build/objs/test/analysis.o" -c "test/analysis.cpp"
g++ -O1 -g -Wall -fPIC -o ./build/analysis ./build/objs/test/audioio.o ./build/objs/test/analysis.o ./build/libworld.a -lm
mkdir -p ./build/objs/test
g++ -O1 -g -Wall -fPIC -Isrc -o "build/objs/test/synth.o" -c "test/synth.cpp"
test/synth.cpp: In function ‘void {anonymous}::WaveformSynthesis(WorldParameters*, int, int, double*)’:
test/synth.cpp:240:9: warning: variable ‘elapsed_time’ set but not used [-Wunused-but-set-variable]
   DWORD elapsed_time;
         ^
test/synth.cpp: In function ‘int main(int, char**)’:
test/synth.cpp:313:55: warning: ignoring return value of ‘size_t fread(void*, size_t, size_t, FILE*)’, declared with attribute warn_unused_result [-Wunused-result]
  fread(&world_parameters.f0[i], sizeof(double), 1, fp);
                                                       ^
test/synth.cpp:332:72: warning: ignoring return value of ‘size_t fread(void*, size_t, size_t, FILE*)’, declared with attribute warn_unused_result [-Wunused-result]
       fread(&world_parameters.spectrogram[i][j], sizeof(double), 1, fp);
                                                                        ^
test/synth.cpp:341:65: warning: ignoring return value of ‘size_t fread(void*, size_t, size_t, FILE*)’, declared with attribute warn_unused_result [-Wunused-result]
       fread(&coarse_aperiodicities[i][j], sizeof(double), 1, fp);
                                                                 ^
g++ -O1 -g -Wall -fPIC -o ./build/synth ./build/objs/test/audioio.o ./build/objs/test/synth.o ./build/libworld.a -lm
Removing all temporary binaries... 
Done.
All tools successfully compiled!!

{% endhighlight %}

Since the output to the terminal was pretty long, I cut out a big part in the middle as you can see.


## Python Dependencies

So now that we have compiled our Merlin tools, let's move on to the second step in the main `merlin/INSTALL` file where we are instructred to make sure we have the right Python dependencies installed. It's not explicit, but I'm pretty sure we need Python2 and not Python3. In any case, I've tested this out with Python2 on my system and it seems to work ok.

So, let's get all the dependencies in one fell swoop with the trusty `pip` program. This program helps us install Python packages securely and easily. You probably already have it installed, but if not, follow the simple instructions [here][pip-install].

{% highlight bash %}

josh@yoga:~/git/merlin$ pip install numpy scipy matplotlib lxml theano bandmat

{% endhighlight %}

If you've already successfully installed these packages, you will see something like the following:

{% highlight bash %}
josh@yoga:~$ pip install numpy scipy matplotlib lxml theano bandmat
Requirement already satisfied (use --upgrade to upgrade): numpy in /usr/local/lib/python2.7/dist-packages
Requirement already satisfied (use --upgrade to upgrade): scipy in /usr/lib/python2.7/dist-packages
Requirement already satisfied (use --upgrade to upgrade): matplotlib in /usr/lib/pymodules/python2.7
Requirement already satisfied (use --upgrade to upgrade): lxml in /usr/lib/python2.7/dist-packages
Requirement already satisfied (use --upgrade to upgrade): theano in /usr/local/lib/python2.7/dist-packages
Requirement already satisfied (use --upgrade to upgrade): bandmat in /usr/local/lib/python2.7/dist-packages
Requirement already satisfied (use --upgrade to upgrade): python-dateutil in /usr/lib/python2.7/dist-packages (from matplotlib)
Requirement already satisfied (use --upgrade to upgrade): tornado in /usr/local/lib/python2.7/dist-packages (from matplotlib)
Requirement already satisfied (use --upgrade to upgrade): pyparsing>=1.5.6 in /usr/lib/python2.7/dist-packages (from matplotlib)
Requirement already satisfied (use --upgrade to upgrade): nose in /usr/lib/python2.7/dist-packages (from matplotlib)
Requirement already satisfied (use --upgrade to upgrade): six>=1.9.0 in /usr/local/lib/python2.7/dist-packages (from theano)
Requirement already satisfied (use --upgrade to upgrade): backports.ssl-match-hostname in /usr/local/lib/python2.7/dist-packages (from tornado->matplotlib)
Requirement already satisfied (use --upgrade to upgrade): singledispatch in /usr/local/lib/python2.7/dist-packages (from tornado->matplotlib)
Requirement already satisfied (use --upgrade to upgrade): certifi in /usr/local/lib/python2.7/dist-packages (from tornado->matplotlib)
Requirement already satisfied (use --upgrade to upgrade): backports-abc>=0.4 in /usr/local/lib/python2.7/dist-packages (from tornado->matplotlib)
Cleaning up...
{% endhighlight %}

So now, at this point we have downloaded and compiled Merlin along with all its necessary dependencies!

Now let's go on to run the demo.


## Running the demo

As per the main `merlin/README.md` file, we are invited to begin our demo with example `slt_arctic`.

So, let's `cd` into that directory and take a look around.


{% highlight bash %}

josh@yoga:~/git/merlin$ cd egs/slt_arctic/s1/
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ ls
conf  merlin_synthesis.sh  README.md  RESULTS.md  run_demo.sh  run_full_voice.sh  scripts  testrefs

{% endhighlight %}

First things first, let's look at what the `README` has to tell us about this example.

{% highlight bash %}

josh@yoga:~/git/merlin/egs/slt_arctic/s1$ cat README.md 
Demo voice
----------

To run demo voice, please follow below steps:

Step 1: git clone https://github.com/CSTR-Edinburgh/merlin.git <br/>
Step 2: cd merlin/egs/slt_arctic/s1 <br/>
Step 3: ./run_demo.sh

Demo voice trains only on 50 utterances and shouldnt take more than 5 min. 

Compare the results in log files to baseline results from demo data in [RESULTS.md](https://github.com/CSTR-Edinburgh/merlin/blob/master/egs/slt_arctic/s1/RESULTS.md)

Full voice
----------

To run full voice, please follow below steps:

Step 1: git clone https://github.com/CSTR-Edinburgh/merlin.git <br/>
Step 2: cd merlin/egs/slt_arctic/s1 <br/>
Step 3: ./run_full_voice.sh

Full voice utilizes the whole arctic data (1132 utterances). The training of the voice approximately takes 1 to 2 hours. 

Compare the results in log files to baseline results from full data in [RESULTS.md](https://github.com/CSTR-Edinburgh/merlin/blob/master/egs/slt_arctic/s1/RESULTS.md)

Generate new sentences
----------------------

To generate new sentences, please follow below steps:

Step 1: Run either demo voice or full voice. <br/>
Step 2: ./merlin_synthesis.sh

{% endhighlight %}

So, we're going to start with the simpler `demo voice` as suggested.

But, before we just go and run that `run_demo.sh`, lets investigate what data and scripts we have so far so that we can get an idea of what Merlin requires and what the workflow is.

So, I always like to use the `tree` program for Linux. It's a very simple program that will list out the contents of a directory recursively with 
{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree .
.
├── conf
│   ├── dnn
│   │   ├── acoustic_slt_arctic_full.conf
│   │   ├── duration_slt_arctic_full.conf
│   │   ├── test_dur_synth_slt_arctic_full.conf
│   │   └── test_synth_slt_arctic_full.conf
│   └── logging_config.conf
├── merlin_synthesis.sh
├── README.md
├── RESULTS.md
├── run_demo.sh
├── run_full_voice.sh
├── scripts
│   ├── prepare_config_files_for_synthesis.sh
│   ├── prepare_config_files.sh
│   ├── prepare_labels_from_txt.sh
│   ├── remove_intermediate_files.sh
│   ├── setup.sh
│   └── submit.sh
└── testrefs
    ├── slt_arctic_demo
    │   ├── acoustic_model
    │   │   └── log
    │   │       └── DNN_TANH_TANH_TANH_TANH_LINEAR__mgc_lf0_vuv_bap_50_259_4_512_0.002000_04_59PM_August_23_2016.log
    │   └── duration_model
    │       └── log
    │           └── DNN_TANH_TANH_TANH_TANH_LINEAR__dur_50_259_4_512_0.002000_04_57PM_August_23_2016.log
    └── slt_arctic_full
        ├── acoustic_model
        │   └── log
        │       └── DNN_TANH_TANH_TANH_TANH_LINEAR__mgc_lf0_vuv_bap_1000_259_4_512_0.002000_08_47PM_August_30_2016.log
        └── duration_model
            └── log
                └── DNN_TANH_TANH_TANH_TANH_LINEAR__dur_1000_259_4_512_0.002000_08_44PM_August_30_2016.log

14 directories, 20 files
{% endhighlight %}



[merlin-github]: https://github.com/CSTR-Edinburgh/merlin
[merlin-cstr]: http://www.cstr.ed.ac.uk/projects/merlin/
[pip-install]: https://pip.pypa.io/en/stable/installing/