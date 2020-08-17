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

#read y_test
Y_test <-read_table2("test/y_test.txt", 
                     col_names = FALSE)



X_test<-X_test %>% 
    bind_cols(Y_test) %>% 
    select(Activity=X1,
           contains("mean"),
           contains("std") #I select only the variables with means and std
           ) %>% 
    mutate(
        Activity=factor(
            .$Activity,
            levels = activity_labels$X1,
            labels = activity_labels$X2
        ),
        database="test"
    )


###########train database###########

#read the X_train database
X_train <- read_table2("train/X_train.txt", 
                      col_names = FALSE)

#use features as the colnames in X_train
names(X_train)<-features$X2

#read y_train
Y_train <-read_table2("train/y_train.txt", 
                     col_names = FALSE)



X_train<-X_train %>% 
    bind_cols(Y_train) %>% 
    select(Activity=X1,
           contains("mean"),
           contains("std") #I select only the variables with means and std
    ) %>% 
    mutate(
        Activity=factor(
            .$Activity,
            levels = activity_labels$X1,
            labels = activity_labels$X2
        ),
        database="train"
    )

rm(features,activity_labels,Y_test,Y_train)


all.equal(colnames(X_test),colnames(X_train))

samsung_database<-
    X_test %>% 
    bind_rows(
        X_train
    )

rm(X_test,X_train)

