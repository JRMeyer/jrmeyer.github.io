---
layout: post
title: "Watercolor Shaders for Ghostty"
date: 2026-02-21
categories: misc
comments: True
---

<br><br>

I made a set of GLSL background shaders for [Ghostty](https://ghostty.org) that simulate different watercolor wash techniques. Each one is named after a real painting method — flat wash, wet-on-wet, variegated wash, glazing, granulating, and a few others.

They use Ghostty's `custom-shader` feature to paint a watercolor texture behind your terminal content. You pick a hue, set your background opacity, and you're done.

<center><img src="/misc/figs/wet-on-wet.png" style="width: 600px;"/></center>
<center><em>Wet-on-Wet</em></center>

<br>

<center><img src="/misc/figs/flat-wash.png" style="width: 600px;"/></center>
<center><em>Flat Wash</em></center>

<br>

<center><img src="/misc/figs/variegated-wash.png" style="width: 600px;"/></center>
<center><em>Variegated Wash</em></center>

<br>

There's also a small shell script that randomizes both the shader and the color each time you open a new terminal window. Source it in your `.zshrc` and every window gets a different wash.

The repo is at [github.com/JRMeyer/ghostty-watercolors](https://github.com/JRMeyer/ghostty-watercolors).
