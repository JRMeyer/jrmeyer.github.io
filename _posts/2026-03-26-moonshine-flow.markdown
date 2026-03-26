---
layout: post
title: "Replacing Apple Dictation with Moonshine Flow (FOSS + local)"
date: 2026-03-26
categories: ASR
comments: True
---

<br/><br/>

## TLDR;

I made a drop-in replacement for Apple's voice dictation. it's 100% open source, runs locally, and afaict it's higher quality. It probably consumes more memory / power though.

Source Code: https://github.com/JRMeyer/MoonshineFlow

## Background

I use Apple's built-in voice dictation a lot. In particular, when I picked up Claude Code in the summer of 2025, I started talking into the terminal more than typing. But it's not just Claude Code. I use dictation for WhatsApp messages, Google searches, emails, basically anywhere I need to input text. Apple Dictation is great because it just works in every text field on MacOS, and it's easy to set up. It's "set it and forget it".

The downside is that the quality isn't SOTA. Especially when I'm talking about code. e.g. Apple Dictation often writes "get hub" instead of "GitHub". But the convenience outweighs the annoyance, and I hand't seen a drop in replacement.

I tried [Wispr Flow][whisperflow] when there was a lot of hype around it. The quality improvement wasn't worth the overhead to me. Plus, I prefer to keep my audio on my machine.

I've had my eye on [Moonshine][moonshine] for a while. Open-source models + inference engine that run on MacOS (and lots of other places). [Pete Warden][pete] (moonshine founder) is one of the OGs of on-device speech recognition. Moonshine released a macOS app called [Moonshine Note Taker][note-taker], so I tried it out and loved it. It's easy to use, and the quality is great.

But Note Taker is designed for transcribing into its own window. I wanted a drop-in replacement for Apple Dictation. I.e. a global hotkey that inserts text wherever I put my cursor.

So I wondered: if Moonshine runs this smoothly on Apple Silicon, maybe with a little help from my friend Claude Code I can hack something together.

That's exactly what [Moonshine Flow][repo] is :)

<br/>

Here it is in action:

<center>
  <video controls preload="metadata" playsinline style="max-width: 100%; height: auto;">
    <source src="/misc/moonshine-flow.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</center>

<br/>

## What It Does

Moonshine Flow is a menu-bar app. Double-tap the right Option key to start dictation, speak, and tap once to stop. Text streams into whatever app has focus.

The streaming is a little different for terminals (phrase-by-phrase, not word-by-word) because they don't support the accessiblty API as well (I haven't spent a ton of time on this... PRs welcome!).

Everything runs locally. No audio leaves your machine.

<br/>

## Getting It Running

The app uses Moonshine's [open-source engine][moonshine-github] via their [Swift package][moonshine-swift]. The only manual step is downloading the model files (~290MB). Full setup is in the [repo's SETUP.md][setup], but the gist is:

{% highlight bash %}
git clone git@github.com:JRMeyer/MoonshineFlow.git
cd MoonshineFlow

# Download model files (~290MB)
MODEL_DIR=MoonshineFlow/models/medium-streaming-en
for f in adapter.ort cross_kv.ort decoder_kv.ort encoder.ort \
         frontend.ort streaming_config.json tokenizer.bin; do
  curl -L "https://download.moonshine.ai/model/medium-streaming-en/quantized/$f" \
    -o "$MODEL_DIR/$f"
done

swift build && swift run
{% endhighlight %}

You'll need Xcode installed (not just Command Line Tools) on an Apple Silicon Mac running macOS 15+. On first run, grant Microphone, Accessibility, and Input Monitoring permissions.

<br/>

## Enjoy!

PRs welcome :)


[claude-code]: https://docs.anthropic.com/en/docs/claude-code
[whisperflow]: https://wisprflow.ai/data-controls#:~:text=Transcription%20always%20occurs%20on%20the%20cloud.%20This%20is%20the%20best%20way%20for%20us%20to%20provide%20accurate%2C%20low%20latency%20transcription.
[moonshine]: https://www.moonshine.ai/
[moonshine-github]: https://github.com/moonshine-ai/moonshine
[moonshine-swift]: https://github.com/moonshine-ai/moonshine-swift
[pete]: https://petewarden.com
[note-taker]: https://note-taker.moonshine.ai/
[repo]: https://github.com/JRMeyer/MoonshineFlow
[setup]: https://github.com/JRMeyer/MoonshineFlow/blob/main/SETUP.md
