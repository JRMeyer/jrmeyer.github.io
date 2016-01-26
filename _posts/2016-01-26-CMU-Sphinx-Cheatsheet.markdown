---
layout: post
title:  "CMU-Sphinx Cheatsheet"
date:   2016-01-26 22:03:04 -0700
categories: cmusphinx
comments: True
---

## Overview

Below are some commands that I've found particularly useful in working with CMU-Sphinx from the command line (i.e. Bash) on my Linux machine. 

I hope they're helpful to others, and if you have comments or suggestions for other commands to include, leave a comment! I'd like to get as much on here as possible, but still have it be more of a cheatsheet than a manual.

## Acoustic Model Training

The following is the file structure you're going to need to train an acoustic model from a set of transcribed sound files. This procedure relies on **sphinxtrain** which I show how to download in another post. *Filenames matter!* and in the file structure below, *your_db* should always be the same

File Structure: |
     your_model/
        etc/
                your_model.dic - Phonetic dictionary
		        your_model.phone - Phoneset file
		        your_model.lm - Language model
		        your_model.filler - List of fillers
		        your_model_train.fileids - List of files for training
		        your_model_train.transcription - Transcription for training
		        your_model_test.fileids - List of files for testing
		        your_model_test.transcription - Transcription for testing
	    wav/
                speaker_1/
                        file_1.wav - Recording of speech utterance
                        file_2.wav - Recording of speech utterance
		        speaker_2/
                        file_1.wav
                        file_2.wav

So, that's the overall file structure you need, and here's what the contents of the files should include:

File contents:

.fileids (paths to WAV files w/o extensions) : |
         speaker_1/file_1
         speaker_2/file_2
              ...
	      
.transcription (transcription + file id w/o path or extension) : |
               <s> hello world </s> (file_1)
               <s> foo bar </s> (file_2)
                          ...

.wav (Recording files) : |
     WAV, (16 kHz, 16 bit, mono - desktop), (8kHz, 16bit, mono - telephone)
     **Audio format mismatch is the most common training problem**

.dict (use alphanumeric-only, case-insensitive) : |
      HELLO HH AH L OW
      WORLD W AO R L D
            ...

.phone (one phone per line + SIL for silence) : |
       SIL
       A
       O
       I
       ...

.lm (or .lm.bin, commonly in ARPA format) : |
    \data\
    ngram 1=7
    ngram 2=7
    
    \1-grams:
    0.1 <UNK>	0.5555
    0 <s>	 0.4939
       ...

.filler (filler noise dict) : |
        <s> SIL
	    </s> SIL
	    <sil> SIL
	    +um+ ++um++
	    +laugh+ ++laugh++	
	    ...

Once you've got the structure correct and the appropriate contents for the files, the training command is actually very simple:



{% highlight bash %}
josh@yoga:~$ sphinxtrain -t your_model setup
{% endhighlight %}

<br />

<br />


[libgtk]: http://packages.ubuntu.com/precise/libgtk2.0-dev


