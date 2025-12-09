# CLAUDE.md - AI Assistant Guide for jrmeyer.github.io

## Repository Overview

This is a **Jekyll-based GitHub Pages personal blog** for Josh Meyer, a speech technology researcher and co-founder of Coqui. The site focuses on technical content about:

- **Automatic Speech Recognition (ASR)**
- **Text-to-Speech (TTS) / Speech Synthesis**
- **Machine Learning**
- **Natural Language Processing**

**Live site**: https://jrmeyer.github.io

## Directory Structure

```
jrmeyer.github.io/
├── _config.yml          # Jekyll configuration
├── _includes/           # Reusable HTML partials
│   ├── head.html        # HTML <head> section with MathJax, CSS
│   ├── header.html      # Site header/navigation
│   ├── footer.html      # Site footer
│   ├── comments.html    # Disqus comment integration
│   ├── share-page.html  # Social sharing buttons
│   ├── analytics.html   # Google Analytics
│   └── icon-*.html/svg  # Social media icons
├── _layouts/            # Page templates
│   ├── default.html     # Base layout (all pages)
│   ├── post.html        # Blog post layout
│   └── page.html        # Static page layout
├── _posts/              # Blog posts (Markdown)
├── _sass/               # SCSS stylesheets
│   ├── _base.scss       # Base typography/elements
│   ├── _layout.scss     # Layout styles
│   └── _syntax-highlighting.scss
├── css/                 # Compiled CSS
│   ├── main.scss        # Main stylesheet (imports _sass)
│   └── asciinema-player.css
├── js/                  # JavaScript
│   └── asciinema-player.js  # Terminal recording player
├── misc/                # Static assets
│   ├── *.pdf            # Papers, CV, presentations
│   ├── *.png/jpg/svg    # Images and diagrams
│   ├── *.wav            # Audio files
│   ├── figs/            # Figures for blog posts
│   └── kaldi-documentation/  # Kaldi docs
├── index.html           # Homepage
├── about.md             # About page
└── feed.xml             # RSS feed
```

## Blog Post Conventions

### File Naming
Posts must follow Jekyll's naming convention:
```
YYYY-MM-DD-Title-With-Dashes.markdown
```

Example: `2020-03-21-overview-mtl-in-asr.markdown`

### Front Matter
Every post requires YAML front matter:
```yaml
---
layout: post
title: "Post Title Here"
date: YYYY-MM-DD
categories: ASR   # Options: ASR, TTS, MachineLearning, misc
comments: True    # Enable Disqus comments (optional)
---
```

### Content Categories
The homepage organizes posts by category:
- **ASR** - Speech recognition tutorials, Kaldi, CMU Sphinx, DeepSpeech
- **TTS** - Speech synthesis, eSpeak, Merlin, Ossian
- **MachineLearning** - TensorFlow, neural networks, MLE tutorials
- **misc** - Other technical content, paper summaries

### Markdown Features

**Code blocks** - Use triple backticks with language:
```bash
echo "Hello World"
```

**Math/LaTeX** - MathJax is enabled via CDN:
- Inline: `$$x^2$$`
- Display: `$$\int_0^1 f(x) dx$$`

**Images** - Reference from `/misc/` directory:
```markdown
<center><img src="/misc/figs/example.png" style="width: 400px;"/></center>
<center><strong>Figure 1</strong>: Caption here</center>
```

**Footnotes** - Use reference-style:
```markdown
Some text[^1].

[^1]: Footnote content here.
```

## Development Workflow

### Local Development
```bash
# Install dependencies
bundle install

# Serve locally with live reload
bundle exec jekyll serve

# Build for production
bundle exec jekyll build
```

### Key Configuration (`_config.yml`)
- **markdown**: kramdown
- **highlighter**: rouge
- **plugins**: jekyll-redirect-from
- **google_analytics**: UA-90329904-1

### Ignored Files (`.gitignore`)
- `_site/` - Generated output
- `.sass-cache/`
- `.jekyll-metadata`
- Temp files (`*~`, `*#`)

## External Integrations

- **Comments**: Disqus (jrmeyer.disqus.com)
- **Analytics**: Google Analytics
- **Math**: MathJax 2.7.7 (CDN)
- **Terminal recordings**: asciinema-player
- **Social embeds**: Facebook SDK, Instagram, YouTube, Spotify

## Common Tasks for AI Assistants

### Adding a New Blog Post
1. Create file in `_posts/` with proper naming convention
2. Add required front matter (layout, title, date, categories)
3. Write content in Markdown
4. Add images to `misc/figs/` if needed

### Updating the About Page
Edit `about.md` - uses `page` layout

### Modifying Styles
1. Edit SCSS files in `_sass/`
2. `_base.scss` for typography
3. `_layout.scss` for page structure

### Adding Static Assets
Place files in `misc/` directory:
- PDFs, papers: root of `misc/`
- Figures for posts: `misc/figs/`
- Documentation: appropriate subdirectory

## Important Notes

- Site is deployed automatically via GitHub Pages when pushing to main branch
- No build step required - GitHub Pages handles Jekyll compilation
- MathJax loads from CDN - ensure formulas use `$$` delimiters
- Comments only appear on posts with `comments: True` in front matter
- The CV is linked from `misc/josh-meyer-cv.pdf`

## Code Style Guidelines

- Use 4 spaces for indentation in HTML/Liquid templates
- Keep lines under 120 characters where practical
- Use semantic HTML5 elements
- Include alt text for images when descriptive

## Testing Changes

Since this is a static Jekyll site:
1. Run `bundle exec jekyll serve` locally
2. Check http://localhost:4000
3. Verify posts appear in correct category sections
4. Test math rendering if LaTeX was modified
5. Check responsive layout on mobile viewport
