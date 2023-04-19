


# Stata

## Simple linear regression

### Setup

We will also set the pseudo-random number generator seed to 02138 to make the stochastic components of our simulations reproducible.


```stata
set seed 02138
```

### Step 4: Simulate

Next, we create a simulated dataset based on our assumptions about the model under the alternative hypothesis, and fit the model.


```stata
clear
set obs 400
generate age = runiformint(18,65)
generate female = rbinomial(1,0.5)
generate interact = age*female
generate e = rnormal(0,20)
generate sbp = 110 + 0.5*age + (-20)*female + 0.35*interact  + e
```

We can then test the null hypothesis that the interaction term equals zero using a likelihood-ratio test.


```stata
regress sbp age i.female c.age#i.female
estimates store full
regress sbp age i.female
estimates store reduced

Likelihood-ratio test                       LR chi2(1)  =  13.38
(Assumption: reduced nested in full)        Prob > chi2 =  0.0003
```

The test yields a p-value of 0.0003.


```stata
return list

scalars:
r(p) =  .0002540647000293
r(chi2) =  13.38189649447986
r(df) =  1

local reject = (r(p)<0.05)
```

### Step 5: Automate

Next, let's write a program that creates datasets under the alternative hypothesis, fits the models, and uses the `simulate` command to test the program.


```stata
capture program drop simregress
program simregress, rclass
    version 16
    // DEFINE THE INPUT PARAMETERS AND THEIR DEFAULT VALUES
    syntax, n(integer)          /// Sample size
          [ alpha(real 0.05)    /// Alpha level
            intercept(real 110) /// Intercept parameter
            age(real 0.5)       /// Age parameter
            female(real -20)    /// Female parameter
            interact(real 0.35) /// Interaction parameter
            esd(real 20) ]      //  Standard deviation of the error
    quietly {
        // GENERATE THE RANDOM DATA
        clear
        set obs `n'
        generate age = runiformint(18,65)
        generate female = rbinomial(1,0.5)
        generate interact = age*female
        generate e = rnormal(0,`esd')
        generate sbp = `intercept' + `age'*age + `female'*female + ///
           `interact'*interact  + e
        // TEST THE NULL HYPOTHESIS
        regress sbp age i.female c.age#i.female
        estimates store full
        regress sbp age i.female
        estimates store reduced
        lrtest full reduced
    }
    // RETURN RESULTS
    return scalar reject = (r(p)<`alpha')
end
```

Below, we use `simulate` to run `simregress` 200 times and summarize the variable reject. The results indicate that we would have 74% power to detect an interaction parameter of 0.35 given a sample of 400 participants and the other assumptions about the model.


```stata
simulate reject=r(reject), reps(200) seed(12345):              ///
         simttest, n(200) m0(70) ma(75) sd(15) alpha(0.05)

Simulations (200)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..................................................   100
..................................................   150
..................................................   200

summarize reject

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      reject |        200        .735    .4424407          0          1

```

Next, let's write a program called `power\_cmd\_simregress` so that we can integrate `simregress` into Stata's `power` command.


```stata
capture program drop power_cmd_simregress
program power_cmd_simregress, rclass
    version 17
    // DEFINE THE INPUT PARAMETERS AND THEIR DEFAULT VALUES
    syntax, n(integer)          /// Sample size
          [ alpha(real 0.05)    /// Alpha level
            intercept(real 110) /// Intercept parameter
            age(real 0.5)       /// Age parameter
            female(real -20)    /// Female parameter
            interact(real 0.35) /// Interaction parameter
            esd(real 20)        /// Standard deviation of the error
            reps(integer 100)]  //   Number of repetitions

    // GENERATE THE RANDOM DATA AND TEST THE NULL HYPOTHESIS
    quietly {
        simulate reject=r(reject), reps(`reps'):               ///
             simregress, n(`n') age(`age') female(`female')    ///
                         interact(`interact') esd(`esd') alpha(`alpha')
        summarize reject
    }
    // RETURN RESULTS
    return scalar power = r(mean)
    return scalar N = `n'
    return scalar alpha = `alpha'
    return scalar intercept = `intercept'
    return scalar age = `age'
    return scalar female = `female'
    return scalar interact = `interact'
    return scalar esd = `esd'
end
```

Finally, run `power simregress` for a range of input parameter values, including the parameters listed in double quotes. To do this, we first need to create a program called `power\_cmd\_simregress\_init`.


```stata
capture program drop power_cmd_simregress_init
program power_cmd_simregress_init, sclass
    sreturn local pss_colnames "intercept age female interact esd"
    sreturn local pss_numopts  "intercept age female interact esd"
end
```

### Step 6: Summarize & visualize

Now, we’re ready to use `power simregress`! The output below shows the simulated power when the interaction parameter equals 0.2 to 0.4 in increments of 0.05 for samples of size 400, 500, 600, and 700.

```stata
power simregress, n(400(100)700) intercept(110)                 ///
                   age(0.5) female(-20) interact(0.2(0.05)0.4)   ///
                   reps(1000) table graph(xdimension(interact)   ///
                   legend(rows(1)))

Estimated power
Two-sided test

  
  +--------------------------------------------------------------------+
  |   alpha   power       N intercept     age  female interact     esd |
  |--------------------------------------------------------------------|
  |     .05      .3     400       110      .5     -20       .2      20 |
  |     .05    .421     400       110      .5     -20      .25      20 |
  |     .05    .546     400       110      .5     -20       .3      20 |
  |     .05    .685     400       110      .5     -20      .35      20 |
  |     .05    .767     400       110      .5     -20       .4      20 |
  |     .05     .34     500       110      .5     -20       .2      20 |
  |     .05    .509     500       110      .5     -20      .25      20 |
  |     .05     .63     500       110      .5     -20       .3      20 |
  |     .05    .767     500       110      .5     -20      .35      20 |
  |     .05    .872     500       110      .5     -20       .4      20 |
  |     .05    .412     600       110      .5     -20       .2      20 |
  |     .05    .556     600       110      .5     -20      .25      20 |
  |     .05    .712     600       110      .5     -20       .3      20 |
  |     .05    .829     600       110      .5     -20      .35      20 |
  |     .05    .886     600       110      .5     -20       .4      20 |
  |     .05    .471     700       110      .5     -20       .2      20 |
  |     .05    .634     700       110      .5     -20      .25      20 |
  |     .05    .771     700       110      .5     -20       .3      20 |
  |     .05    .908     700       110      .5     -20      .35      20 |
  |     .05    .957     700       110      .5     -20       .4      20 |
  +--------------------------------------------------------------------+

```

![](https://github.com/hlmshtj-dan/pigo/blob/main/5.png?raw=true)


## Mixed effects model

### Setup

Again, we set the seed to 02138.


```stata
set seed 02138
```

### Step 4: Simulate

Next, we create a simulated dataset based on our assumptions about the model under the alternative hypothesis, and fit the model. We will simulate 5 observations at 4-month increments for 200 children.


```stata
clear
set obs 200
generate child = _n
generate female = rbinomial(1,0.5)
generate u_0i = rnormal(0,0.25)
generate u_1i = rnormal(0,0.60)
expand 5
bysort child: generate age = (_n-1)*0.5
generate interaction = age*female
generate e_ij = rnormal(0,1.2)
generate weight = 5.35 + 3.6*age + (-0.5)*female + (-0.25)*interaction ///
    + u_0i + age*u_1i + e_ij
```

Our dataset includes the random deviations that we would not observe in a real dataset. We can then use mixed to fit a model to our simulated data.


```stata
mixed weight age i.female c.age#i.female || child: age , stddev nolog noheader
estimates store full
mixed weight age i.female || child: age , stddev nolog noheader
estimates store reduced
lrtest full reduced
```

We can then test the null hypothesis that the interaction term equals zero using a likelihood-ratio test.


```stata
 lrtest full reduced

Likelihood-ratio test                                 LR chi2(1)  =      8.23
(Assumption: reduced nested in full)                  Prob > chi2 =    0.0041
```

The $p$-value for our test is 0.0041, so we would reject the null hypothesis that the interaction term equals zero.

### Step 5: Automate

Next, let's write a program that creates datasets under the alternative hypothesis, fits the mixed effects models, tests the null hypothesis of interest, and uses the `simulate` command to run many iterations of the program.


```stata
capture program drop simmixed
program simmixed, rclass
    version 16
    // PARSE INPUT
    syntax, n1(integer)             ///
            n(integer)              ///
          [ alpha(real 0.05)        ///
            intercept(real 5.35)    ///
            age(real 3.6)           ///
            female(real -0.5)       ///
            interact(real -0.25)    ///
            u0i(real 0.25)          ///
            u1i(real 0.60)          ///
            eij(real 1.2) ]

    // COMPUTE POWER
    quietly {
        drop _all
        set obs `n'
        generate child = _n
        generate female = rbinomial(1,0.5)
        generate u_0i = rnormal(0,`u0i')
        generate u_1i = rnormal(0,`u1i')
        expand `n1'
        bysort child: generate age = (_n-1)*0.5
        generate interaction = age*female
        generate e_ij = rnormal(0,`eij')
        generate weight = `intercept' + `age'*age + `female'*female + ///
           `interact'*interaction  + u_0i + age*u_1i + e_ij

        mixed weight age i.female c.age#i.female || child: age, iter(200)
        local conv1 = e(converged)
        estimates store full
        mixed weight age i.female || child: age, iter(200)
        local conv2 = e(converged)
        estimates store reduced
        lrtest full reduced
        local reject = cond(`conv1' + `conv2'==2, (r(p)<`alpha'), .)
    }
    // RETURN RESULTS
    return scalar reject = `reject'
    return scalar conv = `conv1'+`conv2'
end
```

We then use simulate to run simmixed 10 times using the default parameter values for 5 observations on each of 200 children.


```stata
simulate reject=r(reject) converged=r(conv), reps(10) seed(12345):      
             simmixed, n1(5) n(200)

      command:  simmixed, n1(5) n(200)
       reject:  r(reject)
    converged:  r(conv)

Simulations (10)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5
```

`simulate` saved the results of the hypothesis tests to a variable named reject. The mean of reject is our estimate of the power to test the null hypothesis that the age×sex interaction term equals zero, assuming that the weight of 200 children is measured 5 times.

We could stop with our quick simulation if we were interested only in a specific set of assumptions. But it’s easy to write an additional program named `power\_cmd\_simmixed` that will allow us to use Stata's `power` command to create tables and graphs for a range of sample sizes.


```stata
capture program drop power_cmd_simmixed
program power_cmd_simmixed, rclass
    version 16
    // PARSE INPUT
    syntax, n1(integer)             ///
            n(integer)              ///
          [ alpha(real 0.05)        ///
            intercept(real 5.35)    ///
            age(real 3.6)           ///
            female(real -0.5)       ///
            interact(real -0.25)    ///
            u0i(real 0.25)          ///
            u1i(real 0.60)          ///
            eij(real 1.2)           ///
            reps(integer 1000) ]

    // COMPUTE POWER
    quietly {
        simulate reject=r(reject), reps(`reps'):                            ///
        simmixed, n1(`n1') n(`n') alpha(`alpha') intercept(`intercept')     ///
                  age(`age') female(`female') interact(`interact')          ///
                  u0i(`u0i') u1i(`u1i') eij(`eij')
        summarize reject
    }

    // RETURN RESULTS
    return scalar power = r(mean)
    return scalar n1 = `n1'
    return scalar N = `n'
    return scalar alpha = `alpha'
    return scalar intercept = `intercept'
    return scalar age = `age'
    return scalar female = `female'
    return scalar interact = `interact'
    return scalar u0i = `u0i'
    return scalar u1i = `u1i'
    return scalar eij = `eij'
end
```

It's also easy to write a program named `power\_cmd\_simmixed\_init` that will allow us to simulate power for a range of values for the parameters in our model.


```stata
capture program drop power_cmd_simmixed_init
program power_cmd_simmixed_init, sclass
      version 16
      sreturn clear
      // ADD COLUMNS TO THE OUTPUT TABLE
      sreturn local pss_colnames "n1 intercept age female interact u0i u1i eij"
      // ALLOW NUMLISTS FOR ALL PARAMETERS
      sreturn local pss_numopts  "n1 intercept age female interact u0i u1i eij"
end
```

### Step 6: Summarize & visualize

Now, we can use `power simmixed` to simulate power for a variety of assumptions. The example below simulates power for a range of sample sizes at both levels 1 and 2. Level 2 sample sizes range from 100 to 500 children in increments of 100. At level 1, we consider 5 and 6 observations per child.


```stata
power simmixed, n1(5 6) n(100(100)500) reps(1000)                         
               table(n1 N power)                                         
               graph(ydimension(power) xdimension(N) plotdimension(n1)    
               xtitle(Level 2 Sample Size) legend(title(Level 1 Sample Size)))
xxxxxxxxxxxxxxxxxxxxxxxxxxx
Estimated power
Two-sided test

  +-------------------------+
  |      n1       N   power |
  |-------------------------|
  |       5     100   .2629 |
  |       6     100    .313 |
  |       5     200    .397 |
  |       6     200    .569 |
  |       5     300    .621 |
  |       6     300    .735 |
  |       5     400    .734 |
  |       6     400    .855 |
  |       5     500    .828 |
  |       6     500    .917 |
  +-------------------------+
```

![](https://github.com/hlmshtj-dan/pigo/blob/main/3.png?raw=true)
