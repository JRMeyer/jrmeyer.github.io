---
layout: post
title:  "Josh's Speaker ID Challenge"
date:   2017-09-29
categories: tutorial
comments: True
---


<br/>

*NB - This post is not written to a general audience in its current form. The target audience is currently the organizers of the speakerID challenge in which I participated.*

<br/>


## Introduction

Code may be found [here][code].

The challenge was set up as such:

Given a training set of audio (from now on, `train`), and a set of development data (ie. `dev`), create and assess a speaker identification system which can assign a speaker label (`spkID`) to a previously unheard test utterance (`utt`).

This document describes both the usage and architecture of the created system.


<br/>
<br/>

## Dependencies

The following assumes a standard `Linux` operating system with `python2` as well as `bash` and `perl` installations at `/bin`.

The system developed here relies on two main (non-standard) dependencies:

1. the `Kaldi` ASR Toolkit
2. the `sox` sound manipulation program

For Kaldi installation instructions, follow this post: [How to install Kaldi][kaldi-install].

For sox installation, simply:

{% highlight bash %}
sudo apt-get install sox
{% endhighlight %}

Kaldi is used to do most all of the training and testing.

Sox is used to corrupt the original input data to better make the corrupted testing data.

<br/>
<br/>


## Setup

### Data

The training and dev data are set up in the following way. The topmost, `audio_dir` can be located anywhere and the scripts will still work provided the correct absolute path.

{% highlight bash %}
audio_dir/
├── train
|   ├── utt2spk (optional)
|   └── * FLAC 16kHz files
└── dev
    ├── utt2spk (optional)
    └── * WAV 8kHz files
{% endhighlight %}


### Code

After Kaldi and sox have been installed, extract the provided scripts and copy them to the following location:

{% highlight bash %}
kaldi/egs/ser10/v1/
{% endhighlight %}

Specifically, here are the scripts provided to you:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/sre10/v1$ tree meyer_challenge
.
├── corrupt_data.sh
├── find_best_plda.sh
├── make_mfcc_and_vad.sh
├── prepare_data.sh
├── run_challenge_test.sh
├── run_challenge_train.sh
└── train_ubm_and_ivec_extractor.sh

{% endhighlight %}

Just take those scripts and move them to `v1/`.

<br/>
<br/>

## Usage

For training and testing there are two main run scripts:

1. `run_challenge_train.sh`
2. `run_challenge_test.sh`

### Training


The training script should be run from the `sre10/v1` directory:

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/sre10/v1$ audio_dir=/home/josh/Desktop/spkidtask-distribute
josh@yoga:~/git/kaldi/egs/sre10/v1$ ./run_challenge_train.sh $audio_dir
{% endhighlight %}

The training script expects a directory with two sub-directories:

{% highlight bash %}
audio_dir/
├── train
|   ├── utt2spk (optional)
|   └── * FLAC 16kHz files
└── dev
    ├── utt2spk (optional)
    └── * WAV 8kHz files
{% endhighlight %}

The name `audio_dir` is arbitrary, but `train` and `dev` must be named as such.


### Testing

Assuming that you have successfully trained a speakerID system via `./run_challenge_train.sh`, you can now label any `8kHz` audio file with a `spkID` label from `train`.

{% highlight bash %}
josh@yoga:~/git/kaldi/egs/sre10/v1$ new_utt=/home/josh/Desktop/spkidtask-distribute/eval/1114c90b-4051-420d-97a8-f2c7fe8e2444.wav
josh@yoga:~/git/kaldi/egs/sre10/v1$ ./run_challenge_test.sh $new_utt 
{% endhighlight %}

This script will print out the assigned label to the terminal.



<br/>
<br/>


## Training Pipeline

The training procedure for creating the speakerID system is the following:

### Backup Original Data, Convert, and downsample

The original `train` data came in 16kHz FLAC files, so to make a match with testing (`dev` and `eval`) data, we need to convert to WAV and downsample.

We can accomplish this with the following code snippet, making sure we first back up the original FLAC data to `train-org`.


{% highlight bash %}
# take FLAC files and convert to WAV, with backup in train-org
cp -r $audio_dir/train $audio_dir/train-org

for i in ${audio_dir}/train/*.flac; do
    file=${i##*/}
    base="${file%.*}"
    
    ffmpeg -i $i ${audio_dir}/train/${base}-16k.wav
    sox ${audio_dir}/train/${base}-16k.wav -r 8k ${audio_dir}/train/${base}.wav

    # remove original FLAC and 16k WAV
    rm -f $i ${audio_dir}/train/${base}-16k.wav
done
{% endhighlight %}



### Corrupt Data

To create `train` data more similar to `eval` data, the following subscript will perform a `lowpass` filter, add `Gaussian noise`, and `amplify` all existing frequencies:

{% highlight bash %}
corrupt_data.sh $audio_dir/train
{% endhighlight %}



### Prep Data and Extract Features

To get data in the right format for training, and extract audio features we do the following for both `train` and `dev` data:

{% highlight bash %}
# create data dir
prepare_data.sh $audio_dir $data_type

# create feats dir
make_mfcc_and_vad.sh $data_type
{% endhighlight %}


### Train UBM and T-matrix

The main training sub-script is shown below. This script takes in the `train` data and builds an ivector extractor based on a Universal Background Model.

{% highlight bash %}
num_components=200
ivec_dim=100
 
train_ubm_and_ivec_extractor.sh \
    --num-iters-full-ubm 5 \
    --num-iters-ivec 5 \
    train \
    $num_components \
    $ivec_dim
{% endhighlight %}


### Extract ivectors for Assessment

To assess the performance of the system, we extract ivectors from both `train` and `dev`, and then later classify the `dev` utterances using `spkID`s from `train`.

{% highlight bash %}
sid/extract_ivectors.sh \
    --cmd './utils/run.pl' \
    --nj 4 \
    exp/extractor \
    data-${data_type} \
    exp/ivectors-${data_type}
{% endhighlight %}



### Train PLDA on ivectors

Next, to project our ivectors into a new space with better discriminative power, we use PLDA as such:

{% highlight bash %}

plda_ivec_dir=exp/ivectors-train

utils/run.pl $plda_ivec_dir/log/plda.log \
       ivector-compute-plda \
       ark:$plda_data_dir/spk2utt \
       "ark:ivector-normalize-length scp:${plda_ivec_dir}/ivector.scp  ark:- |" \
       $plda_ivec_dir/plda \
       || exit 1;
{% endhighlight %}


### Assess Classification Error on `dev`

Next, we take the ivectors we extracted from `dev`, along with the averaged ivectors for each `spkID` in `train`, and compare.

Here we are using a `trials` file in which every `utt` is compared against every `spkID`.

{% highlight bash %}
utils/run.pl exp/plda_scores/log/plda_scoring.log \
       ivector-plda-scoring \
       --normalize-length=true \
       --simple-length-normalization=false \
       --num-utts=ark:${plda_ivec_dir}/num_utts.ark \
       "ivector-copy-plda --smoothing=0.0 ${plda_ivec_dir}/plda - |" \
       "ark:${plda_ivec_dir}/spk_ivector.ark" \
       "ark:ivector-normalize-length scp:./exp/ivectors-dev/ivector.scp ark:- |" \
       "cat '$trials' | cut -d\  --fields=1,2 |" \
       exp/plda_scores/plda_scores \
      || exit 1;
{% endhighlight %}

Then we calculate the EER with the following `python` script and Kaldi program:

{% highlight bash %}
eer=`compute-eer <(python local/prepare_for_eer.py $trials exp/plda_scores/plda_scores) 2> /dev/null`
{% endhighlight %}





<br/>
<br/>

## Testing Pipeline

There is much overlap between the Training and Testing scripts, so here I will just highlight the differences.

The main difference is that in `run_challenge_test.sh`, we assume the existence of a trained `ivector extractor` as well as a trained `PLDA matrix`. Also, these two components must be located in the same location as if they had just been trained by the above script, `run_challenge_train.sh`.

### Feature Extraction

As above, we extract `MFCCs` and `VADs` for the new audio file.

### ivector Extraction

As above, we extract ivectors from the new audio using the trained `T-matrix`.

### Compare new `utt` ivector with `spkID` ivectors via PLDA

This step assumes old speaker ivectors as well as a PLDA matrix.

### Choose best label

This is specific to testing (ie. doesn't happen in training).

The way we use PLDA to compare ivectors traditionally results in a similarity score between each pair of `utt` and `spkID`. However, for our current purposes, we want to find the *best* `spkID` for a given `utt`. The following simple script does just that:


{% highlight bash %}
./find_best_plda.sh exp/test/plda_scores/plda_scores
{% endhighlight %}

At the end, you should have a single `spkID` printed to your terminal!


<br/>
<br/>


## Conclusion

The best system I trained obtained an `EER` of `7.5%`, using only the data provided. This system used a full covariance UBM with 200 components and a 200x100 dimensional T-matrix (ie. 100-dimensional ivectors).

Hopefully these instructions and explanation were clear, but if there's a need to clarification, don't hesitate to contact me.

Enjoy your new speaker identification system:)



[kaldi-install]: http://jrmeyer.github.io/kaldi/2016/01/26/Installing-Kaldi.html
[code]: https://github.com/JRMeyer/speakerID_challenge