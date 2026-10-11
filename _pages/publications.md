---
layout: page
permalink: /publications/
title: Publications
description: Journal articles and conference presentations.
meta_description: "Publications and conference presentations by Evan Yarnall on infant sensorimotor development, cerebral palsy, fNIRS and TMS, each with a plain-language summary."
nav: true
nav_order: 2
---

<!-- _pages/publications.md -->

{% include bib_search.liquid %}

<div class="lab-filters" id="pub-filters" hidden>
  <div class="lab-filter">
    <label for="filter-year">Year</label>
    <select id="filter-year">
      <option value="">All years</option>
    </select>
  </div>
  <div class="lab-filter">
    <label for="filter-type">Type</label>
    <select id="filter-type">
      <option value="">All types</option>
      <option value="article">Journal article</option>
      <option value="review">Under review</option>
      <option value="prep">In preparation</option>
      <option value="talk">Talk</option>
      <option value="poster">Poster</option>
    </select>
  </div>
  <label class="lab-filter-check" for="filter-first">
    <input type="checkbox" id="filter-first">
    First author only
  </label>
  <p class="lab-filter-count" aria-live="polite"></p>
  <button type="button" class="lab-filter-clear" id="filter-clear" hidden>Clear</button>
</div>

<div class="publications">

<h2 class="bibliography-section">Journal articles and manuscripts</h2>
{% bibliography --query @article,@unpublished %}

<h2 class="bibliography-section">Conference presentations</h2>
{% bibliography --query @inproceedings %}

</div>

<script>
  // Let keyboard users scroll the BibTeX boxes (al-folio renders them without a tab stop).
  document.querySelectorAll(".bibtex pre").forEach(function (pre) {
    pre.tabIndex = 0;
  });

  // Year / type / first-author filters. Each entry's details come from its BibTeX block,
  // so the filters stay in sync with _bibliography/papers.bib with no extra setup.
  (function () {
    var box = document.getElementById("pub-filters");
    var yearSel = document.getElementById("filter-year");
    var typeSel = document.getElementById("filter-type");
    var firstBox = document.getElementById("filter-first");
    var clearBtn = document.getElementById("filter-clear");
    var countEl = box.querySelector(".lab-filter-count");
    var items = Array.prototype.slice.call(document.querySelectorAll(".publications ol.bibliography > li"));

    function field(bib, name) {
      var m = bib.match(new RegExp("\\b" + name + "\\s*=\\s*\\{([^}]*)\\}", "i"));
      return m ? m[1] : "";
    }

    var years = {};
    items.forEach(function (li) {
      var pre = li.querySelector(".bibtex pre");
      var bib = pre ? pre.textContent : "";
      var kind = (bib.match(/@(\w+)/) || [])[1] || "";
      var note = field(bib, "note");
      var type = "";
      if (kind === "article") type = "article";
      else if (kind === "unpublished") type = /preparation/i.test(note) ? "prep" : "review";
      else if (/poster/i.test(note)) type = "poster";
      else if (kind === "inproceedings") type = "talk";
      var firstAuthor = field(bib, "author").split(/\s+and\s+/)[0] || "";
      li.dataset.year = field(bib, "year");
      li.dataset.type = type;
      li.dataset.first = /yarnall/i.test(firstAuthor) ? "1" : "0";
      if (li.dataset.year) years[li.dataset.year] = true;
    });

    Object.keys(years).sort().reverse().forEach(function (y) {
      var o = document.createElement("option");
      o.value = y;
      o.textContent = y;
      yearSel.appendChild(o);
    });

    // Hide year headings and section headings that have nothing left to show.
    function tidyHeadings() {
      var visible = function (li) {
        return !li.classList.contains("lab-filtered") && !li.classList.contains("unloaded");
      };
      document.querySelectorAll(".publications ol.bibliography").forEach(function (ol) {
        var any = Array.prototype.some.call(ol.children, visible);
        ol.classList.toggle("lab-empty", !any);
        var h = ol.previousElementSibling;
        if (h && h.matches("h2.bibliography")) h.classList.toggle("lab-empty", !any);
      });
      document.querySelectorAll(".publications h2.bibliography-section").forEach(function (sec) {
        var any = false;
        for (var n = sec.nextElementSibling; n && !n.matches("h2.bibliography-section"); n = n.nextElementSibling) {
          if (n.matches("ol.bibliography") && !n.classList.contains("lab-empty")) any = true;
        }
        sec.classList.toggle("lab-empty", !any);
      });
      // Entry count beside each section heading.
      document.querySelectorAll(".publications h2.bibliography-section").forEach(function (sec) {
        var n = 0;
        for (var el = sec.nextElementSibling; el && !el.matches("h2.bibliography-section"); el = el.nextElementSibling) {
          if (el.matches("ol.bibliography")) n += Array.prototype.filter.call(el.children, visible).length;
        }
        var c = sec.querySelector(".lab-section-count");
        if (!c) {
          c = document.createElement("span");
          c.className = "lab-section-count";
          sec.appendChild(c);
        }
        c.textContent = n + (n === 1 ? " entry" : " entries");
      });
      var shown = items.filter(visible).length;
      countEl.textContent = shown === items.length ? items.length + " entries" : "Showing " + shown + " of " + items.length;
    }

    function apply() {
      var y = yearSel.value, t = typeSel.value, f = firstBox.checked;
      items.forEach(function (li) {
        var ok = (!y || li.dataset.year === y) && (!t || li.dataset.type === t) && (!f || li.dataset.first === "1");
        li.classList.toggle("lab-filtered", !ok);
      });
      clearBtn.hidden = !(y || t || f);
      tidyHeadings();
    }

    [yearSel, typeSel, firstBox].forEach(function (c) { c.addEventListener("change", apply); });
    clearBtn.addEventListener("click", function () {
      yearSel.value = "";
      typeSel.value = "";
      firstBox.checked = false;
      apply();
      yearSel.focus();
    });
    // The built-in search box re-shows headings on every keystroke; tidy up after it.
    var search = document.getElementById("bibsearch");
    if (search) search.addEventListener("input", function () { setTimeout(tidyHeadings, 0); });

    box.hidden = false;
    apply();
  })();
</script>
