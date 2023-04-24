


# (PART) Preparation {-}

# Power of what?

The first 3 steps in power simulation involve nothing more than thinking and then writing down your thoughts using a pencil and paper. But, prior to walking through these steps there is an even more fundamental issue to be addressed - the power of what?

What quantity within your model do you wish to calculate power for? Overall model goodness-of-fit, individual parameters, or a combinations of parameters? The point of entry for power analysis is always to identify the particular effect of interest, and for that you must answer the question, "power of what?".
## Simple linear regression

In the following implementations of power simulation in R, Python, and Stata, we will walk through a concrete example using a simple linear regression model, before moving to a more complicated example using a mixed effects model. While canned routines exist to calculate power for some simple general linear models, this exercise will serve to build intuition about the process of power simulation that will be helpful for the more complex case.

### Step 1: model specification

The first step is to write down the regression model of interest, including all variables and parameters:

$$
bpsystol = \beta_0 + \beta_1(age) + \beta_2(sex) + \beta_3(age*sex) + \epsilon
$$

In this case, the data are from the National Health and Nutrition Examination Survey (`NHANES`) (<https://www.cdc.gov/nchs/nhanes/index.htm>) and the variables of interest are `bpsystol` (systolic blood pressure), `age`, `sex`, and their interaction, and the parameters of interest are $\beta_0$, $\beta_1$, $\beta_2$, $\beta_3$.

<caption>(\#tab:param-def)</caption>

<div custom-style='Table Caption'>*Variables in the data-generating model and associated R code.*</div>


model        code                description                                                 
-----------  ------------------  ------------------------------------------------------------
$RT_{si}$    \texttt{RT}         reaction time for subject $s$ to item $i$                   
$X_i$        \texttt{X\_i}       condition for item $i$ (-.5 = ingroup, .5 = outgroup)       
$\beta_0$    \texttt{beta\_0}    intercept; grand mean RT                                    
$\beta_1$    \texttt{beta\_1}    slope; mean effect of ingroup/outgroup                      
$\tau_0$     \texttt{tau\_0}     standard deviation of by-subject random intercepts          
$\tau_1$     \texttt{tau\_1}     standard deviation of by-subject random slopes              
$\rho$       \texttt{rho}        correlation between by-subject random intercepts and slopes 
$\omega_0$   \texttt{omega\_0}   standard deviation of by-item random intercepts             
$\sigma$     \texttt{sigma}      standard deviation of residuals                             
$T_{0s}$     \texttt{T\_0s}      random intercept for subject $s$                            
$T_{1s}$     \texttt{T\_1s}      random slope for subject $s$                                
$O_{0i}$     \texttt{O\_0i}      random intercept for item $i$                               
$e_{si}$     \texttt{e\_si}      residual for the trial involving subject $s$ and item $i$   
### Step 2: Variable composition

Once we have the model equation, we need to specify the details of the covariates, such as the range of `age` or the proportion of females (`sex`). For example, the range of `age` might encompass the full range of human longevity (e.g., 0 to 120 years) or could be more focused on non-retired adults (e.g., 18 to 65 years). The proportion of females could theoretically vary anywhere in the interval (0, 1), but practically is rarely outside of the interval [0.45, 0.55].

### Step 3: Parameter composition

Finally, we need to establish the data-generating parameters in your model. You may draw on your own, or your colleague's, substantive expertise about the phenomenom you're studying to determine what paramater values are plausible. Or, you might look to the literature for studies that examined similar effects and use these as a starting point.

<caption>(\#tab:params-all)</caption>

<div custom-style='Table Caption'>*Settings for all data-generating parameters.*</div>


code                value   description                             
------------------  ------  ----------------------------------------
\texttt{beta\_0}    800     intercept; i.e., the grand mean         
\texttt{beta\_1}    50      slope; i.e, effect of category          
\texttt{omega\_0}   80      by-item random intercept sd             
\texttt{tau\_0}     100     by-subject random intercept sd          
\texttt{tau\_1}     40      by-subject random slope sd              
\texttt{rho}        0.2     correlation between intercept and slope 
\texttt{sigma}      200     residual (error) sd                     

## Mixed effects model

Our mixed effects model example will follow the same steps as the simple linear regression, but this time with data that exhibits clustering.

### Step 1: model specification

Once again, we first write down the regression model of interest, including all variables and parameters:

$$
weight_{it} = \beta_0 + \beta_1(age_{it}) + \beta_2(female_i) + \beta_3(age_{it}*female_i) + \mu_{0i} + \mu_{1i}(age) + \epsilon_{it}
$$

where $i$ stands for `children`, $t$ for `age`, and we assume $\mu_{0i} \sim N(0, \tau_0)$, $\mu_{1i}\sim N(0, \tau_1)$, $\epsilon_{it} \sim N(0, \sigma)$. These data are available from Stata (<http://www.stata-press.com/data/r15/childweight.dta>).

The covariates are `weight`, `age`, `female`, and the interaction term `age\*female`. The parameters are: $\beta_0$ (Intercept), $\beta_1$ (coefficient for age), $\beta_2$ (coefficient for the female comparing with the male), $\beta_3$ (coefficient for the interaction), $\mu_{1i}$ (random effect of age).

<caption>(\#tab:param-def-mixed)</caption>

<div custom-style='Table Caption'>*Variables in the data-generating model and associated R code.*</div>


model        code                description                                                 
-----------  ------------------  ------------------------------------------------------------
$RT_{si}$    \texttt{RT}         reaction time for subject $s$ to item $i$                   
$X_i$        \texttt{X\_i}       condition for item $i$ (-.5 = ingroup, .5 = outgroup)       
$\beta_0$    \texttt{beta\_0}    intercept; grand mean RT                                    
$\beta_1$    \texttt{beta\_1}    slope; mean effect of ingroup/outgroup                      
$\tau_0$     \texttt{tau\_0}     standard deviation of by-subject random intercepts          
$\tau_1$     \texttt{tau\_1}     standard deviation of by-subject random slopes              
$\rho$       \texttt{rho}        correlation between by-subject random intercepts and slopes 
$\omega_0$   \texttt{omega\_0}   standard deviation of by-item random intercepts             
$\sigma$     \texttt{sigma}      standard deviation of residuals                             
$T_{0s}$     \texttt{T\_0s}      random intercept for subject $s$                            
$T_{1s}$     \texttt{T\_1s}      random slope for subject $s$                                
$O_{0i}$     \texttt{O\_0i}      random intercept for item $i$                               
$e_{si}$     \texttt{e\_si}      residual for the trial involving subject $s$ and item $i$   
### Step 2: Variable composition

We also need to think about the covariates in our model. This is a longitudinal study, so we need to specify the starting `age`, the length of time between measurements, and the total number of measurements. We also need to consider the proportion of males and females in our study. Are we likely to sample 50% females and 50% males?

Let's assume that we will measure the children's weight every 4 months for 4 years beginning at age 10. Also, let's assume that the sample will be 50% female. The interaction term (`age\*female`) is easy to calculate once we create variables for `age` and `female`. 

### Step 3: Parameter composition

Finally, we need to establish the data-generating parameters in your model. As before, you may determine what paramater values are plausible by drawing on substantive expertise about the phenomenom you're studying or by referencing the literature for studies that report similar effects.

<caption>(\#tab:params-all-mixed)</caption>

<div custom-style='Table Caption'>*Settings for all data-generating parameters.*</div>


code                value   description                             
------------------  ------  ----------------------------------------
\texttt{beta\_0}    800     intercept; i.e., the grand mean         
\texttt{beta\_1}    50      slope; i.e, effect of category          
\texttt{omega\_0}   80      by-item random intercept sd             
\texttt{tau\_0}     100     by-subject random intercept sd          
\texttt{tau\_1}     40      by-subject random slope sd              
\texttt{rho}        0.2     correlation between intercept and slope 
\texttt{sigma}      200     residual (error) sd                     
