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

So, what should we take away from the files and directories present?

Firstly, if we just look at the first layer of files and dirs inside `s1`, we see three (3) dirs, three (3) scripts, and two (2) documentation files.

As for the three dirs, the first dir (in alphabetical order) is `conf`. The `conf` dir (short for configuration) houses a dir of DNN configuration files. These DNN "conf" files define some information about the paths to relevant directories, information about the training data, and the architecture of the DNNs we want to train.

There are a total of four (4) DNN configuration files, the first two for training and the last two for testing:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/conf/dnn$ tree .
.
├── acoustic_slt_arctic_full.conf
├── duration_slt_arctic_full.conf
├── test_dur_synth_slt_arctic_full.conf
└── test_synth_slt_arctic_full.conf

0 directories, 4 files
{% endhighlight %}

In Merlin, we don't just model the phonemes of the language. We also model their durations. For both (1) phoneme modeling and (2) duration modeling, we use DNNs, and as such we have two configuration files as seen in the `conf/dnn/` dir above.

Quoting from the team's [demonstration paper][merlin-demo-paper], they concisely describe the duration model as such:

> **Duration modelling** Merlin models duration using a separate
> DNN to the acoustic model.  The duration model is trained on
> the aligned data, to predict phone- and/or state-level durations.
> At synthesis time, duration is predicted first, and is used as an
> input to the acoustic model to predict the speech parameters.

Moving onto the second directory within `s1`, we find the location of our data preparation scripts.

Logically, this directory is labeled `scripts`.

Let's take a look inside:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/scripts$ tree .
├── prepare_config_files_for_synthesis.sh
├── prepare_config_files.sh
├── prepare_labels_from_txt.sh
├── remove_intermediate_files.sh
├── setup.sh
└── submit.sh

0 directories, 6 files
{% endhighlight %}

The first four files have very transparent filenames, so I won't elaborate on them.

Skipping to the `setup.sh` script, you should know that the main purpose of this script is to create the main directories to house the current experiment, move test and train data into those directories, and define the global configuration file.

Some main snippets from this file:

Making the dirs and moving data:

{% highlight bash %}
experiments_dir=${current_working_dir}/experiments
voice_dir=${experiments_dir}/${voice_name}
acoustic_dir=${voice_dir}/acoustic_model
duration_dir=${voice_dir}/duration_model
synthesis_dir=${voice_dir}/test_synthesis

mkdir -p ${experiments_dir}
mkdir -p ${voice_dir}
mkdir -p ${acoustic_dir}
mkdir -p ${duration_dir}

mv ${data_dir}/merlin_baseline_practice/duration_data/ ${duration_dir}/data
mv ${data_dir}/merlin_baseline_practice/acoustic_data/ ${acoustic_dir}/data
mv ${data_dir}/merlin_baseline_practice/test_data/ ${synthesis_dir}
{% endhighlight %}

Saving important information to the global config file:

{% highlight bash %}
global_config_file=conf/global_settings.cfg

echo "MerlinDir=${merlin_dir}" >  $global_config_file
echo "WorkDir=${current_working_dir}" >>  $global_config_file
echo "Voice=${voice_name}" >> $global_config_file
echo "Labels=state_align" >> $global_config_file
echo "QuestionFile=questions-radio_dnn_416.hed" >> $global_config_file
echo "Vocoder=WORLD" >> $global_config_file
echo "SamplingFreq=16000" >> $global_config_file

echo "FileIDList=file_id_list_demo.scp" >> $global_config_file
echo "Train=50" >> $global_config_file 
echo "Valid=5" >> $global_config_file 
echo "Test=5" >> $global_config_file 
{% endhighlight %}

This config file will contain information on where the Merlin compiled programs are located, where the current working dir is, what kind of Vocoder we're using is, and how many files to use for training and testing.

It will also download the data for this particular demo and move data to the right location. This happens earlier in the script, but I think because it is specific to the demo data used here, it is not the main purpose of this `setup.sh` script.

Moving on, the next script located in the `s1/scripts/` dir which deserves a word of explanation is the `submit.sh` script. However, the name is transparent once you know that this script will take any Theano job and submit it to either a GPU or CPU, depending on what you have available.

Moving back up a level to the `s1/` dir, the last of the three main dirs is `testrefs`. This dir contains only four (4) files, which are all log files from training performed by the CSTR team. These files can be used to compare against our own training in case we hit any problems.

At this point, we've briefly gone over the content of all the three dirs in the first level of the main model dir: `s1`. Specifically, we mentioned:

1. `conf`: contains configuration files for building, training, and testing our DNNs
2. `scripts`: contains scripts for preparing data and submitting Theano jobs
2. `testrefs`: contains log files from the CSTR team for our reference

Now that we've gone over our dirs, we can go to our three scripts in the top level of `s1`:

1. `merlin_synthesis.sh`
2. `run_demo.sh`
3. `run_full_voice.sh`

I would normally walk through the scripts in alphabetical order, but in fact, the `s1/README.md` file directs us to run the `run_demo.sh` script first, so I will start there. I'm going to skip over the `run_full_voice.sh` altogether, since it is the equivalent of `run_demo.sh` but with more data.

So, walking through the `run_demo.sh` script, the first thing we see is the data prep stage:

{% highlight bash %}
### Step 1: setup directories and the training data files ###
echo "Step 1: setting up experiments directory and the training data files..."
global_config_file=conf/global_settings.cfg
./scripts/setup.sh slt_arctic_demo
./scripts/prepare_config_files.sh $global_config_file
./scripts/prepare_config_files_for_synthesis.sh $global_config_file
{% endhighlight %}

Running these scripts one-by-one, it's easier to see what's going on in my opinion. In the following, I'll be inserting `exit` after the section in question, and commenting out all previous lines of code. I could just run one line of code at a time in the terminal, but there are some variables floating around and I don't want to bother with them, so in the following you will see I'm running the `run_demo.sh` script over and over again, but keep in mind I'm actually only running the code of interest.

So, beginning with the `setup.sh` script, we get the following output to the terminal:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ ./run_demo.sh 
Step 1: setting up experiments directory and the training data files...
downloading data.....
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 12.9M  100 12.9M    0     0  2856k      0  0:00:04  0:00:04 --:--:-- 3181k
unzipping files......
data is ready!
Merlin default voice settings configured in conf/global_settings.cfg
setup done...!Step 1: setting up experiments directory and the training data files...
downloading data.....
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 12.9M  100 12.9M    0     0  2856k      0  0:00:04  0:00:04 --:--:-- 3181k
unzipping files......
data is ready!
Merlin default voice settings configured in conf/global_settings.cfg
setup done...!
{% endhighlight %}

Looking into the file structure at this time, we first see we have a new global config file in the `conf` dir:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree conf/
conf/
├── dnn
│   ├── acoustic_slt_arctic_full.conf
│   ├── duration_slt_arctic_full.conf
│   ├── test_dur_synth_slt_arctic_full.conf
│   └── test_synth_slt_arctic_full.conf
├── global_settings.cfg
└── logging_config.conf

1 directory, 6 files
{% endhighlight %}

We also see that a new directory (`experiments`) has been created with 14 sub directories:


{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree experiments/
experiments/
└── slt_arctic_demo
    ├── acoustic_model
    │   └── data
    │       ├── bap
    │       │   ├── arctic_a0001.bap
    │       │   ├── arctic_a0002.bap
    │       │   └── arctic_a0003.bap
    │       ├── file_id_list_demo.scp
    │       ├── label_phone_align
    │       │   ├── arctic_a0001.lab
    │       │   ├── arctic_a0002.lab
    │       │   └── arctic_a0003.lab
    │       ├── label_state_align
    │       │   ├── arctic_a0001.lab
    │       │   ├── arctic_a0002.lab
    │       │   └── arctic_a0003.lab
    │       ├── lf0
    │       │   ├── arctic_a0001.lf0
    │       │   ├── arctic_a0002.lf0
    │       │   └── arctic_a0003.lf0
    │       └── mgc
    │           ├── arctic_a0001.mgc
    │           ├── arctic_a0002.mgc
    │           └── arctic_a0003.mgc
    ├── duration_model
    │   └── data
    │       ├── file_id_list_demo.scp
    │       ├── label_phone_align
    │       │   ├── arctic_a0001.lab
    │       │   ├── arctic_a0002.lab
    │       │   └── arctic_a0003.lab
    │       └── label_state_align
    │           ├── arctic_a0001.lab
    │           ├── arctic_a0002.lab
    │           └── arctic_a0003.lab
    └── test_synthesis
        ├── prompt-lab
        │   ├── arctic_a0001.lab
        │   ├── arctic_a0002.lab
        │   └── arctic_a0003.lab
        └── test_id_list.scp

14 directories, 433 files

{% endhighlight %} 

In the above output I've omitted displaying most files because there's a lot, specifically, there's 433 files.

In terms of the file formats, we find the following:

1. `*.bap`: band a-periodicities
2. `*.lab`: label files (time-to-phone alignments)
3. `*.lf0`: log-fundamental frequencies
4. `*.mgc`: generalized cepstral coefficients




[merlin-github]: https://github.com/CSTR-Edinburgh/merlin
[merlin-cstr]: http://www.cstr.ed.ac.uk/projects/merlin/
[pip-install]: https://pip.pypa.io/en/stable/installing/
[merlin-demo-paper]: http://homepages.inf.ed.ac.uk/s1432486/papers/Merlin_demo_paper.pdf