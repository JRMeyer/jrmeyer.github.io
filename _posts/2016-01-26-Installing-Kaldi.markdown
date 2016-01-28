---
layout: post
title:  "Installing Kaldi"
date:   2016-01-26 22:03:04 -0700
categories: kaldi
comments: True
---

## Overview


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

{% highlight bash %}
josh@yoga:~/Desktop$ cd kaldi/
josh@yoga:~/Desktop/kaldi$ la
COPYING  .git            .gitignore  misc       src    .travis.yml
egs      .gitattributes  INSTALL     README.md  tools  windows
{% endhighlight %}

{% highlight bash %}
josh@yoga:~/Desktop/kaldi$ cat INSTALL 
This is the official Kaldi INSTALL. Look also at INSTALL.md for the git mirror installation.
[for native Windows install, see windows/INSTALL]

(1)
go to tools/  and follow INSTALL instructions there.

(2) 
go to src/ and follow INSTALL instructions there.
{% endhighlight %}

{% highlight bash %}
josh@yoga:~/Desktop/kaldi$ cd tools/
josh@yoga:~/Desktop/kaldi/tools$ la
CLAPACK  INSTALL           install_pfile_utils.sh  install_speex.sh  Makefile
extras   install_atlas.sh  install_portaudio.sh    install_srilm.sh
{% endhighlight %}


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

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ extras/check_dependencies.sh
extras/check_dependencies.sh: all OK.
{% endhighlight %}

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/tools$ make
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


Those last lines recommend we install a language modeling toolkit [IRSTLM][irstlm], and I want to make my own language models, so I'm going to install it.


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

Now that we've done part (1) of the **kaldi/INSTALL** file, let's go on to step (2), in the **src** folder.

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


{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ make depend
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


{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ make
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


{% highlight bash %}
josh@yoga:~/Desktop/kaldi/src$ cd ../egs/
josh@yoga:~/Desktop/kaldi/egs$ la
ami                chime1                   fisher_english  librispeech  sprakbanken  tidigits      yesno
aspire             chime2                   fisher_swbd     lre          sre08        timit
aurora4            chime3                   gale_arabic     lre07        sre10        voxforge
babel              csj                      gale_mandarin   README.txt   swahili      vystadial_cz
bn_music_speech    farsdat                  gp              reverb       swbd         vystadial_en
callhome_egyptian  fisher_callhome_spanish  hkust           rm           tedlium      wsj
josh@yoga:~/Desktop/kaldi/egs$ 
{% endhighlight %}

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

{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs$ cd yesno/
josh@yoga:~/Desktop/kaldi/egs/yesno$ la
README.txt  s5
josh@yoga:~/Desktop/kaldi/egs/yesno$ cat README.txt 


The "yesno" corpus is a very small dataset of recordings of one individual
saying yes or no multiple times per recording, in Hebrew.  It is available from
http://www.openslr.org/1.
It is mainly included here as an easy way to test out the Kaldi scripts.

The test set is perfectly recognized at the monophone stage, so the dataset is
not exactly challenging.

The scripts are in s5/.
{% endhighlight %}


{% highlight bash %}
josh@yoga:~/Desktop/kaldi/egs/yesno$ cd s5/
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ la
conf  data  exp  input  local  mfcc  path.sh  run.sh  steps  utils  waves_yesno  waves_yesno.tar.gz
josh@yoga:~/Desktop/kaldi/egs/yesno/s5$ ./run.sh 
Preparing train and test data
Dictionary preparation succeeded
Checking data/local/dict/silence_phones.txt ...
--> reading data/local/dict/silence_phones.txt
--> data/local/dict/silence_phones.txt is OK
                    .
                    .
                    .
add-self-loops --self-loop-scale=0.1 --reorder=true exp/mono0a/final.mdl 
steps/decode.sh --nj 1 --cmd utils/run.pl exp/mono0a/graph_tgpr data/test_yesno exp/mono0a/decode_test_yesno
** split_data.sh: warning, #lines is (utt2spk,feats.scp) is (31,29); you can 
**  use utils/fix_data_dir.sh data/test_yesno to fix this.
decode.sh: feature type is delta
%WER 0.00 [ 0 / 232, 0 ins, 0 del, 0 sub ] [PARTIAL] exp/mono0a/decode_test_yesno/wer_10
{% endhighlight %}


[irstlm]: http://hlt-mt.fbk.eu/technologies/irstlm


