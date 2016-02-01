---
layout: post
title:  "CMU-Sphinx Cheatsheet"
date:   2016-01-26 22:03:04 -0700
categories: cmusphinx
comments: True
---

==== POST IN PROGRESS ====

## Overview

Below are some commands that I've found particularly useful in working with CMU-Sphinx from the command line (i.e. Bash) on my Linux machine. 

I hope they're helpful to others, and if you have comments or suggestions for other commands to include, leave a comment! I'd like to get as much on here as possible, but still have it be more of a cheatsheet than a manual.

## Acoustic Model Training

The following is the file structure you're going to need to train an acoustic model from a set of transcribed sound files. This procedure relies on **sphinxtrain** which I show how to download in another post. *Filenames matter!* and in the file structure below, *your_db* should always be the same

File Structure:

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

File contents

.fileids (paths to WAV files w/o extensions):

         speaker_1/file_1
         speaker_2/file_2
              ...
	      
.transcription (transcription + file id w/o path or extension):

               <s> hello world </s> (file_1)
               <s> foo bar </s> (file_2)
                          ...

.wav (Recording files):
     
     WAV, (16 kHz, 16 bit, mono - desktop), (8kHz, 16bit, mono - telephone)
     **Audio format mismatch is the most common training problem**

.dict (use alphanumeric-only, case-insensitive):

      HELLO HH AH L OW
      WORLD W AO R L D
      ...

.phone (one phone per line + SIL for silence):

       SIL
       A
       O
       I
       ...

.lm (or .lm.bin, commonly in ARPA format):

    \data\
    ngram 1=7
    ngram 2=7
    
    \1-grams:
    0.1 <UNK>	0.5555
    0 <s>	 0.4939
       ...

.filler (filler noise dict):

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

Below is an example of what my file structure looks like before training an acoustic model. 

In my case, the main directory is located at **~/Desktop/kyrgyz**. So everywhere above where you see **your_model** in the file and directory names, I just have **kyrgyz**. 

Before training, we should just see two directories in the main dir:

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz$ la
etc  wav
{% endhighlight %}

Just looking into **etc/** we see the following:

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz$ la etc/
kyrgyz.dic     kyrgyz.phone               kyrgyz_train.fileids
kyrgyz.filler  kyrgyz_test.fileids        kyrgyz_train.transcription
kyrgyz.lm      kyrgyz_test.transcription
{% endhighlight %}

If you look into the **wav/** dir, you will have any number of subdirs full of WAV files. Here I only have one subdir, **audio-files**:

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz$ la wav
audio-files
josh@yoga:~/Desktop/kyrgyz$ la wav/audio-files/
100.wav  276.wav  450.wav       atai_142.wav  atai_319.wav
101.wav  277.wav  451.wav       atai_143.wav  atai_31.wav
102.wav  278.wav  452.wav       atai_144.wav  atai_320.wav
103.wav  279.wav  453.wav       atai_145.wav  atai_321.wav
104.wav  27.wav   454.wav       atai_146.wav  atai_322.wav
105.wav  280.wav  455.wav       atai_147.wav  atai_323.wav
                            .
                            .
                            .
{% endhighlight %}

Since this setup is correct, we can run the simple command to train the acoustic model:

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz$ sphinxtrain -t kyrgyz setup
Sphinxtrain path: /usr/local/lib/sphinxtrain
Sphinxtrain binaries path: /usr/local/libexec/sphinxtrain
Setting up the database kyrgyz
{% endhighlight %}

If we look into the main dir again, we will see a lot got generated:

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz$ la
bwaccumdir  feat         logdir              model_parameters  result  wav
etc         kyrgyz.html  model_architecture  qmanager          trees
{% endhighlight %}

In my original **kyrgyz/etc/** dir, some new files appear as well (**feat.params** and **sphinx_train.cfg**).

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz$ la etc/
feat.params    kyrgyz.phone               kyrgyz_train.transcription
kyrgyz.dic     kyrgyz_test.fileids        sphinx_train.cfg
kyrgyz.filler  kyrgyz_test.transcription
kyrgyz.lm      kyrgyz_train.fileids
{% endhighlight %}

If we look into **sphinx_train.cfg**, we see the following:

{% highlight bash %}
josh@yoga:~/Desktop/kyrgyz/etc$ cat sphinx_train.cfg 
# Configuration script for sphinx trainer                  -*-mode:Perl-*-

$CFG_VERBOSE = 1;		# Determines how much goes to the screen.

# These are filled in at configuration time
$CFG_DB_NAME = "kyrgyz";
# Experiment name, will be used to name model files and log files
$CFG_EXPTNAME = "$CFG_DB_NAME";

# Directory containing SphinxTrain binaries
$CFG_BASE_DIR = "/home/josh/Desktop/kyrgyz";
                    .
                    .
                    .
$DEC_CFG_LANGUAGEMODEL  = "$CFG_BASE_DIR/etc/${CFG_DB_NAME}.lm.DMP";
# Or can be JSGF or FSG too, used if uncommented
# $DEC_CFG_GRAMMAR  = "$CFG_BASE_DIR/etc/${CFG_DB_NAME}.jsgf";
# $DEC_CFG_FSG  = "$CFG_BASE_DIR/etc/${CFG_DB_NAME}.fsg";

$DEC_CFG_LANGUAGEWEIGHT = "10";
$DEC_CFG_BEAMWIDTH = "1e-80";
$DEC_CFG_WORDBEAM = "1e-40";

$DEC_CFG_ALIGN = "builtin";

$DEC_CFG_NPART = 1;		#  Define how many pieces to split decode in

# This variable has to be defined, otherwise utils.pl will not load.
$CFG_DONE = 1;

return 1;
{% endhighlight %}

As you can see, it's very important that you are consistent in your file and directory names, because they are dynamically generated at configutaion based on the name you provide for **your_model**. In my case, you can see that the language model location is found by referencing the base/main directory as such: **$DEC_CFG_LANGUAGEMODEL  = "$CFG_BASE_DIR/etc/${CFG_DB_NAME}.lm.DMP"**. So, if you are inconsistent, your configuration won't be able to find your language model or other files.

You should take a look over **sphinx_train.cfg** to make sure everything is in its right place.

Once you're sure you're ready, you can do the actual training with:

{% highlight bash %}
sphinxtrain run
{% endhighlight %}

<br />

<br />

## Testing pocketsphinx

Test your system with a microphone:

{% highlight bash %}
pocketsphinx_continuous -hmm your_hmm_dir -lm your_language_model.lm -dict your_phonetic_dictionary.dic -inmic yes
{% endhighlight %}

Test your system (i.e. make predictions) on a bunch of WAV files:

{% highlight bash %}
pocketsphinx_batch  -adcin yes  -cepdir dir_of_test_WAVs  -cepext .wav  -ctl your_test.fileids -hmm your_hmm_dir -lm your_language_model.lm -dict your_phonetic_dictionary.dic  -hyp predictions.hyp
{% endhighlight %}

Once you have run batch decoding on some files and generated a predictions.hyp file, do this command to see how good your hypotheses were:

{% highlight bash %}
perl word_align.pl your_test.transcription predictions.hyp
{% endhighlight %}



[libgtk]: http://packages.ubuntu.com/precise/libgtk2.0-dev


