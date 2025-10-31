## site-title
Tiny · One-file static sites

## site-description
The smallest possible generator for single-page static sites powered by cmark.

## site-intro
Tiny slices your markdown into sections and drops them into a template. Nothing more, nothing less.

## story
### Why

Sometimes you just want to ship a handcrafted page without juggling frameworks, build caches, or sprawling dependency graphs.

### How

- Author sections in markdown with `##` headings.
- Reference those sections in the template with placeholders like `{{render:story}}` or `{{plain:site-title}}`.
- Run `./build.sh` and open `index.html`.

### When

Use Tiny when you need a story-driven landing page, a personal bio, or a focused announcement that fits on a single sheet of HTML.

## footnote
Tiny is built with `cmark`, `awk`, and a pinch of shell. Source on [GitHub](https://github.com/nrempel/tiny).

## blog-title
Tiny Updates

## blog-intro
Release notes, scrappy tips, and experiments from the Tiny workbench.

## blog-posts
### Ship Shape

Tiny now supports alternate templates when you run `./build.sh blog-template.html blog.html`, so a blog page is just another render away.

### Trick Shots

Use `{{plain:slug}}` for meta tags, `{{render:slug}}` for inline HTML, and `{{lede:slug}}` when you want the first paragraph to pop.

## blog-footnote
Got feedback or a trick to share? Open an issue on [GitHub](https://github.com/nrempel/tiny/issues).
