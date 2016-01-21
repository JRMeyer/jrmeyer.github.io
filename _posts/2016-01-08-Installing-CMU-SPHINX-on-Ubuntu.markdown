---
layout: post
title:  "Installing CMU-SPHINX on Ubuntu via GitHub"
date:   2016-01-08 22:03:04 -0700
categories: installation
comments: True
---

## Some Background

I recently installed Ubuntu 14.04 on my Lenovo Yoga, and it's time to reinstall SPHINX. 

When I installed SPHINX for the first time in September 2015, it was not a fun experience. I originally followed the instructions on [CMU's website][cmu-sphinx], but I couldn't seem to get it right. I tried a number of different approaches, using different blogs as guides, but I got nowhere. I first tried downloading Pocketsphinx, Sphinxtrain, Sphinxbase and Sphinx4 from CMU's [downloads page][cmu-downloads], but that didn't work. I also tried installing the version hosted on [SourceForge][cmu-sourceforge], but no luck there either. I finally decided to try cloning and installing the version on [GitHub][cmu-github], and that seemed to do the trick.

So, I'm going to go through installation process again here, cloning from GitHub.

First, in case it's relevant for others I'm going to show a little info about my current setup.

{% highlight bash %}
josh@yoga:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 14.04.3 LTS
Release:	14.04
Codename:	trusty
{% endhighlight %}

You can see the exact kernel on my version of Ubuntu below:

{% highlight bash %}
josh@yoga:~$ uname -a
Linux yoga 3.19.0-43-generic #49~14.04.1-Ubuntu SMP Thu Dec 31 15:44:49 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
{% endhighlight %}

<br />

<br />

## Installing Dependencies

To install on Ubuntu (or any other unix-like system), we first need to install a few dependencies. Here's the list:

| Name       | Homepage   | Description  |
| ------------- |:-------------:| -----|
| gcc      | [GNU Compiler Collection][gcc] | *GCC development is a part of the GNU Project, aiming to improve the compiler used in the GNU system including the GNU/Linux variant.* | 
| automake      | [Automake][automake]      |   *Tool for generating GNU Standards-compliant Makefiles.* |
| autoconf | [Autoconf][autoconf]      |    *Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages.*  |
| libtool | [GNU Libtool][libtool]      |    *GNU libtool is a generic library support script. Libtool hides the complexity of using shared libraries behind a consistent, portable interface.*  |
| bison | [GNU Bison][bison]      |    *Bison is a general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables.*   |
| swig | [SWIG][swig]      |    *SWIG is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages.*   |
| python-dev | [Python Development Package][python-dev]      |    *Header files, a static library and development tools for building Python modules, extending the Python interpreter or embedding Python in applications.*   |
| libpulse-dev | [PulseAudio Development Package][libpulse-dev]      |    *Headers and libraries for developing applications that access a PulseAudio sound server via PulseAudio's native interface.*   |

<br />
Here's the command to get everything at once:

{% highlight bash %}
sudo apt-get install gcc automake autoconf libtool bison swig python-dev libpulse-dev
{% endhighlight %}

<br />

<br />

## Installing CMU-SPHINX

### Installing sphinxbase

Whether you're using pocketsphinx or sphinx4, you're going to need to install sphinxbase first.

The README for the sphinxbase repository says:

> This package contains the basic libraries shared by the CMU Sphinx trainer and all the Sphinx decoders (Sphinx-II, Sphinx-III, and PocketSphinx), as well as some common utilities for manipulating acoustic feature and audio files.

To get sphinxbase running, we need to clone the repository from GitHub and then run a few commands to configure and install it in the right spot.

I usually make a folder on my desktop to store the source code, and then when it's all been installed you can just throw away all those extra files.

So, first we need to get to the Desktop, make a new directory and cd into it. 

{% highlight bash %}
josh@yoga:~$ cd Desktop/
josh@yoga:~/Desktop$ mkdir sphinx-source
josh@yoga:~/Desktop$ cd sphinx-source/
josh@yoga:~/Desktop/sphinx-source$ 
{% endhighlight %}

Now we can clone the source from GitHub, and you should get something like this:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ git clone https://github.com/cmusphinx/sphinxbase.git
Cloning into 'sphinxbase'...
remote: Counting objects: 10302, done.
remote: Total 10302 (delta 0), reused 0 (delta 0), pack-reused 10302
Receiving objects: 100% (10302/10302), 8.95 MiB | 1.46 MiB/s, done.
Resolving deltas: 100% (8092/8092), done.
Checking connectivity... done.
{% endhighlight %}

Now can see that our once empty dir **sphinx-source** now has a new directory, **sphinxbase**:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la
sphinxbase
{% endhighlight %}

Let's look at what's inside this new dir, **sphinxbase**:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la sphinxbase/
AUTHORS       doc      indent.sh  Makefile.am  README.md         src   win32
autogen.sh    .git     LICENSE    NEWS         sphinxbase.pc.in  swig
configure.ac  include  m4         README       sphinxbase.sln    test
{% endhighlight %}

Now we need to run the **autogen.sh** shell script you can see in the **sphinxbase** directory. This will generate our **Makefiles** and other important scripts for compiling and installing. We're going to get a long output here, so I only show some of it here:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ cd sphinxbase/
josh@yoga:~/Desktop/sphinx-source/sphinxbase$ ./autogen.sh
**Warning**: I am going to run `configure' with no arguments.
If you wish to pass any to it, please specify them on the
`./autogen.sh' command line.

processing .
Running libtoolize...
libtoolize: putting auxiliary files in `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
Running aclocal  ...
Running autoheader...
Running automake --foreign --copy  ...
configure.ac:12: installing './compile'
                        .
                        .
                        .
config.status: creating test/regression/testfuncs.sh
config.status: creating test/regression/Makefile
config.status: creating swig/Makefile
config.status: creating swig/python/Makefile
config.status: creating include/config.h
config.status: creating include/sphinx_config.h
config.status: executing depfiles commands
config.status: executing libtool commands
Now type `make' to compile the package.
{% endhighlight %}

Before we charge right ahead to compilation with the **make** command, lets take a look at what new files were generated from running **autogen.sh**.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxbase$ la
aclocal.m4      config.log     doc         LICENSE      missing        sphinxbase.pc.in  win32
AUTHORS         config.status  .git        ltmain.sh    NEWS           sphinxbase.sln    ylwrap
autogen.sh      config.sub     include     m4           py-compile     src
autom4te.cache  configure      indent.sh   Makefile     README         swig
compile         configure.ac   install-sh  Makefile.am  README.md      test
config.guess    depcomp        libtool     Makefile.in  sphinxbase.pc  test-driver
{% endhighlight %}

You can see that we now have the scripts needed for compiling, configuring, and installing sphinxbase. Now we can run **make** to do our installation. As nicely summarized on [Wikipedia][make], *"**Make** is a utility that automatically builds executable programs and libraries from source code by reading files called **Makefiles** which specify how to derive the target program."*

When you run the **make** command without any arguments (still in the local version of the cloned sphinxbase repository), you will get a long output that ends something like this:
 
{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxbase$ make
                        .
                        .
                        .
libtool: link: (cd ".libs" && rm -f "_sphinxbase.so.0" && ln -s "_sphinxbase.so.0.0.0" "_sphinxbase.so.0")
libtool: link: (cd ".libs" && rm -f "_sphinxbase.so" && ln -s "_sphinxbase.so.0.0.0" "_sphinxbase.so")
libtool: link: ar cru .libs/_sphinxbase.a  _sphinxbase_la-sphinxbase_wrap.o
libtool: link: ranlib .libs/_sphinxbase.a
libtool: link: ( cd ".libs" && rm -f "_sphinxbase.la" && ln -s "../_sphinxbase.la" "_sphinxbase.la" )
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig/python'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig'
make[2]: Nothing to be done for `all-am'.
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig'
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxbase'
make[1]: Nothing to be done for `all-am'.
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase'
{% endhighlight %}

The next step is the last step. Run the command **sudo make install**. Root permission is important, because otherwise you will get some error without any *Permision Denied* warning. 

You will see a good amount of output with some sections that look like this:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxbase$ sudo make install
                        .
                        .
                        .
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
                        .
                        .
                        .
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/lib/python2.7/dist-packages/sphinxbase

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
                        .
                        .
                        .
make[3]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase/swig'
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxbase'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxbase'
make[2]: Nothing to be done for `install-exec-am'.
 /bin/mkdir -p '/usr/local/lib/pkgconfig'
 /usr/bin/install -c -m 644 sphinxbase.pc '/usr/local/lib/pkgconfig'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxbase'
{% endhighlight %}

That's it! You should have successfully installed sphinxbase. To check if you've actually installed it, just go to the terminal and do a tab-completion for **sphinx_**. You will see all the options of what you've just installed. 

{% highlight bash %}
josh@yoga:~$ sphinx_
sphinx_cepview     sphinx_fe          sphinx_lm_convert  sphinx_pitch
sphinx_cont_seg    sphinx_jsgf2fsg    sphinx_lm_eval
{% endhighlight %}

At this point, if you try to run any one of these by entering it at the command line, you get an error:

{% highlight bash %}
josh@yoga:~$ sphinx_lm_convert
sphinx_lm_convert: error while loading shared libraries: libsphinxbase.so.3: cannot open shared object file: No such file or directory
{% endhighlight %}

This error has been answered by Nikolay Shmyrev on [stackoverflow][stackoverflow] already, and the reason for this error is the following:

> This error means that system fails to find the shared library in the location where it is installed. Most likely you installed it with default prefix /usr/local/lib which is not included into the library search path.

When I looked up what my environment variables were using the command **env**, I found that the relevant path, LD_LIBRARY_PATH, had never been set in the first place. So, I set the variable to /usr/local/lib as Nikolay recommends in his post, with the following command:

{% highlight bash %}
josh@yoga:~$ export LD_LIBRARY_PATH=/usr/local/lib
{% endhighlight %}

Now I can run the sphinxbase executables, and I get more reasonable output:

{% highlight bash %}
josh@yoga:~$ sphinx_lm_convert
ERROR: "cmd_ln.c", line 679: No arguments given, available options are:
Arguments list definition:
[NAME]		[DEFLT]	[DESCR]
-case			Ether 'lower' or 'upper' - case fold to lower/upper case (NOT UNICODE AWARE)
-debug			Verbosity level for debugging messages
-help		no	Shows the usage of the tool
-i			Input language model file (required)
-ifmt			Input language model format (will guess if not specified)
-lm_trie	no	Whether trie structure should be used for model holding during convertion
-logbase	1.0001	Base in which all log-likelihoods calculated
-mmap		no	Use memory-mapped I/O for reading binary LM files
-o			Output language model file (required)
-ofmt			Output language model file (will guess if not specified)
{% endhighlight %}








<br />

<br />

### Installing pocketsphinx

Now that we've got sphinxbase installed successfully, we can move onto installing pocketsphinx. According to the description on the [pocketsphinx GitHub repository][pocketsphinx]:

>PocketSphinx is a lightweight speech recognition engine, specifically tuned for handheld and mobile devices, though it works equally well on the desktop.

Still using **sphinx-source** as our current working directory, we can clone pocketsphinx from GitHub with the following command:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ git clone https://github.com/cmusphinx/pocketsphinx.git
Cloning into 'pocketsphinx'...
remote: Counting objects: 11810, done.
remote: Total 11810 (delta 0), reused 0 (delta 0), pack-reused 11810
Receiving objects: 100% (11810/11810), 178.73 MiB | 11.30 MiB/s, done.
Resolving deltas: 100% (8831/8831), done.
Checking connectivity... done.
{% endhighlight %}

If we peek inside the current working directory, we will see we have a new directory:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la
pocketsphinx  sphinxbase
{% endhighlight %}

Now lets take a look at all the stuff we've just cloned:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la pocketsphinx
AUTHORS       doc      indent.sh  Makefile.am  pocketsphinx.pc.in  README.md   swig
autogen.sh    .git     LICENSE    model        pocketsphinx.sln    regression  test
configure.ac  include  m4         NEWS         README              src         win32
{% endhighlight %}

Looks pretty similar to what we found in our sphinxbase source directory, right? 

It basically is, and we can run the same installation procedure as we did above. So now we cd into the dir itself and run **autogen.sh**. We get some output that looks like the following (again, I've truncated the output here).
 
{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ cd pocketsphinx
josh@yoga:~/Desktop/sphinx-source/pocketsphinx$ ./autogen.sh 
**Warning**: I am going to run `configure' with no arguments.
If you wish to pass any to it, please specify them on the
`./autogen.sh' command line.

processing .
Running libtoolize...
libtoolize: putting auxiliary files in `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
Running aclocal  ...
Running automake --foreign --copy  ...
configure.ac:11: installing './compile'
configure.ac:10: installing './config.guess'
configure.ac:10: installing './config.sub'
configure.ac:5: installing './install-sh'
                    .
                    .
                    .
config.status: creating model/Makefile
config.status: creating test/Makefile
config.status: creating test/testfuncs.sh
config.status: creating test/unit/Makefile
config.status: creating test/regression/Makefile
config.status: executing depfiles commands
config.status: executing libtool commands
Now type `make' to compile the package.
{% endhighlight %}

Now we've made all our necessary **Makefiles**, and we can see them in the **pocketsphinx** directory.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/pocketsphinx$ la
aclocal.m4      configure     libtool      model               README.md
AUTHORS         configure.ac  LICENSE      NEWS                regression
autogen.sh      doc           m4           pocketsphinx.pc     src
autom4te.cache  .git          Makefile     pocketsphinx.pc.in  swig
config.log      include       Makefile.am  pocketsphinx.sln    test
config.status   indent.sh     Makefile.in  README              win32
{% endhighlight %}


Same as we did above for **sphinxbase**, we run **make** now. 

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/pocketsphinx$ make
                             .
                             .
                             .
libtool: link: (cd ".libs" && rm -f "_pocketsphinx.so.0" && ln -s "_pocketsphinx.so.0.0.0" "_pocketsphinx.so.0")
libtool: link: (cd ".libs" && rm -f "_pocketsphinx.so" && ln -s "_pocketsphinx.so.0.0.0" "_pocketsphinx.so")
libtool: link: ar cru .libs/_pocketsphinx.a  pocketsphinx_wrap.o
libtool: link: ranlib .libs/_pocketsphinx.a
libtool: link: ( cd ".libs" && rm -f "_pocketsphinx.la" && ln -s "../_pocketsphinx.la" "_pocketsphinx.la" )
make[3]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig/python'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig/python'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig'
make[2]: Nothing to be done for `all-am'.
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig'
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx'
make[1]: Nothing to be done for `all-am'.
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx'
{% endhighlight %}

And now we can actually do the installation with **make install** and root privledges.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/pocketsphinx$ sudo make install
Making install in src
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx/src'
Making install in libpocketsphinx
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx/src/libpocketsphinx'
make[3]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx/src/libpocketsphinx'
                             .
                             .
                             .
libtool: install: /usr/bin/install -c .libs/libpocketsphinx.lai /usr/local/lib/libpocketsphinx.la
libtool: install: /usr/bin/install -c .libs/libpocketsphinx.a /usr/local/lib/libpocketsphinx.a
libtool: install: chmod 644 /usr/local/lib/libpocketsphinx.a
libtool: install: ranlib /usr/local/lib/libpocketsphinx.a
libtool: finish: PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin" ldconfig -n /usr/local/lib
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
                             .
                             .
                             .
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/lib/python2.7/dist-packages/pocketsphinx

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
                             .
                             .
                             .
make[3]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx/swig'
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/pocketsphinx'
make[2]: Nothing to be done for `install-exec-am'.
 /bin/mkdir -p '/usr/local/lib/pkgconfig'
 /usr/bin/install -c -m 644 pocketsphinx.pc '/usr/local/lib/pkgconfig'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/pocketsphinx'
{% endhighlight %}

Let's see if we got something. If you type in **pocketsphinx_** and do a tab completion to list all options, you should see something like this:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/pocketsphinx$ pocketsphinx_
pocketsphinx_batch         pocketsphinx_continuous    pocketsphinx_mdef_convert
{% endhighlight %}

Now if you try to run one of them, we get a sensible error that says we didn't supply any of the needed arguments.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/pocketsphinx$ pocketsphinx_continuous 
ERROR: "cmd_ln.c", line 679: No arguments given, available options are:
Arguments list definition:
[NAME]			[DEFLT]		[DESCR]
-adcdev					Name of audio device to use for input.
-agc			none		Automatic gain control for c0 ('max', 'emax', 'noise', or 'none')
-agcthresh		2.0		Initial threshold for automatic gain control
-allphone				Perform phoneme decoding with phonetic lm
-allphone_ci		no		Perform phoneme decoding with phonetic lm and context-independent units only
-alpha			0.97		Preemphasis parameter
                              .
                              .
                              .
-varfloor		0.0001		Mixture gaussian variance floor (applied to data from -var file)
-varnorm		no		Variance normalize each utterance (only if CMN == current)
-verbose		no		Show input filenames
-warp_params				Parameters defining the warping function
-warp_type		inverse_linear	Warping function type (or shape)
-wbeam			7e-29		Beam width applied to word exits
-wip			0.65		Word insertion penalty
-wlen			0.025625	Hamming window length

INFO: continuous.c(295): Specify '-infile <file.wav>' to recognize from file or '-inmic yes' to recognize from microphone.
{% endhighlight %}

Huzzah! We now have a functional version of **pocketsphinx** installed with all it's **sphinxbase** dependencies (if you followed the first section). If you already have a language model, an acoustic model, and a phonetic dictionary, you're good to go!

However, if you'd like to train or adapt an acoustic model, you need to install **sphinxtrain** as shown below.


<br />

<br />

### Installing sphinxtrain

Let's clone **sphinxtrain** into the temporary directory we've been using to store our source code (**sphinx-source**):

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ git clone https://github.com/cmusphinx/sphinxtrain.git
Cloning into 'sphinxtrain'...
remote: Counting objects: 15997, done.
remote: Total 15997 (delta 0), reused 0 (delta 0), pack-reused 15997
Receiving objects: 100% (15997/15997), 13.15 MiB | 1.80 MiB/s, done.
Resolving deltas: 100% (11174/11174), done.
Checking connectivity... done.
{% endhighlight %}

If we look inside the temorary directory, we see **sphinxtrain** right where it should be, alongside our other directories of source code.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la
pocketsphinx  sphinxbase  sphinxtrain
{% endhighlight %}

Now, if we look inside this new sourcecode, we will see something pretty familiar.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la sphinxtrain
AUTHORS       etc      LICENSE      NEWS    scripts          templates
autogen.sh    .git     m4           python  SphinxTrain.sln  test
configure.ac  include  Makefile.am  README  src              win32
{% endhighlight %}

Let's **cd** into **sphinxtrain** and run the script which generates the **Makefiles**.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ cd sphinxtrain
josh@yoga:~/Desktop/sphinx-source/sphinxtrain$ ./autogen.sh 
**Warning**: I am going to run `configure' with no arguments.
If you wish to pass any to it, please specify them on the
`./autogen.sh' command line.

processing .
Running libtoolize...
libtoolize: putting auxiliary files in `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
                      .
                      .
                      .
config.status: creating src/programs/param_cnt/Makefile
config.status: creating src/programs/printp/Makefile
config.status: creating src/programs/prunetree/Makefile
config.status: creating src/programs/tiestate/Makefile
config.status: creating test/Makefile
config.status: executing depfiles commands
config.status: executing libtool commands
Now type `make' to compile the package.
{% endhighlight %}

Let's take a look at what we just did.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxtrain$ la
aclocal.m4      config.status  include     Makefile.am  SphinxTrain.sln
AUTHORS         config.sub     install-sh  Makefile.in  src
autogen.sh      configure      libtool     missing      templates
autom4te.cache  configure.ac   LICENSE     NEWS         test
compile         depcomp        ltmain.sh   python       win32
config.guess    etc            m4          README
config.log      .git           Makefile    scripts
{% endhighlight %}

As with all the other installations, we now compile with **make**.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxtrain$ make
                            .
                            .
                            .
make[3]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src/programs/tiestate'
make[3]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src/programs'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src/programs'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src/programs'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
make[2]: Nothing to be done for `all-am'.
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
Making all in test
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/test'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/test'
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain'
make[1]: Nothing to be done for `all-am'.
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain'
{% endhighlight %}


Moving right along, we can run **make install** to seal the deal.

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxtrain$ sudo make install
                            .
                            .
                            .
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
make[3]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
make[3]: Nothing to be done for `install-exec-am'.
make[3]: Nothing to be done for `install-data-am'.
make[3]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/src'
Making install in test
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/test'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain/test'
make[2]: Nothing to be done for `install-exec-am'.
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/test'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain/test'
make[1]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain'
make[2]: Entering directory `/home/josh/Desktop/sphinx-source/sphinxtrain'
make[2]: Nothing to be done for `install-exec-am'.
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain'
make[1]: Leaving directory `/home/josh/Desktop/sphinx-source/sphinxtrain'
{% endhighlight %}

Hopefully now you can try out sphinxtrain and get some sensible output:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source/sphinxtrain$ sphinxtrain 

Sphinxtrain processes the audio files and creates and acoustic model 
for CMUSphinx toolkit. The data needs to have a certain layout 
See the tutorial http://cmusphinx.sourceforge.net/wiki/tutorialam 
for details

Usage: sphinxtrain [options] <command>

Commands:
     -t <task> setup - copy configuration into database
     [-s <stage1,stage2,stage3>] [-f <stage>] run - run the training or just selected stages
{% endhighlight %}

You should be ready to go now!

Hopefully this worked for you, or at least was helpful.

<!--

<br />

<br />

### Installing sphinx4

We need to get **gradle** to install. 

josh@yoga:~/Desktop/sphinx-source$ sudo apt-get install gradle
                        .
                        .
                        .
Setting up libgradle-core-java (1.4-2ubuntu1) ...
Setting up libgradle-plugins-java (1.4-2ubuntu1) ...
Setting up gradle (1.4-2ubuntu1) ...
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
Processing triggers for ca-certificates (20141019ubuntu0.14.04.1) ...
Updating certificates in /etc/ssl/certs... 0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d....
done.
done.


Now we need to get the Java Development Kit (JDK) because Sphinx4 is written purely in Java. 

josh@yoga:~/Desktop/sphinx-source$ sudo apt-get install openjdk-7-jdk
josh@yoga:~/Desktop/sphinx-source$ la /usr/lib/jvm
josh@yoga:~/Desktop/sphinx-source$ export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
josh@yoga:~/Desktop/sphinx-source$ export PATH=$PATH:$JAVA_HOME/bin
josh@yoga:~/Desktop/sphinx-source$ javac -version

josh@yoga:~/Desktop/sphinx-source$ git clone https://github.com/cmusphinx/sphinx4.git

josh@yoga:~/Desktop/sphinx-source$ la
pocketsphinx  sphinx4  sphinxbase  sphinxtrain

josh@yoga:~/Desktop/sphinx-source$ la sphinx4
build.gradle  license.terms  settings.gradle  sphinx4-samples
doc           README         sphinx4-core     tests
.git          RELEASE_NOTES  sphinx4-data


josh@yoga:~/Desktop/sphinx-source/sphinx4$ sudo gradle build
                    .
                    .
                    .
:sphinx4-data:check UP-TO-DATE
:sphinx4-data:build UP-TO-DATE
:sphinx4-samples:compileJava UP-TO-DATE
:sphinx4-samples:processResources UP-TO-DATE
:sphinx4-samples:classes UP-TO-DATE
:sphinx4-samples:jar UP-TO-DATE
:sphinx4-samples:javadoc UP-TO-DATE
:sphinx4-samples:javadocJar UP-TO-DATE
:sphinx4-samples:packageSources UP-TO-DATE
:sphinx4-samples:assemble UP-TO-DATE
:sphinx4-samples:compileTestJava UP-TO-DATE
:sphinx4-samples:processTestResources UP-TO-DATE
:sphinx4-samples:testClasses UP-TO-DATE
:sphinx4-samples:test UP-TO-DATE
:sphinx4-samples:check UP-TO-DATE
:sphinx4-samples:build UP-TO-DATE

BUILD SUCCESSFUL

Total time: 7.001 secs
-->


[cmu-sphinx]: http://cmusphinx.sourceforge.net/wiki/tutorialpocketsphinx?s[]=installation/
[cmu-downloads]: http://cmusphinx.sourceforge.net/wiki/download/
[cmu-sourceforge]: http://sourceforge.net/projects/cmusphinx/
[cmu-github]: https://github.com/cmusphinx/
[gcc]: https://gcc.gnu.org/
[automake]: https://www.gnu.org/software/automake/
[autoconf]: http://www.gnu.org/software/autoconf/autoconf.html
[libtool]: http://www.gnu.org/software/libtool/
[bison]: http://www.gnu.org/software/bison/
[swig]: http://www.swig.org/
[python-dev]: https://packages.debian.org/sid/python-dev/
[libpulse-dev]: https://packages.debian.org/sid/libpulse-dev/
[make]: https://en.wikipedia.org/wiki/Make_(software)
[stackoverflow]: http://stackoverflow.com/questions/10630747/converting-the-lm-to-dmp-file-for-building-the-language-model-for-speech-rec
[pocketsphinx]: https://github.com/cmusphinx/pocketsphinx
