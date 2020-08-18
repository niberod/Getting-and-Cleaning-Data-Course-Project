library(tidyverse)


##########features#########
#read tfeatures.txt
features <- read_table2("features.txt", 
                      col_names = FALSE) 

##########activity labels#########
#read activity_labels
activity_labels<-read_table2("activity_labels.txt", 
                          col_names = FALSE)

###########test database###########

#read the X_test database
X_test <- read_table2("test/X_test.txt", 
                      col_names = FALSE)

#use features as the colnames in X_test
names(X_test)<-features$X2

#read y_test and rename the variable to activity
Y_test <-read_table2("test/y_test.txt", 
                     col_names = FALSE) %>% 
    rename(Activity=X1)


#read subject_test and rename the variable to subject_id
subject_test <- read_table2("test/subject_test.txt", 
                             col_names = FALSE) %>% 
    rename(subject_id=X1)


#bind the subject_id and activity columns to X_test 
X_test<-X_test %>% 
    bind_cols(subject_test,
              Y_test #bind the subject_id and activity columns to X_test 
    ) %>% 
    select(subject_id,
           Activity,
           contains("mean"),
           contains("std") #I select only the variables with means and std, and the subject_id and activity variables
    ) %>% 
    mutate(
        Activity=factor(
            .$Activity,
            levels = activity_labels$X1,
            labels = activity_labels$X2
        ), # i change to factor the Activity variable, using the names in activity_labels
        database="test" #I create a database variable in order to know what data is from the test dataset
    )

###########train database###########

#read the X_train database
X_train <- read_table2("train/X_train.txt", 
                      col_names = FALSE)

#use features as the colnames in X_train
names(X_train)<-features$X2

#read y_train and rename the variable to activity
Y_train <-read_table2("train/y_train.txt", 
                     col_names = FALSE)%>% 
    rename(Activity=X1)


#read subject_train and rename the variable to subject_id
subject_train <- read_table2("train/subject_train.txt", 
                             col_names = FALSE) %>% 
    rename(subject_id=X1)




X_train<-X_train %>% 
    bind_cols(subject_train,
              Y_train #bind the subject_id and activity columns to X_train 
              ) %>% 
    select(subject_id,
        Activity,
           contains("mean"),
           contains("std") #I select only the variables with means and std, and the subject_id and activity variables
    ) %>% 
    mutate(
        Activity=factor(
            .$Activity,
            levels = activity_labels$X1,
            labels = activity_labels$X2 # i change to factor the Activity variable, using the names in activity_labels
        ),
        database="train" #I create a database variable in order to know what data is from the train dataset
    )


#####Merge test and train datasets

#I control whether the databases have the same columns or not (it should be TRUE)
all.equal(colnames(X_test),colnames(X_train))

#The result of the former command is TRUE, so I bind the rows of both datasets
samsung_tidy_dataset<-
    X_test %>% 
    bind_rows(
        X_train
    )


#I remove the objects that I don't longer need
rm(features,
   activity_labels,
   subject_test,
   subject_train,
   Y_test,
   Y_train,
   X_test,
   X_train)

#I save the merge dataset
samsung_tidy_dataset %>%
saveRDS("samsung_tidy_dataset.RDS")

####average_dataset#####

#obtaining the means of all variables by subject and activity
average_dataset<-samsung_tidy_dataset %>% 
    group_by(subject_id,Activity) %>% #I group by these variables
    summarise_at(vars(-group_cols()),mean,na.rm=T) %>% #I calculate the mean for the rest of the variables
    ungroup() # I ungroup after the summarise

#I save the average dataset
average_dataset %>% 
    saveRDS("average_dataset.RDS")

