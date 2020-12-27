/*
Project:	ST491 Environmental Practicum Research Project for the EPA
Members:	Siyu Duan, Brandon Neal, Phillip Rodriquez-Lebron
Date:		30Mar2017
Purpose:	To answer three specific questions about the qualitative long term changes in the ozone season and its relationship with temperature.
			Question 1: Is the beginning and end of the ozone season shifting over time.
			Question 2: Is the duration of the ozone season shifting over time.
			Question 3: Is the relationship between daily ozone concentration and daily maximum temperature changing over time and 
						is there a relationship between the beginning of the ozone season and the beginning of observed high temperatures.
						And likewise for the end of the ozone season and the end of observed high temperatures.
*/
/* 
The code for each question is labeled and divided into sections
/*


Creates a library named project that points to the directory in which project files will be located.
All references to files in this code will be relative. To make this code run on another computer the file paths
must be edited to an approprite location.
*/
libname ST491 		'Desktop\ST491\databases';
filename metvars 	'Desktop\ST491\data\metvars.csv';
filename ozone   	'Desktop\ST491\data\ozone.csv';
options ls=160 nocenter;
footnote;



/******************************************************************************************
Code to read in and manipulate the data sets and produce new variables used in the analysis
******************************************************************************************/

*To read in the meteorological data from the provided metvar.csv file;
data ST491.meteor;
	infile metvars dsd missover firstobs = 2;
	input 	date		:	mmddyy10.
			usaf 
			wban
			midday_spd 
			midday_rh
			maxF
			stagIndex	:	14.
			cbsa_code	:	5.
			cbsa_short	:	$20.
			met_station :	$30.
			latitude
			longitude;
	format date mmddyy10.;
	
	/*Create variables to represent the year as a seperate variable from the date, and the actual day of the year 1-365 or 366 on leap years
	I didn't use an algorithm to determine leap years since theres only 7 I hard coded them. Drops the temporary variables
	I use to find the actual day 1-365*/
	actualYear = year(date) -1989;
	year = year(date);
	month = month(date);
	day_of_month = day(date);
	length actualDay 8;

	if year in (1992,1996,2000,2004,2008,2012,2016) then do;
		select (month);
			when (1) day_to_add = 0;
			when (2) day_to_add = 31;
			when (3) day_to_add = 60;
			when (4) day_to_add = 91;
			when (5) day_to_add = 121;
			when (6) day_to_add = 152;
			when (7) day_to_add = 182;
			when (8) day_to_add = 213;
			when (9) day_to_add = 244;
			when (10) day_to_add = 274;
			when (11) day_to_add = 305;
			when (12) day_to_add = 335;
			otherwise;
		end;
	end;
	
	else do;
		select (month);
			when (1) day_to_add = 0;
			when (2) day_to_add = 31;
			when (3) day_to_add = 59;
			when (4) day_to_add = 90;
			when (5) day_to_add = 120;
			when (6) day_to_add = 151;
			when (7) day_to_add = 181;
			when (8) day_to_add = 212;
			when (9) day_to_add = 243;
			when (10) day_to_add = 273;
			when (11) day_to_add = 304;
			when (12) day_to_add = 334;
			otherwise;
		end;
	end;
	actualDay = day_to_add + day_of_month;
	drop month day_of_month day_to_add;
run;



*To read in the ozone data from the provided ozone.csv file;
data ST491.ozone;
	infile ozone dsd missover firstobs = 2;
	input 	date		:	mmddyy10.
			cbsa_code	:	5.
			cbsa_name	:	$40.
			aqi			
			ozone;
	ozonePpb = ozone *1000;
	actualYear = year(date) -1989;
	length cbsa_short $ 20;
	
	/*add the cbsa_short to the ozone data set since merging the ozone dataset with the meteorlogical data set can produce observations in which there was not
	a record in the meteorological data set and the observation will be missing the cbsa_short which is used extensively for grouping */
	select(cbsa_code);
		when(12060) cbsa_short = "Atlanta";
		when(12580) cbsa_short = "Baltimore";
		when(14460) cbsa_short = "Boston";
		when(16740) cbsa_short = "Charlotte";
		when(16980) cbsa_short = "Chicago";
		when(17140) cbsa_short = "Cincinnati";
		when(17460) cbsa_short = "Cleveland";
		when(18140) cbsa_short = "Columbus";
		when(19100) cbsa_short = "Dallas";
		when(19740) cbsa_short = "Denver";
		when(19820) cbsa_short = "Detroit";
		when(26420) cbsa_short = "Houston";
		when(26900) cbsa_short = "Indianapolis";
		when(28140) cbsa_short = "Kansas City";
		when(29820) cbsa_short = "Las Vegas";
		when(31080) cbsa_short = "Los Angeles";
		when(32820) cbsa_short = "Memphis";
		when(33100) cbsa_short = "Miami";
		when(33460) cbsa_short = "Minneapolis";
		when(34980) cbsa_short = "Nashville";
		when(35380) cbsa_short = "New Orleans";
		when(35620) cbsa_short = "New York";
		when(36740) cbsa_short = "Orlando";
		when(37980) cbsa_short = "Philadelphia";
		when(38060) cbsa_short = "Phoenix";
		when(38300) cbsa_short = "Pittsburgh";
		when(38900) cbsa_short = "Portland";
		when(40900) cbsa_short = "Sacramento";
		when(41620) cbsa_short = "Salt Lake City";
		when(41740) cbsa_short = "San Diego";
		when(41860) cbsa_short = "San Francisco";
		when(42660) cbsa_short = "Seattle";
		when(41180) cbsa_short = "St. Louis";
		when(45300) cbsa_short = "Tampa";
		when(47900) cbsa_short = "Washington";

	end;
	drop ozone;
	format date mmddyy10.;
	
	/*Create variables to represent the year as a seperate variable from the date, and the actual day of the year 1-365 or 366 on leap years
	I didn't use an algorithm to determine leap years since theres only 7 I hard coded them. Drops the temporary variables
	I use to find the actual day 1-365*/
	year = year(date);
	month = month(date);
	day_of_month = day(date);
	length actualDay 8;

	if year in (1992,1996,2000,2004,2008,2012,2016) then do;
		select (month);
			when (1) day_to_add = 0;
			when (2) day_to_add = 31;
			when (3) day_to_add = 60;
			when (4) day_to_add = 91;
			when (5) day_to_add = 121;
			when (6) day_to_add = 152;
			when (7) day_to_add = 182;
			when (8) day_to_add = 213;
			when (9) day_to_add = 244;
			when (10) day_to_add = 274;
			when (11) day_to_add = 305;
			when (12) day_to_add = 335;
			otherwise;
		end;
	end;
	
	else do;
		select (month);
			when (1) day_to_add = 0;
			when (2) day_to_add = 31;
			when (3) day_to_add = 59;
			when (4) day_to_add = 90;
			when (5) day_to_add = 120;
			when (6) day_to_add = 151;
			when (7) day_to_add = 181;
			when (8) day_to_add = 212;
			when (9) day_to_add = 243;
			when (10) day_to_add = 273;
			when (11) day_to_add = 304;
			when (12) day_to_add = 334;
			otherwise;
		end;
	end;
	actualDay = day_to_add + day_of_month;
	drop month day_of_month day_to_add;
run;




/*Sort the data sets by the variables to merge on the date and cbsa_code combined
	make a unique primary key that is used to merge on. */
proc sort data = ST491.meteor;
	by date cbsa_code;
run;
proc sort data = ST491.ozone;
	by date cbsa_code;
run;

*Merge the data into a dataset named complete_ozone that is used in answering question 1 and 2;
data ST491.complete_ozone;
	merge ST491.meteor 
		  ST491.ozone	(in = inOzone);
	by date cbsa_code;
	if inOzone = 1;

	select(cbsa_code);
		when(14460,35620,37980,12580,47900,16740,12060) region = 1;
		when(33460,28140,41180,32820,16980,26900,34980,17140,18140,17460,19820,38300) region = 2;
		when(19100,26420,35380,36740,45300,33100) region = 3;
		when(19740,41620) region = 4;
		when(41860,40900,29820,31080,41740,38060) region = 5;
		when(42660,38900) region = 6;
	end;
	drop usaf wban met_station cbsa_name midday_spd midday_rh;
run;

*Merge the data into a dataset named complete_temp for use in answering question 3;
data ST491.complete_temp;
	merge ST491.meteor 	(in = inMeteor)
		  ST491.ozone	(in = inOzone);
	by date cbsa_code;
	if inMeteor = 1 & inOzone = 1;

	select(cbsa_code);
		when(14460,35620,37980,12580,47900,16740,12060) region = 1;
		when(33460,28140,41180,32820,16980,26900,34980,17140,18140,17460,19820,38300) region = 2;
		when(19100,26420,35380,36740,45300,33100) region = 3;
		when(19740,41620) region = 4;
		when(41860,40900,29820,31080,41740,38060) region = 5;
		when(42660,38900) region = 6;
	end;
	drop usaf wban met_station cbsa_name midday_spd midday_rh;
run;











/*sort by cbsa_code in increasing order in order to find the first high ozone day*/
proc sort data = ST491.complete_ozone;
	by cbsa_code date;
run;

/*Code finds the beginning high-ozone day for each year in each city and stores in dataset find_beginning_day*/
data ST491.find_beginning_day (rename=(ozonePpb = begOzoneValue));
	set ST491.complete_ozone;
		by  cbsa_code year ;
		retain found 1;
		
		if first.year then found = 0;

		if found = 0  then do;
			if ozonePpb gt 70  then do; 
				beginningDay = actualDay; 
				found = 1;
				output;
			end;
		end;
	drop found date maxF stagIndex aqi actualDay;
run;




/*sorts the complete dataset by descending order to find the end high ozone day*/
proc sort data = ST491.complete_ozone;
	by cbsa_code descending date;
run;

/*Code finds the end high-ozone day for each year in each city and stores in dataset find_end_day uses the reverse sorted data*/
data ST491.find_end_day (rename=(ozonePpb = endOzoneValue));
	set ST491.complete_ozone;
		by  cbsa_code descending year ;
		retain found 1;
	
		if first.year then found = 0;

		if found eq 0  then do;
			if ozonePpb gt 70  then do;
				endDay = actualDay;
				found = 1;
				output;
			end;
		end;
	drop found date maxF stagIndex aqi actualDay;
run;




/******************************************************************************************************
The following merges the datasets containing the beginning and end days of the ozone seasons
into one data set for analysis in 1st question and determines the interval of the ozone season
for analysis in the 2nd question.
******************************************************************************************************/
proc sort data = ST491.find_beginning_day;
	by cbsa_code year;
run;

proc sort data = ST491.find_end_day;
	by cbsa_code year;
run;

data ST491.interval_data;
	merge ST491.find_beginning_day ST491.find_end_day;
	by cbsa_code year;
	interval = endDay - beginningDay;
run;






/****ALL CODE BEFORE HERE NEEDS TO BE RUN FOR ANY QUESTION ********/
/* This code creates the data sets that the questions depend on   */
/******************************************************************/
/******************************************************************/






/*****************************************************************
START QUESTION 1 CODE
*****************************************************************/


*plot all the beginning and end high-ozone days by year for each city;
proc sort data = ST491.interval_data;
by cbsa_short year;
run;

proc plot data = ST491.interval_data;
	by cbsa_short;
	plot beginningDay*year;
run;
proc plot data = ST491.interval_data;
	by cbsa_short;
	plot endDay*year;
run;


/*Create variables that will be used when model building to the interval_data dataset */
Data ST491.interval_data;
	set ST491.interval_data;
	actualYearT = (actualYear-14)/13;  *Actual year ranges from 1-26 representing 1990-2016, this is transformed to be between (-1,1) for use in the quadratic model;
	actualYearT2 = actualYearT * actualYearT;
	negExpActualYear = exp(-(actualYear-14)/13); *The actual year is transformed to be between (-1,1) before using the exp function to reduce the size of values used in the function;
	expActualYear = exp((actualYear-14)/13);
	logBegDay = log(beginningDay);
	logEndDay = log(endDay);
	logActualYear = log(actualYear);
	begDay2 = beginningDay * beginningDay;
	endDay2 = endDay * endDay;
	begDayRt = sqrt(beginningDay);
	endDayRt = sqrt(endDay);
	
run;

*Check the correlation between the transformed actual year and its square for multicolinearity in the variables that will be used in a quadratice model;
proc corr data = St491.interval_data;
	var actualYearT actualYearT2;
run;

*Produce all models for beginning day by actual year to explore appropriate model;
/*
proc reg data = ST491.interval_data;
	by cbsa_short;
	model beginningDay = actualYear /dwprob;
	model beginningDay = expActualYear /dwprob;
	model beginningDay = negExpActualYear /dwprob;
	model beginningDay = actualYearT actualYearT2 /dwprob;
	model logBegDay = actualYear /dwprob;
	model beginningDay = logActualYear /dwprob;
	model logBegDay = logActualYear /dwprob;
	model begDay2 = actualYear /dwprob;	
	model begDayRt = actualYear /dwprob;
	model begDayRt = expActualYear /dwprob;
	model begDay2 = expActualYear /dwprob;
	model begDayRt = negExpActualYear /dwprob;
	model begDay2 = negExpActualYear /dwprob;
run;
quit;
*/



*Produce all models for end day by actual year to explore appropriate model;
/*
proc reg data = ST491.interval_data;
	by cbsa_short;
	where not (cbsa_short = "Los Angeles" and year = 2016); *Remove Los Angeles 2016 from the models as the data stops early in 2016 and the calculated value is incorrect;
	model endDay = actualYear /dwprob;
	model endDay = expActualYear /dwprob;
	model endDay = negExpActualYear /dwprob;
	model endDay = actualYearT actualYearT2 /dwprob;
	model logEndDay = actualYear /dwprob;
	model endDay = logActualYear /dwprob;
	model logEndDay = logActualYear /dwprob;
	model endDay2 = actualYear /dwprob;	
	model endDayRt = actualYear /dwprob;
	model endDayRt = expActualYear /dwprob;
	model endDay2 = expActualYear /dwprob;
	model endDayRt = negExpActualYear /dwprob;
	model endDay2 = negExpActualYear /dwprob;
run;
quit;
*/

*Produce the robust regression models for beg day by actual year to determine appropriate model using robust estimates for parameters;
/*
title "Begin Model 1";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model beginningDay = actualYear /diagnostics leverage;	
run;
quit;


title "Begin Model 2";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot)  method = mm;
	by cbsa_short;
	model beginningDay = expActualYear /diagnostics leverage ;	
run;
quit;

title "Begin Model 3";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model beginningDay = negExpActualYear /diagnostics leverage;	
run;
quit;

title "Begin Model 4";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model beginningDay = actualYearT actualYearT2 /diagnostics leverage;	
run;
quit;

title "Begin Model 5";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model logBegDay = actualYear /diagnostics leverage;
run;
quit;

title "Begin Model 6";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model beginningDay = logActualYear /diagnostics leverage;
run;
quit;	

title "Begin Model 7";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model logBegDay = logActualYear /diagnostics leverage;
run;
quit;
	
title "Begin Model 8";	
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model begDay2 = actualYear /diagnostics leverage;	
run;
quit;	

title "Begin Model 9";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model begDayRt = actualYear /diagnostics leverage;	
run;
quit;	

title "Begin Model 10";	
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model begDayRt = expActualYear /diagnostics leverage;	
run;
quit;	

title "Begin Model 11";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model begDay2 = expActualYear /diagnostics leverage;	
run;
quit;	

title "Begin Model 12";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model begDayRt = negExpActualYear /diagnostics leverage;
run;
quit;	

title "Begin Model 13";	
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model begDay2 = negExpActualYear /diagnostics leverage;
run;
quit;		
*/



*Produce the robust regression models for end day by actual year to determine appropriate model using robust estimates for parameters;
/*
title "End Model 1";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay = actualYear /diagnostics leverage;
	
run;
quit;

title "End Model 2";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay = expActualYear /diagnostics leverage;
run;
quit;

title "End Model 3";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay = negExpActualYear /diagnostics leverage;
run;
quit;

title "End Model 4";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay = actualYearT actualYearT2 /diagnostics leverage;
run;
quit;

title "End Model 5";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model logEndDay = actualYear /diagnostics leverage;
run;
quit;

title "End Model 6";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay = logActualYear /diagnostics leverage;
run;
quit;	

title "End Model 7";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model logEndDay = logActualYear /diagnostics leverage;
run;
quit;	

title "End Model 8";	
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay2 = actualYear /diagnostics leverage;	
run;
quit;	

title "End Model 9";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDayRt = actualYear /diagnostics leverage;	
run;
quit;	

title "End Model 10";	
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDayRt = expActualYear /diagnostics leverage;	
run;
quit;	

title "End Model 11";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay2 = expActualYear /diagnostics leverage;	
run;
quit;	

title "End Model 12";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDayRt = negExpActualYear /diagnostics leverage;
run;
quit;	
	
title "End Model 13";
proc robustreg data = ST491.interval_data plots=(rdplot ddplot histogram qqplot) method = mm;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	by cbsa_short;
	model endDay2 = negExpActualYear /diagnostics leverage;
run;
quit;		

*/





/* Code to manually add the model codes determined for each cities beginning and end high-ozone day */
data ST491.interval_dataQ1beg;
	set ST491.interval_data;
	if cbsa_short in("Cincinnati","Cleveland","Columbus","Detroit","Houston","Las Vegas","Miami","Minneapolis","San Francisco","Seattle","Washington") then modelCodeBeg = 0;
		else if cbsa_short in("Portland","Sacramento") then modelCodeBeg = 1;
		else if cbsa_short in("Dallas","Denver","Indianapolis","Kansas City","New Orleans","New York","Pittsburgh","Tampa") then modelCodeBeg = 2;
		else if cbsa_short in("Salt Lake City","San Diego") then modelCodeBeg = 3;
		else if cbsa_short in("Los Angeles","Nashville","Philadelphia","St. Louis") then modelCodeBeg = 4;
		else if cbsa_short in("Chicago") then modelCodeBeg = 8;
		else if cbsa_short in("Atlanta","Baltimore","Boston","Charlotte") then modelCodeBeg = 10;
		else if cbsa_short in("Memphis","Orlando","Phoenix") then modelCodeBeg = 11;
run;
data ST491.interval_dataQ1end;	
	set ST491.interval_data;
	where not(cbsa_short eq 'Los Angeles' and year eq 2016);
	if cbsa_short in("Denver","Indianapolis","Los Angeles","Minneapolis","New Orleans","Orlando","Portland","San Francisco","Seattle") then modelCodeEnd = 0;
		else if cbsa_short in("Baltimore","Boston","Houston","Kansas City","Miami","Phoenix","Sacramento","Washington") then modelCodeEnd = 1;
		else if cbsa_short in("Atlanta","Chicago","Cincinnati","Cleveland","Columbus","Detroit","Nashville","Philadelphia","Salt Lake City") then modelCodeEnd = 2;
		else if cbsa_short in("Dallas","New York","San Diego","St. Louis") then modelCodeEnd = 3;
		else if cbsa_short in("Las Vegas","Pittsburgh","Tampa") then modelCodeEnd = 4;
		else if cbsa_short in("Charlotte") then modelCodeEnd = 10;
		else if cbsa_short in("Memphis") then modelCodeEnd = 11;		
run;







/*BEGINNING DAY reruns all the robust regression models based on the model codes and export residuals, parameter estimates, and p values for the beginning day */
proc sort data = ST491.interval_dataQ1beg;
	by cbsa_short;
run;

title "Final Models 1 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCodeBeg = 1;
	by cbsa_short;
   	model beginningDay = actualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas1beg;
	ods output goodFit = ST491.Q1goodfit1beg;
	output out=ST491.q1residualBeg1  P=predicted SR=residual;
run;

title "Final Models 2 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot) method = mm ;
  	where modelCodeBeg = 2;
	by cbsa_short;
   	model beginningDay = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas2beg;
	ods output goodFit = ST491.Q1goodfit2beg;
	output out=ST491.q1residualBeg2  P=predicted SR=residual;
run;

title "Final Models 3 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot)  method = mm ;
  	where modelCodeBeg = 3;
	by cbsa_short;
   	model beginningDay = negExpActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas3beg;
	ods output goodFit = ST491.Q1goodfit3beg;
	output out=ST491.q1residualBeg3  P=predicted SR=residual;
run;


title "Final Models 4 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot) method = mm ;
  	where modelCodeBeg = 4;
	by cbsa_short;
   	model beginningDay = actualYearT actualYearT2 / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas4beg;
	ods output goodFit = ST491.Q1goodfit4beg;
	output out=ST491.q1residualBeg4  P=predicted SR=residual;
run;


title "Final Models 8 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot) method = mm  ;
  	where modelCodeBeg = 8;
	by cbsa_short;
   	model begDay2 = actualYear /diagnostics leverage;	
	ods output parameterestimates = ST491.Q1betas8beg;
	ods output goodFit = ST491.Q1goodfit8beg;
	output out=ST491.q1residualBeg8  P=predicted SR=residual;
run;

title "Final Models 10 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot) method = mm  ;
  	where modelCodeBeg = 10;
	by cbsa_short;
   	model begDayRt = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas10beg;
	ods output goodFit = ST491.Q1goodfit10beg;
	output out=ST491.q1residualBeg10  P=predicted SR=residual;
run;

title "Final Models 11 Begin";
proc robustreg data=ST491.interval_dataQ1beg plots=(rdplot ddplot histogram qqplot) method = mm  ;
  	where modelCodeBeg = 11;
	by cbsa_short;
   	model begDay2 = expActualYear  / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas11beg;
	ods output goodFit = ST491.Q1goodfit11beg;
	output out=ST491.q1residualBeg11  P=predicted SR=residual;
run;


/*END DAY rerun all the robust regression models based on the model codes and export residuals,parameter estimates, and p values for the end day */
proc sort data = ST491.interval_dataQ1end;
	by cbsa_short;
run;

title "Final Models 1 End";
proc robustreg data=ST491.interval_dataQ1end plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCodeEnd = 1;
	by cbsa_short;
   	model endDay = actualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas1end;
	ods output goodFit = ST491.Q1goodfit1end;
	output out=ST491.q1residualEnd1  P=predicted SR=residual;
run;

title "Final Models 2 End";
proc robustreg data=ST491.interval_dataQ1end plots=(rdplot ddplot histogram qqplot) method = mm ;
  	where modelCodeEnd = 2;
	by cbsa_short;
   	model endDay = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas2end;
	ods output goodFit = ST491.Q1goodfit2end;
	output out=ST491.q1residualEnd2  P=predicted SR=residual;
run;

title "Final Models 3 End";
proc robustreg data=ST491.interval_dataQ1end plots=(rdplot ddplot histogram qqplot)  method = mm ;
  	where modelCodeEnd = 3;
	by cbsa_short;
   	model endDay = negExpActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas3end;
	ods output goodFit = ST491.Q1goodfit3end;
	output out=ST491.q1residualEnd3  P=predicted SR=residual;
run;

title "Final Models 4 End";
proc robustreg data=ST491.interval_dataQ1end plots=(rdplot ddplot histogram qqplot) method = mm ;
  	where modelCodeEnd = 4;
	by cbsa_short;
   	model endDay = actualYearT actualYearT2 / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas4end;
	ods output goodFit = ST491.Q1goodfit4end;
	output out=ST491.q1residualEnd4  P=predicted SR=residual;
run;

title "Final Models 10 End";
proc robustreg data=ST491.interval_dataQ1end plots=(rdplot ddplot histogram qqplot) method = mm  ;
  	where modelCodeEnd = 10;
	by cbsa_short;
   	model endDayRt = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas10end;
	ods output goodFit = ST491.Q1goodfit10end;
	output out=ST491.q1residualEnd10  P=predicted SR=residual;
run;

title "Final Models 11 End";
proc robustreg data=ST491.interval_dataQ1end plots=(rdplot ddplot histogram qqplot) method = mm  ;
  	where modelCodeEnd = 11;
	by cbsa_short;
   	model endDay2 = expActualYear  / diagnostics leverage;
	ods output parameterestimates = ST491.Q1betas11end;
	ods output goodFit = ST491.Q1goodfit11end;
	output out=ST491.q1residualEnd11  P=predicted SR=residual;
run;


/*Merges the residuals from the models for the beginning day into one data set*/
data ST491.q1residualsBeg;
	set ST491.q1residualBeg1
		ST491.q1residualBeg2
		ST491.q1residualBeg3
		ST491.q1residualBeg4
		ST491.q1residualBeg8
		ST491.q1residualBeg10
		ST491.q1residualBeg11;
	keep cbsa_code cbsa_short predicted residual;
run;

/*Merges the residuals from the models for the end day into one data set*/
data ST491.q1residualsEnd;
	set ST491.q1residualEnd1
		ST491.q1residualEnd2
		ST491.q1residualEnd3
		ST491.q1residualEnd4
		ST491.q1residualEnd10
		ST491.q1residualEnd11;
	keep cbsa_code cbsa_short predicted residual;
run;


/* Plot the residuals for the beginning and end of the ozone season */
proc sort data = ST491.q1residualsBeg;
	by cbsa_short;
run;
proc sort data = ST491.q1residualsEnd;
	by cbsa_short;
run;
proc sgplot data = ST491.q1residualsBeg;
	title "Beginning Ozone Season Residuals";
	by cbsa_short;
	scatter x = predicted y = residual / markerattrs= (color= cx0000FF);
	xaxis label = "Predicted";
	yaxis label = "Standardized Residual";
run;
proc sgplot data = ST491.q1residualsEnd;
	title "End Ozone Season Residuals";
	by cbsa_short;
	scatter x = predicted y = residual / markerattrs= (color= cx0000FF);
	xaxis label = "Predicted";
	yaxis label = "Standardized Residual";
run;



/*Merge the data sets containing the parameter estimates and R square values for the beginning ozone day*/


/*Drop the extra parameter estimate for the linear term for year from the cities with quadratic model */
data ST491.Q1betas4beg;
	set ST491.Q1betas4beg;
	if parameter eq "actualYearT2";
run;

/*Merge the data sets containing the parameter estimates for the beginning ozone day */
data ST491.Q1betasCompleteBeg;
	length parameter $ 20;
	set ST491.Q1betas1beg
		ST491.Q1betas2beg
		ST491.Q1betas3beg
		ST491.Q1betas4beg
		ST491.Q1betas8beg
		ST491.Q1betas10beg
		ST491.Q1betas11beg;
	if parameter in("expActualYear","actualYear","actualYearT2","negExpActualYear");
run;

/*Merge the data sets containing the goodness of fit R square value for each model */
data ST491.Q1goodFitCompleteBeg;
	set ST491.Q1goodfit1beg
	 ST491.Q1goodfit2beg
	 ST491.Q1goodfit3beg
	 ST491.Q1goodfit4beg
	 ST491.Q1goodfit8beg
	 ST491.Q1goodfit10beg
	 ST491.Q1goodfit11beg;
	where name eq "R-Square";
run;



/*Merge the goodness of fit data and the parameter estimates for the beginning ozone day*/
proc sort data = ST491.Q1betasCompleteBeg;
	by cbsa_short;
run;

proc sort data = ST491.Q1goodFitCompleteBeg;
	by cbsa_short;
run;

data ST491.Q1parameterFitBeg;
	merge ST491.Q1betasCompleteBeg ST491.Q1goodFitCompleteBeg;
	by cbsa_short;
	rename estimate=begEstimate stderr = begStdErr lowerCL = begLowerCl upperCL=begUpperCl chiSq=begChiSq probChiSq=begProbChiSq value=begRsquare;
 	drop parameter df name;
	label 	chiSq = 'beg chi-square'
			probChiSq = 'beg p-value'
			stderr = "beg std err";
run;



/*Merge the data sets containing the parameter estimates and R square for the end ozone day */


/*Drop the extra parameter estimate for the linear term for year from the cities with quadratic model */
data ST491.Q1betas4end;
	set ST491.Q1betas4end;
	if parameter eq "actualYearT2";
run;

/*Merge the data sets containing the parameter estimates for the end ozone day */
data ST491.Q1betasCompleteEnd;
	length parameter $ 20;
	set ST491.Q1betas1end
		ST491.Q1betas2end
		ST491.Q1betas3end
		ST491.Q1betas4end
		ST491.Q1betas10end
		ST491.Q1betas11end;
	if parameter in("expActualYear","actualYear","actualYearT2","negExpActualYear");
run;

/*Merge the data sets containing the goodness of fit R square value for each model */
data ST491.Q1goodFitCompleteEnd;
	set ST491.Q1goodfit1end
	 ST491.Q1goodfit2end
	 ST491.Q1goodfit3end
	 ST491.Q1goodfit4end
	 ST491.Q1goodfit10end
	 ST491.Q1goodfit11end;
	where name eq "R-Square";
run;


/*Merge the goodness of fit data and the parameter estimates for the end ozone day*/
proc sort data = ST491.Q1betasCompleteEnd;
	by cbsa_short;
run;

proc sort data = ST491.Q1goodFitCompleteEnd;
	by cbsa_short;
run;

data ST491.Q1parameterFitEnd;
	merge ST491.Q1betasCompleteEnd ST491.Q1goodFitCompleteEnd;
	by cbsa_short;
	rename estimate=endEstimate stderr = endStdErr lowerCL = endLowerCl upperCL=endUpperCl chiSq=endChiSq probChiSq=endProbChiSq value=endRsquare;
 	drop parameter df name;
	label 	chiSq = 'end chi-square'
			probChiSq = 'end p-value'
			stderr = 'end std error';
run;



/*Merge the two data sets for beginning and end ozone day parameters and R square values */
proc sort data = ST491.Q1parameterFitBeg;
	by cbsa_short;
run;
proc sort data = ST491.Q1parameterFitEnd;
	by cbsa_short;
run;

data ST491.Q1parameterFitBegEnd;
	merge ST491.Q1parameterFitBeg ST491.Q1parameterFitEnd;
	by cbsa_short;
run;



/* Sort the interval_data and create a reduced data set with one observation for each city to maintain the region and model code*/
data ST491.reducedIntervalBeg;
	set ST491.interval_dataQ1beg;
run;
data ST491.reducedIntervalEnd;
	set ST491.interval_dataQ1end;
run;
proc sort data = ST491.reducedIntervalBeg nodupkey;
	by cbsa_short;
run;
proc sort data = ST491.reducedIntervalEnd nodupkey;
	by cbsa_short;
run;
data ST491.reduced_interval_data ;
	set ST491.reducedIntervalBeg (keep= cbsa_short cbsa_code region modelCodeBeg);
	set ST491.reducedIntervalEnd (keep= cbsa_short cbsa_code region modelCodeEnd);
	by cbsa_short;
	
run;



/* merge the Q1parameterFitBegEnd dataset with a dataset that contains the region and model code 
	so the parameter estimates and p-value can be related to the model type and region for beginning and end day*/
proc sort data = ST491.Q1parameterFitBegEnd;
	by cbsa_short;
run;
data ST491.Q1parameterFitBegEndRegion;
	merge  ST491.reduced_interval_data ST491.Q1parameterFitBegEnd;
	by cbsa_short;
	
run;

/* Examines the p-values and parameter estimates based on the model code and creates variables to represent the status of change and direction */
data ST491.Q1AnswersFull;
	set ST491.Q1parameterFitBegEndRegion;
	select(modelCodeBeg);
		/* 
		0 represents no statistically significant change, 1 represents yes there was a statistically significant change
		0 represents the shift is toward earlier in the year, 1 represents the shift was later into the year 
		*/
		when(0) do;
			begIfchange = 20;  *begIfChange represents if the change is statistically significant, 20 represents no model was fit for the city;
			begDirection = 20; *begDirection represents the direction of the shift, 20 represents no model was fit for the city;
		end;
		when(1,2,8,10,11) do;
			if begProbChiSq le 0.05 then do;
					begIfchange = 1;
					if begEstimate ge 0 then begDirection = 1;
						else begDirection = 0;
				end;
			else do;
				begIfchange = 0;
				begDirection = 10;
			end;
		end;
		when(3) do;
			if begProbChiSq le 0.05 then do;
					begIfchange = 1;
					if begEstimate ge 0 then begDirection = 0;
						else begDirection = 1;
				end;
			else do;
				begIfchange = 0;
				begDirection = 10;
			end;
		end;
		when(4) do;
			if begProbChiSq le 0.05 then do;
					begIfchange = 1;
					begDirection = 2;
					if begEstimate ge 0 then begCurrentDirection = 1;
						else begCurrentDirection = 0;
				end;
			else do;
				begIfchange = 0;
				begDirection = 10;
			end;
		end;
		otherwise;
	end;/*end for select modelCodeBeg */

	select(modelCodeEnd);
		when(0) do;
			endIfchange = 20;
			endDirection = 20;
		end;
		when(1,2,10,11) do;
			if endProbChiSq le 0.05 then do;
					endIfchange = 1;
					if endEstimate ge 0 then endDirection = 1;
						else endDirection = 0;
				end;
			else do;
				endIfchange = 0;
				endDirection = 10;
			end;
		end;
		when(3) do;
			if endProbChiSq le 0.05 then do;
					endIfchange = 1;
					if endEstimate ge 0 then endDirection = 0;
						else endDirection = 1;
				end;
			else do;
				endIfchange = 0;
				endDirection = 10;
			end;
		end;
		when(4) do;
			if endProbChiSq le 0.05 then do;
					endIfchange = 1;
					endDirection = 2;
					if endEstimate ge 0 then endCurrentDirection = 1;
						else endCurrentDirection = 0;
				end;
			else do;
				endIfchange = 0;
				endDirection = 10;
			end;
		end;
		otherwise;
	end;/*end for select modelCodeEnd */

	label begDirection = "Beginning (Direction)"
		  endDirection = "End (Direction)"
		  cbsa_short = "City"
		  cbsa_code = "CBSA Code"
		  region = "Region"
		  begIfChange = "Beginning (Significant)"
		  begCurrentDirection = "Current Direction (Beg)"
		  endIfChange = "End (Significant)"
		  endCurrentDirection = "Current Direction (End)";
run;



/*Formats to visually represent the coded  values */
proc format;
	*Format for if the change was statistically significant;
	value ifChange 0 = 'No'
				   1 = 'Yes'
				   20 = 'No Model';
	
	*Format for which direction the beginning or end day shifted;
	value whichway 0 = 'Earlier'
	   				1 = 'Later'
					2 = 'Both'
					10 = 'No Evidence'
					20 = 'No Model'
					. = ' ' ;

	*Format for the region;
	value reg 1 = 'East Coast'
		  		2 = 'Central'
				3 = 'South'
				4 = 'Rockies'
				5 = 'South West'
				6 = 'North West';

	*Format for the change in the duration of the season;
	value int 0 = 'Shortening'
			  1 = 'Lengthening'
			  2 = 'Both'
			  10 = 'No Evidence'
			  20 = 'No Model'
			  . = ' ';

run;


/*Code to show the results of question 1*/

options nodate nonumber;
ods listing;


/*Produce an example report of the qualitative values*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\begin table 5 obs.rtf";
proc report data=ST491.Q1answersFull(obs=5) nowd;
	title "Shift in the Beginning and End of the Ozone Season";
	column cbsa_short region begIfChange 
			begDirection begCurrentDirection endIfChange endDirection endCurrentDirection;
	define cbsa_short / width = 14;
	define region / format= reg. width = 12;
	define begIfChange / format =ifChange. width=13;
	define begDirection / format = whichway. width=12;
	define begCurrentDirection / format = whichway. width=13;
	define endIfChange / format = ifChange. width = 13;
	define endDirection / format = whichway. width = 12;
	define endCurrentDirection / format=whichway. width=12;
run;
quit;
ods rtf close;

/*Produce a report of the qualitative values*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\begin table all.rtf";
proc report data=ST491.Q1answersFull nowd;
	title "Shift in the Beginning and End of the Ozone Season";
	column cbsa_short region begIfChange 
			begDirection begCurrentDirection endIfChange endDirection endCurrentDirection;
	define cbsa_short / width = 14;
	define region / format= reg. width = 12;
	define begIfChange / format =ifChange. width=13;
	define begDirection / format = whichway. width=12;
	define begCurrentDirection / format = whichway. width=13;
	define endIfChange / format = ifChange. width = 13;
	define endDirection / format = whichway. width = 12;
	define endCurrentDirection / format=whichway. width=12;
run;
quit;
ods rtf close;

/* Example of raw data set for beginning day*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\beginning raw data example.rtf";
proc report data=ST491.Q1answersFull nowd;
	where cbsa_short = "Sacramento";
	title "Shift in the Beginning of the Ozone Season";
	column cbsa_short region modelCodeBeg begEstimate begStdErr begChiSq begProbChiSq begRsquare;
	define cbsa_short / width = 14 "City";
	define region / format= reg. width = 12 "Region";
	define modelCodeBeg / width = 3 "Model Code (Beg)";
	define begEstimate / format = 8.2 width=13 "Estimate (Beg)";
	define begStdErr / format = 8.2 width=12 "Std Err (Beg)";
	define begChiSq / format = 8.2 width=13 "Chi Sq (Beg)";
	define begProbChiSq / format = pvalue6.4 width = 13 "p-value (Beg)";
	define begRsquare / format = 8.2 width = 12 "R square (Beg)";
run;
quit;
ods rtf close;

/* Example of raw data set for end day*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\end raw data example.rtf";
proc report data=ST491.Q1answersFull nowd;
	where cbsa_short = "Sacramento";
	title "Shift in the End of the Ozone Season";
	column cbsa_short region modelCodeEnd endEstimate endStdErr endChiSq endProbChiSq endRsquare ;
	define cbsa_short / width = 14 "City";
	define region / format= reg. width = 12 "Region";
	define modelCodeEnd / width = 3 "Model Code (End)";
	define endEstimate / format = 8.2 width=13 "Estimate (End)";
	define endStdErr / format = 8.2 width=12 "Std Err (End)";
	define endChiSq / format = 8.2 width=13 "Chi Sq (End)";
	define endProbChiSq / format = pvalue6.4 width = 13 "p-value (End)";
	define endRsquare / format = 8.2 width = 12 "R square (End)";
run;
quit;
ods rtf close;

/* Complete raw data set for beginning day*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\beginning raw data full.rtf";
proc report data=ST491.Q1answersFull nowd;
	title "Shift in the Beginning of the Ozone Season";
	column cbsa_short region modelCodeBeg begEstimate begStdErr begChiSq begProbChiSq begRsquare;
	define cbsa_short / width = 14 "City";
	define region / format= reg. width = 12 "Region";
	define modelCodeBeg / width = 3 "Model Code (Beg)";
	define begEstimate / format = 8.2 width=13 "Estimate (Beg)";
	define begStdErr / format = 8.2 width=12 "Std Err (Beg)";
	define begChiSq / format = 8.2 width=13 "Chi Sq (Beg)";
	define begProbChiSq / format = pvalue6.4 width = 13 "p-value (Beg)";
	define begRsquare / format = 8.2 width = 12 "R square (Beg)";
run;
quit;
ods rtf close;

/* Example of raw data set for end day*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\end raw data full.rtf";
proc report data=ST491.Q1answersFull nowd;
	title "Shift in the End of the Ozone Season";
	column cbsa_short region modelCodeEnd endEstimate endStdErr endChiSq endProbChiSq endRsquare ;
	define cbsa_short / width = 14 "City";
	define region / format= reg. width = 12 "Region";
	define modelCodeEnd / width = 3 "Model Code (End)";
	define endEstimate / format = 8.2 width=13 "Estimate (End)";
	define endStdErr / format = 8.2 width=12 "Std Err (End)";
	define endChiSq / format = 8.2 width=13 "Chi Sq (End)";
	define endProbChiSq / format = pvalue6.4 width = 13 "p-value (End)";
	define endRsquare / format = 8.2 width = 12 "R square (End)";
run;
quit;
ods rtf close;


/*Create a template to change label size and graph colors */
proc template;
define style myfont;
parent=styles.analysis;
style GraphFonts /
'GraphDataFont' = ("Helvetica",6pt)
'GraphUnicodeFont' = ("Helvetica",6pt)
'GraphValueFont' = ("Helvetica",12pt,bold) /*axis number values */
'GraphLabelFont' = ("Helvetica",12pt,bold) /*axis labels */
'GraphFootnoteFont' = ("Helvetica",6pt,bold)
'GraphTitleFont' = ("Helvetica",12pt,bold)
'GraphAnnoFont' = ("Helvetica",6pt);
style GraphColors / 'gdata' =cxcc0000;
end;
run;


/*Produce vertical bar charts for question 1 */
ods listing style=myfont;
options nodate nonumber;
ods listing;


*Vertical bar chart beg;
proc sgplot data = ST491.Q1answersFull;
	vbar begDirection ; 
	format region  reg.
			begIfChange  ifChange.
			endIfChange  ifChange.
			begDirection  whichway.
			endDirection  whichway.;
	xaxis label="Direction of Shift" ;
	title "Shift in the Ozone Season";
	title2 "Beginning Day";

run;


/*vertical bar chart end*/
proc sgplot data = ST491.Q1answersFull;
	vbar endDirection ;
	format region  reg.
			begIfChange  ifChange.
			endIfChange  ifChange.
			begDirection  whichway.
			endDirection  whichway.;
	xaxis label="Direction of Shift" ;
	title "Shift in the  Ozone Season";
	title2 "End Day";
run;




/* beginning day panel by region */
proc sgpanel data = ST491.Q1answersFull;
	panelby region;
	vbar begDirection;
	format region  reg.
			begIfChange  ifChange.
			endIfChange  ifChange.
			begDirection  whichway.
			endDirection  whichway.;
	
	title "Shift in Ozone Season (Beginning Day by Region)";
	
run;

/* end day panel by region */
proc sgpanel data = ST491.Q1answersFull;
	panelby region;
	vbar endDirection;
	format region  reg.
			begIfChange  ifChange.
			endIfChange  ifChange.
			begDirection  whichway.
			endDirection  whichway.;
	title "Shift in Ozone Season (End Day by Region)";
run;
quit;

/* END Code to process question 1 results */



/**************************************************************************/
/*END QUESTION 1 CODE *****************************************************/
/**************************************************************************/



/*************************************************************************/
/*START QUESTION 2 CODE **************************************************/
/*************************************************************************/



/* Create dataset for interval analysis by adding extra variables for model and removing the where the interval is zero */
Data ST491.interval_dataQ2;
	set ST491.interval_data;
	where interval ne 0 and not(cbsa_short eq 'Los Angeles' and year eq 2016); *2016 Los Angeles is excluded as the data stopped being recorded before the normal stop time. The value is incorrect;
	logInterval = log(interval);
	intervalRt = sqrt(Interval);
	interval2 = interval * interval;
run;


/* sort and make all the interval by year plots with zeroes and without zeroes */
proc sort data = ST491.interval_data;
	by cbsa_short;
run;
proc sort data = ST491.interval_dataQ2;
	by cbsa_short;
run;

proc plot data = ST491.interval_data;
	title "Interval by year with zero values";
	by cbsa_short;
	plot interval*year;
run;
proc plot data = ST491.interval_dataQ2;
	title "Interval by year without zero values";
	by cbsa_short;
	plot interval*year;
run;

/***************************************/
*Produce all models for intervals by year to explore the best model;
/*
proc reg data = ST491.interval_dataQ2;
	by cbsa_short;
	model interval = actualYear /dwprob;
	model interval = expActualYear /dwprob;
	model interval = negExpActualYear /dwprob;
	model interval = actualYearT actualYearT2 /dwprob;
	model logInterval = actualYear /dwprob;
	model interval = logActualYear /dwprob;
	model logInterval = logActualYear /dwprob;
	model interval2 = actualYear /dwprob;	
	model intervalRt = actualYear /dwprob;
	model intervalRt = expActualYear /dwprob;
	model interval2 = expActualYear /dwprob;
	model intervalRt = negExpActualYear /dwprob;
	model interval2 = negExpActualYear /dwprob;
run;
quit;

*/

*All models using robust regression for interval by actual year to determine appropriate model;
/*
title "Duration Model 1";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval = actualYear /diagnostics leverage;
run;
quit;

title "Duration Model 2";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval = expActualYear /diagnostics leverage;
run;
quit;

title "Duration Model 3";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval = negExpActualYear /diagnostics leverage;
run;
quit;

title "Duration Model 4";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval = actualYearT actualYearT2 /diagnostics leverage;
run;
quit;

title "Duration Model 5";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model logInterval = actualYear /diagnostics leverage;
run;
quit;

title "Duration Model 6";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval = logActualYear /diagnostics leverage;
run;
quit;	

title "Duration Model 7";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model logInterval = logActualYear /diagnostics leverage;
run;
quit;	

title "Duration Model 8";	
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval2 = actualYear /diagnostics leverage;	
run;
quit;	

title "Duration Model 9";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model intervalRt = actualYear /diagnostics leverage;	
run;
quit;	

title "Duration Model 10";	
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model intervalRt = expActualYear /diagnostics leverage;	
run;
quit;	

title "Duration Model 11";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval2 = expActualYear /diagnostics leverage;	
run;
quit;	

title "Duration Model 12";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model intervalRt = negExpActualYear /diagnostics leverage;
run;
quit;	
	
title "Duration Model 13";
proc robustreg data = ST491.interval_dataQ2 plots=(rdplot ddplot histogram qqplot) method = mm;
	by cbsa_short;
	model interval2 = negExpActualYear /diagnostics leverage;	
run;
quit;		

*/

/*Based on the model noted this assigns each city a model code for the interval of the ozone season */
data ST491.interval_dataQ2withCode;
	set ST491.interval_dataQ2;
	if cbsa_short in("Chicago","Denver","Minneapolis","Nashville","New Orleans","Portland","Sacramento","Seattle","St. Louis") then modelCode = 0;
	else if cbsa_short in("Houston","San Francisco") then modelCode = 1;
	else if cbsa_short in("Atlanta","Charlotte","Cincinnati","Dallas","Kansas City","Memphis","Miami","Orlando","Pittsburgh","Salt Lake City") then modelCode = 2;
	else if cbsa_short in("Las Vegas") then modelCode = 4;
	else if cbsa_short in("Phoenix") then modelCode = 5;
	else if cbsa_short in("Baltimore","Boston","New York") then modelCode = 8;
	else if cbsa_short in("Columbus") then modelCode = 10;
	else if cbsa_short in("Cleveland","Detroit","Indianapolis","Philadelphia","Tampa","Washington") then modelCode =11;
	else if cbsa_short in("Los Angeles","San Diego") then modelCode = 13;
run;


/*Rerun all the regression models using robust regression based on the model codes and export residuals,parameter estimates, and p values */
proc sort data = ST491.interval_dataQ2withCode;
	by cbsa_short;
run;

title "Final Models 1 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 1;
	by cbsa_short;
   	model interval = actualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas1;
	ods output goodFit = ST491.Q2goodfit1;
	output out=ST491.q2residual1  P=predicted SR=residual;
run;

title "Final Models 2 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 2;
	by cbsa_short;
   	model interval = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas2;
	ods output goodFit = ST491.Q2goodfit2;
	output out=ST491.q2residual2  P=predicted SR=residual;
run;

title "Final Models 4 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 4;
	by cbsa_short;
   	model interval = actualYearT actualYearT2 / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas4;
	ods output goodFit = ST491.Q2goodfit4;
	output out=ST491.q2residual4  P=predicted SR=residual;
run;

title "Final Models 5 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 5;
	by cbsa_short;
   	model logInterval = actualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas5;
	ods output goodFit = ST491.Q2goodfit5;
	output out=ST491.q2residual5  P=predicted SR=residual;
run;

title "Final Models 8 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 8;
	by cbsa_short;
   	model interval2 = actualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas8;
	ods output goodFit = ST491.Q2goodfit8;
	output out=ST491.q2residual8  P=predicted SR=residual;
run;

title "Final Models 10 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 10;
	by cbsa_short;
   	model intervalRt = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas10;
	ods output goodFit = ST491.Q2goodfit10;
	output out=ST491.q2residual10  P=predicted SR=residual;
run;

title "Final Models 11 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 11;
	by cbsa_short;
   	model interval2 = expActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas11;
	ods output goodFit = ST491.Q2goodfit11;
	output out=ST491.q2residual11  P=predicted SR=residual;
run;

title "Final Models 13 Duration";
proc robustreg data=ST491.interval_dataQ2withCode plots=(rdplot ddplot histogram qqplot) method = mm  ;
	where modelCode = 13;
	by cbsa_short;
   	model interval2 = negExpActualYear / diagnostics leverage;
	ods output parameterestimates = ST491.Q2betas13;
	ods output goodFit = ST491.Q2goodfit13;
	output out=ST491.q2residual13  P=predicted SR=residual;
run;

/* Merge all the residuals from the models for the duration of the ozone season */
data ST491.q2residuals;
	set ST491.q2residual1
		ST491.q2residual2
		ST491.q2residual4
		ST491.q2residual5
		ST491.q2residual8
		ST491.q2residual10
		ST491.q2residual11
		ST491.q2residual13;
	keep cbsa_code cbsa_short predicted residual;
run;

/* Plot the residuals from modeling the duration of the ozone season for each city */
proc sort data = ST491.q2residuals;
	by cbsa_short;
run;
proc sgplot data = ST491.q2residuals;
	title "Residual by Predicted for the Duration of the Ozone Season";
	by cbsa_short;
	scatter x = predicted y = residual / markerattrs= (color= cx0000FF);
	xaxis label = "Predicted";
	yaxis label = "Standardized Residual";
run;


/*Merge the data sets containing the parameter estimates and R square values for the interval of the ozone season*/


/*Drop the extra parameter estimate for the linear term for year from the cities with quadratic model */
data ST491.Q2betas4;
	set ST491.Q2betas4;
	if parameter eq "actualYearT2";
run;

/*Merge the data sets containing the parameter estimates for the interval */
data ST491.Q2betasComplete;
	length parameter $ 20;
	set ST491.Q2betas1
		ST491.Q2betas2
		ST491.Q2betas4
		ST491.Q2betas5
		ST491.Q2betas8
		ST491.Q2betas10
		ST491.Q2betas11
		ST491.Q2betas13;
	if parameter in("expActualYear","actualYear","actualYearT2","negExpActualYear");
	
run;

/*Merge the data sets containing the goodness of fit R square value for each model */
data ST491.Q2goodFitComplete;
	set ST491.Q2goodfit1
	 	ST491.Q2goodfit2
	 	ST491.Q2goodfit4
	 	ST491.Q2goodfit5
	 	ST491.Q2goodfit8
	 	ST491.Q2goodfit10
	 	ST491.Q2goodfit11
	 	ST491.Q2goodfit13;
	where name eq "R-Square";
run;


/*Merge the goodness of fit data and the parameter estimates for the interval*/
proc sort data = ST491.Q2betasComplete;
	by cbsa_short;
run;

proc sort data = ST491.Q2goodFitComplete;
	by cbsa_short;
run;

data ST491.Q2parameterFit;
	merge ST491.Q2betasComplete ST491.Q2goodFitComplete;
	by cbsa_short;
 	drop parameter df name;
	label 	chiSq = 'chi-square'
			probChiSq = 'p-value'
			value = 'R-square';
run;





/* Sort the interval_data and create a reduced data set with one observation for each city to maintain the region and model code*/
data ST491.reducedIntervalQ2;
	set ST491.interval_dataQ2withCode;
	keep cbsa_short cbsa_code region modelCode;
run;
proc sort data = ST491.reducedIntervalQ2 nodupkey;
	by cbsa_short;
run;




/* merge the Q2parameterFit dataset with a dataset that contains the region and model code 
	so the parameter estimates and p-value can be related to the model type and region */
proc sort data = ST491.Q2parameterFit;
	by cbsa_short;
run;
data ST491.Q2parameterFitRegion;
	merge  ST491.reducedIntervalQ2 ST491.Q2parameterFit;
	by cbsa_short;
run;

/* Examine the p-values and the sign of the estimates for each model type to determine variables that 
	qualitatively indicate if the change in duration is statistically significant and whether the duration
	shortened or lengthened 
*/
data ST491.Q2AnswersFull;
	set ST491.Q2parameterFitRegion;
	select(modelCode);
		/* 
		0 represents no statistically significant change, 1 represents yes there was a statistically significant change
		0 represents the duration shortened, 1 represents the duration lengthened
		*/
		when(0) do;
			ifchange = 20;  *ifchange represents if the change was statistically significant, 20 represents no model was fit for the city;
			direction = 20;	*direction represents if the change was shortening or lengthening, 20 represents no model was fit for the city;
		end;
		when(1,2,5,8,10,11) do;
			if probChiSq le 0.05 then do;
					ifchange = 1;
					if estimate ge 0 then direction = 1;
						else direction = 0;
				end;
			else do;
				ifchange = 0;
				direction = 10;
			end;
		end;
		when(3,13) do;
			if probChiSq le 0.05 then do;
					ifchange = 1;
					if estimate ge 0 then direction = 0;
						else direction = 1;
				end;
			else do;
				ifchange = 0;
				direction = 10;
			end;
		end;
		when(4) do;
			if probChiSq le 0.05 then do;
					ifchange = 1;
					direction = 2;
					if estimate ge 0 then currentDirection = 1;
						else currentDirection = 0;
				end;
			else do;
				ifchange = 0;
				direction = 10;
			end;
		end;
		otherwise;
	end;/*end for select modelCodeBeg */
	

	label direction = "Interval (Direction)"
		  cbsa_short = "City"
		  cbsa_code = "CBSA Code"
		  region = "Region"
		  ifChange = "Interval (Significant)"
		  currentDirection = "Current Direction";
run;


/****************************************************************************
Question 2 tables and charts 
	
	The template and the format produced in question one must be run
	in order to produce the graphs and reports with the intended formats
****************************************************************************/

options nodate nonumber;

/* Produce an example report of the qualitative answers for duration of the ozone season */
ods rtf file="C:\Users\neal\Desktop\ST491\output\interval five.rtf";;
proc report data=ST491.Q2answersFull(obs = 5) nowd;
	title "Change in the Duration of the Ozone Season";
	column cbsa_short region ifChange direction currentDirection;
	define cbsa_short / width = 14;
	define region / format= reg. width = 12;
	define ifChange / format =ifChange. width=13;
	define direction / format = int. width=12;
	define currentDirection / format = int. width=13;
run;
quit;
ods rtf close;

/* Produce full report of the qualitative answers for duration of the ozone season */
ods rtf file="C:\Users\neal\Desktop\ST491\output\interval all.rtf";;
proc report data=ST491.Q2answersFull nowd;
	title "Change in the Duration of the Ozone Season";
	column cbsa_short region ifChange direction currentDirection;
	define cbsa_short / width = 14;
	define region / format= reg. width = 12;
	define ifChange / format =ifChange. width=13;
	define direction / format = int. width=12;
	define currentDirection / format = int. width=13;
run;
quit;
ods rtf close;

/* Example raw data set for duration of the ozone season*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\interval raw example.rtf";
proc report data=ST491.Q2answersFull nowd;
	where cbsa_short = "Houston";
	title "Change in the Duration of the Ozone Season";
	column cbsa_short region modelCode estimate intStdErr chiSq probChiSq intRsquare;
	define cbsa_short / width = 14 "City";
	define region / format= reg. width = 12 "Region";
	define modelCode / width = 3 "Model Code";
	define estimate / format = 8.2 width=13 "Estimate";
	define intStdErr / format = 8.2 width=12 "Std Err";
	define chiSq / format = 8.2 width=13 "Chi Sq";
	define probChiSq / format = pvalue6.4 width = 13 "p-value";
	define intRsquare / format = 8.2 width = 12 "R square";
run;
quit;
ods rtf close;

/* Full raw data set for duration of the ozone season*/
ods rtf file="C:\Users\neal\Desktop\ST491\output\interval raw full.rtf";
proc report data=ST491.Q2answersFull nowd;
	title "Change in the Duration of the Ozone Season";
	column cbsa_short region modelCode estimate intStdErr chiSq probChiSq intRsquare;
	define cbsa_short / width = 14 "City";
	define region / format= reg. width = 12 "Region";
	define modelCode / width = 3 "Model Code";
	define estimate / format = 8.2 width=13 "Estimate";
	define intStdErr / format = 8.2 width=12 "Std Err";
	define chiSq / format = 8.2 width=13 "Chi Sq";
	define probChiSq / format = pvalue6.4 width = 13 "p-value";
	define intRsquare / format = 8.2 width = 12 "R square";
run;
quit;
ods rtf close;




ods listing style=myfont;
options nodate nonumber;
ods listing;


*vertical bar chart interval of ozone season;
proc sgplot data = ST491.Q2answersFull;
	vbar direction ; 
	
	format 	region  reg.
			ifChange  ifChange.
			direction  int.;
	xaxis label="Direction of Change" ;
	title "Change in Duration of the Ozone Season";
run;


/* interval of ozone season panel by region */
proc sgpanel data = ST491.Q2answersFull;
	panelby region;
	vbar direction;
	format 	region  reg.
			ifChange  ifChange.
			direction  int.;
	title "Change in Ozone Season Duration for each Region";
run;



/*End question 2 tables and vertical bar charts */

/***********************************************************/
/****** END QUESTION 2 CODE ********************************/
/***********************************************************/







/**********************************************************************/
/* Start Code for question 3  										  */
/**********************************************************************/


/* Create a data set to answer the first part of question 3 from the complete_temp data set and
	add variables that will be used in modeling the data
*/
data ST491.completeQ3;
	set ST491.complete_temp;
	int_ty = maxF * year;  *interaction term between maximum daily temperature and the year;
	maxF2=maxF*maxF;
	year2= year*year;
	actualDay2= actualDay* actualDay; 
run;


/*looks at the correlation between all the extra created variables */
proc corr data = ST491.completeQ3;
run;


/* Examine the stepwise selection to get an idea of what variables should be in the model */
proc sort data = ST491.completeQ3;
 	by cbsa_short;
run;

proc glmselect data = ST491.completeQ3 Plots=criteria;
	by cbsa_short;
	model ozonePpb = maxF maxF2 year year2 actualDay actualDay2 int_ty stagIndex latitude longitude /
	selection=stepwise(select=sl choose=adjrsq stop=aic);
run;


/****************************************************************************************************************/
/*run autoregressive moving average model ARMA*/


proc sort data = ST491.completeQ3;
 	by cbsa_short;
run;

/* this command may only work is SAS 9.4 */
ods graphics on / loessmaxobs=8000; 

proc arima data= ST491.completeQ3
  plots(only)= residual(smooth); 
  by cbsa_short; 
  identify var=ozonePpb crosscorr=(maxF year actualDay stagIndex maxF2 actualDay2 int_ty) nlag=100;
  estimate input=(maxF year actualDay stagIndex maxF2 actualDay2 int_ty); 
run; 
ods graphics off;

/*End Arima */
/*******************************************************************************************************************/






/********************************************************************************************************************/
/* Second part of question 3 relating first high-ozone day to first high temperature day */
/********************************************************************************************************************/

/*
Code to find find beginning and end high temperature days from the complete_temp dataset.
The complete_temp is different from complete_ozone because the complete ozone has about 4,000 more observations.
The complete_temp data set only has those where the airTemp and the ozone were available. The first and last high 
temp days get combined with the first and last high ozone days into one data set in order to model the second part
of the 3rd question
*/

/* find the first high temperature day for each year in each city */
proc sort data = ST491.complete_temp;
by cbsa_code;
run;
data ST491.find_first_highTemp;
	set ST491.complete_temp;
		by  cbsa_code year ;
		retain foundT 1;
		if first.year then foundT = 0;

		if foundT = 0  then do;
			if maxF gt 90  then do;
				firstHighTemp = actualDay;
				foundT = 1;
				output;
			end;

		end;
	drop foundT date maxF stagIndex aqi actualDay;
run;

/*find the last high temperature day for each year in each city*/
proc sort data = ST491.complete_temp;
by cbsa_code descending date;
run;

data ST491.find_last_highTemp;
	set ST491.complete_temp;
		by  cbsa_code descending year ;
		retain foundT 1;
		if first.year then foundT = 0;

		if foundT = 0  then do;
			if maxF gt 90  then do;
				lastHighTemp = actualDay;
				foundT = 1;
				output;
			end;

		end;
	drop foundT date maxF stagIndex aqi actualDay;
run;

/* sort and merge the two datasets with the high temperature values into one data set named hightempQ3 */
proc sort data = ST491.find_first_highTemp;
by cbsa_code year;
run;

proc sort data = ST491.find_last_highTemp;
by cbsa_code year;
run;

data ST491.hightempQ3;
	merge ST491.find_first_highTemp ST491.find_last_highTemp;
	by cbsa_code year;
run;
/* ****************************************************************************/



/*sort and merge to create a dataset with the first and last high ozone day and the first and last high temperature days.
 This is the data set that is used for part 2 of question 3. Named ozone_highTemp to show it has all four of the 
necessary values */
proc sort data = ST491.hightempQ3;
	by cbsa_code year;
run;
proc sort data = ST491.interval_data;
	by cbsa_code year;
run;
data ST491.ozone_highTemp;
	merge ST491.hightempQ3 (in = inHigh) ST491.interval_data (in = inInterval);
	by cbsa_code year;
	if inHigh = 1 & inInterval = 1;
run;



/*
This code makes both sets of plots for the first high-ozone day vs. the first high temperature day
 and for the last high-ozone day vs. the last high temperature day
*/
proc sort data = ST491.ozone_highTemp;
	by cbsa_short;
run;
proc plot data = ST491.ozone_highTemp;
	by cbsa_short;
	plot beginningDay*firstHighTemp;
run;
proc plot data = ST491.ozone_highTemp;
	by cbsa_short;
	plot endDay*lastHighTemp;
run;


/*creates all the simple linear models  for the second part of question 3 
 for all values from the nation as a whole and for each city individually*/
ods graphics on; 
proc glm data = ST491.ozone_highTemp PLOTS=(DIAGNOSTICS RESIDUALS);
	/*by cbsa_short;*/
	model beginningDay = firstHighTemp;
run;
ods graphics off; 


ods graphics on;
proc glm data = ST491.ozone_highTemp PLOTS=(DIAGNOSTICS RESIDUALS);
	/*by cbsa_short;*/
	model endDay = lastHighTemp;
run;
ods graphics off; 
quit;

ods graphics on; 
proc glm data = ST491.ozone_highTemp PLOTS=(DIAGNOSTICS RESIDUALS);
	by cbsa_short;
	model beginningDay = firstHighTemp;
run;
ods graphics off; 


ods graphics on;
proc glm data = ST491.ozone_highTemp PLOTS=(DIAGNOSTICS RESIDUALS);
	by cbsa_short;
	model endDay = lastHighTemp;
run;
ods graphics off; 
quit;



/* Code to count the number of missing daily maximium temperature values.   
	Counts the number of days that a missing value is seen before the first high temperature for each city
	to give an indication of the number of days that may have an incorrect value for the first high temperature day.
    Counts the number of missing daily maximum temperature values for each city for each year and also a running 
	total. This is to give an indication of the percentage of the data that is missing. But only with respect to 
	the observations that are actually in the data set. Some dates do not actually have an associated observation
	so the code will not count it as a missing value since the record does not exist in the data set to be counted.*/

proc sort data = ST491.complete_temp;
	by cbsa_code year;
run;

data ST491.missingCounter;
		set ST491.complete_temp;
	
		by  cbsa_code year ;
		retain found 1;
		retain missingFirst 0;  /*counts the number years that a missing daily max temperature was seen before the first observed high temperature */
		retain missingMaxFCityTotal 0; /* counts the number of total missing daily max temperature values in a city, resets for every city in order to tally cites*/
		retain missingGrandTotal 0;  /* counts the grand total of missing daily maximum temperature values in the dataset */

		if first.year then found = 0;
			
		if first.cbsa_code then missingFirst = 0;
		if first.cbsa_code then missingMaxFCityTotal = 0;
		if found = 0  then do;
			if maxF gt 90  then do;  
				found = 1;
			end;
			if missing(maxF) then do;
				found = 1;
				missingFirst = missingFirst + 1;
			end;

		end;
		if missing(maxF) then do;
			missingMaxFCityTotal = missingMaxFCityTotal + 1;
			missingGrandTotal = missingGrandTotal + 1;
		end;
		if first.year | first.cbsa_code then output;
	drop found;
run;



/* Code to plot the missing values. This only plots where there is a record for that day but the value is missing, 
	obviously it can not check if the daily maximum temperature value is missing on a day if there is no record for
	that day. Look at Denver all the data is mising but there are 5 years with no missing values. That is because 
	those 5 years are not in the data set */
proc sort data = ST491.meteor;
	by cbsa_short;
run;
proc sgplot data = ST491.meteor;
	by cbsa_short;
	where missing(maxF) ;
	scatter x = year y = actualDay;
run;



/* Plot vertical bar chart for total years of missing maxF before the first high_temp day is observed*/
/*Set the graphic environment*/
goptions reset=all cback=white border htitle=12pt  htext=10pt; 

data Total_missing_years ; 
  length City $ 15. Total_missing_years 3.; 
  input city& $ total_missing_years; 
  datalines; 
Atlanta   17
Baltimore  22
Boston  19
Charlotte  18
Chicago  20
Cincinnati  21
Cleveland  22
Columbus  15
Dallas  18
Denver  22
Detroit  19
Houston  20
Indianapolis  19
Kansas City  20
Las Vegas  22
Los Angeles  20
Memphis  21
Miami  16
Minneapolis  22
Nashville  18
New Orleans  19
New York  22
Orlando  20
Philadelphia  19
Phoenix  17
Pittsburgh  21
Portland  19
Sacramento  22
Salt Lake City  20
San Diego  19
San Francisco  23
Seattle  22
St.Louis  19
Tampa  20
Washington  20
;
run; 


title "The number of years that a missing maxF was seen before the first hight temperature day was observed "; 
proc gchart data= Total_missing_years;
   hbar city/ sumvar=total_missing_years ref=26 wref=4 cref=depk width=10 nostat;
run; 
quit; 




/*Other plots generated for the report*/
/*Observations where missing maximum daily temperature data for city Denver*/
proc sort data = ST491.meteor;
	by cbsa_short;
run;
proc sgplot data = ST491.meteor;
	title "Observations where Max Daily Temperature is Missing (Denver)";
	where missing(maxF) and cbsa_short = "Denver";
	scatter x = year y = actualDay / markerattrs= (color= cx0000FF);
	xaxis label = "Year";
	yaxis label = "Day of Year";
run;

/*Observationa where missing maximum daily temperature data for city Boston*/

proc sgplot data = ST491.meteor;
    title "Observations where Max Daily Temperature is Missing (Boston)";
	where missing(maxF) and cbsa_short = "Boston";
	scatter x = year y = actualDay / markerattrs= (color= cx0000FF);
	xaxis label = "Year";
	yaxis label = "Day of Year";
run;

/*Begining of the high ozone day against the first observed high temperature day 
  for city Cleveland and Indianapolis*/

proc sgplot data = ST491.ozone_hightemp noautolegend;
    title;
	*title "First High Ozone Day vs. First High Temperature Day for Cleveland";
	where cbsa_short = "Cleveland" ;
	reg y = beginningDay x = firstHighTemp / markerattrs=(size = 2.5mm color= cxFF6666)clm cli;
	xaxis label = "First observed high temp day";
	yaxis label = "First observed high ozone day";
run;

proc sgplot data = ST491.ozone_hightemp noautolegend;
    title;
	*title "First High Ozone Day vs. First High Temperature Day for Indianapolis";
	where cbsa_short = "Indianapolis" ;
	reg y = beginningDay x = firstHighTemp / markerattrs=(size = 2.5 mm color= cxFF6666) clm cli;
	xaxis label = "First observed high temp day";
	yaxis label = "First observed high ozone day";
run;

/*Ending of the high ozone day agianst the last observed high temperature day for city 
 Cincinnati and New York*/
proc sgplot data = ST491.ozone_hightemp noautolegend;
    title;
	*title "First High Ozone Day vs. First High Temperature Day for Cincinnati";
	where cbsa_short = "Cincinnati" ;
	reg y = endDay x = lastHighTemp / markerattrs=(size = 2.5 mm color= cxFF6666) clm cli;
	xaxis label = "Last observed high temp day";
	yaxis label = "Last observed high ozone day";
run;

proc sgplot data = ST491.ozone_hightemp noautolegend;
    title;
	*title "First High Ozone Day vs. First High Temperature Day for New York";
	where cbsa_short = "New York" ;
	reg y = endDay x = lastHighTemp / markerattrs=(size = 2.5 mm color= cxFF6666) clm cli;
	xaxis label = "First observed high temp day";
	yaxis label = "First observed high ozone day";
run;







/*Presentation Graphics Production*/
/*Must have run the format and template code in question one to produce the desired results */

ods listing style=myfont;
options nodate nonumber;
ods listing;


/* Example plot of residuals must have run all the code to get answers for question 1 */
proc sgplot data = ST491.q1residualsBeg;
	title "Standardized Residual vs. Predicted for Beginning Season of Atlanta";
	where cbsa_short = "Atlanta";
	scatter x = predicted y = residual / markerattrs= (color= cx0000FF);
	xaxis label = "Predicted";
	yaxis label = "Standardized Residual";
run;

/* Example plot of ozone concentration over time for one city */
proc sgplot data = ST491.complete_ozone;
	title "Ozone Concentration vs. Day of the Year in Houston 2005";
	where cbsa_short = "Houston" and year = 2005;
	scatter x = actualDay y = ozonePpb / markerattrs =(size = 2.5 mm) ;
	xaxis label = "Day of the Year";
	yaxis label = "Ozone Concentration (ppb)";
run;



/*  3D plot for question 3 *****************************************************************/
proc g3grid data=ST491.complete_temp out=spline;
  where cbsa_short = "Charlotte";
  grid year*maxF = ozonePpb /spline axis1 = 1990 to 2016 by 1 axis2 = 50 to 110 by 5;
run;
proc template;
  define statgraph surface;
  begingraph;
	    layout overlay3d / xaxisopts=(label = 'Year') yaxisopts=(label = 'Maximum Daily Temp (F)') zaxisopts=(label='Ozone Concentration (ppb)');
      surfaceplotparm x=year y=maxF z=ozonePpb;
	    endlayout;
  	endgraph;
  end;
run;

proc sgrender data=spline template = surface ; 
	title "Max Daily Ozone vs. Max Daily Temp plotted over time";
run;
/** 3D plot for question 3  *************************************************************/

/* Example plot of the first high temperature day and first high ozone day for New York */
proc sgplot data=ST491.ozone_hightemp;
	title "First High Temperature Day and First High Ozone Day, Yearly for New York";
	where cbsa_short = "New York";
	scatter x = year y = firstHighTemp / markerattrs=(size = 2.5 mm color= cxFF0000);
	scatter x = year y = beginningDay /markerattrs=(size = 2.5 mm color= cx0000FF);;
	xaxis label = "Year" ;
	yaxis label = "Day of Year";
	label firstHighTemp = "First High Temp"
	      beginningDay = "First High Ozone Day";
run;

/*Example plot of the beginning and end high-ozone day for Houston  */
proc sgplot data = ST491.interval_data;
	title "Beginning and End of the Ozone Season vs. Year for Houston";
	where cbsa_short = "Houston";
	scatter x = year y = beginningDay /markerattrs=(size = 2.5 mm color= cxFF0000);
	scatter x = year y = endDay /markerattrs=(size = 2.5 mm color= cx0000FF);
	yaxis label = "Day of Year";
	xaxis label = "Year";
run;

/* Example plot of the ozone season duration over time for New York */
proc sgplot data = ST491.interval_data;
	title "Interval of the Ozone Season vs. Year for New York";
	where cbsa_short = "New York";
	scatter x = year y = interval /markerattrs=(size = 2.5 mm color= cx0000FF);
	yaxis label = "Duration (Days)";
	xaxis label = "Year";
run;

/* Example plot of ozone season duration for Portland showing zero values */
proc sgplot data = ST491.interval_data;
	title "Interval of the Ozone Season vs. Year for Portland";
	where cbsa_short = "Portland";
	scatter x = year y = interval /markerattrs=(size = 2.5 mm color= cx0000FF);
	
	yaxis label = "Interval Duration (Days)";
	xaxis label = "Year";
run;

/* Example plot to show how ozone season duration can be affected */
proc sgplot data = ST491.complete_ozone;
	title "Ozone Concentration vs. Day of the Year in Portland 2005";
	where cbsa_short = "Portland" and year = 2005;
	
	scatter x = actualDay y = ozonePpb / markerattrs=(size = 2.5 mm color= cx0000FF) ;
	xaxis label = "Day of the Year";
	yaxis label = "Ozone Concentration (ppb)";
run;

/*Example plot of first high ozone day versus first high temperature day for New York */
proc sgplot data = ST491.ozone_hightemp;
	title "First High Ozone Day vs. First High Temperature Day for New York";
	where cbsa_short = "New York";
	scatter y = beginningDay x = firstHighTemp / markerattrs=(size = 2.5 mm color= cx0000FF) ;;
	xaxis label = "First observed high temp day";
	yaxis label = "First observed high ozone day";
run;


/* Other graphics produced for the presentation */
proc sgplot data = ST491.ozone_hightemp;
	title "First High Ozone Day vs. First High Temperature Day for New York";
	where cbsa_short = "Orlando" ;
	scatter y = beginningDay x = firstHighTemp / markerattrs=(size = 2.5 mm color= cx0000FF) ;;
	xaxis label = "First observed high temp day";
	yaxis label = "First observed high ozone day";
run;

proc glm data = ST491.ozone_hightemp;
	title "Beginning High Ozone Day vs. First High Temp Day Orlando";
	where cbsa_short = "Orlando";
	model beginningDay = firstHighTemp;
run;
proc glm data = ST491.ozone_hightemp;
	title "Beginning High Ozone Day vs. First High Temp Day Orlando without 1999";
	where cbsa_short = "Orlando" and year ne 1999;
	model beginningDay = firstHighTemp;
run;

proc sort data = ST491.meteor;
	by cbsa_short;
run;
proc sgplot data = ST491.meteor;
	title "Observations where Max Daily Temperature is Missing (Orlando)";
	where missing(maxF) and cbsa_short = "Orlando";
	scatter x = year y = actualDay / markerattrs= (color= cx0000FF);
	xaxis label = "Year";
	yaxis label = "Day of Year";
run;



/*End presentation graphic production */





