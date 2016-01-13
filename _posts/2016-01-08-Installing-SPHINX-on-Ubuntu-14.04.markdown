---
layout: post
title:  "Installing SPHINX on Ubuntu 14.04 from GitHub"
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