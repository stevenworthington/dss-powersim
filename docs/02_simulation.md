# Power Analysis via Simulation

For some studies, formulas may not exist to calculate sample size, such as in complex study designs or when using mixed effects models for inference. In such cases, we must rely on simulation-based power analysis. The basic idea is to simulate running the study many times and calculate the proportion of times we reject the null hypothesis. This proportion provides an estimate of power. Generating a dataset and running an analysis for the hypothesis test is part of the simulation. One thing to mention is that randomness is usually introduced into the process through the dataset generation.

For example, say the fixed power level is 95%, and you want to calculate the sample size using this level. You can take a "guess and check" method. With this method, firstly, you choose a sample size $n_1$ and run the simulation to estimate your power. If power is estimated to be lower than 95%, you need to select a new value $n_2$ that is larger than $n_1$ running the simulation again. Multiple procedures are repeated until the estimated power is roughly 95%.

As the example shows in the previous section, for several basic statistical tests, we can use Stata's `power` command to calculate power and/or sample size. For more complicated analyses, however, such as those involving mixed effects models, we need to use a simulation-based approach. In these scenarios, we usually use the following procedures to perform power analysis:

## Step by step

- Think 
    1. **Model specification:** Write down the regression model, including all variables and parameters of interest.
    2. **Variable composition:** Specify the details of the covariates, such as the range of age or the proportion of females.
    3. **Parameter composition:** Establish reasonable values for the data-generating parameters in your model.

- Act  
    4. **Simulate:** Simulate the sampling process for a single dataset, assuming the alternative hypothesis, and fit the model.
    5. **Automate:** Write a function/program/macro to create the datasets, fit the models, test the hypotheses of interest, and calculate power. The function/program/macro should allow for iterating power calculations over a grid of parameter values.
    6. **Summarize:** Summarize the output in tables and figures.
