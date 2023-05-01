


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

In some situations, where the study design and/or model of interest is fairly simple, we can use a formula to calculate the sample size required to reject a null hypothesis. We will use a simple example to show the process involved. For instance, if we plan to perform a test of an hypothesis comparing the average height of people in two populations, we would specify the following null and alternative hypotheses, respectively: 
$$
\begin{align}
\textrm{H}_0 : \mu_1 &= \mu_2 \\
\textrm{H}_1 : \mu_1 &\neq \mu_2
\end{align}
$$ 

where $\mu_1$ and $\mu_2$ are the mean heights in the two populations being compared. To make sure the test has a specific power, we can use the following formula to determine the sample sizes: 
$$
\textrm{N} = 2(\frac{z_{1-\frac{\alpha}{2}}+z_{1-\beta}}{\textrm{ES}})^{2}
$$

Where $n_i$ is the sample size required in each group ($i=1,2$), $\alpha$ is the specific level of significance, $z_{1-\frac{\alpha}{2}}$ is the critical value corresponding to the significance level, $z_{1-\beta}$ is the value from the standard normal distribution holding the selected power level ($1-\beta$) below it, and $\textrm{ES}$ is the effect size, defined as follows: 
$$
\textrm{ES} = \frac{|p_1 \neq p_2|}{\sqrt{p(1-p)}}
$$ 

where $|p_1 \neq p_2|$ is the absolute value of the difference in proportions between the two groups under the alternative hypothesis, and $p$ is the proportion by pooling the observations from the two comparison groups.

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
