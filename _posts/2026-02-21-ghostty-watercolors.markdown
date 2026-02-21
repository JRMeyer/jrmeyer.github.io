---
layout: post
title: "Watercolor Shaders for Ghostty"
date: 2026-02-21
categories: misc
comments: True
---

<br/><br/>

## Introduction

I've been using [Ghostty][ghostty] as my terminal for a while now, and one of my favorite features is the `custom-shader` support. You can write GLSL fragment shaders that Ghostty renders behind your terminal content. So naturally I started wondering what it would look like to have watercolor washes as a background.

I ended up making a whole collection of them, each named after a real watercolor painting technique. The repo is at [github.com/JRMeyer/ghostty-watercolors][repo].

<br/>

## The Shaders

There are nine shaders in the collection. Each one simulates a different wash technique:

- **Flat Wash** -- Uniform color with organic edges.
- **Graded Wash** -- Fades from full color to transparent, top to bottom.
- **Variegated Wash** -- Two colors blending into each other.
- **Wet-on-Wet** -- Soft, bleeding color regions like pigment dropped on wet paper.
- **Glazing** -- Multiple transparent color layers stacked with visible overlap.
- **Granulating** -- Pigment settles into paper texture, creating a speckled, grainy look.
- **Salt** -- Fine speckled texture where salt crystals disrupted the wash.
- **Cauliflower** -- Backruns with fractal edges where wet paint crept into drying areas.
- **Splatter** -- Random droplets scattered across a light wash, like flicking a loaded brush.

Here are a few of them in action:

<br/>

<center><img src="/misc/figs/wet-on-wet.png" style="width: 600px;"/></center>
<center><em>Wet-on-Wet</em></center>

<br/>

<center><img src="/misc/figs/flat-wash.png" style="width: 600px;"/></center>
<center><em>Flat Wash</em></center>

<br/>

<center><img src="/misc/figs/variegated-wash.png" style="width: 600px;"/></center>
<center><em>Variegated Wash</em></center>

<br/>

## Getting Started

Add a shader to your Ghostty config (`~/.config/ghostty/config`):

{% highlight bash %}
custom-shader = /path/to/shader.glsl
background-opacity = 0.85
{% endhighlight %}

I also like adding some extra padding so the wash has room to breathe:

{% highlight bash %}
window-padding-x = 64
window-padding-y = 64
{% endhighlight %}

Each shader uses a `WASH_HUE` placeholder for the color. Replace it with a value between `0.0` and `1.0` to pick a hue:

{% highlight bash %}
sed 's/WASH_HUE/0.6/g' flat-wash-bg.glsl > my-shader.glsl
{% endhighlight %}

<br/>

## Randomizing Per Window

There's also a small script called `randomize-shader.sh` that picks a random shader *and* a random color each time it runs. Source it in your `.zshrc`:

{% highlight bash %}
source /path/to/ghostty-watercolors/randomize-shader.sh
{% endhighlight %}

Then point your Ghostty config to the generated file:

{% highlight bash %}
custom-shader = /path/to/ghostty-watercolors/active-shader.glsl
{% endhighlight %}

Now every new terminal window gets a different wash type and color. Pretty cool, right?

<br/>

## Conclusion

I hope this was helpful! If you end up using these shaders, let me know how it goes. If you have any feedback or questions, don't hesitate to leave a comment below :)

[ghostty]: https://ghostty.org
[repo]: https://github.com/JRMeyer/ghostty-watercolors
