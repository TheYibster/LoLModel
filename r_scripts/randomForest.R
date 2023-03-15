library(tidymodels)
library(tidyverse)
library(ISLR)
library(glmnet)
library(modeldata)
library(ggthemes)
library(janitor)
library(naniar)
library(xgboost)
library(ranger)
library(vip)
library(corrplot)
library(dplyr)

load("~/PSTAT131/Final Project/RDAfiles/splitrecipefold.rda")

# Set up model and tuning grid
rf_spec <- rand_forest(mtry = tune(), trees = tune(), min_n = tune()) %>%
  set_engine("ranger", importance = "impurity") %>%
  set_mode("classification")

rf_wf <- workflow() %>% 
  add_model(rf_spec) %>% 
  add_recipe(LoL_recipe)

rf_grid <- grid_regular(mtry(range = c(1, 29)), 
                        trees(range = c(100, 300)),
                        min_n(range = c(50, 100)),
                        levels = 5)
# Fit Model
tune_rf <- tune_grid(
  rf_wf, 
  resamples = df_folds, 
  grid = rf_grid,
  control = control_grid(verbose = TRUE)
)

save(tune_rf, file="~/PSTAT131/Final Project/RDAfiles/rf_res.rda")

