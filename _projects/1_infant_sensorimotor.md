---
layout: page
title: Sensorimotor development in infants at risk for CP
description: A longitudinal study following infants from 6 to 24 months. The focus of my dissertation.
meta_description: "Evan Yarnall's dissertation: a longitudinal study of sensorimotor development and brain activity (fNIRS) in infants at risk for cerebral palsy, from 6 to 24 months."
importance: 1
teaser: Squeeze and watch the brain respond
teaser_type: interactive
---

How does sensorimotor development unfold in infants who are at risk for cerebral palsy, and when does it
start to diverge from typical development?

My dissertation examines this with a longitudinal dataset that follows typically developing infants and
infants at risk for cerebral palsy from 6 to 24 months. I analyze the data using R, MATLAB and Python.

## Building the baseline: how bimanual skills develop

To know what to compare against, we first mapped how typically developing infants learn to use their two
hands together. Infants start by using both hands for the same purpose, and later learn
**role-differentiated bimanual manipulation**, where each hand does a different but complementary job, like
pulling apart the pieces of a toy, or holding a container steady with one hand while the other opens it or
puts things inside.

We filmed semi-structured play sessions every 3 months from 6 to 24 months, coded every bout of toy contact
in Datavyu, and recorded brain activity over sensorimotor cortex with fNIRS at the same time.

<figure class="lab-figure">
  <img src="{{ '/assets/img/research/rdbm-bilateral-contact.jpg' | relative_url }}" alt="Two charts. Left: the percentage of toy contact time that is bilateral rises with age from about 50 percent at 6 months to about 67 percent at 24 months. Right: stacked bars by age showing the bilateral share growing while left-only and right-only shares shrink." loading="lazy">
  <figcaption><b>Fig. 1a.</b> Manual exploration becomes increasingly bilateral between 6 and 24 months.</figcaption>
</figure>

<figure class="lab-figure">
  <img src="{{ '/assets/img/research/rdbm-topography.jpg' | relative_url }}" alt="Three head maps of sensorimotor cortex at 6, 12 and 18 to 24 months, showing the difference between right-hand and left-hand activity. At 6 months the pattern is mixed across both hemispheres; by 12 months and later, activity is more lateralized." loading="lazy">
  <figcaption><b>Fig. 1b.</b> fNIRS topography during role-differentiated bimanual manipulation. Cortical activity becomes more lateralized to the hemisphere opposite the active hand with age.</figcaption>
</figure>

Infants spent about the same amount of time touching toys at every age, but how they used their hands
changed: bilateral contact and role-differentiated manipulation both increased, and cortical activity
shifted from bilateral to contralateral patterns. Next, we will compare these patterns in infants at risk
for cerebral palsy.

## Try it: watching the brain respond

fNIRS shines near-infrared light through the scalp to track oxygenated blood in the cortex underneath. When a
brain area works harder, fresh oxygenated blood flows in, but only after a delay of several seconds. Squeeze
below and watch for it.

{% include fnirs_figure.liquid %}

<p class="lab-funding">Supported by NINDS K01NS117659.</p>

{% include participate.liquid text="The DEMR Lab is enrolling infants 2–12 months old, both typically developing and born preterm, for studies like this one. Visits are scheduled around naps and feeds, and families are compensated for their time and travel." %}

## Related work

<div class="publications">
{% bibliography --group_by none --query @*[key=yarnall2026bilateral || key=yarnall2025motor] %}
</div>
