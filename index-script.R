
library(tidyverse)
library(caret)
library(knitr)
set.seed(22)

## Time Series (Not Aggregated over Time) Data

training_all <- read.csv("./data/pml-training.csv")
training_all_data <- select(training_all, c("user_name",
   "raw_timestamp_part_1","raw_timestamp_part_2",
   "cvtd_timestamp","new_window","num_window","roll_belt",
   "pitch_belt","yaw_belt","total_accel_belt","gyros_belt_x",
   "gyros_belt_y","gyros_belt_z","accel_belt_x","accel_belt_y",
   "accel_belt_z","magnet_belt_x","magnet_belt_y",
   "magnet_belt_z","roll_arm","pitch_arm","yaw_arm",
   "total_accel_arm","gyros_arm_x","gyros_arm_y",
   "gyros_arm_z","accel_arm_x","accel_arm_y","accel_arm_z",
   "magnet_arm_x","magnet_arm_y","magnet_arm_z","roll_dumbbell",
   "pitch_dumbbell","yaw_dumbbell","total_accel_dumbbell",
   "gyros_dumbbell_x","gyros_dumbbell_y","gyros_dumbbell_z",
   "accel_dumbbell_x","accel_dumbbell_y","accel_dumbbell_z",                                                    "magnet_dumbbell_x","magnet_dumbbell_y","magnet_dumbbell_z",
   "roll_forearm","pitch_forearm","yaw_forearm",
   "total_accel_forearm","gyros_forearm_x",
   "gyros_forearm_y","gyros_forearm_z","accel_forearm_x",
   "accel_forearm_y","accel_forearm_z","magnet_forearm_x",
   "magnet_forearm_y","magnet_forearm_z","classe"))


training_all_clean <- read.csv("./data/pml-training.csv",
                               na.strings = c("NA","NaN","","#DIV/0!"))
training_nonblanks_clean <- filter(training_all_clean, kurtosis_roll_belt != "")
training_nonblanks_clean <- mutate(training_nonblanks_clean, 
                                   rel_time = as.numeric(paste(raw_timestamp_part_1,
                                                               raw_timestamp_part_2,sep=".")))


training_nonblanks_clean <- select(training_nonblanks_clean, 
                                   c("roll_belt", "pitch_belt", "yaw_belt", "total_accel_belt", 
                                     "gyros_belt_x", "gyros_belt_y", "gyros_belt_z", "accel_belt_x",
                                     "accel_belt_y", "accel_belt_z", "magnet_belt_x", 
                                     "magnet_belt_y", "magnet_belt_z", "roll_arm", "pitch_arm", "yaw_arm",
                                     "accel_belt_y", "accel_belt_z", "magnet_belt_x", 
                                     "magnet_arm_y", "magnet_arm_z", "roll_dumbbell", "pitch_dumbbell", "yaw_dumbbell",
                                     "total_accel_dumbbell", "gyros_dumbbell_x", "gyros_dumbbell_y",
                                     "gyros_dumbbell_z", "accel_dumbbell_x", "accel_dumbbell_y", 
                                     "accel_dumbbell_z", "magnet_dumbbell_x", "magnet_dumbbell_y",
                                     "magnet_dumbbell_z", "roll_forearm", "pitch_forearm", "yaw_forearm",
                                     "total_accel_forearm", "gyros_forearm_x", "gyros_forearm_y", "gyros_forearm_z", 
                                     "accel_forearm_x", "accel_forearm_y",
                                     "accel_forearm_z", "magnet_forearm_x", "magnet_forearm_y", 
                                     "magnet_forearm_z", "classe"))



testing_all_clean <- read.csv("./data/pml-testing.csv")
testing_nonblanks_clean <- mutate(testing_all_clean, 
                                  rel_time = as.numeric(paste(raw_timestamp_part_1,
                                                              raw_timestamp_part_2,sep=".")))

testing_nonblanks_clean <- select(testing_nonblanks_clean, 
                                  c("roll_belt", "pitch_belt", "yaw_belt", "total_accel_belt", 
                                    "gyros_belt_x", "gyros_belt_y", "gyros_belt_z", "accel_belt_x",
                                    "accel_belt_y", "accel_belt_z", "magnet_belt_x", 
                                    "magnet_belt_y", "magnet_belt_z", "roll_arm", "pitch_arm", "yaw_arm",
                                    "accel_belt_y", "accel_belt_z", "magnet_belt_x", 
                                    "magnet_belt_y", "magnet_belt_z", "roll_arm", "pitch_arm", "yaw_arm",
                                    "magnet_arm_y", "magnet_arm_z", "roll_dumbbell", "pitch_dumbbell", "yaw_dumbbell",
                                    "total_accel_dumbbell", "gyros_dumbbell_x", "gyros_dumbbell_y",
                                    "gyros_dumbbell_z", "accel_dumbbell_x", "accel_dumbbell_y", 
                                    "accel_dumbbell_z", "magnet_dumbbell_x", "magnet_dumbbell_y",
                                    "magnet_dumbbell_z", "roll_forearm", "pitch_forearm", "yaw_forearm",
                                    "total_accel_forearm", "gyros_forearm_x", "gyros_forearm_y", "gyros_forearm_z", 
                                    "accel_forearm_x", "accel_forearm_y",
                                    "accel_forearm_z", "magnet_forearm_x", "magnet_forearm_y", 
                                    "magnet_forearm_z", "problem_id"))

training_blanks_cv <- select(training_all, c("roll_belt",
                                             "pitch_belt","yaw_belt","total_accel_belt","gyros_belt_x",
                                             "gyros_belt_y","gyros_belt_z","accel_belt_x","accel_belt_y",
                                             "accel_belt_z","magnet_belt_x","magnet_belt_y",
                                             "magnet_belt_z","roll_arm","pitch_arm","yaw_arm",
                                             "total_accel_arm","gyros_arm_x","gyros_arm_y",
                                             "gyros_arm_z","accel_arm_x","accel_arm_y","accel_arm_z",
                                             "magnet_arm_x","magnet_arm_y","magnet_arm_z","roll_dumbbell",
                                             "pitch_dumbbell","yaw_dumbbell","total_accel_dumbbell",
                                             "gyros_dumbbell_x","gyros_dumbbell_y","gyros_dumbbell_z",
                                             "accel_dumbbell_x","accel_dumbbell_y","accel_dumbbell_z",
                                             "magnet_dumbbell_x","magnet_dumbbell_y","magnet_dumbbell_z",
                                             "roll_forearm","pitch_forearm","yaw_forearm",
                                             "total_accel_forearm","gyros_forearm_x",
                                             "gyros_forearm_y","gyros_forearm_z","accel_forearm_x",
                                             "accel_forearm_y","accel_forearm_z","magnet_forearm_x",
                                             "magnet_forearm_y","magnet_forearm_z","classe"))

set.seed(22)
controlTS <- rfeControl(functions=rfFuncs, method="repeatedcv", number=3)

correlationMatrixTS <- cor(training_nonblanks_clean[,1:44], use="complete.obs")
highlyCorrelatedTS75 <- findCorrelation(correlationMatrixTS, cutoff=0.75)
names(training_nonblanks_clean[,highlyCorrelatedTS75])

resultsTS <- rfe(training_nonblanks_clean[,1:44], 
                 training_nonblanks_clean$classe, sizes=c(1:20), rfeControl=controlTS)
print(resultsTS)

predictors(resultsTS)
plot(resultsTS, type=c("g", "o"))


## Running the training model on the test data for Random Forests (all fields) 

TcontrolTS <- trainControl(method="repeatedcv", number=10)
modelTSrf <- train(factor(classe) ~ ., data=training_nonblanks_clean, 
                   method="rf", preProcess=c("scale","center"), 
                   trControl=TcontrolTS, na.action=na.pass)
importanceTSrf <- varImp(modelTSrf, scale=TRUE)
print(importanceTSrf)

predictrf <- predict(modelTSrf,newdata=testing_nonblanks_clean)
predictrf


## Running the training model on the test data for Decision Trees (all fields) 

modelTSC50 <- train(factor(classe) ~ ., data=training_nonblanks_clean, 
                    method="C5.0", preProcess=c("scale","center"), 
                    trControl=TcontrolTS, na.action=na.pass)
importanceTSC50 <- varImp(modelTSC50, scale=TRUE)
print(importanceTSC50)

predictC50 <- predict(modelTSC50,newdata=testing_nonblanks_clean)
predictC50



## Running the training model on the test data for Bagged Trees (all fields) 


modelTStreebag <- train(factor(classe) ~ ., data=training_nonblanks_clean, 
                        method="treebag", preProcess=c("scale","center"), 
                        trControl=TcontrolTS, na.action=na.pass)
importanceTStreebag <- varImp(modelTStreebag, scale=TRUE)
print(importanceTStreebag)

predicttreebag <- predict(modelTStreebag,newdata=testing_nonblanks_clean)
predicttreebag



## Running the training model on the test data for SVM Polynomial Kernel (all fields) 

set.seed(22)
modelTSsvmPoly <- train(factor(classe) ~ ., data=training_nonblanks_clean, 
                        method="svmPoly", preProcess=c("scale","center"), 
                        trControl=TcontrolTS, na.action=na.pass)
importanceTSsvmPoly <- varImp(modelTSsvmPoly, scale=TRUE)
print(importanceTSsvmPoly)

predictsvmPoly <- predict(modelTSsvmPoly,newdata=testing_nonblanks_clean)
predictsvmPoly


## all models

allModelsall <- resamples(list(SVMPoly=modelTSsvmPoly, 
                               DecisionTree=modelTSC50, 
                               RandomForest=modelTSrf, 
                               BaggedTrees=modelTStreebag
))
summary(allModelsall)

bwplot(allModelsall)

require(knitr)
predictTableall <- cbind(testing_nonblanks_clean$problem_id,
                         predictrf,predictC50,predicttreebag,predictsvmPoly)
kable(predictTableall)

###################### section two
#Explain use of minus highly correlated fields
## Running the training model on the test data for Random Forests (minus highly correlated fields) 


modelTSselrf <- train(factor(classe) ~ pitch_belt + yaw_belt + gyros_belt_x + 
                        gyros_belt_y + gyros_belt_z +   
                        magnet_belt_y + magnet_belt_z + roll_arm + pitch_arm + yaw_arm + 
                        accel_belt_y + accel_belt_z + magnet_belt_x +  magnet_arm_y + roll_dumbbell + 
                        pitch_dumbbell + yaw_dumbbell + total_accel_dumbbell + gyros_dumbbell_x + 
                        gyros_dumbbell_y + gyros_dumbbell_z +  magnet_dumbbell_z + roll_forearm + 
                        pitch_forearm + yaw_forearm + total_accel_forearm + gyros_forearm_x + 
                        gyros_forearm_y + gyros_forearm_z +  accel_forearm_x + accel_forearm_z + 
                        magnet_forearm_x + magnet_forearm_y + 
                        magnet_forearm_z, data=training_nonblanks_clean, 
                      method="rf", preProcess=c("scale","center"), 
                      trControl=TcontrolTS, na.action=na.pass)
importanceTSselrf <- varImp(modelTSselrf, scale=TRUE)
print(importanceTSselrf)

predictselrf <- predict(modelTSselrf,newdata=testing_nonblanks_clean)
predictselrf


## Running the training model on the test data for Decision Trees (minus highly correlated fields) 

modelTSselC50 <- train(factor(classe) ~ pitch_belt + yaw_belt + gyros_belt_x + gyros_belt_y + gyros_belt_z +   
                         magnet_belt_y + magnet_belt_z + roll_arm + pitch_arm + yaw_arm + 
                         accel_belt_y + accel_belt_z + magnet_belt_x +  magnet_arm_y + roll_dumbbell + 
                         pitch_dumbbell + yaw_dumbbell + total_accel_dumbbell + gyros_dumbbell_x + 
                         gyros_dumbbell_y + gyros_dumbbell_z +  magnet_dumbbell_z + roll_forearm + 
                         pitch_forearm + yaw_forearm + total_accel_forearm + gyros_forearm_x + 
                         gyros_forearm_y + gyros_forearm_z +  accel_forearm_x + accel_forearm_z + 
                         magnet_forearm_x + magnet_forearm_y + 
                         magnet_forearm_z, data=training_nonblanks_clean, 
                       method="C5.0", preProcess=c("scale","center"), 
                       trControl=TcontrolTS, na.action=na.pass)
importanceTSselC50 <- varImp(modelTSselC50, scale=TRUE)
print(importanceTSselC50)

predictselC50 <- predict(modelTSselC50,newdata=testing_nonblanks_clean)
predictselC50



## Running the training model on the test data for Bagged Trees (minus highly correlated fields) 


modelTSseltreebag <- train(factor(classe) ~ pitch_belt + yaw_belt + 
                             gyros_belt_x + gyros_belt_y + gyros_belt_z +   
                             magnet_belt_y + magnet_belt_z + roll_arm + pitch_arm + yaw_arm + 
                             accel_belt_y + accel_belt_z + magnet_belt_x +  magnet_arm_y + roll_dumbbell + 
                             pitch_dumbbell + yaw_dumbbell + total_accel_dumbbell + gyros_dumbbell_x + 
                             gyros_dumbbell_y + gyros_dumbbell_z +  magnet_dumbbell_z + roll_forearm + 
                             pitch_forearm + yaw_forearm + total_accel_forearm + gyros_forearm_x + 
                             gyros_forearm_y + gyros_forearm_z +  accel_forearm_x + accel_forearm_z + 
                             magnet_forearm_x + magnet_forearm_y + 
                             magnet_forearm_z, data=training_nonblanks_clean, 
                           method="treebag", preProcess=c("scale","center"), 
                           trControl=TcontrolTS, na.action=na.pass)
importanceTSseltreebag <- varImp(modelTSseltreebag, scale=TRUE)
print(importanceTSseltreebag)

predictseltreebag <- predict(modelTSseltreebag,newdata=testing_nonblanks_clean)
predictseltreebag


## Running the training model on the test data for SVM Polynomial Kernel (minus highly correlated fields) 


modelTSselsvmPoly <- train(factor(classe) ~ pitch_belt + yaw_belt + gyros_belt_x + 
                             gyros_belt_y + gyros_belt_z +   
                             magnet_belt_y + magnet_belt_z + roll_arm + pitch_arm + yaw_arm + 
                             accel_belt_y + accel_belt_z + magnet_belt_x +  magnet_arm_y + roll_dumbbell + 
                             pitch_dumbbell + yaw_dumbbell + total_accel_dumbbell + gyros_dumbbell_x + 
                             gyros_dumbbell_y + gyros_dumbbell_z +  magnet_dumbbell_z + roll_forearm + 
                             pitch_forearm + yaw_forearm + total_accel_forearm + gyros_forearm_x + 
                             gyros_forearm_y + gyros_forearm_z +  accel_forearm_x + accel_forearm_z + 
                             magnet_forearm_x + magnet_forearm_y + 
                             magnet_forearm_z, data=training_nonblanks_clean, 
                           method="svmPoly", preProcess=c("scale","center"), 
                           trControl=TcontrolTS, na.action=na.pass)
importanceTSselsvmPoly <- varImp(modelTSselsvmPoly, scale=TRUE)
print(importanceTSselsvmPoly)

predictselsvmPoly <- predict(modelTSselsvmPoly,newdata=testing_nonblanks_clean)
predictselsvmPoly



## all models

allModelssel <- resamples(list(SVMPoly=modelTSselsvmPoly, 
                               DecisionTree=modelTSselC50, 
                               RandomForest=modelTSselrf, 
                               BaggedTrees=modelTSseltreebag
))
summary(allModelssel)

bwplot(allModelssel)


Text

require(knitr)
predictTable <- cbind(testing_nonblanks_clean$problem_id,
                      predictselrf,predictselC50,predictseltreebag,predictselsvmPoly)
kable(predictTable)


###################### subtract fields











## Appendix: Time Series Exploratory Data Analysis


trg_data <- mutate(training_all_data, rel_time = as.numeric(paste(raw_timestamp_part_1,
                                                                  raw_timestamp_part_2,sep=".")))

trg_adelmo_A <- filter(trg_data,user_name == "adelmo" & classe == "A")
trg_adelmo_B <- filter(trg_data,user_name == "adelmo" & classe == "B")
trg_adelmo_C <- filter(trg_data,user_name == "adelmo" & classe == "C")
trg_adelmo_D <- filter(trg_data,user_name == "adelmo" & classe == "D")
trg_adelmo_E <- filter(trg_data,user_name == "adelmo" & classe == "E")

trg_data_adelmo_A_left <- mutate(trg_adelmo_A, time_left = rel_time - min(rel_time))
trg_data_adelmo_B_left <- mutate(trg_adelmo_B, time_left = rel_time - min(rel_time))
trg_data_adelmo_C_left <- mutate(trg_adelmo_C, time_left = rel_time - min(rel_time))
trg_data_adelmo_D_left <- mutate(trg_adelmo_D, time_left = rel_time - min(rel_time))
trg_data_adelmo_E_left <- mutate(trg_adelmo_E, time_left = rel_time - min(rel_time))

trg_carlitos_A <- filter(trg_data,user_name == "carlitos" & classe == "A")
trg_carlitos_B <- filter(trg_data,user_name == "carlitos" & classe == "B")
trg_carlitos_C <- filter(trg_data,user_name == "carlitos" & classe == "C")
trg_carlitos_D <- filter(trg_data,user_name == "carlitos" & classe == "D")
trg_carlitos_E <- filter(trg_data,user_name == "carlitos" & classe == "E")

trg_data_carlitos_A_left <- mutate(trg_carlitos_A, time_left = rel_time - min(rel_time))
trg_data_carlitos_B_left <- mutate(trg_carlitos_B, time_left = rel_time - min(rel_time))
trg_data_carlitos_C_left <- mutate(trg_carlitos_C, time_left = rel_time - min(rel_time))
trg_data_carlitos_D_left <- mutate(trg_carlitos_D, time_left = rel_time - min(rel_time))
trg_data_carlitos_E_left <- mutate(trg_carlitos_E, time_left = rel_time - min(rel_time))

trg_charles_A <- filter(trg_data,user_name == "charles" & classe == "A")
trg_charles_B <- filter(trg_data,user_name == "charles" & classe == "B")
trg_charles_C <- filter(trg_data,user_name == "charles" & classe == "C")
trg_charles_D <- filter(trg_data,user_name == "charles" & classe == "D")
trg_charles_E <- filter(trg_data,user_name == "charles" & classe == "E")

trg_data_charles_A_left <- mutate(trg_charles_A, time_left = rel_time - min(rel_time))
trg_data_charles_B_left <- mutate(trg_charles_B, time_left = rel_time - min(rel_time))
trg_data_charles_C_left <- mutate(trg_charles_C, time_left = rel_time - min(rel_time))
trg_data_charles_D_left <- mutate(trg_charles_D, time_left = rel_time - min(rel_time))
trg_data_charles_E_left <- mutate(trg_charles_E, time_left = rel_time - min(rel_time))

trg_eurico_A <- filter(trg_data,user_name == "eurico" & classe == "A")
trg_eurico_B <- filter(trg_data,user_name == "eurico" & classe == "B")
trg_eurico_C <- filter(trg_data,user_name == "eurico" & classe == "C")
trg_eurico_D <- filter(trg_data,user_name == "eurico" & classe == "D")
trg_eurico_E <- filter(trg_data,user_name == "eurico" & classe == "E")

trg_data_eurico_A_left <- mutate(trg_eurico_A, time_left = rel_time - min(rel_time))
trg_data_eurico_B_left <- mutate(trg_eurico_B, time_left = rel_time - min(rel_time))
trg_data_eurico_C_left <- mutate(trg_eurico_C, time_left = rel_time - min(rel_time))
trg_data_eurico_D_left <- mutate(trg_eurico_D, time_left = rel_time - min(rel_time))
trg_data_eurico_E_left <- mutate(trg_eurico_E, time_left = rel_time - min(rel_time))

trg_jeremy_A <- filter(trg_data,user_name == "jeremy" & classe == "A")
trg_jeremy_B <- filter(trg_data,user_name == "jeremy" & classe == "B")
trg_jeremy_C <- filter(trg_data,user_name == "jeremy" & classe == "C")
trg_jeremy_D <- filter(trg_data,user_name == "jeremy" & classe == "D")
trg_jeremy_E <- filter(trg_data,user_name == "jeremy" & classe == "E")

trg_data_jeremy_A_left <- mutate(trg_jeremy_A, time_left = rel_time - min(rel_time))
trg_data_jeremy_B_left <- mutate(trg_jeremy_B, time_left = rel_time - min(rel_time))
trg_data_jeremy_C_left <- mutate(trg_jeremy_C, time_left = rel_time - min(rel_time))
trg_data_jeremy_D_left <- mutate(trg_jeremy_D, time_left = rel_time - min(rel_time))
trg_data_jeremy_E_left <- mutate(trg_jeremy_E, time_left = rel_time - min(rel_time))

trg_pedro_A <- filter(trg_data,user_name == "pedro" & classe == "A")
trg_pedro_B <- filter(trg_data,user_name == "pedro" & classe == "B")
trg_pedro_C <- filter(trg_data,user_name == "pedro" & classe == "C")
trg_pedro_D <- filter(trg_data,user_name == "pedro" & classe == "D")
trg_pedro_E <- filter(trg_data,user_name == "pedro" & classe == "E")

trg_data_pedro_A_left <- mutate(trg_pedro_A, time_left = rel_time - min(rel_time))
trg_data_pedro_B_left <- mutate(trg_pedro_B, time_left = rel_time - min(rel_time))
trg_data_pedro_C_left <- mutate(trg_pedro_C, time_left = rel_time - min(rel_time))
trg_data_pedro_D_left <- mutate(trg_pedro_D, time_left = rel_time - min(rel_time))
trg_data_pedro_E_left <- mutate(trg_pedro_E, time_left = rel_time - min(rel_time))

par(mfrow=c(2,2))
plot(trg_data_adelmo_A_left$time_left,trg_data_adelmo_A_left$roll_belt,
     main="Belt Roll for Adelmo", xlab="A sequence (seconds)", ylab="Belt Roll (degrees)")
plot(trg_data_carlitos_A_left$time_left,trg_data_carlitos_A_left$roll_belt,
     main="Belt Roll for Carlitos", xlab="A sequence (seconds)", ylab="Belt Roll (degrees)")
plot(trg_data_adelmo_E_left$time_left,trg_data_adelmo_E_left$roll_belt,
     main="Belt Roll for Adelmo", xlab="E sequence (seconds)", ylab="Belt Roll (degrees)")
plot(trg_data_carlitos_E_left$time_left,trg_data_carlitos_E_left$roll_belt,
     main="Belt Roll for Carlitos", xlab="E sequence (seconds)", ylab="Belt Roll (degrees)")



## Appendix: Aggregated Time Bin Data

training_nonblanks_clean_time <- filter(training_all_clean, kurtosis_roll_belt != "")
training_sdvar_sel_clean_all <- select(training_nonblanks_clean_time,c("user_name",
                                                                  "classe","raw_timestamp_part_1","raw_timestamp_part_2","cvtd_timestamp",
                                                                  "new_window","num_window","kurtosis_roll_belt","kurtosis_picth_belt",
                                                                  "skewness_roll_belt",
                                                                  "skewness_roll_belt.1","max_roll_belt","max_picth_belt",
                                                                  "max_yaw_belt","min_roll_belt","min_pitch_belt","min_yaw_belt","amplitude_roll_belt",
                                                                  "amplitude_pitch_belt","var_total_accel_belt","avg_roll_belt",
                                                                  "stddev_roll_belt","var_roll_belt","avg_pitch_belt","stddev_pitch_belt","var_pitch_belt",
                                                                  "avg_yaw_belt","stddev_yaw_belt","var_yaw_belt","var_accel_arm","avg_roll_arm",
                                                                  "stddev_roll_arm","var_roll_arm","avg_pitch_arm","stddev_pitch_arm","var_pitch_arm",
                                                                  "avg_yaw_arm","stddev_yaw_arm","var_yaw_arm","kurtosis_roll_arm","kurtosis_picth_arm",
                                                                  "kurtosis_yaw_arm","skewness_roll_arm","skewness_pitch_arm","skewness_yaw_arm",
                                                                  "max_roll_arm","max_picth_arm","max_yaw_arm","min_roll_arm","min_pitch_arm",
                                                                  "min_yaw_arm","amplitude_roll_arm","amplitude_pitch_arm","amplitude_yaw_arm",
                                                                  "kurtosis_roll_dumbbell","kurtosis_picth_dumbbell",
                                                                  "skewness_roll_dumbbell","skewness_pitch_dumbbell",
                                                                  "max_roll_dumbbell","max_picth_dumbbell","max_yaw_dumbbell","min_roll_dumbbell",
                                                                  "min_pitch_dumbbell","min_yaw_dumbbell","amplitude_roll_dumbbell","amplitude_pitch_dumbbell",
                                                                  "total_accel_dumbbell","var_accel_dumbbell","avg_roll_dumbbell",
                                                                  "stddev_roll_dumbbell","var_roll_dumbbell","avg_pitch_dumbbell","stddev_pitch_dumbbell",
                                                                  "var_pitch_dumbbell","avg_yaw_dumbbell","stddev_yaw_dumbbell","var_yaw_dumbbell",
                                                                  "kurtosis_roll_forearm","kurtosis_picth_forearm",
                                                                  "skewness_roll_forearm","skewness_pitch_forearm",
                                                                  "max_roll_forearm","max_picth_forearm","max_yaw_forearm","min_roll_forearm",
                                                                  "min_pitch_forearm","min_yaw_forearm","amplitude_roll_forearm","amplitude_pitch_forearm",
                                                                  "total_accel_forearm","var_accel_forearm","avg_roll_forearm",
                                                                  "stddev_roll_forearm","var_roll_forearm","avg_pitch_forearm","stddev_pitch_forearm",
                  "var_pitch_forearm","avg_yaw_forearm","stddev_yaw_forearm","var_yaw_forearm"))

kable(table(training_sdvar_sel_clean_all$user_name, training_sdvar_sel_clean_all$classe))


## Appendix: Time Bin Exploratory Data Analysis

training_sdvar_sel_clean_all_A <- filter(training_sdvar_sel_clean_all, classe == "A")
training_sdvar_sel_clean_all_B <- filter(training_sdvar_sel_clean_all, classe == "B")
training_sdvar_sel_clean_all_C <- filter(training_sdvar_sel_clean_all, classe == "C")
training_sdvar_sel_clean_all_D <- filter(training_sdvar_sel_clean_all, classe == "D")
training_sdvar_sel_clean_all_E <- filter(training_sdvar_sel_clean_all, classe == "E")

par(mfrow=c(2,2))
plot(training_sdvar_sel_clean_all_A$avg_roll_dumbbell,training_sdvar_sel_clean_all_A$stddev_roll_belt,
     main="Low Correlation Example A sequence", xlab="Avg Roll of the Dumbell (degrees)", 
     ylab="Std Dev of the Belt Roll (degrees)")
plot(training_sdvar_sel_clean_all_A$avg_yaw_belt,training_sdvar_sel_clean_all_A$min_pitch_dumbbell,
     main="High Correlation Example A sequence", xlab="Avg Yaw of the Belt (degrees)", 
     ylab="Min Pitch of the Dumbbell (degrees)")
plot(training_sdvar_sel_clean_all_C$avg_roll_dumbbell,training_sdvar_sel_clean_all_C$stddev_roll_belt,
     main="Low Correlation Example C sequence", xlab="Avg Roll of the Dumbell (degrees)", 
     ylab="Std Dev of the Belt Roll (degrees)")
plot(training_sdvar_sel_clean_all_C$avg_yaw_belt,training_sdvar_sel_clean_all_C$min_pitch_dumbbell,
     main="High Correlation Example C sequence", xlab="Avg Yaw of the Belt (degrees)", 
     ylab="Min Pitch of the Dumbbell (degrees)")



## Appendix: Time Bin Feature Selection


training_sdvar_cor <- training_sdvar_sel_clean_all[,8:100]
correlationMatrixSDVAR <- cor(training_sdvar_sel_clean_all[,8:100], use="complete.obs")
highlyCorrelatedSDVAR75 <- findCorrelation(correlationMatrixSDVAR, cutoff=0.75)
names(training_sdvar_cor[,highlyCorrelatedSDVAR75])

training_sdvar_sel_clean <- select(training_sdvar_sel_clean_all,c("user_name",
        "classe","raw_timestamp_part_1","raw_timestamp_part_2","cvtd_timestamp",
        "new_window","num_window","kurtosis_roll_belt","skewness_roll_belt",
        "skewness_roll_belt.1","min_roll_belt",
        "var_roll_belt","avg_pitch_belt","var_pitch_belt",
        "var_yaw_belt","var_accel_arm","avg_roll_arm",
        "stddev_roll_arm","avg_pitch_arm","var_pitch_arm",
        "avg_yaw_arm","var_yaw_arm","kurtosis_roll_arm","kurtosis_picth_arm",
        "kurtosis_yaw_arm","skewness_roll_arm","skewness_pitch_arm","skewness_yaw_arm",
        "max_yaw_arm","min_yaw_arm","kurtosis_picth_dumbbell",
        "skewness_roll_dumbbell","skewness_pitch_dumbbell",
        "max_roll_dumbbell","max_picth_dumbbell","min_roll_dumbbell",
        "min_yaw_dumbbell","total_accel_dumbbell","var_accel_dumbbell","avg_roll_dumbbell",
        "var_roll_dumbbell","avg_pitch_dumbbell","stddev_pitch_dumbbell",
        "var_pitch_dumbbell","var_yaw_dumbbell","kurtosis_picth_forearm",
        "skewness_roll_forearm","skewness_pitch_forearm",
        "max_picth_forearm","min_roll_forearm","min_pitch_forearm",
        "total_accel_forearm","var_accel_forearm","avg_roll_forearm","var_roll_forearm",
        "var_pitch_forearm","avg_yaw_forearm","var_yaw_forearm"))


str(training_sdvar_cor_classe_noNA)


training_sdvar_cor_classe_noNA <- na.omit(training_sdvar_sel_clean)
controlSDVAR2 <- rfeControl(functions=rfFuncs, method="cv", number=10)
resultsSDVAR2 <- rfe(training_sdvar_cor_classe_noNA[,8:58], 
                     training_sdvar_cor_classe_noNA$classe, sizes=c(1:30), rfeControl=controlSDVAR2)
print(resultsSDVAR2)


predictors(resultsSDVAR2)
plot(resultsSDVAR2, type=c("g", "o"))


## Appendix: Caret Models Applied to the Aggregated Training Data

training_sdvar_cor_classe_noNA_A <- filter(training_sdvar_cor_classe_noNA, classe == "A")
training_sdvar_cor_classe_noNA_B <- filter(training_sdvar_cor_classe_noNA, classe == "B")
training_sdvar_cor_classe_noNA_C <- filter(training_sdvar_cor_classe_noNA, classe == "C")
training_sdvar_cor_classe_noNA_D <- filter(training_sdvar_cor_classe_noNA, classe == "D")
training_sdvar_cor_classe_noNA_E <- filter(training_sdvar_cor_classe_noNA, classe == "E")

testing_sdvar_cor_classe_noNA_A <- sample_n(training_sdvar_cor_classe_noNA_A, 20, replace=FALSE)
testing_sdvar_cor_classe_noNA_B <- sample_n(training_sdvar_cor_classe_noNA_B, 20, replace=FALSE)
testing_sdvar_cor_classe_noNA_C <- sample_n(training_sdvar_cor_classe_noNA_C, 20, replace=FALSE)
testing_sdvar_cor_classe_noNA_D <- sample_n(training_sdvar_cor_classe_noNA_D, 20, replace=FALSE)
testing_sdvar_cor_classe_noNA_E <- sample_n(training_sdvar_cor_classe_noNA_E, 20, replace=FALSE)

testing_sdvar_cor_classe_noNA <- rbind(testing_sdvar_cor_classe_noNA_A,
                                       testing_sdvar_cor_classe_noNA_B,
                                       testing_sdvar_cor_classe_noNA_C,
                                       testing_sdvar_cor_classe_noNA_D,
                                       testing_sdvar_cor_classe_noNA_E)

training_sdvar_cor_classe_noNA <- training_sdvar_cor_classe_noNA[,c(2,8:58)]
controlSDVAR <- trainControl(method="repeatedcv", number=10)


modelSDVARlvq <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                       method="lvq", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARlvq <- varImp(modelSDVARlvq, scale=TRUE)
print(importanceSDVARlvq)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARlvq,testing_sdvar_cor_classe_noNA))


#Here are the results for the Least Squares Support Vector Machines with Polynomial Kernel  (method="svmPoly" in caret train function) model.

modelSDVARsvmPoly <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                       method="svmPoly", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARsvmPoly <- varImp(modelSDVARsvmPoly, scale=TRUE)
print(importanceSDVARsvmPoly)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARsvmPoly,testing_sdvar_cor_classe_noNA))


## trees

modelSDVARC50 <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                        method="C5.0", 
                       preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARC50 <- varImp(modelSDVARC50, scale=TRUE)
print(importanceSDVARC50)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARC50,testing_sdvar_cor_classe_noNA))


## naive Bayes

modelSDVARnb <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                      method="nb", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARnb <- varImp(modelSDVARnb, scale=TRUE)
print(importanceSDVARnb)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARnb,testing_sdvar_cor_classe_noNA))



## rpart classification tree

modelSDVARrpart <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                         method="rpart", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARrpart <- varImp(modelSDVARrpart, scale=TRUE)
print(importanceSDVARrpart)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARrpart,testing_sdvar_cor_classe_noNA))


## random forest

modelSDVARrf <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                      method="rf", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARrf <- varImp(modelSDVARrf, scale=TRUE)
print(importanceSDVARrf)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARrf,testing_sdvar_cor_classe_noNA))


### bagged trees 

modelSDVARtreebag <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                           method="treebag", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARtreebag <- varImp(modelSDVARtreebag, scale=TRUE)
print(importanceSDVARtreebag)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARtreebag,testing_sdvar_cor_classe_noNA))


#### knn


modelSDVARknn <- train(factor(classe) ~ ., data=training_sdvar_cor_classe_noNA, 
                       method="knn", preProcess=c("scale","center"), trControl=controlSDVAR)
importanceSDVARknn <- varImp(modelSDVARknn, scale=TRUE)
print(importanceSDVARknn)
confusionMatrix(testing_sdvar_cor_classe_noNA$classe,
                predict(modelSDVARknn,testing_sdvar_cor_classe_noNA))



## all models

allModels <- resamples(list(LVQ=modelSDVARlvq, SVMPoly=modelSDVARsvmPoly, 
                          DecisionTree=modelSDVARC50, 
                          NaiveBayes=modelSDVARnb, NeuralNet=modelSDVARnb,
                          ClassificationTree=modelSDVARrpart,
                          RandomForest=modelSDVARrf, 
                          BaggedTrees=modelSDVARtreebag
                          ))
summary(allModels)

#From these, we select 
# - Decision Tree
# - Random Forest
# - Bagged Trees 
# - SVMpoly 


bwplot(allModels)


## Appendix: Time Unaggregated Data Feature Selection

training_blanks_cv_A <- filter(training_blanks_cv, classe == "A")
training_blanks_cv_B <- filter(training_blanks_cv, classe == "B")
training_blanks_cv_C <- filter(training_blanks_cv, classe == "C")
training_blanks_cv_D <- filter(training_blanks_cv, classe == "D")
training_blanks_cv_E <- filter(training_blanks_cv, classe == "E")

training_blanks_cv_sample_A <- sample_n(training_blanks_cv_A, 100, replace=FALSE)
training_blanks_cv_sample_B <- sample_n(training_blanks_cv_B, 100, replace=FALSE)
training_blanks_cv_sample_C <- sample_n(training_blanks_cv_C, 100, replace=FALSE)
training_blanks_cv_sample_D <- sample_n(training_blanks_cv_D, 100, replace=FALSE)
training_blanks_cv_sample_E <- sample_n(training_blanks_cv_E, 100, replace=FALSE)

training_blanks_cv_sample <- rbind(training_blanks_cv_sample_A,
                                   training_blanks_cv_sample_B,
                                   training_blanks_cv_sample_C,
                                   training_blanks_cv_sample_D,
                                   training_blanks_cv_sample_E)

table(training_blanks_cv_sample$classe)


######


controlTSCV <- rfeControl(functions=rfFuncs, method="repeatedcv", number=3)

correlationMatrixTSCV <- cor(training_blanks_cv_sample[,1:52], use="complete.obs")
highlyCorrelatedTSCV75 <- findCorrelation(correlationMatrixTSCV, cutoff=0.75)
names(training_blanks_cv_sample[,highlyCorrelatedTSCV75])


#remove these
#"yaw_belt"         "accel_belt_x"     "accel_belt_z"     "roll_belt"        "pitch_belt"      
#"total_accel_belt" "accel_dumbbell_z" "accel_dumbbell_y" "accel_arm_x"      "accel_dumbbell_x"
#"accel_arm_z"      "magnet_arm_y"     "magnet_forearm_y" "gyros_arm_x"      "gyros_forearm_y" 

resultsTSCV <- rfe(training_blanks_cv_sample[,1:52], 
                 training_blanks_cv_sample$classe, sizes=c(1:30), rfeControl=controlTSCV)
print(resultsTSCV)

predictors(resultsTSCV)
plot(resultsTSCV, type=c("g", "o"))



############

modelTScvrf <- train(factor(classe) ~ ., data=training_blanks_cv_sample, 
                     method="rf", preProcess=c("scale","center"), 
                     trControl=TcontrolTS, na.action=na.pass)
importanceTSCVrf <- varImp(modelTScvrf, scale=TRUE)
print(importanceTSCVrf)

modelTScvC50 <- train(factor(classe) ~ ., data=training_blanks_cv_sample, 
                      method="C5.0", preProcess=c("scale","center"), 
                      trControl=TcontrolTS, na.action=na.pass)
importanceTSCVC50 <- varImp(modelTScvC50, scale=TRUE)
print(importanceTSCVC50)


## Running the training model on the test data for Bagged Trees (all fields) 

modelTScvtreebag <- train(factor(classe) ~ ., data=training_blanks_cv_sample, 
                          method="treebag", preProcess=c("scale","center"), 
                          trControl=TcontrolTS, na.action=na.pass)
importanceTSCVtreebag <- varImp(modelTScvtreebag, scale=TRUE)
print(importanceTSCVtreebag)



## Running the training model on the test data for SVM Polynomial Kernel (all fields) 


modelTScvsvmPoly <- train(factor(classe) ~ ., data=training_blanks_cv_sample, 
                          method="svmPoly", preProcess=c("scale","center"), 
                          trControl=TcontrolTS, na.action=na.pass)
importanceTSCVsvmPoly <- varImp(modelTScvsvmPoly, scale=TRUE)
print(importanceTSCVsvmPoly)



## all models

allModelscv <- resamples(list(SVMPoly=modelTScvsvmPoly, 
                               DecisionTree=modelTScvC50, 
                               RandomForest=modelTScvrf, 
                               BaggedTrees=modelTScvtreebag
))
summary(allModelscv)

bwplot(allModelscv)

