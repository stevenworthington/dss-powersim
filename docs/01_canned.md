


# (PART) Concepts {-}

# Power Analysis

<div class="alert alert-success">
Statistical power is the probability of rejecting a null hypothesis when it is false, or equivalently, of detecting an effect if such an effect exists.
</div>

## Canned routines

For some studies, it can be an important step to calculate *a priori* statistical power. We use statistical power to determine the probability of rejecting a null hypothesis when it is false, or equivalently, of detecting an effect if such an effect exists.

$$
\begin{align}
\textrm{Power} &= \textrm{Pr}(\textrm{reject} \, H_0 \, | \, H_0 \, \textrm{is false}) \\
               &= 1 - \textrm{Pr}(\textrm{fail to reject} \, H_0 \, | \, H_0 \, \textrm{is false}) \\
               &= 1 - \beta
\end{align}
$$

We want $\beta$ (Type II error) to be small and power to be large. When designing a study, rather than calculating power when sample size and effect size are fixed, researchers typically want to know the sample size required to reject a null hypothesis at a given level of power and effect size.

In some situations, where the study design and/or model of interest is fairly simple, we can use a formula to calculate the sample size required to reject a null hypothesis. We will use a simple example to show the process involved. For instance, if we plan to perform a test of an hypothesis comparing the cholesterol levels of people in two populations, one with a diet comprising low oat consumption and the other with high oat consumption, we could specify the following null and alternative hypotheses, respectively: 

$$
\begin{align}
\textrm{H}_0 : \mu_1 - \mu_2 &= 0 \\
\textrm{H}_1 : \mu_1 - \mu_2 &\neq 0
\end{align}
$$ 

where $\mu_1$ and $\mu_2$ are the mean cholesterol levels in the two populations being compared. We can use a formula to determine the sample sizes required so that the test has a specific power. We will need the following inputs to the formula:

1. $\alpha$ (Type I error / significance level): typically, this is set to $0.05$ in most studies.
2. $1 - \beta$ (power): often this is set to $0.8$ or $0.9$.
3. $\sigma$ (population standard deviation): we need to estimate/guess this.
4. $\delta$ (alternative hypothesis): ideally the smallest difference $\delta = \mu_1 - \mu_2$ that has scientific or clinical importance.

Given $\alpha$, $(1 - \beta)$, $\sigma$, and $\delta$, we can calculate $n_g$ the sample size in each group to reject $\textrm{H}_0$ with probability $(1 - \beta)$. To simplify things a little, we will use the normal distribution as an approximation to the $t$ distribution (which should be fine when $n_g \geq 30$). Here is the formula for this approximate two-sample $t$-test:

$$
n_g \approx 2(z_{\alpha / 2} + z_\beta)^2 \left( \frac{\sigma}{\delta} \right)^2
$$

where $n_g$ is the sample size required in each group, $z_{\alpha/2}$ is the value from the standard normal distribution holding half the selected $\alpha$ level below it (because this is a two-tailed test), $z_\beta$ is the value from the standard normal distribution holding the $\beta$ level below it, $\delta$ is the effect size (the difference in population averages $\mu_1 - \mu_2$ of cholesterol), and $\sigma$ is the pooled population standard deviation (during study planning we usually assume equal variances in the two groups). Typically, we would set $\alpha$ and $\beta$ to the following values and rely on previous studies or pilot data to obtain reasonable values for $\sigma$ and $\delta$:

1. $\alpha = 0.05$, so $z_{\alpha / 2} = 1.960$.
2. $1 - \beta = 0.8$, so $\beta = 0.2$, so $z_\beta = 0.8416$.
3. $\sigma = 1$; this could be our best guess based on previous studies.
4. $\delta = 0.7$, our best guess based on previous studies could be that mean differences of 0.7 mmol/L or greater should be considered biologically important.

We can then plug these input values into our formula:

$$
n_g \approx 2(1.960 + 0.8416)^2 \left( \frac{1}{0.7} \right)^2 = 32.036
$$

We always round up to a whole number for sample size, so for this study we need 33 subjects per group, or $n=66$ in total.

In practice, we will often rely on software to perform the above calculation for us. In R we can use the `power.t.test()` function from the built-in `{stats}` package to calculate the sample size needed to reject the null hypothesis that $\textrm{H}_0 : \mu_1 - \mu_2 = 0$. We just need to pass the $n$ parameter as `NULL` to tell R that we'd like to calculate sample size based on the values of the other parameters:


```r
power.t.test(n=NULL, delta=0.7, sd=1, sig.level=0.05, power=0.8, alternative="two.sided")
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 33.02467
##           delta = 0.7
##              sd = 1
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```


## Step by step

Here are the general set of steps required to implement a power analysis for most study designs:

**1. Specify a hypothesis test.**

Make explicit a null and alternative hypothesis.

**2. Specify Type I and Type II error levels for the test.**

Typically, the Type I error level (significance level / false positive level) is set to $\alpha=0.05$ and Type II error level (false negative level) $\beta=0.2$, which yields a power level of $1 - \beta = 0.8$, but other values could be substituted instead.

**3. Specify the estimated effect size level for the test.**

To solve for sample size $n$, we need an estimate of effect size ($\delta = \mu_1 - \mu_2$) that has scientific meaning. Sometimes we need to use a pilot dataset or look to previous studies to get this value.

**4. Calculate the sample size required to obtain the power level desired.**

This can either be done by pugging and chugging values into the relevant formula, or by using a software-based implementation of said formula.
