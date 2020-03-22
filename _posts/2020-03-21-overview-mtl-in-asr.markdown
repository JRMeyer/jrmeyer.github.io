---
layout: post
title:  "An Overview of Multi-Task Learning in Speech Recognition"
date:   2020-03-21
categories: ASR
comments: True
---

<br><br>

## Roadmap

In this overview of Multi-Task Learning in Automatic Speech Recognition (ASR), we're going to cover a lot of ground quickly. First, we're going to define Multi-Task Learning and walk through a very simple example from image recognition[^1]. Then, once we have a base as to what Multi-Task Learning is and what constitutes a task, we will move into a survey of the speech recognition literature[^2].

The literature survey focuses on acoustic modeling in particular. Speech Recognition has a long history, but this overview is limited in scope to the Hybrid (i.e. DNN-HMM) and End-to-End approaches. Both approaches involve training Deep Neural Networks, and we will focus on how Multi-Task Learning has been used to train them. We will divide up the literature along monolingual and multilingual models, and then finally we will touch on Multi-Task Learning in other speech technologies such as Speech Synthesis and Speaker Verification.

"Multi-Task Learning" denotes more than a model which can perform multiple tasks at inference time. Multi-Task Learning can be useful even when there is just *one* target task of interest. Especially with regards to small datasets, a Multi-Task model can beat out a model which was trained to optimize the performance of just one task. Moreover, Multi-Task Learning can be used even when there is one task explicitly labeled in the training data.

[^1]: Yes, there will be pictures of dogs!
[^2]: For a more complete overview of Multi-Task Learning itself: [Ruder (2017)](https://ruder.io/multi-task/)

<br><br>

## An Introduction to Multi-Task Learning

### Definition

Before we can define *Multi-Task Learning*, we first need to define what counts as a *task*. Some researchers may define a task as a set of data and corresponding target labels (i.e. a task is merely $$(X,Y)$$). Other definitions may focus on the statistical function that performs the mapping of data to targets (i.e. a task is the function $$f: X \rightarrow Y$$). In order to be precise, in this overview a task is defined as the combination of data, targets, and mapping function.

<br><br>

A *task* is the combination of:

1. Data: $$X$$, a sample of data from a certain domain
2. Targets: $$Y$$, a sample of targets from a certain domain
3. Mapping Function: $$f: X \rightarrow Y$$, a function which maps data to targets 

<br><br>

 The *targets* can be distinct label categories represented by one-hot vectors (e.g. classification labels), or they can be $$N$$-dimensional continuous vectors (e.g. a target for regression)[^3].

[^3]: In reality these two kinds of targets are the same with regards to training neural networks via backpropagation. The targets for classification are just a special case of regression targets, where the values in the vector are $$1.0$$ or $$0.0$$.
  
Given this definition of *task}, in this overview we define Multi-Task Learning as a training procedure which updates model parameters such that the parameters optimize performance on multiple tasks in parallel[^4]. At its core, Multi-Task Learning is an approach to parameter estimation for statistical models[^5]. Even though we use multiple tasks during training, we will produce only one model. A subset of the model's parameters will be task-specific, and another subset will be shared among all tasks. Shared model parameters are updated according to the error signals of all tasks, whereas task-specific parameters are updated according to the error signal of only one task. It is important to note that a Multi-Task model will have both *task-dependent} and *task-independent} parameters. The main intuition as to why the Multi-Task approach works is the following: if tasks are related, they will rely on a common underlying representation of the data. As such, learning related tasks together will bias the shared parameters to encode robust, task-independent representations of the data. 

[^4]: An exception to this is Multi-Task Adversarial Learning, in which performance on an auxiliary task is encouraged to be as poor as possible. In domain adaptation, an example of this may be forcing a neural net to be blind to the difference between domains. The Adverserial auxiliary task would be classification of **domain-type**, and the weights would be updated in a way to increase error as much as possible.

[^5]: caruana1998multitask, caruana1996algorithms

Given this definition of \textit{task} and this definition of \textit{Multi-Task Learning}, we can start to think about the different ways in which a Multi-Task model can be trained. Probably the most common Multi-Task use-case is the classification of a single dataset $$(X)$$ as multiple sets of target labels $$(Y_{1}, Y_{2} \dots Y_{N})$$. This model will perform mappings from $$(X)$$ into each of the label spaces separately. Another approach is the classification of multiple datasets sampled from various domains $$(X_{1}, X_{2} \dots X_{N})$$ as their own, dataset-specific targets $$(Y_{1}, Y_{2} \dots Y_{N})$$. Less commonly, it is possible to classify multiple datasets using one super-set of labels. These different approaches are represented with regards to vanilla feed-forward neural networks in the following Figure (1).

<br><br>
<img src="/misc/figs/color-si-mo.png" align="left" style="width: 225px;"/>
<img src="/misc/figs/color-mi-so.png" align="center" style="width: 225px;"/>
<img src="/misc/figs/color-mi-mo.png" align="right" style="width: 200px;"/>
<center><strong>Figure 1</strong>: Possible Neural Multi-Task Architectures. Black layers are task-independent layers, blue layers are task-dependent input layers, and red layers are task-dependent output layers. These figures are modified versions of a figure from heigold2013.</center>
<br><br>



 With regards to neural approaches (c.f. Figure (1), Multi-Task models are comprised of three component parts: (1) &#x2B1B; **shared hidden layers** which serve as a task-independent feature extractor; (2) &#x1F7E5; **task-specific output layers** which serve as task-dependent classifiers or regressors; (3) &#x1F7E6; **task-specific input layers** which serve as feature transformations from domain-specific to domain-general representations. Neural Multi-Task models will always have some hidden layers shared among tasks. This view of a Multi-Task neural network highlights the intuition behind the shared hidden layers - to encode robust representations of the input data.

With regards to domains in which we have very limited data (i.e. low-resource environments), Multi-Task parameter estimation promises gains in performance which do not require us to collect more in-domain data, as long as we can create new tasks. In the common scenario where an engineer has access to only a small dataset, the best way she could improve performance would be by collecting more data. However, data collection takes time and money. This is the promise of Multi-Task Learning in low-resource domains: if the engineer can create new tasks, then she does not need to collect more data.

<br><br>


## An Example

This section gives an example of a Multi-Task image recognition framework, where we start with a single task, create a second task, and train a model to perform both tasks. Starting with a single task, suppose we have the access to the following:

1. Data: $$X_1$$, a collection of photographs of dogs from one camera
2. Targets: $$Y_1$$, a finite set of **dog_breed** labels (e.g. terrier, collie, rottweiler)
3. Mapping Function: $$f_1: X_1 \rightarrow Y_1$$, a vanilla feedforward neural network which returns a set of probabilities over labels of **dog_breed** to a given photograph


In order to create a new task, we either need to collect some data ($$X_2$$) from a new domain, create new targets ($$Y_2$$), or define a new mapping function ($$f_2: X_1 \rightarrow Y_1$$). Furthermore, we would like to create a *related task*, with the hopes of improving performance on the original task. There's several ways we can go about making a new task. We could use the same set of labels (**dog_breed**), but a collect new set of pictures from a different camera. We could try classifying each photograph according to the size of the dog, which would mean we created new labels for our existing data. In addition to our vanilla feed-forward network, we could use a convolutional neural network as a mapping function and share some of the hidden layers between the two networks. 

Assuming we don't want to collect more data and we don't want to add a new mapping function, the easiest way to create a new task is to create a new set of target labels. Since we only had a single set of labels available (i.e. &#x2B1B; **dog_breed**), we can manually add a new label to each photo (i.e. &#x1F7E5; **dog_size**) by referencing an encyclopedia of dogs[^6]. So, we started with a single dataset of photos of dogs (&#x2B1B; $$X_1$$) and a single set of classification labels (&#x1F7E5; $$Y_1$$) for the dog's breed, and now we've added a new set of labels ($$Y_2$$) for a classification task of the dog's size. A few training examples from our training set (&#x2B1B; $$X_1$$, &#x2B1B; $$Y_1$$, &#x1F7E5; $$Y_2$$) may look like what we find in Figure (2).
  
[^6]: This is an example of using domain or expert knowledge to create a new task, where the expert knowledge is contained in the encyclopedia. One could also hire a dog expert to label the images manually. Either way, we are exploiting some source of domain-specific knowledge (i.e. knowledge of the physiology of different dog breeds).

<br><br>
<img src="/misc/figs/rotweiler.jpg" align="left" style="width: 225px;"/>
<img src="/misc/figs/collie.jpg" align="center" style="width: 225px;"/>
<img src="/misc/figs/terrier.jpg" align="right" style="width: 225px;"/>
<center><strong>Figure 2</strong>: Three pictures of dogs from our dataset (&#x2B1B; <strong>X_1</strong>), where each picture has been labeled with separate targets: &#x2B1B; <strong>dog_breed</strong>, &#x1F7E5; <strong>dog_size</strong></center>
<br><br>


  Given this data and our two sets of labels, we can train a Multi-Task neural network to perform classification of both label sets with the vanilla feed-forward architecture shown in Figure (3). This model now has two task-specific output layers and two task-specific penultimate layers. The input layer and following three hidden layers are shared between both tasks. The shared parameters will be updated via the combined error signal of both tasks.

<br><br>
<img src="/misc/figs/dog-model.png" align="center" style="width: 400px;"/>
<center><strong>Figure 3</strong>:<Multi-Task DNN for classifying pictures of dogs according to both &#x2B1B; <strong>dog_breed</strong> and &#x1F7E5; <strong>dog_size</strong>. Any additional task by definition brings along with it additional parameters, because a subset of model parameters must be task-specific. Task-specific parameters for the new task of &#x1F7E5; <strong>dog_size</strong> classification are shown in red.</center>
<br><br>


This example came from image recognition, but now we will move onto to our overview of Multi-Task Learning in Automatic Speech Recognition. As we will see in what follows, researchers have trained Multi-Task Acoustic Models where the auxiliary tasks involve a new data domain, a new label set, or even a new mapping function.

## Multi-Task Learning in ASR

The Multi-Task Learning discussed here deals with either acoustic modeling in Hybrid (i.e. DNN-HMM) ASR, or it deals with End-to-End ASR[^7]. The Acoustic Model accepts as input a window of audio features ($$X$$) and returns a posterior probability distribution over phonetic targets ($$Y$$). The phonetic targets can be fine-grained context-dependent units (e.g. triphones from a Hybrid model), or these targets may be simply characters (e.g. as in End-to-End approaches). The following survey will focus on how Multi-Task Learning has been used to train these acoustic models, with a focus on the nature of the tasks themselves.

[^7]: In the traditional, Hybrid ASR approach (i.e. DNN Acoustic Model + N-gram language model), there's not a lot of room to use MTL when training the language model or the decoder.

Past work in Multi-Task acoustic modeling for speech recognition can be split into two broad categories, depending on whether data was used from multiple languages or just one language. In this survey, we will refer to these two branches of research as *monolingual* vs. *multilingual* approaches. Within each of those two branches, we find sub-branches of research, depending on how the auxiliary tasks are crafted. These major trends are shown in Figure (4), and will be discussed more in-depth below.

<br><br>
<img src="/misc/figs/overview-MTL.png" align="center" style="width: 700px;"/>
<center><strong>Figure 4</strong>: Major Trends in the Research on Multi-Task Learning in Automatic Speech Recognition. Here, "Recording Characteristics" refers to general characteristics of the audio file (i.e. the "recording"), not the quality of the "recording" setup or "recording" equipment. </center>
<br><br>

Within *monolingual* Multi-Task acoustic modeling we can identify two trends in the literature. We find that researchers will either (1) predict some additional linguistic representation of the input speech, or (2) explicitly model utterance-level characteristics of the utterance. When using additional linguistic tasks for a single language, each task is a phonetically relevant classification: predicting triphones vs. predicting monophones vs. predicting graphemes bell2015, seltzer2013, huang2015, chen2014, chen2015, toshniwal2017multitask. When explicitly modeling utterance-specific characteristics, researchers either use adversarial learning to force the model to "forget" channel, noise, and speaker characteristics, or the extra task is a standard regression in order to pay extra attention to these features shinohara2016adversarial, serdyuk2016invariant, tripathi2018adversarial, saon2017english, meng2018speaker, sun2018domain, parveen2003multitask, giri2015improving, chen2015speech, zhang2017attention.


Within *multilingual* Multi-Task acoustic modeling we can also identify two main veins of research: (1) using data from some source language(s) or (2) using a pre-trained model from some source language(s). When using data from source languages, most commonly we find researchers training a single neural network with multiple output layers, where each output layer represents phonetic targets from a different language huang2013, heigold2013, tuske2014multilingual, mohan2015multi, grezl2016, matassoni2018non,yang2018joint, rao2017multi, jain2018improved, sun2018domain. As such, these Acoustic Models look like the prototype shown in Figure (1). When using a pre-trained model from some source language(s) we find researchers using the source model as either a teacher or as a feature extractor for the target language dupont2005feature, cui2015multilingual, grezl2014adaptation, knill2013investigation, vu2014multilingual, xu2015comparative, he2018improved. The source model extracts embeddings of the target speech, and then the embedding is either used as the target for an auxiliary task or the embedding is concatenated to the standard input as a kind of feature enhancement.

### Monolingual Multi-Task ASR

With regards to monolingual Multi-Task Learning in ASR, we find two major tracks of research. The first approach is to find tasks (from the same language) which are linguistically relevant to the main task stadermann2005multi, seltzer2013,huang2015, bell2015, arora2017phonological, chen2014, chen2015, chen2015diss, bell2015complementary, swietojanski2015structured, badino2016phonetic, pironkov2016multi. These studies define abstract phonetic categories (e.g. fricatives, liquids, voiced consonants), and use those category labels as auxiliary tasks for frame-level classification.

The second major track of research in monolingual Multi-Task acoustic modeling involves explicit modeling of speaker, channel, or noise characteristics shinohara2016adversarial, serdyuk2016invariant, tripathi2018adversarial, saon2017english, meng2018speaker, sun2018domain, parveen2003multitask, giri2015improving, chen2015speech, zhang2017attention. These studies train the Acoustic Model to identify these characteristics via an additional classification task, or they encourage the model to ignore this information via adversarial learning, or they force the model to map data from the input domain to another domain (e.g. from noisy audio $$\rightarrow$$ clean audio). 

All the studies in this section have in common the following: the model in question learns an additional classification of the audio at the frame-level. That is, every chunk of audio sent to the model will be mapped onto a standard ASR category such as a triphone or a character *in addition to* an auxiliary mapping which has some linguistic relevance. This linguistic mapping will typically be a broad phonetic class (think vowel vs. consonant) of which the typical target (think triphone) is a member.

Good examples of defining additional auxiliary tasks via broad, abstract phonetic categories for English can be found in seltzer2013 and later huang2015. With regards to low-resource languages, some researchers have created extra tasks using graphemes or a universal phoneset as more abstract classes chen2014, chen2015, chen2015diss.

A less linguistic approach, but based on the exact same principle of using more abstract classes as auxiliary targets, bell2015 used monophone alignments as auxiliary targets for DNN-HMM acoustic modeling (in addition to the standard triphone alignments). The authors observed that standard training on context-dependent triphones could easily lead to over-fitting on the training data. When monophones were added as an extra task, they observed $$3-10\%$$ relative improvements over baseline systems. The intuition behind this approach is that two triphones belonging to the same phoneme will be treated as completely unrelated classes in standard training by backpropagation. As such, valuable, exploitable information is lost. In follow up studies, bell2015complementary, swietojanski2015structured, badino2016phonetic made the linguistic similarities among DNN output targets explicit via linguistic phonetic concepts such as place, manner, and voicing as well as phonetic context embeddings.

However, the benefits of using linguistic targets vary from study to study, and in their survey paper, pironkov2016multi concluded that "Using even broader phonetic classes (such as plosive, fricative, nasal, $$\ldots$$) is not efficient for MTL speech recognition". In particular, they were referring to the null findings from stadermann2005multi. 

In a similar vein, Multi-Task Learning has been used in an End-to-End framework, in an effort to encourage explicit learning of hierarchical structure of words and phonemes. Oftentimes these hierarchical phonemic levels (e.g. phonemes vs. words) are trained at different levels of the model itself fernandez2007sequence, sanabria2018hierarchical, krishna2018hierarchical, toshniwal2017multitask, moriya2018multi. Figure (5) displays the approach taken in sanabria2018hierarchical.


<br><br>
<img src="/misc/figs/sanabria-2018.png" align="center" style="width: 225px;"/>
<center><strong>Figure 5</strong>: Multi-Task Hierarchical Architecture from Sanabria and Metze (2018) </center>
<br><br>

All of these studies have in common the following: they encourage the model to learn abstract linguistic knowledge which is not explicitly available in the standard targets. Whatever the standard target may be (e.g. triphones, graphemes, etc.) the researchers in this section created abstract groupings of those labels, and used those new groupings as an additional task. These new groupings (e.g. monophones, sub-word units, etc) encourage the model to learn the set of underlying features (e.g. voicing, place of articulation, etc.) which distinguish the main targets.

### Regression on Better Features as a new Task

Class labels are the most common output targets for an auxiliary task, but parveen2003multitask, giri2015improving, chen2015speech, zhang2017attention took an approach where they predicted de-noised versions of the input audio from noisy observations (c.f. Figure (6). The effect of this regression was that the Acoustic Model cleaned and classified each input audio frame in real time.

<br><br>
<img src="/misc/figs/giri-2015.png" align="center" style="width: 225px;"/>
<center><strong>Figure 6</strong>: Regression and Classification Neural Network Architecture from Giri et al. (2015)</center>
<br><br>


In a similar vein, das2017deep trained an Acoustic Model to classify standard senomes targets as well as regress an input audio frame to bottleneck features of that same frame. Bottleneck features are a compressed representation of the data which have been trained on some other dataset or task --- as such bottleneck features should contain linguistic information. In a very early study, the authors in lu2004multitask predicted enhanced audio frame features as an auxiliary task (along with the speaker's gender).



