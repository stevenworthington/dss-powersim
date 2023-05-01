


# (PART) Concepts {-}

# Power Analysis

<div class="alert alert-success">
Statistical power is the probability of rejecting a null hypothesis when it is false, or equivalently, of detecting an effect if such an effect exists.
</div>

## Canned routines

For some studies, it can be an important step to calculate *a priori* statistical power. We use statistical power to determine the probability of rejecting a null hypothesis when it is false, or equivalently, of detecting an effect if such an effect exists. 
$$
\begin{align}
\textrm{Power} &= \textrm{Pr}(\textrm{reject} H_0 \, | \, H_0 \textrm{is false}) \\
               &= 1 - \textrm{Pr}(\textrm{fail to reject} H_0 \, | \, H_0 \textrm{is false}) \\
               &= 1 - \beta
\end{align}
$$

We want $\beta$ (Type II error) to be small and power to be large. When designing a study, rather than calculating power when sample size and effect size are fixed, researchers typically want to know the sample size required to reject a null hypothesis at a given level of power and effect size.

In some situations, where the study design and/or model of interest is fairly simple, we can use a formula to calculate the sample size required to reject a null hypothesis. We will use a simple example to show the process involved. For instance, if we plan to perform a test of an hypothesis comparing the cholesterol levels of people in two populations, one with a diet comprising low oat consumption and the other with high oat consumption, we would specify the following null and alternative hypotheses, respectively: 
$$
\begin{align}
\textrm{H}_0 : \mu_1 - \mu_2 &= 0 \\
\textrm{H}_1 : \mu_1 - \mu_2 &\neq 0
\end{align}
$$ 

where $\mu_1$ and $\mu_2$ are the mean cholesterol levels in the two populations being compared. We can use a formula to determine the sample sizes required so that the test has a specific power. We will need the following inputs to the formula:

1. $\alpha$ (Type I error): typically, this is set to $0.05$ in most studies.
2. $1 - \beta$ (power): often this is set to $0.8$ or $0.9$.
3. $\sigma$ (population standard deviation): we need to estimate/guess this.
4. $\delta$ (alternative hypothesis): ideally the smallest difference $\delta = \mu_1 - \mu_2$ that has scientific or clinical importance.

Given $\alpha$, $(1 - \beta)$, $\sigma$, and $\delta$, we can calculate $n_g$ the sample size in each group. To simplify things a little, we will use the normal distribution as an approximation to the $t$ distribution (which should be fine when $n_g \geq 30$). Here is the formula for this approximate two-sample $t$-test:

$$
n_g \approx 2(z_{\alpha / 2} + z_\beta)^2 \left( \frac{\sigma}{\mu_1 - \mu_2} \right)^2
$$

Where $n_g$ is the sample size required in each group, $z_{\alpha/2}$ is the Type I error level, $z_\beta$ is the value from the standard normal distribution holding the selected power level ($1-\beta$) below it, and $\mu_1 - \mu_2$ is the effect size (difference in population averages of cholesterol), and $\sigma$ is the pooled population standard deviation (during study planning we typically assume equal variances in the two groups). Typically, we set our input values to:

1. $\alpha = 0.05$, so $Z_{\alpha / 2} = 1.960$.
2. $1 - \beta = 0.8$, so $\beta = 0.2$, so $Z_\beta = 0.8416$.
3. $\sigma = 1$; from previous studies, this is our best guess.
4. $\delta = 0.7$, that is, from previous studies our best guess is that mean differences of 0.7 mmol/L or greater should be considered as biologically important.

$$
n_g \approx 2(1.960 + 0.8416)^2 \left( \frac{1}{0.7} \right)^2 = 32.036
$$

We always round up to a whole number for sample size, so for this study we need 33 subjects per group, or $n=66$ in total.

For example, in R we can use the following function from the built-in `{stats}` package to calculate the sample size needed to reject the null hypothesis that $\textrm{H}_0 :p_1 = p_2$ given observed heads proportions of $\hat{p_1} = 0.2, \hat{p_2} = 0.6$ and a fixed level of power (90%):


```r
power.prop.test(n=NULL, p1=0.2, p2=0.6, sig.level=0.05, power=0.9)
```

```
## 
##      Two-sample comparison of proportions power calculation 
## 
##               n = 29.38798
##              p1 = 0.2
##              p2 = 0.6
##       sig.level = 0.05
##           power = 0.9
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```


## Step by step

1. Specify a hypothesis test.

Make explicit a null and alternative hypothesis.

2. Specify the significance level of the test.

Typically $\alpha=0.05$ is used, but other values could be substituted instead.

3. Get the values of the parameters necessary to compute power.

To solve for sample size $n$, we need value(s) for effect size(s). Sometimes we need to use a pilot dataset or look to the literature to get these values.

4. Specify the intended power of the test.

The power of a test is the probability of finding significance if the alternative hypothesis is true.

5. Calculate the sample size required to obtain the power level desired.
