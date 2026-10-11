---
layout: page
title: Better ways to measure infant movement
description: Comparing video coding, wearable sensors and markerless tracking, plus the coding pipelines behind them.
meta_description: "Comparing video coding, wearable sensors (IMUs) and markerless tracking for measuring infant movement in cerebral palsy research."
importance: 3
teaser: Try coding two clips yourself
teaser_type: interactive
---

Early signs of cerebral palsy often show up in how infants move, but measuring that movement reliably is
hard. Our lab compares several ways of capturing it:

- **Video observation**, scored through behavioral coding
- **Wearable sensors** (inertial measurement units, or IMUs)
- **Markerless motion tracking** with DeepLabCut during infant reaching

I build and maintain the lab's behavioral coding pipelines in Datavyu, using Ruby and Python, including the
inter-rater reliability workflows that make the coded data trustworthy.

## What behavioral coding looks like

Coding means watching video and marking exactly when a behavior happens, such as each moment an infant's hand
touches a toy. Two trained coders score the same sessions, and their agreement (inter-rater reliability) tells
us whether the codes can be trusted. Try it:

{% include coding_figure.liquid %}

## Coding which hand

Real coding schemes go further than "touching or not." To study how infants learn to use their two hands
together, we also code *which* hand is on the toy: the left, the right, or both. Telling these apart reliably
is the first step toward spotting more advanced skills, like pulling apart the pieces of a toy, opening
containers, or putting things into them.

{% include coding_hands_figure.liquid %}

## Video or wearable sensors?

Video coding is detailed but slow: someone has to watch every second. Wearable sensors (IMUs), worn on the wrists
and ankles like bracelets, record movement automatically, but their continuous signal has to be turned into
"moving" and "not moving" with a threshold. Part of our work compares the two. Try picking a threshold:

{% include imu_figure.liquid %}

## Related work

<div class="publications">
{% bibliography --group_by none --query @*[key=su2025imu || key=su2026deeplabcut || key=su2024dynamics] %}
</div>
