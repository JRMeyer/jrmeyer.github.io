---
layout: post
title: "What happened to Coqui?"
date: 2026-07-30
categories: misc
comments: True
---

<br/><br/>

<em>I wrote this in January 2024, a few weeks after we shut down Coqui, prompted by some questions from TechCrunch. Posting it now unedited.</em>

---

<br/>

When we shut down Coqui, there was an overwhelming wave of support. To be honest, I didn't expect it. It meant a lot to me and to the team. Thank you to everyone who offered kind words.

But there wasn't just support - there was also shock. A lot of people asking, "what happened?"

Coqui was the most successful generative voice AI startup in open-source. How could we fail? It seems as if there's endless hype and VC money for open-source generative AI. Why not Coqui?

I want to share my thoughts on what happened. These are my personal views. There are other, completely valid viewpoints from my team, our investors, our customers, and the open-source community.

For those who don't know Coqui, we trained and released foundation models for text-to-speech and voice cloning. You can still use our models on Hugging Face or Github. Our most popular model was XTTS, and it is the highest quality voice generation model in open-source today. We were a small team of mostly researchers and engineers. On top of open-source we built a creator-facing webapp and a developer-facing API.

The straightforward, boring reason why we shut down is: we never hit product-market fit, compute and talent were expensive, and the current funding atmosphere is tough.

Compared to other generative AI start-ups I'd say we were pretty scrappy on costs, and we did hit something like "open-source-market fit". Nevertheless, millions of downloads didn't translate to millions in revenue. Creating the most popular open-source voice AI wasn't enough to close a new funding round.

Outside of the obvious reasons, my views about why Coqui failed are closely tied to my views on generative AI and open-source. The following is my thoughts

<br/>

## Coqui is the canary in the coal-mine

All startups are hard, but the hype and pace of innovation in generative AI makes it different.

The typical startup:

<center><img src="/misc/figs/coqui-typical-startup.jpg" style="width: 600px;"/></center>

<br/>

The generative AI startup:

<center><img src="/misc/figs/coqui-genai-startup.png" style="width: 600px;"/></center>

<br/>

You're laying the track as you go, but there's a jetpack on your back and crowds screaming on the sidelines. There's a ton of noise and hype, and you're moving crazy fast.

### Research / Product relay race:

The pace of progress in generative AI is staggering. I've been in machine learning for over a decade, but the last 18 months left my head spinning. Keeping your product in sync with the state-of-the-art is an uphill battle.

You take a SOTA model, polish it for production, and by the time it's in production the next best model just came out. Even when it's your own team making those model breakthroughs, it's hard to sync with your product. Your research and product teams are running a relay race, and there's a new baton as soon as the old one is handed off.

### Training models vs. Productizing them

Training the state-of-the-art is very different from productizing it. It's hard to do both well. If you train a model, it's tempting to just throw it behind an API and monetize as SaaS. I think this is a bad idea for a startup. Firstly, anyone can do this with open-source models, including FAANG. Second, it's hard to build good APIs that are low-latency and scale efficiently. Thirdly, even if you do manage to stand out from the crowd with your API and model, there’s non-trivial work with each new model release. You're always competing on price, latency, and quality. If you think you can spend 99% of your time training a model and 1% packaging it behind an API, you're in for some bad news.

### Foundational challenge: training vs fine-tuning

To be honest, I don't think it makes sense for a small startup to train foundation models. Fine-tuning makes a ton of sense, yes, but training something new from scratch, no. It takes too much time and too many resources. If you're one of the lucky startups to raise a pre-seed of 100M+, then you're an exception;) For the rest of us mere mortals, I'd say leave the foundation models to those who can afford to burn the cash and time.

Regardless, it's extremely valuable to invest in your dataset. You can fine-tune new base models as they're released. Models change, data is forever.

<center><img src="/misc/figs/coqui-data-never-dies.png" style="width: 600px;"/></center>

<br/>

Apart from it being costly, do you really need to train a foundation model for your product? Why not just use something open-source? If the model you need isn't open-sourced yet, then maybe wait for it. It will work its way into the open sooner or later.

### The model is not king. Your product is.

Often, generative AI startups love training models. It's exciting! You're at the cutting-edge, pushing open science and technology forward. Product can often be an afterthought. It's tempting to think that as long as your model is technically the best, customers will come. That's not true, unfortunately. At least, it's not true for the kinds of customers who stick around after the hype.

To the original question, I think the toughest challenge in running a generative AI startup is keeping product in sync with the state-of-the-art. You can't afford to fall behind on SOTA, but you can't afford to fall behind on product. Models need to get polished for your customers; you can't just plug in an off-the-shelf model. In early 2022, Coqui probably had the highest quality generative voice model in production. While we were productizing our model, other startups shipped newer model architectures (core algorithms). We fell behind on the state-of-the-art.

### Attracting top talent:

Building the right team is crucial. We put a great team together at Coqui in large part because we aligned on the open-source mission. Researchers want their work to make an impact, and it's hard to have more impact than releasing model weights under an open-source or open-access license. Our core research engineers were active in the community before they ever joined us, which was a real leg up for Coqui. However, recruitment in generative AI is hard.

There's a tiny number of people in the world who can train these models. Each is the belle of the ball. When FAANG and top startups are throwing around astronomical salaries, you need to stand out. For us, it was a philosophical alignment around open-source.

### Competition:

For any startup in generative AI, you compete with FAANG, creative professionals, and other startups. FAANG has lowest cost and lowest quality (for now). For example, Google TTS is fast and cheap, but lacks expressiveness. Creative professionals have the highest quality and highest cost. For voice AI, these are the voice actors. Other startups is where you have to work harder to differentiate on quality / cost / features.

### Race to the bottom:

As the state-of-the-art spreads to open-source, it's a race to the bottom on pricing -- a race that startups will lose. It's already happening (all the big cloud providers integrated Mistral 7B less than a month after the release). I don't think that hosting a model behind an API isn’t a defensible business model for startups in 2024. I'm not talking about APIs that are fully-fledged products, which happen to integrate foundation models (e.g. Gladia.io for voice). I'm talking about a simple API for calling a single foundation model (e.g. OpenAI's TTS)

The delta in quality between closed-source and open-source is closing. When quality stops being a differentiator, cost and distribution win. TLDR; generative models are commoditizing.

### Verticalization

If you can't win on pricing or quality, where do you win? Features comes to mind, but features are really just the first step to verticalization. Verticalization and the application layer is where I think there's still lots of interesting work to be done for early-stage AI startups. There's a delta between what a foundation model does and what a given industry needs. Startups are already attacking these deltas, because they make attractive beachheads.

### Market appetite:

Some markets aren’t ready to use generative AI. You need to gauge a market's readiness as quickly as possible before investing time into it. Markets can be blocked by concerns around quality, legality, and controllability.

At the enterprise, legal teams wade through the gray areas of IP very, very slowly. This is necessary for the enterprise, but it's impossible for the early-stage startup. You don’t want to be the startup helping the enterprise define their company policy. I personally spent too much time on exciting enterprise deals after legal teams turned on the slo-mo. This was probably my biggest GTM failure at Coqui. Make sure you're going after customers who are comfortable <em>today</em> with the legal landscape.

Text-generation and image-generation startups are helping to set legal precedent, but we're not out of the woods yet. If you're a Fortune 500 company, you're a big target. You don't want to get sued for copyright infringement. It's cheaper to just pay human creatives instead. We've seen providers offering blanket legal support (OpenAI) or guarantees on clean training data (Adobe Firefly), but these are not the same as legal precedent. Even if you have an advocate inside the company who is pushing for your deal, legal can come along and jam a stick in your spokes.

Apart from IP, quality is still a major concern. There's chatter about AI taking over Hollywood, but I don't see it happening soon. The top creators won't settle for less than perfect. They'd rather spend millions to get it right than save money on sub-par media. Temporary assets and concept art will use more AI, sure, but AI won't be replacing cameras, actors, or filmmakers any time soon. Not in Hollywood, at least. Voice-skins and face-swapping are already there, but so are greenscreens and the Unreal Engine. Generative quality will keep improving, so I do expect to see more AI in top media, but the current quality is a blocker.

Controllability is the last big blocker. Lack of controllability is a major time-sink. If a human can do it faster, why use AI? If I need to display the number "20", I could roll a 20-sided die until I hit it, or I might pick up a pen and paper and draw it. We're still rolling dice with generative models. All model interfaces have some kind of “regenerate” button for this exact purpose. There's a limit to how long you’ll roll the dice before you pick up the pen. For customers who need creative control, this will be a hard blocker.

Startups don't have the privilege to spend time on the wrong customers or the wrong market. It's good to know the common blockers, and gauge how customers feel about them.

<br/>

## What would I do differently at Coqui? My 2 cents for anyone getting into generative startups?

### Different beachhead market

Knowing what I know now, I would have laid out a completely different go-to-market strategy. I spent too much time going after gaming studios (especially the AAA studios), but it wasn't the right beachhead. They had too many legal concerns around IP. Multiply that by the SAG-AFTRA and WGA strikes, and you've got a perfect recipe for long discussions and unsigned contracts. I think product-led-growth with an eye on SMEs would have given us a better shot at success.

### Stick to our guns, train models, PLG

I wouldn't advise anyone to do this now, but if I could go back to 2021 Coqui, I'd focus on what we were really good at: training models and open-source. I would have started releasing models under a non-commercial license while monetizing commercial licenses in parallel.

At that time, there was no one openly releasing foundation models for generative voice. We might have had a chance at gaining enough commercial traction to push through a new funding round, and then set sights on what comes next. However, I think there's too many permissively licensed generative voice models today for this to be a promising tactic in 2024.

<em>My general advice for anyone getting into the generative space is that core AI models are commoditizing. Plan accordingly.</em>

The researchers who create the models want to open-source them. It's a part of the academic tradition. Where would machine learning be without arXiv and pytorch? For FAANG, open-source is a great recruiting tool, goodwill PR, and encourages developer adoption of their product (cloud infra, mostly). It’s safe to say we will keep seeing more, better open models.

So, what happens when there is an open-source alternative for every foundation model? What's left to monetize? That's the question AI founders need to answer. Higher-quality but closed-source isn't going to cut it for long. OpenAI, Midjourney, Adobe, and Stability AI are converging on quality. Once they hit feature parity, they've got to pivot (except for Adobe who already has a product). My bet is the AI companies will start to verticalize.

Commoditization is already here. It happened for speech-to-text (whisper), and it's happening for text-generation (mistral) and text-to-image (stable diffusion). When models are free, a bare-bones API will be won by the cloud providers. Google, Microsoft, and Amazon have been providing text-to-speech for ages, and now they provide LLMs and image diffusion models.

So, what's a defensible business model for a generative AI startup? User-interfaces? Vertical integrations? Hardware? Generative AI is just getting started, and I'm excited to see the explosion of companies around it. Time will tell what the solid business models are.

Verticalization at the application layer seems a common path right now, but in many cases there already exist incumbents. Tools for creative humans and teams already exist (iMovie, Photoshop, GarageBand, Google Docs, etc), and the incumbents are moving as fast as they can to integrate AI. Will they get overtaken by a faster-moving startup? Having a product and a distribution channel is a big leg up.

### Does it make sense to have an "AI company"?

AI is becoming just another kind of software. You can use it to create a product, you can monetize services around it, but monetization of model weights is going to be hard in 2024. There was a boom in "database companies" not so long ago. "AI companies" may see a similar fate. Just like databases, AI will be everywhere, and it will be free at the core.

<br/>

## What's next?

Not sure. I'm still sorting out what I think is a defensible business model in generative AI in 2024. Whatever comes next, I want to see the mid and long-term more clearly, even with all the noise in this space.
