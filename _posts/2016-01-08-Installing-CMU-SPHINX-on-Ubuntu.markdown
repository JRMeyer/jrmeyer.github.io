---
layout: post
title:  "Installing CMU-SPHINX on Ubuntu via GitHub"
date:   2016-01-08 22:03:04 -0700
categories: installation
---

## Some Background

I recently installed Ubunutu 14.04 on my Lenovo Yoga, and it's time to reinstall SPHINX. 

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

Now we can take a look at what we got:

{% highlight bash %}
josh@yoga:~/Desktop/sphinx-source$ la
sphinxbase
josh@yoga:~/Desktop/sphinx-source$ la sphinxbase/
AUTHORS       doc      indent.sh  Makefile.am  README.md         src   win32
autogen.sh    .git     LICENSE    NEWS         sphinxbase.pc.in  swig
configure.ac  include  m4         README       sphinxbase.sln    test
{% endhighlight %}

Now we need to run the **autogen.sh** shell script you can see in the sphinxbase directory. This will generate our **Makefiles** and other important scripts for compiling and installing. We're going to get a long output here, so I only show some of it here:

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

Now for the last step. Run the command **sudo make install**. Root permission is important, because otherwise you will get some error without any *Permision Denied* warning. 

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
[python-dev]: https://packages.debian.org/sid/python-dev
[libpulse-dev]: https://packages.debian.org/sid/libpulse-dev
[make]: https://en.wikipedia.org/wiki/Make_(software)
[stackoverflow]: http://stackoverflow.com/questions/10630747/converting-the-lm-to-dmp-file-for-building-the-language-model-for-speech-rec