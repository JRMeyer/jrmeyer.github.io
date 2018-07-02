---
layout: post
title:  "How we added Kyrgyz to Mozilla's Common Voice project"
date:   2019-05-29
categories: misc
comments: True
---

<br/>

<img src="/misc/robot-greetings.png" align="right" style="width: 250px;"/>

<br/>
<br/>


## Introduction

Mozilla is helping build Kyrgyz voice technology (for free) via its Common Voice project. Anyone can go to the Common Voice website and record sentences for the project. We need as many speakers and accents as possible in order to create robust technologies. [Donate your voice now.][kyrgyz-common]

<br/>

## What is Common Voice?

Common Voice is a data collection project from Mozilla, focused on collecting free and open-source data for speech recognition systems. To build a working speech recognition system (such as Siri or OK Google) the developer must first train the computer to understand how words in a language are pronounced. The system must be able to distinguish sounds like vowels and consonants, and to accomplish this you need lots of audio data.

Mozilla is crowd-sourcing this data collection with the Common Voice project, which allows anyone to record their voice and upload it to the cloud. At any time, developers can download these collections of recordings and train their own speech technologies for any kind of application. For instance, Google could use this data to create a Kyrgyz-language voice assistant for Android phones, or Namba taxi could use this data to make a voice-powered iPhone app for Kyrgyz speakers. Anyone can download the data and use it for whatever project they wish!


<br/>



## Why is this important?

Enabling Kyrgyz data collection to Mozilla's Common Voice project is important because it will spur innovation in the Kyrgyz technology sector. Voice technologies are often more comfortable to use than typing, and for many people (such as people who are blind or handicapped) these technologies are essential to normal living. Voice technologies are widely used already for European languages such as English, French and Spanish because the appropriate datasets (i.e. large collections of voice recordings) already exist.

However, the time and money required to create one of these datasets is a major hindrance for a new language, and Mozilla has developed a method of crowd-sourcing data collection which makes data collection much faster and free. Mozilla provides all the recordings under the Creative Commons CC-0 license, so the data is free to use for any purpose. This open license ensures that small companies have access to the same cutting-edge technologies as technology giants like Google.

<br/>



## How did we do it?

We took two main steps to add Kyrgyz to the Common Voice project:

1. Translate the user interface and information into Kyrgyz
2. Collect text sentences which users will read out-loud

### Translation

In order to translate the user interface into Kyrgyz, a team of contributors worked together to ensure that the translations are natural-sounding and accurate. This team includes [Chorobek Saandanbek][chorobek] (director of the [Bizdin Muras Foundation][bizdin]), [Saikal Maatkerimova][saikal] (Kyrgyz language instructor at [Lingua Yurt][lingua-yurt]), and [Talgat Subanaliev][talgat] (recent [AUCA][auca] graduate). As the interface evolves and expands, Saandanbek will lead the team to ensure that the translation is accurate and up-to-date.

Mozilla has enabled crowd-sourcing of the interface translation itself, such that anyone can propose a new translation if they identify an error in translation. Kyrgyz speakers can help with Common Voice translation via the [Pontoon system][pontoon]. Once a new translation is proposed, the team leader (i.e. Saandanbek) will review and accept or defer the translation. In this way, problems are found quickly and resolved appropriately.

### Text Collection

To create a dataset for training speech technologies, collecting voices isn't enough. We need to know what was said in every recording so that the computer can recognize words from the audio. As such, Mozilla has devised a system to display a text sentence on the screen, and then the speaker reads the sentence out loud so that each recording is saved along with the text. These sentences are difficult to find, because they must be under the [Create Commons license CC-0][cc0] so that Mozilla may freely distribute the text sentences and audio recordings together.

Currently, all Kyrgyz text sentences used for this project come from the well-known Kyrgyz language news source [Kloop.kg][kloop]. The founder of Kloop.kg, [Bektour Iskender][bektour] - a proponent of an open-internet and the Create Commons - allowed use of Kyrgyz language articles from Kloop to be distributed under CC-0. As such, when the user reads a sentence for Kyrgyz Common Voice, they are actually reading news from Kloop.kg. This is a major win for the Kyrgyz language and the open internet, because finding CC-0 text for Common Voice is typically the most difficult task in adding a new language. At least 5,000 different sentences should be initially recorded, and most books and online news (such as [BBC Kyrgyz][bbc]) are not available under CC-0.

After the text was automatically downloaded from Kloop (via [this Python script][scrape]), the text was cleaned (all foreign words, numbers, abbreviations were removed) and sentences of an appropriate length were selected. Ideally each recording should be about 5 seconds long. More text can be added later, such that there is more diversity in the kinds of sentences read. Diversity is important for Common Voice, because good speech technologies should recognize the speech of people speaking with different accents about different topics.

The Common Voice team itself, lead by [Michael Henretty][henretty] and [Kelly Davis][davis] personally helped push the Kyrgyz language version into production. In addition, [Francis Tyers][tyers] (computational linguist and Turkic language activist) helped in team coordination and translation overview. Josh Meyer processed the text from Kloop.kg and helped coordinate the various teams (i.e. Mozilla folks, translation team, Kloop.kg, and Tyers).

<br/>

## Donate Your Voice!

In order for quality technologies to be created for the Kyrgyz language, we need more voices!

Anyone can record and donate sentences for the Common Voice project, and the more voices we get, the more accurate the technology becomes.

[Donate your voice today!][kyrgyz-common]








[chorobek]: https://www.facebook.com/chorobek.saadanbekov
[bizdin]: http://bizdin.kg/
[saikal]: https://www.facebook.com/saykal.maatkerimova
[lingua-yurt]: https://www.facebook.com/lingua.yurt
[talgat]: https://www.facebook.com/subanaliev
[auca]: https://www.facebook.com/MyAUCA/
[pontoon]: https://pontoon.mozilla.org/ky/common-voice/
[cc0]: https://creativecommons.org/publicdomain/zero/1.0/deed
[kloop]: http://ky.kloop.asia/
[bektour]: https://twitter.com/bektour
[bbc]: https://www.bbc.com/kyrgyz
[scrape]: https://www.github.com/JRMeyer/web_corpus
[henretty]: https://video.golem.de/internet/20162/mozilla-common-voice-interview-englisch.html
[davis]: https://video.golem.de/internet/20161/mozilla-deep-speech-interview-englisch.html
[tyers]: https://www.hse.ru/en/news/campus/208242212.html
[kyrgyz-common]: https://voice.mozilla.org/ky