---
layout: page
title: Reaching in unilateral CP
description: Brain, body and a new apparatus. Combining fNIRS with a custom moving-target reaching board.
meta_description: "How children with unilateral cerebral palsy adjust a reach mid-movement, studied with fNIRS and a custom moving-target reaching board."
importance: 2
teaser: Step through a reaching trial
teaser_type: interactive
---

Children with unilateral cerebral palsy often have difficulty integrating sensory feedback with movement
in their affected arm. To understand why, I combine two non-invasive techniques during reaching tasks:

- **TMS** (transcranial magnetic stimulation) to assess corticospinal tract connectivity
- **fNIRS** (functional near-infrared spectroscopy) to measure sensory cortical responses

## Why the pathways matter

Each hemisphere of the brain starts out connected to both hands. As the brain matures, only the connections to the
opposite hand remain. An early injury to one hemisphere, as in unilateral cerebral palsy, can change how these
pathways develop, and TMS lets us see which ones are there. Switch between the stages below, then try a TMS pulse:

{% include motor_pathways_figure.liquid %}

## A moving target you can actually touch

Reaching for a moving target requires constant correction based on what you see and feel. Most studies of
this "online" motor control use targets on a screen, which lack the touch and depth cues of reaching for a
real object. So I designed a physical moving-target board, built with Julia Zayas (Boston University College of
Engineering, Class of 2027), the project's lead engineer.

{% include moving_target_figure.liquid %}

A child reaches from a home button toward a joystick target on a motorized track. When the hand is 35% of
the way there, an ultrasonic sensor tracking the hand triggers the target to shift about 10 cm left or right. We
measure correction latency, movement time and success rate, while fNIRS records cortical activity. Children
reach with both their affected and unaffected arm.

<figure class="lab-figure">
  <img src="{{ '/assets/img/research/moving-target-board.jpg' | relative_url }}" alt="The moving-target board: a clear acrylic case holding a motorized track, with a joystick target and two ultrasonic sensors on a 3D-printed carriage, wiring, a small display and a keypad." width="720" height="540" loading="lazy">
  <figcaption><b>Fig. 2c.</b> The board: the joystick target and its ultrasonic sensor ride on an enclosed motorized track. Still from the <a href="https://youtube.com/shorts/V6jFa3vHAho">video demo</a>.</figcaption>
</figure>

To our knowledge, it is the first physical moving-target apparatus for assessing online motor control in
children with CP alongside neuroimaging. Next steps are establishing its reliability and testing whether it
can be used for training.

<p class="lab-funding">Supported by NICHD R03HD114194.</p>

{% include participate.liquid text="The DEMR Lab is enrolling children and teens 6–17 years old, both typically developing and with cerebral palsy, for studies of how the brain pathways that control the hands are organized. Families are compensated for their time and travel." %}

## Related work

<div class="publications">
{% bibliography --group_by none --query @*[key=yarnall2026board] %}
</div>
