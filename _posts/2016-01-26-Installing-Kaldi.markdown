---
layout: post
title:  "Installing Kaldi"
date:   2016-01-26
categories: ASR
comments: True
redirect_from: "/kaldi/2016/01/26/Installing-Kaldi.html"
---

<br/>
<br/>
<br/>
<br/>

> 👋 Hi, it's Josh here. I'm writing you this note in 2021: the world of speech technology has changed dramatically since Kaldi. Before devoting weeks of your time to deploying Kaldi, take a look at 🐸 [Coqui Speech-to-Text][coqui-github]. It takes minutes to deploy an off-the-shelf 🐸 STT model... and it's [open source on Github][coqui-github]! I'm on the Coqui founding team so I'm admittedly biased, but as you can tell from my blog, I spent years working with Kaldi. With 🐸 STT, we've removed the headaches of Kaldi, and streamlined everything for production settings. You can train and deploy state-of-the-art 🐸 Speech-to-Text models in just minutes, not weeks. Check out the [🐸 Model Zoo][coqui-model-zoo] for pre-trained models in different languages. Try it out for yourself, and come join our [friendly chatroom][coqui-gitter] 💚

<img src="/misc/kaldi_text_and_logo.png" align="right" alt="logo" style="width: 400px;"/>

## Installation via GitHub

Kaldi is primarily hosted on GitHub (not SourceForge anymore), so I'm going to just clone [the official GitHub repository][official-repo] to my Desktop and go from there.

{% highlight bash %}
josh@yoga:~/Desktop$ git clone https://github.com/kaldi-asr/kaldi.git
Cloning into 'kaldi'...
remote: Counting objects: 63320, done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 63320 (delta 5), reused 0 (delta 0), pack-reused 63298
Receiving objects: 100% (63320/63320), 74.94 MiB | 8.26 MiB/s, done.
Resolving deltas: 100% (49427/49427), done.
Checking connectivity... done.
{% endhighlight %}

Taking a look inside to see what I just cloned:

{% highlight bash %}
josh@yoga:~/Desktop$ cd kaldi/
josh@yoga:~/Desktop/kaldi$ la
COPYING  .git            .gitignore  misc       src    .travis.yml
egs      .gitattributes  INSTALL     README.md  tools  windows
{% endhighlight %}

Now there's a lot of good [official documentation][docs] for Kaldi, but I think the best install info will always be in the **INSTALL** file on the latest version is. So, let's take a look:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi$ cat INSTALL 
This is the official Kaldi INSTALL. Look also at INSTALL.md for the git mirror installation.
[for native Windows install, see windows/INSTALL]

(1)
go to tools/  and follow INSTALL instructions there.

(2) 
go to src/ and follow INSTALL instructions there.
{% endhighlight %}

First things first, it says to go to **tools/** and follow those instructions. So, lets cd into **tools/** and see what's there:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi$ cd tools/
josh@yoga:~/Desktop/kaldi/tools$ la
CLAPACK  INSTALL           install_pfile_utils.sh  install_speex.sh  Makefile
extras   install_atlas.sh  install_portaudio.sh    install_srilm.sh
{% endhighlight %}

Looking into the **INSTALL** file, we see:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ cat INSTALL 

To install the most important prerequisites for Kaldi:

 first do

  extras/check_dependencies.sh

to see if there are any system-level installations or modifications you need to do.
Check the output carefully: there are some things that will make your life a lot
easier if you fix them at this stage.

Then run

  make

If you have multiple CPUs and want to speed things up, you can do a parallel
build by supplying the "-j" option to make, e.g. to use 4 CPUs:

  make -j 4

By default, Kaldi builds against OpenFst-1.3.4. If you want to build against
OpenFst-1.4, edit the Makefile in this folder. Note that this change requires
a relatively new compiler with C++11 support, e.g. gcc >= 4.6, clang >= 3.0.

In extras/, there are also various scripts to install extra bits and pieces that
are used by individual example scripts.  If an example script needs you to run
one of those scripts, it will tell you what to do.
{% endhighlight %}

So, first we need to check out dependencies:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ extras/check_dependencies.sh
extras/check_dependencies.sh: all OK.
{% endhighlight %}

I'm OK on this one, but I have a feeling others will need to do some installing of dependencies before they move on. I'd recommend running that **check_dependencies.sh** script after you do your installs to make sure you actually did install what you needed and that it's in the right spot.

Moving along, we need to run **make**. There's an option here for parallelizing this step, so I'm going to check how many processors I have:

{% highlight bash %}
josh@yoga:~/Desktop$ nproc
4
{% endhighlight %}

So I can run **make** on all 4 of my processors like this:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ make -j 4
                .
                .
                .
make[3]: Entering directory `/home/josh/Desktop/kaldi/tools/openfst-1.3.4'
make[3]: Nothing to be done for `install-exec-am'.
make[3]: Nothing to be done for `install-data-am'.
make[3]: Leaving directory `/home/josh/Desktop/kaldi/tools/openfst-1.3.4'
make[2]: Leaving directory `/home/josh/Desktop/kaldi/tools/openfst-1.3.4'
make[1]: Leaving directory `/home/josh/Desktop/kaldi/tools/openfst-1.3.4'
rm -f openfst
ln -s openfst-1.3.4 openfst



Warning: IRSTLM is not installed by default anymore. If you need IRSTLM
Warning: use the script extras/install_irstlm.sh
All done OK.
josh@yoga:~/Desktop/kaldi/tools$ 
{% endhighlight %}

Those last lines recommend we install a language modeling toolkit [IRSTLM][irstlm], and I want to make my own language models, so I'm going to install it. If you're using some pre-existing language model, you can skip these next few steps.

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ extras/install_irstlm.sh
                           .
                           .
                           .
make[1]: Entering directory `/home/josh/Desktop/kaldi/tools/irstlm'
make[2]: Entering directory `/home/josh/Desktop/kaldi/tools/irstlm'
make[2]: Nothing to be done for `install-exec-am'.
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/josh/Desktop/kaldi/tools/irstlm'
make[1]: Leaving directory `/home/josh/Desktop/kaldi/tools/irstlm'
readlink: missing operand
Try 'readlink --help' for more information.
***() Installation of IRSTLM finished successfully
***() Please source the tools/env.sh in your path.sh to enable it
{% endhighlight %}


<!---
It seems we've installed IRSTLM, but we still need to adjust something in our **path.sh** file to enable IRSTLM. If you search for **path.sh** from the **kaldi/** dir, we see that in each of the example directories, there is a separate **path.sh** file:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ cd ../
josh@yoga:~/Desktop/kaldi$ find -name path.sh
./egs/csj/s5/path.sh
./egs/timit/s5/path.sh
./egs/chime2/s5/path.sh
./egs/tedlium/s5/path.sh
./egs/fisher_swbd/s5/path.sh
          .
          .
          .
./egs/sprakbanken/s5/path.sh
./egs/lre/v1/path.sh
./egs/fisher_english/s5/path.sh
./egs/gp/s5/path.sh
./egs/gp/s1/path.sh
./egs/aurora4/s5/path.sh
{% endhighlight %}


If we look into one of those shell scripts, we see something like this:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi$ cat egs/yesno/s5/path.sh 

export PATH=$PWD/utils/:$PWD/../../../src/bin:$PWD/../../../tools/openfst/bin:$PWD/../../../src/fstbin/:$PWD/../../../src/gmmbin/:$PWD/../../../src/featbin/:$PWD/../../../src/lm/:$PWD/../../../src/sgmmbin/:$PWD/../../../src/fgmmbin/:$PWD/../../../src/latbin/:$PWD:$PATH
export LC_ALL=C
{% endhighlight %}

In this **yesno** example, there are just two commands which set the two environment variables **PATH** and **LC_ALL**. I think when it comes to making my own **path.sh** script and enabling IRSTLM, I will just include a line with:

{% highlight bash %}
source tools/env.sh
{% endhighlight %}
-->

Now we should have a working installation of IRSTLM on the computer, and you can verify by looking into **/usr/local**:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ cd /usr/local/
josh@yoga:/usr/local$ ls
bin  etc  games  include  irstlm  lib  libexec  man  MATLAB  sbin  share  src
josh@yoga:/usr/local$ ls irstlm/
bin  include  lib
{% endhighlight %}

        
We don't have to do anything else with IRSTLM right now because we're just installing. But it'll be there when you need it!

So, at this point we've done part (1) of the **kaldi/INSTALL** file (i.e. following the steps in the **kaldi/tools/INSTALL** file). 

Now let's go on to step (2), and follow the instructions in **kaldi/src/INSTALL**.

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ cd ../src/
josh@yoga:~/Desktop/kaldi/src$ la
base        Doxyfile  gmm         ivector     lm         nnet2     online      sgmm2      tree
bin         feat      gmmbin      ivectorbin  lmbin      nnet2bin  online2     sgmm2bin   util
configure   featbin   gst-plugin  kws         Makefile   nnet3     online2bin  sgmmbin
cudamatrix  fgmmbin   hmm         kwsbin      makefiles  nnet3bin  onlinebin   thread
decoder     fstbin    INSTALL     lat         matrix     nnetbin   probe       TODO
doc         fstext    itf         latbin      nnet       NOTES     sgmm        transform
{% endhighlight %}

Looking into the **INSTALL** file itself:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ cat INSTALL 

These instructions are valid for UNIX-like systems (these steps have
been run on various Linux distributions; Darwin; Cygwin).  For native Windows
compilation, see ../windows/INSTALL.

You must first have completed the installation steps in ../tools/INSTALL
(compiling OpenFst; getting ATLAS and CLAPACK headers).

The installation instructions are:
./configure
make depend
make

Note that "make" takes a long time; you can speed it up by running make
in parallel if you have multiple CPUs, for instance 
 make depend -j 8
 make -j 8
For more information, see documentation at http://kaldi-asr.org/doc/
and click on "The build process (how Kaldi is compiled)".
{% endhighlight %}

Like it says, the first step is to run the **./configure** script:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ ./configure
Configuring ...
Checking OpenFST library in /home/josh/Desktop/kaldi/tools/openfst ...
Checking OpenFst library was patched.
Doing OS specific configurations ...
On Linux: Checking for linear algebra header files ...
Using ATLAS as the linear algebra library.
Successfully configured for Debian/Ubuntu Linux [dynamic libraries] with ATLASLIBS =/usr/lib/libatlas.so.3  /usr/lib/libf77blas.so.3 /usr/lib/libcblas.so.3  /usr/lib/liblapack_atlas.so.3
CUDA will not be used! If you have already installed cuda drivers 
and cuda toolkit, try using --cudatk-dir=... option.  Note: this is
only relevant for neural net experiments
Static=[false] Speex library not found: You can still build Kaldi without Speex.
SUCCESS
{% endhighlight %}

Now we run **make depend**:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ make depend -j 4
                    .
                    .
                    .
make[1]: Leaving directory `/home/josh/Desktop/kaldi/src/online2'
make -C online2bin/ depend
make[1]: Entering directory `/home/josh/Desktop/kaldi/src/online2bin'
g++ -M -msse -msse2 -Wall -I.. -pthread -DKALDI_DOUBLEPRECISION=0 -DHAVE_POSIX_MEMALIGN -Wno-sign-compare -Wno-unused-local-typedefs -Winit-self -DHAVE_EXECINFO_H=1 -rdynamic -DHAVE_CXXABI_H -DHAVE_ATLAS -I/home/josh/Desktop/kaldi/tools/ATLAS/include -I/home/josh/Desktop/kaldi/tools/openfst/include  -g  *.cc > .depend.mk
make[1]: Leaving directory `/home/josh/Desktop/kaldi/src/online2bin'
make -C lmbin/ depend
make[1]: Entering directory `/home/josh/Desktop/kaldi/src/lmbin'
g++ -M -msse -msse2 -Wall -I.. -pthread -DKALDI_DOUBLEPRECISION=0 -DHAVE_POSIX_MEMALIGN -Wno-sign-compare -Wno-unused-local-typedefs -Winit-self -DHAVE_EXECINFO_H=1 -rdynamic -DHAVE_CXXABI_H -DHAVE_ATLAS -I/home/josh/Desktop/kaldi/tools/ATLAS/include -I/home/josh/Desktop/kaldi/tools/openfst/include -Wno-sign-compare -g  *.cc > .depend.mk
make[1]: Leaving directory `/home/josh/Desktop/kaldi/src/lmbin'
{% endhighlight %}

And finally, **make**:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ make -j 4
               .
               .
               .
make -C lmbin 
make[1]: Entering directory `/home/josh/Desktop/kaldi/src/lmbin'
g++ -msse -msse2 -Wall -I.. -pthread -DKALDI_DOUBLEPRECISION=0 -DHAVE_POSIX_MEMALIGN -Wno-sign-compare -Wno-unused-local-typedefs -Winit-self -DHAVE_EXECINFO_H=1 -rdynamic -DHAVE_CXXABI_H -DHAVE_ATLAS -I/home/josh/Desktop/kaldi/tools/ATLAS/include -I/home/josh/Desktop/kaldi/tools/openfst/include -Wno-sign-compare -g    -c -o arpa-to-const-arpa.o arpa-to-const-arpa.cc
g++ -rdynamic -Wl,-rpath=/home/josh/Desktop/kaldi/tools/openfst/lib  arpa-to-const-arpa.o ../lm/kaldi-lm.a ../util/kaldi-util.a ../base/kaldi-base.a   -L/home/josh/Desktop/kaldi/tools/openfst/lib -lfst /usr/lib/libatlas.so.3 /usr/lib/libf77blas.so.3 /usr/lib/libcblas.so.3 /usr/lib/liblapack_atlas.so.3 -lm -lpthread -ldl -o arpa-to-const-arpa
make[1]: Leaving directory `/home/josh/Desktop/kaldi/src/lmbin'
echo Done
Done
{% endhighlight %}

If you've gotten to this point without any hiccups, you should now have a working installation of Kaldi!

<br>

## Testing Kaldi Out

#### The YESNO Example Recipe

To make sure our install worked well, we can take advantage of the examples provided in the **kaldi/egs/** directory:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ cd ../egs/
josh@yoga:~/Desktop/kaldi/egs$ la
ami                chime1                   fisher_english  librispeech  sprakbanken  tidigits      yesno
aspire             chime2                   fisher_swbd     lre          sre08        timit
aurora4            chime3                   gale_arabic     lre07        sre10        voxforge
babel              csj                      gale_mandarin   README.txt   swahili      vystadial_cz
bn_music_speech    farsdat                  gp              reverb       swbd         vystadial_en
callhome_egyptian  fisher_callhome_spanish  hkust           rm           tedlium      wsj
{% endhighlight %}

Let's take a look at the **README.txt** file:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs$ cat README.txt 

This directory contains example scripts that demonstrate how to 
use Kaldi.  Each subdirectory corresponds to a corpus that we have
example scripts for.

Note: we now have some scripts using free data, including voxforge,
vystadial_{cz,en} and yesno.  Most of the others are available from
the Linguistic Data Consortium (LDC), which requires money (unless you
have a membership).

If you have an LDC membership, probably rm/s5 or wsj/s5 should be your first
choice to try out the scripts.
{% endhighlight %}

Since we can try out **yesno** off the shelf (the WAV files are downloaded when you run the **run.sh** script), we're going to go with that one.

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs$ cd yesno/
josh@yoga:~/Desktop/kaldi/egs/yesno la
README.txt  s5
josh@yoga:~/Desktop/kaldi/egs/yesno$ cat README.txt 


The "yesno" corpus is a very small dataset of recordings of one individual
saying yes or no multiple times per recording, in Hebrew.  It is available from
http://www.openslr.org/1.
It is mainly included here as an easy way to test out the Kaldi scripts.

The test set is perfectly recognized at the monophone stage, so the dataset is
not exactly challenging.

The scripts are in **s5/**.

{% endhighlight %}

<br>

#### Pre-Training File Structure

To get a clearer picture of the file structure, I like to use the **tree** command to display the file structure as a tree with indented braches. You might have to install **tree**, but I'd say it's worth it.

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno$ tree .
.
├── README.txt
└── s5
    ├── conf
    │   ├── mfcc.conf
    │   └── topo_orig.proto
    ├── input
    │   ├── lexicon_nosil.txt
    │   ├── lexicon.txt
    │   ├── phones.txt
    │   └── task.arpabo
    ├── local
    │   ├── create_yesno_txt.pl
    │   ├── create_yesno_waves_test_train.pl
    │   ├── create_yesno_wav_scp.pl
    │   ├── prepare_data.sh
    │   ├── prepare_dict.sh
    │   ├── prepare_lm.sh
    │   └── score.sh
    ├── path.sh
    ├── run.sh
    ├── steps -> ../../wsj/s5/steps
    └── utils -> ../../wsj/s5/utils

6 directories, 16 files
{% endhighlight %}

These original directories contain general information about the language (in the **input/** dir) as well as instructions for preparing the data and scoring it (in the **local/** dir) as well as information about the kind of model we want to train and test (in the **conf/** dir).

More big-picture scripts (e.g. training monophones, extracting MFCCs from WAV files, etc) are in the **steps/** and **utils/** dirs. In this case, since these scripts are easily generalizable, Kaldi stores them for all examples in the same directory (in the Wall Street Journal example). All other example dirs (like YESNO) have symbolic links to those dirs.

<br>

#### Data Prep & Training & Testing: The **run.sh** Script

Now lets cd into the **s5/** directory (which holds all the relevant scripts and data for running this example) and run the **run.sh** script.
 
{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno$ cd s5/
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ ./run.sh 
--2016-02-08 18:42:03--  http://www.openslr.org/resources/1/waves_yesno.tar.gz
Resolving www.openslr.org (www.openslr.org)... 107.178.217.247
Connecting to www.openslr.org (www.openslr.org)|107.178.217.247|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4703754 (4.5M) [application/x-gzip]
Saving to: 'waves_yesno.tar.gz'

100%[================================================================>] 4,703,754    630KB/s   in 6.9s   

2016-02-08 18:42:10 (661 KB/s) - 'waves_yesno.tar.gz' saved [4703754/4703754]

waves_yesno/
waves_yesno/1_0_0_0_0_0_1_1.wav
waves_yesno/1_1_0_0_1_0_1_0.wav
waves_yesno/1_0_1_1_1_1_0_1.wav
waves_yesno/1_1_1_1_0_1_0_0.wav
waves_yesno/0_0_1_1_1_0_0_0.wav
                .
                .
                .
waves_yesno/0_0_0_1_0_1_1_0.wav
waves_yesno/1_1_1_1_1_1_0_0.wav
waves_yesno/0_0_0_0_1_1_1_1.wav
Preparing train and test data
Dictionary preparation succeeded
Checking data/local/dict/silence_phones.txt ...
--> reading data/local/dict/silence_phones.txt
--> data/local/dict/silence_phones.txt is OK

Checking data/local/dict/optional_silence.txt ...
--> reading data/local/dict/optional_silence.txt
--> data/local/dict/optional_silence.txt is OK

Checking data/local/dict/nonsilence_phones.txt ...
--> reading data/local/dict/nonsilence_phones.txt
--> data/local/dict/nonsilence_phones.txt is OK
                 .
                 .
                 .
steps/train_mono.sh: Initializing monophone system.
steps/train_mono.sh: Compiling training graphs
steps/train_mono.sh: Aligning data equally (pass 0)
steps/train_mono.sh: Pass 1
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 2
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 3
                 .
                 .
                 .
0.755859 -0.000430956
HCLGa is not stochastic
add-self-loops --self-loop-scale=0.1 --reorder=true exp/mono0a/final.mdl 
steps/decode.sh --nj 1 --cmd utils/run.pl exp/mono0a/graph_tgpr data/test_yesno exp/mono0a/decode_test_yesno
** split_data.sh: warning, #lines is (utt2spk,feats.scp) is (31,29); you can 
**  use utils/fix_data_dir.sh data/test_yesno to fix this.
decode.sh: feature type is delta
%WER 0.00 [ 0 / 232, 0 ins, 0 del, 0 sub ] [PARTIAL] exp/mono0a/decode_test_yesno/wer_10
{% endhighlight %}

You can see from the last line of output, that as we were warned in the **README**, this data set is not interesting because we get perfect performance, and our percent Word Error Rate was indeed %0.00.

<br> 

#### Post-Training & Testing File Structure

If we take another look at the **yesno** dir, we will see that our **run.sh** file generated some more directories and files for us. 

I'm going to use the **tree** function below with the **-d** flag so we only see directories. Otherwise, all the downloaded WAV files are listed and it's a little much.

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ la
conf  data  exp  input  local  mfcc  path.sh  run.sh  steps  utils  waves_yesno  waves_yesno.tar.gz
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree -d .
.
|-- conf
|-- data
|   |-- lang
|   |   `-- phones
|   |-- lang_test_tg
|   |   |-- phones
|   |   `-- tmp
|   |-- local
|   |   |-- dict
|   |   `-- lang
|   |-- test_yesno
|   |   `-- split1
|   |       `-- 1
|   `-- train_yesno
|       `-- split1
|           `-- 1
|-- exp
|   |-- make_mfcc
|   |   |-- test_yesno
|   |   `-- train_yesno
|   `-- mono0a
|       |-- decode_test_yesno
|       |   |-- log
|       |   `-- scoring
|       |       `-- log
|       |-- graph_tgpr
|       |   `-- phones
|       `-- log
|-- input
|-- local
|-- mfcc
|-- steps -> ../../wsj/s5/steps
|-- utils -> ../../wsj/s5/utils
`-- waves_yesno

34 directories
{% endhighlight %}

Walking down the subdirs, we can see that the three original dirs were left unchanged:

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree ./conf/
./conf/
|-- mfcc.conf
`-- topo_orig.proto

0 directories, 2 files
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree ./input/
./input/
|-- lexicon.txt
|-- lexicon_nosil.txt
|-- phones.txt
`-- task.arpabo

0 directories, 4 files
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree ./local/
./local/
|-- create_yesno_txt.pl
|-- create_yesno_wav_scp.pl
|-- create_yesno_waves_test_train.pl
|-- prepare_data.sh
|-- prepare_dict.sh
|-- prepare_lm.sh
`-- score.sh

0 directories, 7 files
{% endhighlight %}

These are unchanged because these original directories are housing general information about the language (in the **input/** dir) as well as instructions for preparing the data and scoring it (in the **local/** dir) as well as information about the kind of model we want to train and test (in the **conf/** dir).

Logically, nothing about these files and directories should change after we train and test the model.

However, the newly created **data/** directory has a lot of new stuff in it. In general, this directory created by the **run.sh** script houses and organizes the files which describe the language (e.g. dictionary, phone lists, etc) and data (e.g. WAV file ids and their transcripts) to test and train the model. 

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree ./data/
./data/
├── lang
│   ├── L_disambig.fst
│   ├── L.fst
│   ├── oov.int
│   ├── oov.txt
│   ├── phones
│   │   ├── align_lexicon.int
│   │   ├── align_lexicon.txt
│   │   ├── context_indep.csl
│   │   ├── context_indep.int
│   │   ├── context_indep.txt
│   │   ├── disambig.csl
│   │   ├── disambig.int
│   │   ├── disambig.txt
│   │   ├── extra_questions.int
│   │   ├── extra_questions.txt
│   │   ├── nonsilence.csl
│   │   ├── nonsilence.int
│   │   ├── nonsilence.txt
│   │   ├── optional_silence.csl
│   │   ├── optional_silence.int
│   │   ├── optional_silence.txt
│   │   ├── roots.int
│   │   ├── roots.txt
│   │   ├── sets.int
│   │   ├── sets.txt
│   │   ├── silence.csl
│   │   ├── silence.int
│   │   ├── silence.txt
│   │   ├── wdisambig_phones.int
│   │   ├── wdisambig.txt
│   │   └── wdisambig_words.int
│   ├── phones.txt
│   ├── topo
│   └── words.txt
├── lang_test_tg
│   ├── G.fst
│   ├── L_disambig.fst
│   ├── L.fst
│   ├── oov.int
│   ├── oov.txt
│   ├── phones
│   │   ├── align_lexicon.int
│   │   ├── align_lexicon.txt
│   │   ├── context_indep.csl
│   │   ├── context_indep.int
│   │   ├── context_indep.txt
│   │   ├── disambig.csl
│   │   ├── disambig.int
│   │   ├── disambig.txt
│   │   ├── extra_questions.int
│   │   ├── extra_questions.txt
│   │   ├── nonsilence.csl
│   │   ├── nonsilence.int
│   │   ├── nonsilence.txt
│   │   ├── optional_silence.csl
│   │   ├── optional_silence.int
│   │   ├── optional_silence.txt
│   │   ├── roots.int
│   │   ├── roots.txt
│   │   ├── sets.int
│   │   ├── sets.txt
│   │   ├── silence.csl
│   │   ├── silence.int
│   │   ├── silence.txt
│   │   ├── wdisambig_phones.int
│   │   ├── wdisambig.txt
│   │   └── wdisambig_words.int
│   ├── phones.txt
│   ├── tmp
│   │   ├── CLG_1_0.fst
│   │   ├── disambig_ilabels_1_0.int
│   │   ├── ilabels_1_0
│   │   └── LG.fst
│   ├── topo
│   └── words.txt
├── local
│   ├── dict
│   │   ├── lexiconp.txt
│   │   ├── lexicon.txt
│   │   ├── lexicon_words.txt
│   │   ├── nonsilence_phones.txt
│   │   ├── optional_silence.txt
│   │   └── silence_phones.txt
│   ├── lang
│   │   ├── align_lexicon.txt
│   │   ├── lexiconp_disambig.txt
│   │   ├── lexiconp.txt
│   │   ├── lex_ndisambig
│   │   ├── phone_map.txt
│   │   └── phones
│   ├── lm_tg.arpa
│   ├── test_yesno.txt
│   ├── test_yesno_wav.scp
│   ├── train_yesno.txt
│   ├── train_yesno_wav.scp
│   ├── waves_all.list
│   ├── waves.test
│   └── waves.train
├── test_yesno
│   ├── cmvn.scp
│   ├── feats.scp
│   ├── spk2utt
│   ├── split1
│   │   └── 1
│   │       ├── cmvn.scp
│   │       ├── feats.scp
│   │       ├── spk2utt
│   │       ├── text
│   │       ├── utt2spk
│   │       └── wav.scp
│   ├── text
│   ├── utt2spk
│   └── wav.scp
└── train_yesno
    ├── cmvn.scp
    ├── feats.scp
    ├── spk2utt
    ├── split1
    │   └── 1
    │       ├── cmvn.scp
    │       ├── feats.scp
    │       ├── spk2utt
    │       ├── text
    │       ├── utt2spk
    │       └── wav.scp
    ├── text
    ├── utt2spk
    └── wav.scp

14 directories, 115 files
{% endhighlight %}

The next directory created by the **run.sh** script is the **exp/** directory. As far as I can gather, "exp" is short for "experiment". I think this is the case becuase the **exp/** dir holds information about the model you're training and testing. It has a lot of files as you see below, and you can see that a lot of them (if not most) are **.log** files. 

I think that Kaldi could have more transparent naming conventions for files and directories, but I will say that the log files are very thorough. There's a lot of info to be found if you do some digging. 


{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree ./exp/
./exp/
├── make_mfcc
│   ├── test_yesno
│   │   ├── cmvn_test_yesno.log
│   │   └── make_mfcc_test_yesno.1.log
│   └── train_yesno
│       ├── cmvn_train_yesno.log
│       └── make_mfcc_train_yesno.1.log
└── mono0a
    ├── 0.mdl
    ├── 40.mdl
    ├── 40.occs
    ├── ali.1.gz
    ├── cmvn_opts
    ├── decode_test_yesno
    │   ├── lat.1.gz
    │   ├── log
    │   │   └── decode.1.log
    │   ├── num_jobs
    │   ├── scoring
    │   │   ├── 10.tra
    │   │   ├── 11.tra
    │   │   ├── 9.tra
    │   │   ├── log
    │   │   │   ├── best_path.10.log
    │   │   │   ├── best_path.11.log
    │   │   │   ├── best_path.9.log
    │   │   │   ├── score.10.log
    │   │   │   ├── score.11.log
    │   │   │   └── score.9.log
    │   │   └── test_filt.txt
    │   ├── wer_10
    │   ├── wer_11
    │   └── wer_9
    ├── final.mdl -> 40.mdl
    ├── final.occs -> 40.occs
    ├── fsts.1.gz
    ├── graph_tgpr
    │   ├── disambig_tid.int
    │   ├── Ha.fst
    │   ├── HCLGa.fst
    │   ├── HCLG.fst
    │   ├── num_pdfs
    │   ├── phones
    │   │   ├── align_lexicon.int
    │   │   ├── align_lexicon.txt
    │   │   ├── disambig.int
    │   │   ├── disambig.txt
    │   │   └── silence.csl
    │   ├── phones.txt
    │   └── words.txt
    ├── log
    │   ├── acc.10.1.log
    │   ├── acc.11.1.log
    │   ├── acc.1.1.log
    │   ├── acc.12.1.log
    │   ├── acc.13.1.log
    │   ├── acc.14.1.log
    │   ├── acc.15.1.log
    │   ├── acc.16.1.log
    │   ├── acc.17.1.log
    │   ├── acc.18.1.log
    │   ├── acc.19.1.log
    │   ├── acc.20.1.log
    │   ├── acc.21.1.log
    │   ├── acc.2.1.log
    │   ├── acc.22.1.log
    │   ├── acc.23.1.log
    │   ├── acc.24.1.log
    │   ├── acc.25.1.log
    │   ├── acc.26.1.log
    │   ├── acc.27.1.log
    │   ├── acc.28.1.log
    │   ├── acc.29.1.log
    │   ├── acc.30.1.log
    │   ├── acc.31.1.log
    │   ├── acc.3.1.log
    │   ├── acc.32.1.log
    │   ├── acc.33.1.log
    │   ├── acc.34.1.log
    │   ├── acc.35.1.log
    │   ├── acc.36.1.log
    │   ├── acc.37.1.log
    │   ├── acc.38.1.log
    │   ├── acc.39.1.log
    │   ├── acc.4.1.log
    │   ├── acc.5.1.log
    │   ├── acc.6.1.log
    │   ├── acc.7.1.log
    │   ├── acc.8.1.log
    │   ├── acc.9.1.log
    │   ├── align.0.1.log
    │   ├── align.10.1.log
    │   ├── align.1.1.log
    │   ├── align.12.1.log
    │   ├── align.14.1.log
    │   ├── align.16.1.log
    │   ├── align.18.1.log
    │   ├── align.20.1.log
    │   ├── align.2.1.log
    │   ├── align.23.1.log
    │   ├── align.26.1.log
    │   ├── align.29.1.log
    │   ├── align.3.1.log
    │   ├── align.32.1.log
    │   ├── align.35.1.log
    │   ├── align.38.1.log
    │   ├── align.4.1.log
    │   ├── align.5.1.log
    │   ├── align.6.1.log
    │   ├── align.7.1.log
    │   ├── align.8.1.log
    │   ├── align.9.1.log
    │   ├── compile_graphs.1.log
    │   ├── init.log
    │   ├── update.0.log
    │   ├── update.10.log
    │   ├── update.11.log
    │   ├── update.12.log
    │   ├── update.13.log
    │   ├── update.14.log
    │   ├── update.15.log
    │   ├── update.16.log
    │   ├── update.17.log
    │   ├── update.18.log
    │   ├── update.19.log
    │   ├── update.1.log
    │   ├── update.20.log
    │   ├── update.21.log
    │   ├── update.22.log
    │   ├── update.23.log
    │   ├── update.24.log
    │   ├── update.25.log
    │   ├── update.26.log
    │   ├── update.27.log
    │   ├── update.28.log
    │   ├── update.29.log
    │   ├── update.2.log
    │   ├── update.30.log
    │   ├── update.31.log
    │   ├── update.32.log
    │   ├── update.33.log
    │   ├── update.34.log
    │   ├── update.35.log
    │   ├── update.36.log
    │   ├── update.37.log
    │   ├── update.38.log
    │   ├── update.39.log
    │   ├── update.3.log
    │   ├── update.4.log
    │   ├── update.5.log
    │   ├── update.6.log
    │   ├── update.7.log
    │   ├── update.8.log
    │   └── update.9.log
    ├── num_jobs
    └── tree

11 directories, 145 files
{% endhighlight %}

The last directory created by the **run.sh** script isn't super interesting, but it's essential. This is the **mfcc/** dir. This directory holds all the **.ark** (archive) and **.scp** (script) files for (1) the MFCC features as well as (2) the cepstral mean and variance statistics per speaker. 

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ tree ./mfcc/
./mfcc/
├── cmvn_test_yesno.ark
├── cmvn_test_yesno.scp
├── cmvn_train_yesno.ark
├── cmvn_train_yesno.scp
├── raw_mfcc_test_yesno.1.ark
├── raw_mfcc_test_yesno.1.scp
├── raw_mfcc_train_yesno.1.ark
└── raw_mfcc_train_yesno.1.scp

0 directories, 8 files

{% endhighlight %}

<br>

## Conclusion

I hope this was helpful! 

Let me know if you have comments or suggestions and you can always leave a comment below. 

Happy Kaldi-ing!

[irstlm]: http://hlt-mt.fbk.eu/technologies/irstlm
[official-repo]: https://github.com/kaldi-asr/kaldi
[docs]: http://kaldi-asr.org/doc/
[coqui-github]: https://github.com/coqui-ai/stt
[coqui-model-zoo]: https://coqui.ai/models
[coqui-gitter]: https://gitter.im/coqui-ai/STT