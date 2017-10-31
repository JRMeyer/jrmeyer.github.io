#!/bin/sh

# USAGE ./run-demo.sh
#
# INPUT: None, but don't forget to set variables
#        for your HTK account at beginning of script
#
# OUTPUT: ./Ossian/
#
# Joshua Meyer 2017 (U of Arizona)
# This script is based on commands from
# Oliver Watts 2017 (U of Edinburgh)
#


HTK_USERNAME=
HTK_PASSWORD=


echo ### GET DEPENDENCIES ###
# check for HTK info
if [ -z "$HTK_USERNAME" ] || [ -z "$HTK_USERNAME" ]; then
    echo "ERROR: Missing HTK username and password"
    echo "Register for HTK at http://htk.eng.cam.ac.uk/register.shtml"
    exit 1
fi

# install compilation dependencies
sudo apt-get install clang libsndfile1-dev gsl-bin libgsl0-dev libconfig-dev

# install Python dependencies
# for Ossian
sudo pip install numpy scipy regex argparse lxml scikit-learn regex configobj
# for Merlin
sudo pip install bandmat theano matplotlib


echo ### GET OSSIAN ###
# clone
git clone https://github.com/CSTR-Edinburgh/Ossian.git
# install
cd ./Ossian
./scripts/setup_tools.sh $HTK_USERNAME $HTK_PASSWORD


echo ### GET DATA ###
# download 
wget https://www.dropbox.com/s/uaz1ue2dked8fan/romanian_toy_demo_corpus_for_ossian.tar?dl=0
# decompress
tar xvf romanian_toy_demo_corpus_for_ossian.tar\?dl\=0


echo ### TRAIN OSSIAN ###
python ./scripts/train.py -s rss_toy_demo -l rm naive_01_nn


echo ### TRAIN MERLIN DNNs ###
export THEANO_FLAGS=""
OSSIAN=`pwd`
# train duration model
python ./tools/merlin/src/run_merlin.py $OSSIAN/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/duration_predictor/config.cfg
# train acoustic model
python ./tools/merlin/src/run_merlin.py $OSSIAN/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/acoustic_predictor/config.cfg


echo ### FORMAT MERLIN DNNs ###
# store duration model
python ./scripts/util/store_merlin_model.py $OSSIAN/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/duration_predictor/config.cfg $OSSIAN/voices/rm/rss_toy_demo/naive_01_nn/processors/duration_predictor
# store acoustic model
josh@yoga:~/git/Ossian$ python ./scripts/util/store_merlin_model.py $OSSIAN/train/rm/speakers/rss_toy_demo/naive_01_nn/processors/acoustic_predictor/config.cfg $OSSIAN/voices/rm/rss_toy_demo/naive_01_nn/processors/acoustic_predictor


echo ### SYNTHESIZE NEW AUDIO ###
mkdir ./test/wav/
python ./scripts/speak.py -l rm -s rss_toy_demo -o ./test/wav/romanian_test.wav naive_01_nn ./test/txt/romanian.txt


echo ### All Done! New audio located in ./test/wav/romanian_test.wav ###


exit 1
