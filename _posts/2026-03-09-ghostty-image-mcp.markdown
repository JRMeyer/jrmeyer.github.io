---
layout: post
title: "Displaying Images in Claude Code"
date: 2026-03-09
categories: misc
comments: True
---

<br/><br/>

<center>
<img src="/misc/figs/ghostty-image-mcp-1.png" style="width: 32%; display: inline-block; vertical-align: top;"/>
<img src="/misc/figs/ghostty-image-mcp-2.png" style="width: 32%; display: inline-block; vertical-align: top;"/>
<img src="/misc/figs/ghostty-image-mcp-3.png" style="width: 32%; display: inline-block; vertical-align: top;"/>
</center>

<br/>

## Introduction

In my [last post][watercolors] I mentioned that Ghostty can display images inline in the terminal. I wanted to do this with [Claude Code][claude-code], but it won't work out of the box.

The problem is Claude Code doesn't have a built-in way to send images to the terminal. So I built an [MCP server][repo] that does it.

<br/>

## Why MCP?

An MCP (Model Context Protocol) server is the right tool here because Claude Code needs to write raw bytes directly to the terminal, NOT text. The key is in the [Kitty graphics protocol][kitty-graphics] escape sequences. None of Claude Code's built-in tools can do this. The Bash tool captures stdout as text.

An MCP server runs as a separate process, so it's not limited to CC's tool limitations. The MCP captures the controlling TTY at startup, then writes escape sequences directly to the terminal using `os.write()` on the raw file descriptor. Claude Code never even sees the image data.

<br/>

## How It Works

The whole server is a single Python file.

1. at startup, grab the TTY path via `/dev/tty` before stdio takes over
2. convert the file to PNG (via `sips` on macOS, or `rsvg-convert` for SVGs, or CoreGraphics for PDFs)
3. Base64-encode the PNG file path
4. Write a single Kitty graphics escape sequence to the TTY: `\x1b_Ga=T,f=100,t=f,c={cols},q=2;{path}\x1b\\`
5. The terminal reads the file and renders it inline

<br/>

## Setup

Clone the repo and add it to Claude Code:

{% highlight bash %}
git clone https://github.com/jrmeyer/ghostty-image-mcp.git
claude mcp add ghostty-image -- uv run /path/to/ghostty-image-mcp/server.py
{% endhighlight %}

You need [uv][uv], Python 3.10+, and a Kitty graphics-compatible terminal ([Ghostty][ghostty], [Kitty][kitty], etc.).

Then just ask Claude to show you things:

{% highlight text %}
show me ~/photos/cat.jpg
show me this PDF page 5: ~/papers/attention.pdf
make it 2x bigger
rotate it
{% endhighlight %}

It handles PNG, JPEG, HEIC, SVG, PDF, and anything else `sips` can convert :)

<br/>

## The Repo

Everything is at [github.com/JRMeyer/ghostty-image-mcp][repo]. It's one file, about 160 lines. Let me know if you have comments or run into issues.


[watercolors]: /misc/2026/02/21/ghostty-watercolors.html
[claude-code]: https://docs.anthropic.com/en/docs/claude-code
[repo]: https://github.com/JRMeyer/ghostty-image-mcp
[kitty-graphics]: https://sw.kovidgoyal.net/kitty/graphics-protocol/
[uv]: https://docs.astral.sh/uv/
[ghostty]: https://ghostty.org
[kitty]: https://sw.kovidgoyal.net/kitty/
