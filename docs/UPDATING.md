# Updating evanyarnall.com

A guide for Evan: how to change the site, and where everything lives.

## Two ways to make a change

**On GitHub (no setup):** open a file in this repository, click the pencil icon, make the edit, and click
**Commit changes**. The site rebuilds itself and the change is live in a few minutes. The **Actions** tab shows
progress: a green check means it's live, a red X means something went wrong (click it to see what).

**On your computer (to preview first):** install Ruby, then in this folder run `bundle install` once. To preview:

```bash
LANG=en_US.UTF-8 bundle exec jekyll serve --livereload
```

Open http://localhost:4000, make your changes (the page reloads as you save), then commit and push.

Everything else, including the CV PDF and the link-preview image, rebuilds itself when the site updates.

## Add a news item

Create a file in `_news/` named with the date, like `_news/2026-11-03-award.md`:

```markdown
---
layout: post
date: 2026-11-03
inline: true
---

Received the XYZ award for my work on bimanual skills in infancy.
```

The home page shows the four newest items.

## Add a paper or talk

Add an entry at the top of the right section of `_bibliography/papers.bib` (journal articles first, then
conference presentations). Copy an existing entry and change it, or paste BibTeX from Google Scholar or Zotero.
Write your own name as `Yarnall, Evan` so it's highlighted.

```bibtex
@inproceedings{yarnall2027example,
  abbr        = {AACPDM},
  bibtex_show = {true},
  title       = {Title of the Talk},
  author      = {Yarnall, Evan and Su, X. and Ferre, C. L.},
  summary     = {One or two sentences, in plain words, on what you did and found.},
  booktitle   = {American Academy for Cerebral Palsy and Developmental Medicine (AACPDM) 81st Annual Meeting},
  address     = {City, ST},
  year        = {2027},
  month       = {Sep},
  note        = {Free paper R3}
}
```

Optional fields:

| Field                   | What it does                                                              |
| ----------------------- | ------------------------------------------------------------------------- |
| `summary`               | The "in plain words" line under the entry                                 |
| `selected = {true}`     | Also shows the entry under "Selected work" on the home page               |
| `abbr`                  | The colored badge (venues are set up in `_data/venues.yml`)               |
| `note`                  | Session code, or "Under review, Journal Name"                             |
| `status`                | For `@unpublished` manuscripts: `review` or `preparation`                 |
| `abstract`              | Adds an "Abs" button                                                      |
| `poster`                | Adds a "Poster" button. Put the PDF in `assets/pdf/` and write its name   |
| `preview`               | Thumbnail image. Put it in `assets/img/publication_preview/`              |
| `video`                 | Adds a "Video" button (a link)                                            |
| `news`                  | Adds a "Lab news" button (a link to a DEMR Lab post)                      |
| `doi`                   | For published articles; adds a "DOI" button                               |

When a manuscript is published, change `@unpublished` to `@article` and add `journal`, `volume`, `pages` and
`doi`. Project pages list their related papers by key near the bottom of each file in `_projects/`.

Co-authors from the DEMR Lab link to the lab's People page automatically. To link someone else, add them to
`_data/coauthors.yml`.

## Update the CV

The CV page and the PDF are both made from two files:

- `_data/cv.yml`: education, positions, awards, outreach, skills
- `_bibliography/papers.bib`: publications and presentations (nothing to do here, they're picked up automatically)

The PDF rebuilds itself every time the site updates, so the "Download PDF" button always matches the CV
page. It's designed for two pages: if an addition pushes it longer, the run in the **Actions** tab shows a
"CV length" warning.

The copy in `assets/pdf/` is only for previewing on your computer, and a fallback if the automatic rebuild ever
fails. To refresh it locally:

```bash
bash _cv/build.sh
```

## Change a photo

- **Headshot:** replace `assets/img/prof_pic.jpg` with a new photo of the same name (square, 800 by 800 pixels like
  the current one). The link-preview card, the image that shows when someone shares the site on LinkedIn or
  Slack, picks up the new photo automatically. Its title and headline come from the top of `_pages/about.md`.
  LinkedIn keeps old previews for a while; paste the site address into https://www.linkedin.com/post-inspector/
  to refresh it.

- **Project figures:** images live in `assets/img/research/`. Replace a file with the same name, or add a new
  one and change its name in the project's file in `_projects/`.

## Broken links

The **Check links** workflow builds the site and tests every link after each change, and again every Monday
for outside pages that moved or disappeared. If it finds one, GitHub emails you; open the run and the summary
lists each broken link and the page it's on. Some sites block automated checkers even though they work in a
browser. If one keeps failing, add it to `.lycheeignore`.

GitHub turns off the Monday check if the repository has no activity for 60 days, and emails a warning first.
To turn it back on, open the **Actions** tab, choose **Check links**, and click **Enable workflow**.

## Search engines and AI tools

Every page carries structured data (schema.org) describing you, your publications, the DEMR Lab and Dr. Ferre,
and `/llms.txt` gives AI tools a plain-text summary of the site. Both are built automatically from `_data/cv.yml`,
`_data/socials.yml` and `papers.bib`, so there's nothing to update. Facts about the lab, Dr. Ferre and BU live in
`_data/schema.yml`; edit that file if, say, the lab moves or Dr. Ferre's title changes.

## Where things live

| To change…                       | Edit                                    |
| -------------------------------- | --------------------------------------- |
| Home page text and the spec box  | `_pages/about.md`                       |
| Publications and presentations   | `_bibliography/papers.bib`              |
| Research projects (Fig. 1, 2, 3) | `_projects/`                            |
| News                             | `_news/` (one small file per item)      |
| CV                               | `_data/cv.yml`                          |
| Contact links                    | `_data/socials.yml`                     |
| Name, description, site settings | `_config.yml`                           |
| Colors, fonts, grid              | `_sass/_lab-notebook.scss`              |
| Home page layout                 | `_layouts/about.liquid`                 |
| Interactive figures              | `_includes/*_figure.liquid`             |
| Lab and Dr. Ferre (for search)   | `_data/schema.yml`                      |

## Publishing

Every push to `main` builds the site with GitHub Actions and publishes it to the `gh-pages` branch, which
GitHub Pages serves at evanyarnall.com.
