<<<<<<< Updated upstream
# Project 1: Imbalanced Image Classification Using Machine Learning (R) 
=======
# Project 1: Imbalanced Image Classification using Machine Learning 
>>>>>>> Stashed changes


Term: Fall 2020

+ Team members (In alphabetical order)

	+ Siyu Duan
	+ Xinying Feng 
	+ Depeng Kong
	+ Xinyuan Peng
	+ Natalie Williams

+ Project summary:
The goal of this project is efficiently and accurately classifying images by facial emotions. We took the parwise distance between fiducial points as our features for facial emotion recognition.  To deal with the imbalanced data problem, we re balanced training data using Bootstrap Random Over-Sampling Examples Technique(ROSE) after training and testing split. Our beaseline model is GBM using default parameters.  Improved GBM, Random Forest, Xgboost and SVM were built to improve the efficiency and accuracy of predictions through parameter tuning. Cross-validation is used in training all models.  To evaluate the performances of our model,  we rebalanced our testing data, and then using balanced testing data to calculate accuracy, weightedROC, weightedAUC of our models as part of our evaluation metrics for choosing the final model.   Also, training time and testing time included in the evaluation metrics.  Our final model is SVM, compared to basedline GBM, the AUC increased around 0.2, and prediction accuracy improved around 25%.  





# Project 2: Causal Inference Algorithms Evaluation 


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




# Project 3: Traffic Flow Simulation 


Term: Fall 2018

+ Project summary:
This project involves a traffic flow simulation in the two-interval highway.  The users can customize the number of lanes, maximum vehicle capacity per lane per minute, the number of booths in each interval, average booth processing rate.    The output is a simulation table which calculates the minute by minute volumes of vehicles arriving, departing, and waiting in the backup. 






<<<<<<< Updated upstream
# Project 4: Analysis of Ozone Season Trends in the U.S.  (SAS)
=======
# Project 4: Analysis of Ozone Season trends in the U.S.  
>>>>>>> Stashed changes


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


     
