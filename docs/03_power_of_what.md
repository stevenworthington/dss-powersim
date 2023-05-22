


# (PART) Preparation {-}

# Power of What?

The initial steps of power simulation involve nothing more than thinking and writing down your thoughts using a pencil and paper. But, prior to walking through these steps, there is an even more fundamental issue to be addressed - the power of what?

What quantity within your model do you wish to calculate power for? Overall model goodness-of-fit, individual parameters, or combinations of parameters? The point of entry for power analysis is always to identify the particular effect of interest, and for that you must answer the question: "power of what?"

## Study design

The study design we will use as an example throughout this tutorial comes from Julian Quandt's blogpost (<https://julianquandt.com/post/power-analysis-by-data-simulation-in-r-part-iv/>). He describes this as:

> A new hypothetical research question focused on music preference. The overarching research goal will be to find out whether Rock or Pop music is better. Of course, we could just ask people what they prefer, but we want a more objective measure of what is Rock and Pop (people might have different ideas about the genres). Therefore, we will have participants listen to a bunch of different songs that are either from a Spotify "best-of-pop" or "best-of-rock" playlist and have them rate each song on an evaluation scale from 0-100 points. 

## Simple linear regression

Canned routines exist to perform power analysis for some simple general linear models (GLMs), however, using simulation to calculate power for a GLM will serve as scaffolding to build intuition about the process of conducting power simulation more generally, which will be helpful when we later move to a more complex case using a mixed effects model. While the outcome in this example is bounded on the interval [0, 100], we will not concern ourselves with the issue of using a linear model with such an outcome. Likewise, we will make no effort to address the within-subject nature of the effect of interest in the GLM example.

### Step 1: model specification

The first step in simulation-based power analysis is to write down the regression model of interest, including all variables and parameters:

$$
\textrm{liking}_i = \beta_0 + \beta_1 \times \textrm{genre}_i + \epsilon_i
$$

where the subscript $i$ denotes an individual song, `liking` is an integer-based rating of a given song on the interval [0, 100], `genre` is a dummy coded binary variable indicating whether the song is classified as "rock" or "pop", and we assume $\epsilon_{i} \sim \mathcal{N}(0, \sigma)$. The parameter of interest is $\beta_1$ - the average difference in the rating of songs between the two genres. Table 3.1 lists all of the variables and parameters in the model.

<caption>(\#tab:param-def-glm)</caption>

<div custom-style='Table Caption'>*Variables in the data-generating model and associated code-based names.*</div>


model                 code                  description                                                
--------------------  --------------------  -----------------------------------------------------------
$\textrm{liking}_i$   $\texttt{liking_i}$   rating of song $i$ on the interval [0, 100]                
$\textrm{genre}_i$    $\texttt{genre_i}$    genre of song $i$ (0='pop', 1='rock')                      
$\beta_0$             $\texttt{beta_0}$     intercept; mean of liking rating for 'pop' genre           
$\beta_1$             $\texttt{beta_1}$     'slope'; mean difference btw 'pop' and 'rock' song ratings 
$\sigma$              $\texttt{sigma}$      standard deviation of residuals                            
$e_{i}$               $\texttt{e_i}$        residual for song $i$                                      

### Step 2: Variable composition

Once we have the model equation, we need to specify the details of the explanatory variables. In our model, we only have a single binary predictor, so the only decision to make is which coding scheme to use: dummy coding, zero sum coding, or something else. Here, we chose dummy coding, since our primary interest is in the difference between the "rock" and "pop" genres. 

In many other situations, we might include variables such as age and sex in the model. In which case we would need to determine reasonable settings for the range of age and the proportion of females to males. For example, the range of age might encompass the full possible range of human longevity (e.g., 0 to 120 years) or could be more focused on non-retired adults (e.g., 18 to 65 years). The proportion of females to males could theoretically vary anywhere in the interval (0, 1), but practically is rarely outside of the interval [0.45, 0.55].

### Step 3: Parameter composition

Finally, we need to establish the data-generating parameters in the model. You may draw on your own, or your colleague's, substantive expertise about the phenomenom you're studying to determine what paramater values are plausible. Or, you might look to the literature for studies that examined similar effects. Table 3.2 lists parameter values we will use as a starting point. Later, we will try alternative values and compare power for each.

<caption>(\#tab:params-all-glm)</caption>

<div custom-style='Table Caption'>*Settings for all data-generating parameters.*</div>


code                value   description                                                   
------------------  ------  --------------------------------------------------------------
$\texttt{beta_0}$   65      intercept; i.e., mean of liking rating for 'pop' genre        
$\texttt{beta_1}$   15      slope; i.e, mean difference btw 'pop' and 'rock' song ratings 
$\texttt{sigma}$    5       residual (error) sd                                           

## Mixed effects model

Our mixed effects model example will follow the same steps as the simple linear regression, but this time incorporate some additional model machinery to account for by-subject clustering in the data.

### Step 1: model specification

Once again, we first write down the regression model of interest, including all variables and parameters:

$$
\textrm{liking}_{ij} = \beta_0 + b_{0j} + (\beta_1 + b_{1j}) \times \textrm{genre}_i + \epsilon_{ij}
$$

where the subscripts $i$ and $j$ denote individual songs and participants, respectively, `liking` is an integer-based rating of a given song on the interval [0, 100], `genre` is a dummy coded binary variable indicating whether the song is classified as "rock" or "pop", and we assume $b_{0j} \sim \mathcal{N}(0, \tau_0)$, $b_{1j} \sim \mathcal{N}(0, \tau_1)$, $\epsilon_{ij} \sim \mathcal{N}(0, \sigma)$. The parameter of interest is $\beta_1$ - the average (within-subject) difference in the rating of songs between the two genres. Table 3.3 lists all of the variables and parameters in the model. 

<caption>(\#tab:param-def-mixed)</caption>

<div custom-style='Table Caption'>*Variables in the data-generating model and associated code-based names.*</div>


model                    code                   description                                                     
-----------------------  ---------------------  ----------------------------------------------------------------
$\textrm{liking}_{ij}$   $\texttt{liking_ij}$   rating of song $i$ for participant $j$ on the interval [0, 100] 
$\textrm{genre}_i$       $\texttt{genre_i}$     genre of song $i$ (0='pop', 1='rock')                           
$\beta_0$                $\texttt{beta_0}$      intercept; mean of liking rating for 'pop' genre                
$\beta_1$                $\texttt{beta_1}$      slope; mean difference btw 'pop' and 'rock' song ratings        
$\tau_0$                 $\texttt{tau_0}$       standard deviation of by-subject random intercepts              
$\tau_1$                 $\texttt{tau_1}$       standard deviation of by-subject random slopes                  
$\rho$                   $\texttt{rho}$         correlation between by-subject random intercepts and slopes     
$\sigma$                 $\texttt{sigma}$       standard deviation of residuals                                 
$b_{0j}$                 $\texttt{b_0j}$        random intercept for subject $j$                                
$b_{1j}$                 $\texttt{b_1j}$        random slope for subject $j$                                    
$e_{ij}$                 $\texttt{e_ij}$        residual of song $i$ for participant $j$                        

### Step 2: Variable composition

We also need to think about the explanatory variables in our model. Since we only have a single binary predictor, we just need to decide which coding scheme to use: dummy coding, zero sum coding, or something else. Once again, here we chose dummy coding, since our primary interest is in the difference between the "rock" and "pop" genres.

### Step 3: Parameter composition

Finally, we need to establish the data-generating parameters in the model. As before, you may determine what paramater values are plausible by drawing on substantive expertise about the phenomenom you're studying or by referencing the literature for studies that report similar effects. Table 3.4 lists parameter values we will use as a starting point. Later, we will try alternative values and compare power for each.

<caption>(\#tab:params-all-mixed)</caption>

<div custom-style='Table Caption'>*Settings for all data-generating parameters.*</div>


code                value   description                                                   
------------------  ------  --------------------------------------------------------------
$\texttt{beta_0}$   65      intercept; i.e., mean of liking rating for 'pop' genre        
$\texttt{beta_1}$   15      slope; i.e, mean difference btw 'pop' and 'rock' song ratings 
$\texttt{tau_0}$    7       by-subject random intercept sd                                
$\texttt{tau_1}$    3       by-subject random slope sd                                    
$\texttt{rho}$      0.2     correlation between intercept and slope                       
$\texttt{sigma}$    5       residual (error) sd                                           