---
title: ""
author: ""
date: "April 2023"
description: "This is a tutorial for power simulation"
github-repo: "IQSS/dss-powersim"
site: "bookdown::bookdown_site"
documentclass: book
geometry: "margin=1.5in"
biblio-style: apalike
link-citations: yes
---

# Simulation-Based Power Analysis {-}

This tutorial is designed to be a quick-start guide for conducting simulation-based power analyses in R, Python, and Stata. We focus particularly on power for mixed effects models, but the principles employed can be repurposed for any model and study design. The tutorial is suitable for anyone with a intermediate understanding of mixed effects models and coding in either R, Python, or Stata.

While high-level packages exist in some of these languages for conducting power analysis (e.g., the R packages [`{simr}`](https://cran.r-project.org/web/packages/simr/vignettes/fromscratch.html), [`{longpower}`](https://cran.r-project.org/web/packages/longpower/vignettes/longpower.html), and [`{simglm}`](https://cran.r-project.org/web/packages/simglm/vignettes/tidy_simulation.html)), such packages abstract away the details of conducting simulations and thus are best used after gaining an understanding of the power simulation process. In addition, rolling your own simulations from scratch provides much more flexibility to tackle different study designs and models - and it's fun!

We are always grateful for any feedback you are willing to provide about our tutorials! Please email <help@iq.harvard.edu> with any thoughts.

## Table of Contents {-}

1. [Canned Power Analysis](./power-analysis.html)
2. [Simulation-based Power Analysis](./simulation-based-power-analysis-1.html)
3. [Power of What?](./power-of-what.html)
4. [R Examples](./r-1.html)
5. [Python Examples](./python.html)
6. [Stata Examples](./stata-1.html)

![](images/Ultimate_Power_Vol_1_5_Textless.webp)

## Contributors {-}

The contents of these workshops are the result of a collaborative effort from members of the [Data Science Services](http://dss.iq.harvard.edu) team at the Institute for Quantitative Social Science at Harvard University. The main contributors are Steve Worthington and Dan Yuan, with additional feedback from Jinjie Liu and Noah Greifer.
