---
layout: post
title:  "Installing SPHINX on Ubuntu 14.04 from GitHub"
date:   2016-01-08 22:03:04 -0700
categories: installation
---

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


[cmu-sphinx]: http://cmusphinx.sourceforge.net/wiki/tutorialpocketsphinx?s[]=installation/
[cmu-downloads]: http://cmusphinx.sourceforge.net/wiki/download/
[cmu-sourceforge]: http://sourceforge.net/projects/cmusphinx/
[cmu-github]: https://github.com/cmusphinx/