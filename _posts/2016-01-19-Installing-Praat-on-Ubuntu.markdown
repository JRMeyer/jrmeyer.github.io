---
layout: post
title:  "Installing Praat on Ubuntu - getting sound to work"
date:   2016-01-19 22:03:04 -0700
categories: installation
---

## Some Background

I recently installed Ubuntu 14.04 on my Lenovo Yoga, and it's time to reinstall Praat. 

I've gotten Praat to work before on Ubuntu, but it was a pain. From what I can tell, a lot of Linux users hit this problem where they can see and edit sounds, but just not play them through speakers or headphones. 

I remember reading a lot about alsa and pulsaudio, but not getting far.

Today I was on Praat's website, looking through their installation page and their suggested steps to get Praat working, but then I thought installing from the latest source might be the solution. It's strange, but there's no mention that I could find of their source code being hosted on GitHub. They have a local version of the source, but I thought I'd just check on GitHub anyways. 

Sure enough, there it was, and it was reassuring to see that Paul Boersma was the one who had made the latest commits.

So, I cloned from GitHub, did the install, and it worked! Since I couldn't find other posts about the install and the GitHub page is little publicized on Praat's home page, I will go through the steps here.

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
| libasound2-dev      | [ALSA Development Library][libasound2] | *This package contains files required for developing software that makes use of libasound2, the ALSA library. ALSA is the Advanced Linux Sound Architecture.* | 
| libgtk2.0-dev      | [GTK+ Development Library][libgtk]      |   *development files for the GTK+ library* |


<br />
Here's the command to get both at once:

{% highlight bash %}
sudo apt-get install libasound2-dev libgtk2.0-dev
{% endhighlight %}

<br />

<br />

## Installing Praat

To get the most update version of Praat, let's clone it from GitHub and just save it on our desktop. Once it's on our desktop. 

{% highlight bash %}
josh@yoga:~/Desktop$ git clone https://github.com/praat/praat.git
{% endhighlight %}

If you do an **ls** on your Desktop, you should see a new, praat directory. Here are located all the files (Makefiles) to install it correctly. Let's take a look at what we've just got:

{% highlight bash %}
josh@yoga:~/Desktop$ la praat
artsynth  dwsys   dwtools  external  fon   .gitattributes  gram  LPC   makefile   num        stat  test
contrib   dwtest  EEG      FFNet     .git  .gitignore      kar   main  makefiles  README.md  sys
{% endhighlight %}

Now we need to get the definitions that are specific to Linux for our makefiles. We need to be in our new praat directory and save the ones that are relevant to us to a new file, **makefiles.defs**.

{% highlight bash %}
josh@yoga:~/Desktop$ cd praat
josh@yoga:~/Desktop/praat$ cp makefiles/makefile.defs.linux.alsa ./makefile.defs
{% endhighlight %}

Now that we've made this new **makefiles.defs** file, we can see it in our praat dir.

{% highlight bash %}
josh@yoga:~/Desktop/praat$ la
artsynth  dwtest   external  .git            gram  main           makefiles  stat
contrib   dwtools  FFNet     .gitattributes  kar   makefile       num        sys
dwsys     EEG      fon       .gitignore      LPC   makefile.defs  README.md  test
{% endhighlight %}

Now we can install Praat with the standard **make** command. 

You're going to get a lot of output at the command line, and it may take a couple mintues to finish. Here's the tail end of the output you should be getting.

{% highlight bash %}
josh@yoga:~/Desktop/praat$ sudo make
                      .
                      .
                      .
make[1]: Leaving directory `/home/josh/Desktop/praat/contrib/ola'
make -C main main_Praat.o 
make[1]: Entering directory `/home/josh/Desktop/praat/main'
g++ -std=c++11 -DUNIX -Dlinux -DALSA -D_FILE_OFFSET_BITS=64 `pkg-config --cflags gtk+-2.0` -Werror=missing-prototypes -Werror=implicit -Wreturn-type -Wunused -Wunused-parameter -Wuninitialized -O1 -g1 -pthread -Wshadow -I ../num -I ../sys -I ../fon  -c -o main_Praat.o main_Praat.cpp
make[1]: Leaving directory `/home/josh/Desktop/praat/main'
g++ -o praat main/main_Praat.o  fon/libfon.a \
		contrib/ola/libOla.a artsynth/libartsynth.a \
		FFNet/libFFNet.a gram/libgram.a EEG/libEEG.a \
		LPC/libLPC.a dwtools/libdwtools.a \
		fon/libfon.a stat/libstat.a dwsys/libdwsys.a \
		sys/libsys.a num/libnum.a kar/libkar.a \
		external/espeak/libespeak.a external/portaudio/libportaudio.a \
		external/flac/libflac.a external/mp3/libmp3.a \
		external/glpk/libglpk.a external/gsl/libgsl.a \
		`pkg-config --libs gtk+-2.0` -lm -lasound -lpthread
{% endhighlight %}

At this point you might think that you're done, but if you try to run Praat from the command line, you get an error:

{% highlight bash %}
josh@yoga:~/Desktop/praat$ praat
The program 'praat' is currently not installed. You can install it by typing:
sudo apt-get install praat
{% endhighlight %}

DO NOT RUN THAT COMMAND! 

This error is telling you that the computer can't find Praat, not that it's not installed.

You do have Praat and it does work. To prove it, you can just run:

{% highlight bash %}
josh@yoga:~/Desktop/praat$ ./praat
{% endhighlight %}

You should see that familiar, beautiful GUI. 

So, to put Praat in the right place, you just copy that executable file **./praat** to where it belongs. For Ubuntu users, this executable shoudl be in **/usr/bin**. 

So, we simply copy the file to where it goes:

{% highlight bash %}
josh@yoga:~/Desktop/praat$ sudo cp ./praat /usr/bin/.
{% endhighlight %}

Now you can run Praat from anywhere, and you should have sound!

{% highlight bash %}
josh@yoga:~/Desktop/praat$ praat
{% endhighlight %}

You probably want to remove those source files on the Desktop, since you don't need them anymore:

{% highlight bash %}
josh@yoga:~/Desktop/praat$ cd ..
josh@yoga:~/Desktop$ sudo rm -r praat
{% endhighlight %}

Enjoy your Praat!

[libgtk]: http://packages.ubuntu.com/precise/libgtk2.0-dev
[libasound2]: https://packages.debian.org/sid/libasound2-dev

