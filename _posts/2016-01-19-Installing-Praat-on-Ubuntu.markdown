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




[libgtk]: http://packages.ubuntu.com/precise/libgtk2.0-dev
[libasound2]: https://packages.debian.org/sid/libasound2-dev

