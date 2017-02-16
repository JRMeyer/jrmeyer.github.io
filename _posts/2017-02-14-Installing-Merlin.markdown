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


<br/>
<br/>

## Installation

### Clone

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

### Compile

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


### Install Python Dependencies

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


<br/>
<br/>

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

<br/>

### Pre-existing Dirs & Files

Before we just go and run that `run_demo.sh`, lets investigate what data and scripts we have so far so that we can get an idea of what Merlin requires and what the workflow is.

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

<br/>

##### `conf`

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

<br/>

##### `scripts`

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

The first four data preparation scripts in the `scripts` dir have very transparent filenames, so I won't elaborate on them.

However, we should note that the main purpose of the `setup.sh` script is to download the demo data, create the main directories to house the current experiment, move test and train data into those directories, and define the global configuration file.

Moving on, the next script located in the `s1/scripts/` dir which deserves a word of explanation is the `submit.sh` script. However, the name is transparent once you know that this script will take any Theano job and submit it to either a GPU or CPU, depending on what you have available.

<br/>

##### `testrefs`

Moving back up a level to the `s1/` dir, the last of the three main dirs is `testrefs`. This dir contains only four (4) files, which are all log files from training performed by the CSTR team. These files can be used to compare against our own training in case we hit any problems.

At this point, we've briefly gone over the content of all the three dirs in the first level of the main model dir: `s1`. Specifically, we mentioned:

1. `conf`: contains configuration files for building, training, and testing our DNNs
2. `scripts`: contains scripts for preparing data and submitting Theano jobs
2. `testrefs`: contains log files from the CSTR team for our reference

Now that we've gone over our dirs, we can go to our three scripts in the top level of `s1`:

1. `merlin_synthesis.sh`
2. `run_demo.sh`
3. `run_full_voice.sh`

<br/>

### Running the `run_demo.sh` Script

The `s1/README.md` file directs us to run the `run_demo.sh` script first, so I will start there.

So, walking through the `run_demo.sh` script, the first thing we see is three scripts in the data prep stage:

{% highlight bash %}
### Step 1: setup directories and the training data files ###
echo "Step 1: setting up experiments directory and the training data files..."
global_config_file=conf/global_settings.cfg
./scripts/setup.sh slt_arctic_demo
./scripts/prepare_config_files.sh $global_config_file
./scripts/prepare_config_files_for_synthesis.sh $global_config_file
{% endhighlight %}

If we take the time to run these scripts one-by-one, we can more easily see what's going on. I'm going to run each script here, and look into what's being output by each one.

<br/>

### Calling the `setup.sh` script from `run_demo.sh`

`setup.sh` does two important things:

1. download, unzip, and move training and testing data into new `experiments` dir
2. create global configuration file, `global_settings.cfg`, in our `conf` dir

So, beginning by running *only* the `setup.sh` script (from within `run_demo.sh`), we get the following output to the terminal:

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
setup done...!
{% endhighlight %}

Looking into the file structure at this time of the `s1` dir (for just the first level, hence the `-L 1` flag, we can see we've created a few new things:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree -L 1 .
.
├── conf
├── experiments
├── merlin_synthesis.sh
├── README.md
├── RESULTS.md
├── run_demo.sh
├── run_full_voice.sh
├── scripts
├── slt_arctic_demo_data
├── slt_arctic_demo_data.zip
└── testrefs

5 directories, 6 files
{% endhighlight %}

Specifically, we have created the following:

1. `experiments` dir
2. `slt_arctic_demo_data` dir
3. `slt_arctic_demo_data.zip` compressed file

What happened was that the relevant data files were downloaded from [Srikanth Ronanki's homepage][ronanki], hence the `slt_arctic_demo_data.zip` file.

Then this file was uncompressed and saved as `slt_arctic_demo_data`.

Then the relevant files were copied into the new `experiments` directory.

As such, at this point the `experiments` dir contains mostly just extracted audio feature files. 

Here's what we find in this new `experiments` dir:

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

Since there's a lot of stuff going on in the `experiments` dir, I think it's worth the time to briefly explain what we have downloaded in terms of audio feature, label, and utterance ID files.

<br/>

#### File Formats in `experiments` Dir

In terms of the file formats, we find the following:

1. `*.bap`: band a-periodicities
2. `*.lab`: label files (time-to-phone alignments)
3. `*.lf0`: log-fundamental frequencies
4. `*.mgc`: generalized cepstral coefficients
5. `*.scp`: script file for filenames

<br/>

#### `*.bap`

The first file type, `*.bap`, is a kind of feature extracted from the audio, and we have one file for every audio file in our data set. If we look into the `*.bap` file itself, we find it is not human readable, but that makes sense, because it contains extracted audio features:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data/bap$ head arctic_a0001.bap 
B#߿�
    ��]����T��,�x�kQ�����[kr�զ������B#���Q��D���������f�A����d_�������Rz�����%�u��3
                                                                                          �hZ
                                                                                             ����ځK���[���n�l��F���LJ���ؿ|��Ƅd�|)��.���-����D�~�$�J�&�eV����s[���u��̞�����Ҩ��
                                                                                                                                                                                   �h���6���TR�Q<,��������	C"��PN��g��]��K�Đ���(1���?����9�7�Y.���A�nj*���.�R�W��!���>�����@�R����L����4���^̄��:F�����;�ֿ=�׿�d�ʷ6� ��A���Z�"�����k@=��6�qcϿ�"�
                                                                                                                                             A6��Q鿩κ�w������ƿ�ڿߗ��ֿ�g�������w���i��H���݊@��9~�jXf��1�~����'��d�DD����J��ID��i��~��T����1$�	�S�������#WI�s�=����Y�N��J��7'�P8D�8� �w��
�o�y�;w�8���I�T���o�4e������J������������<������q.ݿ2����B���                   0������Y������f�������!�P����@��9?���.��v7�2�$�o�������4L�m��E�����V�:�����Ԡ��|�[�n�%��ϣ��z��m`"���3�.���
��1?�X=�-�,�b���Pÿ�+��]`޿\�o����3�[�d�:��D)��dX�l�6�܌S���,���W�� @��fj�tr�e+t��<���$r�����g����ɿ9��v��~I�'���U'#�yL�������y��At�W�u���Y�L }���G>����m{p������T��E�G��O%��0�3���2��]��Z���r����u�y���iT��?�����x�sGT�A{�����p�u$ҿ#�.��8,��ғ�/���zT�X�ؿ��H��/5�<������������c�����j�����I��������2���a�F�5���.r��{v��s���\����0��;X�d�`��!H�4d��A�-�?���f��)�S,\�
                                                                                                                                                                    M�?f�t(�1��MM��6����bp7�K<h���I�	i���_}>�6S�_*�s��[ڒ�����t�7Hh�XY3���7���BR��|��Kb�?�������z��̒�ao~���u������%����f�y�A�;�.X4���W���<�c\�S�7�{�a#��DQ���d���@�W𮿂���r&��
�Z�2���c�aٝ�����d                                                                                                                                 �e��m���ֵ�Z���[�Ϳ����8��D|C�D�����
��]�����T����͊�}�J���/���'��aR�Y��	IM@��4@���d���
                                                       �DJ(�v\/�~���89�A?���A\M���+���j�i���SFa�B�B��ER�o�0V���9h������n�|�:�:�/�Q�f��uY���=�$��@	�׉��[9D���>J��)v�ße���Q�� N�IT�����|90��:]�D
B���	���-�����g�W[��׳
{% endhighlight %}


<br/>

#### `*.lab`

The second file type in the `experiments` dir is `*.lab`. These files are the "label" files which contain alignments for either phones or states to our audio files from our data set. We have two kinds of files here: (1) for phoneme alignments, and (2) for state alignments.

First, for phoneme alignments, we see something like this:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data/label_phone_align$ head arctic_a0001.lab 
0 2050000 x^x-sil+sil=ao@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:0+0+0/D:0_0/E:x+x@x+x&x+x#x+x/F:0_0/G:0_0/H:x=x@1=2|0/I:0=0/J:14+8-2
2050000 3400000 sil^sil-ao+th=er@1_2/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
3400000 4650000 sil^ao-th+er=ah@2_1/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
4650000 5950000 ao^th-er+ah=v@1_1/A:1_1_2/B:0-0-1@2-1&2-6#1-4$1-3!1-1;1-3|er/C:1+0+2/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
5950000 6650000 th^er-ah+v=dh@1_2/A:0_0_1/B:1-0-2@1-1&3-5#1-3$1-3!2-2;2-2|ah/C:0+0+2/D:content_2/E:in+1@2+4&2+2#1+2/F:det_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
6650000 7650000 er^ah-v+dh=ax@2_1/A:0_0_1/B:1-0-2@1-1&3-5#1-3$1-3!2-2;2-2|ah/C:0+0+2/D:content_2/E:in+1@2+4&2+2#1+2/F:det_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
7650000 8200000 ah^v-dh+ax=d@1_2/A:1_0_2/B:0-0-2@1-1&4-4#2-3$1-3!1-1;3-1|ax/C:1+1+4/D:in_1/E:det+1@3+3&2+2#2+1/F:content_2/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
8200000 8500000 v^dh-ax+d=ey@2_1/A:1_0_2/B:0-0-2@1-1&4-4#2-3$1-3!1-1;3-1|ax/C:1+1+4/D:in_1/E:det+1@3+3&2+2#2+1/F:content_2/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
8500000 9450000 dh^ax-d+ey=n@1_4/A:0_0_2/B:1-1-4@1-2&5-3#2-2$1-2!2-2;4-2|ey/C:0+0+1/D:det_1/E:content+2@4+2&2+1#3+1/F:content_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
9450000 10450000 ax^d-ey+n=jh@2_3/A:0_0_2/B:1-1-4@1-2&5-3#2-2$1-2!2-2;4-2|ey/C:0+0+1/D:det_1/E:content+2@4+2&2+1#3+1/F:content_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2
{% endhighlight %}

For state-level alignments, we get the following:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data/label_state_align$ head arctic_a0001.lab 
0 50000 x^x-sil+sil=ao@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:0+0+0/D:0_0/E:x+x@x+x&x+x#x+x/F:0_0/G:0_0/H:x=x@1=2|0/I:0=0/J:14+8-2[2]
50000 100000 x^x-sil+sil=ao@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:0+0+0/D:0_0/E:x+x@x+x&x+x#x+x/F:0_0/G:0_0/H:x=x@1=2|0/I:0=0/J:14+8-2[3]
100000 150000 x^x-sil+sil=ao@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:0+0+0/D:0_0/E:x+x@x+x&x+x#x+x/F:0_0/G:0_0/H:x=x@1=2|0/I:0=0/J:14+8-2[4]
150000 1700000 x^x-sil+sil=ao@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:0+0+0/D:0_0/E:x+x@x+x&x+x#x+x/F:0_0/G:0_0/H:x=x@1=2|0/I:0=0/J:14+8-2[5]
1700000 2050000 x^x-sil+sil=ao@x_x/A:0_0_0/B:x-x-x@x-x&x-x#x-x$x-x!x-x;x-x|x/C:0+0+0/D:0_0/E:x+x@x+x&x+x#x+x/F:0_0/G:0_0/H:x=x@1=2|0/I:0=0/J:14+8-2[6]
2050000 2400000 sil^sil-ao+th=er@1_2/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2[2]
2400000 2550000 sil^sil-ao+th=er@1_2/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2[3]
2550000 2650000 sil^sil-ao+th=er@1_2/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2[4]
2650000 2700000 sil^sil-ao+th=er@1_2/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2[5]
2700000 3400000 sil^sil-ao+th=er@1_2/A:0_0_0/B:1-1-2@1-2&1-7#1-4$1-3!0-2;0-4|ao/C:0+0+1/D:0_0/E:content+2@1+5&1+2#0+3/F:in_1/G:0_0/H:7=5@1=2|L-L%/I:7=3/J:14+8-2[6]
{% endhighlight %}

For a little sanity check, we can see that the two `*.lab` files for the same audio file have different number of lines. Specifically, since each line represents and alignment in time, we would expect that since for any given `phoneme` alignment, we would have more than three times more lines for its `state` alignment. That is because we usually use triphone phonemes to do alignment. We'd have to look more into the details of the acoustic model used to do forced alignment to generate the labels, but the difference between number of lines in the alignment files are around the expected numbers:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data$ wc -l label_phone_align/arctic_a0001.lab 
37 label_phone_align/arctic_a0001.lab
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data$ wc -l label_state_align/arctic_a0001.lab 
185 label_state_align/arctic_a0001.lab
{% endhighlight %}

In this case, we have for the audio file `arctic_a0001.lab` a total of **37 phonemes** and **185 states**. This comes out to `185/37 = 5` states per phoneme. Five states per phoneme is not a crazy number at all.


<br/>

#### `*.lf0`

The `*.lf0` files are the log-fundamental frequency files, aka, another kind of feature file extracted from our audio files in our data set.

We can expect these files to not be human-readable, and that's just what we see when we look in to one such file:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data/lf0$ head arctic_a0001.lf0 
����������������������������������������������������������������������������������������M1�@�y�@�d�@x��@���@5��@Xg�@Ní@yE�@��b�@�8�@d�@���@�ȫ@|��@쬫@"ޫ@���@��@�a�@���@2��@���@�Ȭ@�	�@)r�@�/�@���@���@�������������������������������k�@滿@A��@�߷@@ղ@~�@(J�@�ů@���@���@�ȯ@�Я@'�@C�@�2�@�S�@Uk�@܊�@r��@���@���@���@��@4ש@N;�@ޗ�@���@A+�@j3�@�7�@yR�@R��@A�@�t�@�[�@���@�@W	0�@;�@5��@5��@�r�@��Pˣ@M�@�Q�@G�@1��@��@���@,_�@�$�@o�@i��@�ȩ@
�@ب@�z�@ݤ�@ߥ@��@QX�@�
                       �@/�@�7�@���@'�@���@R٠@U�@�2�@P��@��@��@k
�@aR�@���@+�@!
�@
b�@!��@(g�@�\�@kW�@)0�@o>�@�I�@n-�@5:�@�=�@@^�@��������������������+�@A��@�~�@�]�@���@���@�ʦ@�Ŧ@sæ@Ţ�@�Y�@aC�@QM�@�Z�@�H�@Lt�@�@��@̓�@襦@<��@�@�@


�@i�@'��@�q�@�t�@���@���@���@'��@��@���@?��@=ʦ@�̦@�Φ@�ܦ@|ަ@���@��@��@@�@6t�@�)�@J�@(¦@#
                                                                                          �@�@�3�@�P�@(A���@>*�@�x�@M��@�_�@a��@�S�@���������������������������������������������������Ь�@r�@���@ذ�@R+�@�@���@4Ǩ@�Ψ@�Ǩ@/��@Ŭ�@bè@�ب@���@�1�@�o�@��@��@�m�@��@�ͪ@p��@3$�@��@^(�@[C�@���@\�@�]�@�R�@o��@0n�@l��@Jk�@6��@���@���@���@�������������������������������������������������������������������������
=�@���@��@�̧@@x��@�x�@6a�@f�@�n�@�n�@�p�@Hy�@訧@��@X��@���@���@��@�T�@��@��@,��@���@q��@���@*��@�Z�@E��@���@���@��@ʦ@�Ҧ@�֦@���@1!�@z+�@2*�@<�@'�@�s�@�~�@tç@�ʧ@�Ч@칧@�ŧ@�ۧ@ۧ@���@=0�@�4�@mǦ@;ͦ@@S�@@��@���@�8�@����������������������������������������������������������������x��@����������������������������������������������������9�@2��@�&�@ƨ@Nm�@���@@f�@���@]ͦ@�Ʀ@F��@˹�@���@	~�@���@�m�@�$�@���@Q�@���@ ��@�@�ע��@R��@U(�@�Q�@�q�@��@���@���@�v�@�e�@;p�@�Z�@��@��@ �@���@��@f��@wդ@�Ǥ@���@⚤@;Y�@
                                                                                                                                                                                                 1�@
�@���@���@���@�գ@�0�@̑�@�@w��@q�@�W�@   �@Kݤ@��@�A�@�^�@���@�@;�@5��@ �@�ˢ@�ǣ@|��@���@2�@�����������������������������������������������������������������������������
{% endhighlight %}

I've deleted a bunch of empty lines in the above output so as not to take up so much space.


<br/>

#### `*.mgc`

Next, we move onto our next feature file type: `*.mgc`. These files contain the generalized cepstral coefficients for our audio files in our data set. Again, this is not very human readable:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data/mgc$ head arctic_a0001.mgc 
5��?;�?o�\?��M?聥>FԄ>��r>�n�>�B�>���0�<x��>�d�&�>\��آ�<�
                                                           =�8�=8E�8Wq��׹�=�qV��և�o��<z�J=��`�ĸ��'�+<�ư=0!I�
                                                                                                               ���D<1=̫=J5ҽ(>����n<c�=���
{% endhighlight %}
                                                                                                                                      



<br/>

#### `*.scp`

Moving on to the next file type, the `*.scp` files here, I'm guessing, are similar to Kaldi's `*.scp` files. These files are "script" files which typically contain lists of information. In this case, the `experiments` dir contains two `*.scp` files which contain lists of file ids. For example:
 
{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1/experiments/slt_arctic_demo/acoustic_model/data$ head file_id_list_demo.scp 
arctic_a0001
arctic_a0002
arctic_a0003
arctic_a0004
arctic_a0005
arctic_a0006
arctic_a0007
arctic_a0008
arctic_a0009
arctic_a0010
{% endhighlight %}

<br/>

Now that we've gone through the `experiments` dir and the format of its file contents, here's a short recap of where we are:

> We've just run the `setup.sh` script. This script downloaded, unzipped, and formatted the data we need for training and testing. The data we need includes (1) various audio feature files, (2) label files, and (3) utterance lists.

<br/>

#### Creating `global_settings.cfg` in `conf` dir

We shouldn't forget that the `setup.sh` script created a new, global configuration file in the `conf` dir. 

This new configuration file is called `global_settings.cfg`.

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

This global config file (`conf/global_settings.cfg`) will contain information on where the compiled Merlin programs are located, where the current working dir is, what kind of Vocoder we're using, and how many files to use for training and testing.

That's all for `setup.sh`!

<br/>

### Calling the `prepare_config_files.sh` script from `run_demo.sh`

As above with the `setup.sh` script, now I'm going to run *just* the `prepare_config_files.sh` script and take a look at what it does.

This script produces two configuration files for training:

1. `duration_slt_arctic_demo.conf`
2. `acoustic_slt_arctic_demo.conf`

When we run the script, we only get two lines of output to the terminal: 

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ ./run_demo.sh 
Duration configuration settings stored in conf/duration_slt_arctic_demo.conf
Acoustic configuration settings stored in conf/acoustic_slt_arctic_demo.conf
{% endhighlight %}

Sure enough, as promised by our two above messages, when we look into our pre-existing `conf` directory, we find two new configuration files:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree conf/
conf/
├── acoustic_slt_arctic_demo.conf
├── dnn
│   ├── acoustic_slt_arctic_full.conf
│   ├── duration_slt_arctic_full.conf
│   ├── test_dur_synth_slt_arctic_full.conf
│   └── test_synth_slt_arctic_full.conf
├── duration_slt_arctic_demo.conf
├── global_settings.cfg
└── logging_config.conf

1 directory, 8 files
{% endhighlight %}

These two new configuration files are of the same form as the original configuration files we found pre-existing when we cloned Merlin from GitHub. 

They define architecture and training procedure for the acoustic model DNN and the duration model DNN. 

Pretty straightforward overall. 


### Calling the `prepare_config_files_for_synthesis.sh` script from `run_demo.sh`

In the previous script we created the configuration files for our training procedure, now we do the same for our testing (aka aynthesis) phase.

Just like before, we get two lines of output to the terminal.

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ ./run_demo.sh 
Duration configuration settings stored in conf/test_dur_synth_slt_arctic_demo.conf
Acoustic configuration settings stored in conf/test_synth_slt_arctic_demo.conf
{% endhighlight %}

Also, just like before, we have two new files in our `conf` dir:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree conf/
conf/
├── acoustic_slt_arctic_demo.conf
├── dnn
│   ├── acoustic_slt_arctic_full.conf
│   ├── duration_slt_arctic_full.conf
│   ├── test_dur_synth_slt_arctic_full.conf
│   └── test_synth_slt_arctic_full.conf
├── duration_slt_arctic_demo.conf
├── global_settings.cfg
├── logging_config.conf
├── test_dur_synth_slt_arctic_demo.conf
└── test_synth_slt_arctic_demo.conf

1 directory, 10 files
{% endhighlight %}


### Training the Duration Model

If you've gotten here and followed all the previous steps, we're ready to finally start training our DNNs... huzzah!

You'll see in the `run_demo.sh` script that after the data preparation phase is completed, we send a Theano job to our processing unit (CPU or GPU) and we specify that we want to train the duration model:

{% highlight bash %}
### Step 2: train duration model ###
echo "Step 2: training duration model..."
./scripts/submit.sh ${MerlinDir}/src/run_merlin.py conf/duration_${Voice}.conf
{% endhighlight %}

Since this second step in `run_demo.sh` produces a lot of output, I decided to record my terminal session and embed it here.

<asciinema-player src="/misc/train-dur-model.json"></asciinema-player>

After the training is complete, we can see that we've produced some new dirs and files in our `experiments` directory:

{% highlight bash %}
josh@yoga:~/git/merlin/egs/slt_arctic/s1$ tree -d experiments/
experiments/
└── slt_arctic_demo
    ├── acoustic_model
    │   └── data
    │       ├── bap
    │       ├── label_phone_align
    │       ├── label_state_align
    │       ├── lf0
    │       └── mgc
    ├── duration_model
    │   ├── data
    │   │   ├── binary_label_416
    │   │   ├── dur
    │   │   ├── label_phone_align
    │   │   ├── label_state_align
    │   │   ├── lf0
    │   │   ├── nn_dur_5
    │   │   ├── nn_norm_dur_5
    │   │   ├── nn_no_silence_lab_416
    │   │   ├── nn_no_silence_lab_norm_416
    │   │   ├── ref_data
    │   │   └── var
    │   ├── gen
    │   │   └── DNN_TANH_TANH_TANH_TANH_LINEAR__dur_1_50_416_5_4_512_512
    │   ├── log
    │   └── nnets_model
    └── test_synthesis
        └── prompt-lab

27 directories
{% endhighlight %}

[merlin-github]: https://github.com/CSTR-Edinburgh/merlin
[merlin-cstr]: http://www.cstr.ed.ac.uk/projects/merlin/
[pip-install]: https://pip.pypa.io/en/stable/installing/
[merlin-demo-paper]: http://homepages.inf.ed.ac.uk/s1432486/papers/Merlin_demo_paper.pdf
[ronanki]: http://104.131.174.95/