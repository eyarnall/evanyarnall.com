---
layout: page
title: Research
permalink: /research/
description: What I'm working on now, in the DEMR Lab at Boston University.
meta_description: "Evan Yarnall's research in the DEMR Lab at Boston University: infant sensorimotor development, reaching in unilateral cerebral palsy, and better ways to measure infant movement."
nav: true
nav_order: 1
---

<div class="lab-figs lab-figs-page">
{% assign figs = site.projects | sort: 'importance' %}
{% for project in figs %}
  {% include research_card.liquid project=project index=forloop.index heading='h2' %}
{% endfor %}
</div>
