# evanyarnall.com

Source for the academic website of **Evan Yarnall**, a PhD candidate in Rehabilitation Science at Boston
University. He works in the [Development, Experience, & Motor Recovery (DEMR) Lab](https://sites.bu.edu/demrlab/),
studying how infants and children with and at risk for cerebral palsy learn to coordinate the brain and body.

**Visit the site: [evanyarnall.com](https://evanyarnall.com)**

## What's on the site

- **Research:** three projects, each with an interactive figure you can try in the browser: watch the brain
  respond to a hand squeeze (fNIRS), step through a reaching trial on a moving-target board, and code infant
  movement from video the way a trained coder does.
- **Publications:** journal articles and conference presentations, generated from a BibTeX file, each with a
  plain-language summary, and searchable by year, type and first author.
- **CV:** a web page and a downloadable PDF, both built from the same data file.

## How it's built

- [Jekyll](https://jekyllrb.com) with the [al-folio](https://github.com/alshedivat/al-folio) academic theme,
  plus a custom "lab notebook" design: graph-paper backgrounds, numbered figures, and IBM Plex type.
- Publications come from `_bibliography/papers.bib` via
  [jekyll-scholar](https://github.com/inukshuk/jekyll-scholar).
- The interactive figures are custom SVG and JavaScript, with no plotting libraries. They respect
  reduced-motion settings and work on phones.
- Every page carries [schema.org](https://schema.org) structured data, and [`/llms.txt`](https://evanyarnall.com/llms.txt)
  gives AI tools a plain-text summary of the site.

Every push to `main` runs GitHub Actions. They build the site, print the CV to PDF, render the link-preview
image with headless Chrome, and publish to GitHub Pages. A separate workflow checks every link after each
change and again each week.

## Run it locally

```bash
bundle install
LANG=en_US.UTF-8 bundle exec jekyll serve --livereload
```

Then open http://localhost:4000. To update content, see [docs/UPDATING.md](docs/UPDATING.md).

## Reuse

© Evan Yarnall. All rights reserved. This covers the site's content (text, photos, CV, posters and research
figures) and the code written for it, including the interactive figures, the lab-notebook design and the
build scripts. Please [get in touch](https://evanyarnall.com) for permission before reusing any of it.

The site is built on the open-source [al-folio](https://github.com/alshedivat/al-folio) theme, whose code
remains available under its own MIT License (see [LICENSE](LICENSE)). The motor pathways diagram on the
reaching page is © DEMR Lab, Boston University, and appears courtesy of the lab.

## Contact

See the contact links at [evanyarnall.com](https://evanyarnall.com).
