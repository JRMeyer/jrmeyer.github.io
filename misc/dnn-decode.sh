#!/bin/bash

# Author Joshua Meyer (2017)

# USAGE:
#    $ kaldi/egs/your-model/your-model-1/dnn-decode.sh
# 
#    This script is meant to demonstrate how an existing DNN-HMM
#    model and its corresponding HCLG graph, build via Kaldi,
#    can be used to decode new audio files.
#    Although this script takes no command line arguments, it assumes
#    the existance of a directory (./transcriptions) and an scp file
#    within that directory (./transcriptions/wav.scp). For more on scp
#    files, consult the official Kaldi documentation.

# INPUT:
#    transcriptions/
#        wav.scp
#
#    config/
#        mfcc.conf
#
#    experiment/
#        nnet2_online/
#            nnet_a_baseline/
#                final.mdl
#
#        triphones_lda_mllt_sat/
#            graph/
#                HCLG.fst
#                words.txt

# OUTPUT:
#    transcriptions/
#        feats.ark
#        feats.scp
#        lattices.ark
#        one-best.tra
#        one-best-hypothesis.txt


. ./path.sh  
# make sure you include the path to the nnet2 bin
# the following two export commands are what my path.sh script contains:
# export PATH=$PWD/utils/:$PWD/../../../src/bin:$PWD/../../../tools/openfst/bin:$PWD/../../../src/fstbin/:$PWD/../../../src/gmmbin/:$PWD/../../../src/featbin/:$PWD/../../../src/lm/:$PWD/../../../src/sgmmbin/:$PWD/../../../src/fgmmbin/:$PWD/../../../src/latbin/:$PWD/../../../src/nnet2bin/:$PWD:$PATH
# export LC_ALL=C


### DNN-HMM DECODING ###


# AUDIO --> FEATURE VECTORS
compute-mfcc-feats \
    --config=config/mfcc.conf \
    scp:transcriptions/wav.scp \
    ark,scp:transcriptions/feats.ark,transcriptions/feats.scp;

# # FEATURE VECTORS --> NORMALIZED FEATURE VECTORS 
# # This is optional, and only really makes sense if you have a lot of 
# # recordings with repeat speakers
# compute-cmvn-stats \
#     --spk2utt=ark:transcriptions/spk2utt \
#     scp:transcriptions/feats.scp \
#     ark,scp:transcriptions/cmvn.ark,transcriptions/cmvn.scp;

# apply-cmvn \
#     --norm-means=false \
#     --norm-vars=false \
#     --utt2spk=ark:transcriptions/utt2spk \
#     scp:transcriptions/cmvn.scp \
#     scp:transcriptions/feats.scp \
#     ark,scp:transcriptions/new-feats.ark,transcriptions/new-feats.scp;

# TRAINED DNN-HMM + FEATURE VECTORS --> LATTICE
nnet-latgen-faster \
    --word-symbol-table=experiment/triphones_lda_mllt_sat/graph/words.txt \
    experiment/nnet2_online/nnet_a_baseline/final.mdl \
    experiment/triphones_lda_mllt_sat/graph/HCLG.fst \
    ark:transcriptions/feats.ark \
    ark,t:transcriptions/lattices.ark;

# LATTICE --> BEST PATH THROUGH LATTICE
lattice-best-path \
    --word-symbol-table=experiment/triphones_lda_mllt_sat/graph/words.txt \
    ark:transcriptions/lattices.ark \
    ark,t:transcriptions/one-best.tra;

# BEST PATH INTERGERS --> BEST PATH WORDS
utils/int2sym.pl -f 2- \
    experiment/triphones_lda_mllt_sat/graph/words.txt \
    transcriptions/one-best.tra \
    > transcriptions/one-best-hypothesis.txt;

