# Note to grader

My complete analysis is in the PDF file C8W4A-Report-V5-final.pdf titled: "Machine Learning Modeling of Selected Weight-lifting Activities"

# Summary of this Analysis

In this analysis, we evaluate the data used by Velloso et al. in their paper “Qualitative Activity Recognition of Weight Lifting Exercises” [ACM SIGCHI 2013]. The data was collected for six young men performing weight-lifting exercises with a light dumbbell (1.25 KG) using five pre-determined sequences (named as the variable ‘classe’ in the dataset). Sequence A is the correct sequence, and sequences B, C, D, and E are variations of the men performing the weigth-lifting exercise incorrectly. Sequences B, C, D, and E are specific ways to perform the weigth-lifting exercise incorrectly, and this means that the four wrong sequences should be just as separable from each other as they are from A.

We use a specific seed (22) to ensure our data runs are reproducible. We perform exploratory data analysis (EDA), caret model selection, and feature selection in an appendix. The steps relegated to an appendix are as follows:

- Explore the unaggregated training time series data to get a feel for what movements were performed for each sequence, as captured by the classe variable. We plot a small sample of these.
- Explore the aggregated training time series data after selecting only the rows containing these fileds, and removing fields that contain no data, all zeroes and/or all NA values.
- For the aggregated time bin training data, we generate the model accuracy contribution of each feature using the Recursive Feature Elimination (RFE) algorithm. We come up with the features with greater than or equal to 0.75 correlation as features that can be excluded from the classification training algorithms, but none of these fields are found in the test data. Therefore, this selection criteria is not useful in our analysis.
- For the aggregated time bin training data, and using all predictors found in the training data, we apply four models (Decision Tree, Random Forest, Bagged Trees and SVMpoly-short for Support Vector Machines with polynomial kernel) using the caret package to asses the within sample accuracy of predicting the weight-lifting activities using classe as our response variable. We resample from within the training data to obtain confusion matrix results for each caret model.
- For the unaggregated time bin training data, we generate the model accuracy contribution of each feature using the RFE algorithm. We come up with the features with greater than or equal to 0.75 correlation as features that can be excluded from the classification training algorithms. Since some of these fields we want to exclude are found in the test data, we use this knowledge.
- Finally, within the appendix, and for the unaggregated time bin training data, using all predictors found in the training data, we apply the four models we found to have the highest accuracy and kappa measures (Decision Tree, Random Forest, Bagged Trees and SVMpoly), using the caret package to asses the within sample accuracy of predicting the weight-lifting activities using classe as our response variable. We resample here as well from within the training data to obtain confusion matrix results for each caret model.

We estimate in-sample error using the model’s accuracy when resampling from within the training data, and out-of-sample error using the model’s accuracy when comparing the training data to the test data. All of the percent accuracy numbers quoted in this summary are for a Random Forest model, and we have the same results for three other models (Decision Tree, Bagged Trees and SVMpoly) in the body of the analysis. The estimates for in-sample error using the model’s accuracy are in the appendix, and the estimates for out-of-sample error using the model’s accuracy are in the three cycles of analysis in the main body of this work.

From the appendix, our in-sample error results for the Random Forest model are:

77.5 percent when using only the time-aggregated predictors.
84.8 percent when using only the unaggregated predictors, for all fields
81.8 percent when using only the unaggregated predictors, for all fields minus the highly correlated fields.
After we perform all of the steps previously outlined and contained here in an appendix, we have four caret models we want to apply on the test data in two cycles:

- In the first cycle, we use all predictors. We obtain predictions for classe for the 20 events in the test data. We estimate that the out of sample error will be close to the in-sample error (approximately 84.8 percent mean accuracy for a Random Forest model using the unaggregate time data). We find the mean accuracy for a Random Forest model to be 79.3 percent using all predictors.
- In the second and cycle, we use only the predictors that have less than 0.75 correlation, based on our cross-validation analysis described in the appendix. We expect the out of sample error will be close to the in-sample error (approximately 81.8 percent mean accuracy for a Random Forest model using the unaggregate time data). We find the mean accuracy for a Random Forest model to be 76.0 percent using only the least-correlated predictors. We expected this accuracy to be higher than the accuracy when using all predictors. - In the third and last cycle, We find the mean accuracy for a Random Forest model to be 77.3 using only the top 20 least-correlated predictors. We expected this accuracy to be higher than the accuracy when using all predictors. We subtract one predictor at a time for four additional accuracy measurements and find that the accuracy is 78.8 percent minus one predictor, 76.8 percent minus two predictors, 76.8 percent minus three predictors, and 77.3 percent minus four predictors.

From these three cycles of analysis, our out-of-sample error results for the Random Forest model are:

79.3 percent when using only the unaggregated predictors, for all fields
76.0 percent when using only the unaggregated predictors, for all fields minus the highly correlated fields. -Within the range between 76.8 percent and 78.8 percent when using only the top 20 unaggregated predictors, and subtracting one field at a time based on the accuracy results of the top 20 model four times.

# Analysis Conclusion

We present our conclusion here for the benefit of the Coursera graders. The rest of this analysis has all of the supporting work for this conclusion. We find the in-sample error to be slightly lower than the out-of-sample error. We also find all of the error measurements, using model accuracy as a proxy, to be in the range from the higher 70s percents to the lower 80s percents. Our predictor selection did not change the accuracy results significantly. We attribute this result to a high level of noise in the data, and many missing fields.
