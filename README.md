# Project 1: Imbalanced Image Classification using Machine Learning (R project)


Term: Fall 2020

+ Team members (In alphabetical order)

	+ Siyu Duan
	+ Xinying Feng 
	+ Depeng Kong
	+ Xinyuan Peng
	+ Natalie Williams

+ Project summary:
The goal of this project is efficiently and accurately classifying images by facial emotions. We took the parwise distance between fiducial points as our features for facial emotion recognition.  To deal with the imbalanced data problem, we re balanced training data using Bootstrap Random Over-Sampling Examples Technique(ROSE) after training and testing split. Our beaseline model is GBM using default parameters.  Improved GBM, Random Forest, Xgboost and SVM were built to improve the efficiency and accuracy of predictions through parameter tuning. Cross-validation is used in training all models.  To evaluate the performances of our model,  we rebalanced our testing data, and then using balanced testing data to calculate accuracy, weightedROC, weightedAUC of our models as part of our evaluation metrics for choosing the final model.   Also, training time and testing time included in the evaluation metrics.  Our final model is SVM, compared to basedline GBM, the AUC increased around 0.2, and prediction accuracy improved around 25%.  





# Project 2: Causal Inference Algorithms Evaluation (Python project) 


Term: Fall 2020

+ Team members (In alphabetical order)
	+ Siyu Duan 
	+ Yotam Segal 
	+ Yuwei Tong
	+ Hanyi Wang 
	+ Lingjia Zhang 

+ Project summary:
 In this project, we implemented and compared different algorithms for Causal Inference on both low dimension data and high dimension data. We compared the following algorithms using L1 penalized logistic regression to estimate propensity scores:
	+ Propensity Matching (linear PS)
	+ Doubly Robust Estimation
	+ Regression Estimate (without PS)
	
We evaluated different methods by accuracy (difference between our estimated ATE and real ATE) and running time, and got following results:

Method | Data Type | run_time | ATE | Accuracy   
--- | --- | --- | --- | ---  
regression_estimate | lowDim| 6.618 | 2.532 | 98.7%    
regression_estimate | highDim | 4.319 | -2.951 | 98.4%
DRE | lowDim | 0.115 | 2.645 | 94.2%
DRE | highDim | 0.438 | -3.082 | 97.3%
PSM | lowDim | 3.323 | 2.586 | 96.5%
PSM | highDim | 23.656 | -3.069 | 97.7%




# Project 3: Performance of tech industry during COVID-19 period (R project)


Term: Fall 2020

+ Team members (In alphabetical order)
	+ Siyu Duan 
	+ Jingyuan Liu
	+ Haonan Wen
	
+ Project summary: 
In this project, we have picked the 5 most representative types of tech companies including Streaming, E-commerce, Entertainment (Gaming), Videoconferencing, and integrated tech companies. We evaluated the companies’ performances mainly based on three measurements: stock closing price, quarterly revenue, and investors' Confidence Index. First, we look at the companies’ behave on the stock market. Moreover, we introduced the Confidence Index to evaluate investor confidence in the market. Finally, we also take the companies’ quarterly revenue into account. Based on the three measurements described above, we hope our work would provide some insight for those who look back at this unprecedented year. The final  bookdown source file is available here: https://syd-cu.github.io/tech_companies_during_covid-19/
	

*This repo was initially generated from a bookdown template available here: https://github.com/jtr13/EDAVtemplate.*	




# Project 4: COVID-19 AS WE KNOW IT! (R shiny project)


Term: Fall 2020

+ Team members (In alphabetical order)
	+ Siyu Duan
	+ Mengyao He
	+ Wannian Lou
	+ Sneha Swati
	+ Luyao Sun
	

+ Project summary: This project is titled COVID-19 as we know it because it is a play on words for Life as we know it. Our life has been turned upside down because of COVID. So many important and life changing events have occurred, odd facts about COVID have been spread and, our usual spots have been up rooted. This app provides the users with a timeline of all the events that have unfolded from Feb. 29th 2020 to Sep. 30th, 2020. It also helps to disprove the Presidents theory about temperature and its relationship to COVID cases. Lastly, this app helps users find a new and safe hangout spot/restaurant.  The app is available here:  https://columbiaproject2.shinyapps.io/Project_2_Group_7_COVID/






# Project 5: Traffic Flow Simulation (Python project)


Term: Fall 2018

+ Author:
Siyu Duan 

+ Project summary:
This project involves a traffic flow simulation in the two-interval highway.  The users can customize the number of lanes, maximum vehicle capacity per lane per minute, the number of booths in each interval, average booth processing rate.    The output is a simulation table which calculates the minute by minute volumes of vehicles arriving, departing, and waiting in the backup. 





# Project 6: Analysis of Ozone Season trends in the U.S.  (SAS project)



Term: Spring 2017

+ Team members (In alphabetical order)
	+ Siyu Duan 
	+ Brandon Neal 
	+ Phillip Rodriquez-Lebron
	
+ Project summary:
In this project, we used data collected by Environmental Protection Agency (EPA).  	The objective of the project is to characterize the long-term changes in the ozone season using meteorology data from 35 major U.S. cities from 1990 to 2016.   Ground level ozone (O 3 ) is an air pollutant, which has negative health and environmental impacts. The formation of ground level ozone is mainly due to emissions from cars, power plants, factories, and other sources undergoing reactions in the presence of sunlight. People who are exposed to higher levels of ozone may have an increased risk of an asthma attack, lung inflammation, or other respiratory ailments. Thus, The beginning and end of the ozone season was defined as the first and last day for a specific year and city where the observed daily ozone concentration was above 70 ppb. The following is the research questions we proposed in the project:

	+ Is the beginning or end of ozone season shifting over time for each of the 35 cities?  Shifting earlier or later in the year?
	+ Is the ozone season as a whole getting shorter or longer for each of the 35 cities?
	+ What is the relationship between daily ozone concentration and daily maximum temperature over time for each of the 35 cities? 


     
