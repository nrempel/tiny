## Tiny — One-File Static Site Kit

Tiny is a cheeky static site generator in one shell script. It slices `content.md` into sections, runs them through `cmark`, and drops the output into `template.html`.

### Quick Start

1. **Fork or clone** this repo.
2. **Install cmark** (Tiny’s only dependency):
   ```sh
   brew install cmark
   ```
3. **Edit the copy** in `content.md`. Each section starts with a `##` heading. Tiny lowercases and slugifies that heading, so `## Hero` becomes the `hero` section.
4. **Wire sections into the template** with placeholders in `template.html`:
   - `{{render:slug}}` – render the section as HTML.
   - `{{plain:slug}}` – render and collapse to plain text (handy for titles/meta).
   - `{{lede:slug}}` – render and tag the first paragraph with `class="lede"`.
   - `{{raw:slug}}` – insert the raw markdown.
5. **Run Tiny**:
   ```sh
   ./build.sh [template [output]]
   ```
   With no arguments Tiny overwrites `index.html` using `template.html`. Supply a different template and optional output path when you want another page.
6. **Deploy** `index.html` + `styles.css` (and any assets) wherever you like—GitHub Pages, Cloudflare Pages, Netlify, etc.

### What’s Included

- `build.sh` — the generator (POSIX shell + `awk` + `cmark`).
- `content.md` — sample story-driven content.
- `template.html` — minimal HTML shell showing placeholder usage.
- `blog-template.html` — a blog layout driven by the same content.
- `index.html` & `blog.html` — generated examples that keep the templates honest.
- `styles.css` — tiny starter styling so the demo looks decent.

### Customize & Extend

- Swap in your own `styles.css` or link to hosted fonts.
- Generate additional pages with alternate templates:
  ```sh
  ./build.sh blog-template.html blog.html
  ```
- Duplicate `content.md` / template pairs and wrap Tiny in a loop if you need entirely different copy.
- `CMARK` env var lets you point to a custom `cmark` binary: `CMARK=/path/to/cmark ./build.sh`.
- Preview locally with the Python web server that ships on most systems:
  ```sh
  python3 -m http.server 8000
  ```
  Then open <http://localhost:8000>.

### Blog Example

`blog-template.html` reuses the sections in `content.md` (`blog-title`, `blog-intro`, `blog-posts`, `blog-footnote`) to produce `blog.html`. Update the markdown headings, rerun
```sh
./build.sh
./build.sh blog-template.html blog.html
```
and the home page will link out to the refreshed blog.

### Why Tiny?

When you just want to ship a handcrafted page with zero build chains, Tiny keeps the tooling out of the way. Fork it, customize the copy, and publish—no frameworks or bundlers required.

—

Built by [@nbrempel](https://x.com/nbrempel).
