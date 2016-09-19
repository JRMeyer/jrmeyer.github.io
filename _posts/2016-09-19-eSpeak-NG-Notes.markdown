---
layout: post
title:  "eSpeak NG Notes"
date:   2016-09-19
categories: espeak
comments: True
---

## Introduction

If you're looking to install and get started with eSpeak NG, I have a post on that [here][install-post]. In this post, I'm just going to collect some various notes as I'm working on the Kyrgyz language.

[ESpeak NG][official-repo] is an open-source, [formant speech synthesizer][formant] which has been integrated into various open-source projects (e.g. Ubuntu, [NVDA][nvda]). ESpeak NG can be also be used as a stand-alone text-to-speech converter to read text out loud on a computer. ESpeak NG is the 'New Generation' fork of the older, [eSpeak][espeak]. You can find the official documentation [here][docs].

## Word-Level Stress

I got caught up for a while on how to add stress to words. For Kyrgyz, most all words have stress on the final syllable, so this should be in principle easy to code up.

The reason this was not so simple, was that I spent my time trying to figure out how to use the **ph_source/intonation** file. However, this file has to do with *clause* and not *word-level* stress. 

I ended up encoding stress in the **dictsource/ky_rules** file with definitions such as:

{% highlight bash %}
.group а
       а (_  'a   // word final syllable gets stressed
       аа (_  'a:   // word final syllable gets stressed
       а (L03_  'a   // word final syllable gets stressed
       аа (L03_  'a:   // word final syllable gets stressed
       а (L03L03_  'a   // word final syllable gets stressed
       аа (L03L03_  'a:   // word final syllable gets stressed
       а        a
       аа       a:
{% endhighlight %}

The first six rules find word final vowels, and give them main stress with the tick mark. If there's a more concise way to write these rules in some kind of regular expression, I don't know yet, hence the repetition. A more concise rule would be: "а (L03*_ 'a".


[install-post]: http://jrmeyer.github.io/tutorial/2016/07/03/How-to-Add-a-Language-to-Espeak-NG.html
[official-repo]: https://github.com/espeak-ng/espeak-ng
[formant]: https://en.wikipedia.org/wiki/Speech_synthesis#Formant_synthesis
[nvda]: http://www.nvaccess.org/
[espeak]: https://en.wikipedia.org/wiki/ESpeak
[docs]: https://github.com/espeak-ng/espeak-ng/tree/master/docs