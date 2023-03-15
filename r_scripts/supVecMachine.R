library(tidymodels)
library(tidyverse)
library(glmnet)
library(modeldata)
library(kernlab)
library(tidyclust)
library(dplyr)

load("~/PSTAT131/Final Project/RDAfiles/splitrecipefold.rda")

svm_rbf_spec <- svm_rbf(cost = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("kernlab")

svm_wkflow <- workflow() %>% 
  add_recipe(LoL_recipe) %>% 
  add_model(svm_rbf_spec)

svm_grid <- grid_regular(cost(), levels = 5)

svm_res <- tune_grid(svm_wkflow, df_folds, svm_grid, control = control_grid(verbose = TRUE))


save(svm_res, file="~/PSTAT131/Final Project/RDAfiles/svm_res.rda")


autoplot(svm_res)
