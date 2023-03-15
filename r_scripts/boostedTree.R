library(tidymodels)
library(tidyverse)
library(modeldata)
library(naniar)
library(xgboost)

load("~/PSTAT131/Final Project/RDAfiles/splitrecipefold.rda")

# Set up model
bt_spec <- boost_tree(mtry = tune(), 
                            trees = tune(), 
                            learn_rate = tune()) %>%
  set_engine("xgboost") %>% 
  set_mode("classification")

bt_wf <- workflow() %>% 
  add_model(bt_spec) %>% 
  add_recipe(LoL_recipe)

# Set up tuning grid
bt_grid <- grid_regular(mtry(range = c(1, 29)), 
                        trees(range = c(100, 300)),
                        learn_rate(range = c(-10, -1)),
                        levels = 5)

# Tune the model  
tune_bt <- tune_grid(
  bt_wf,
  resamples = df_folds,
  grid = bt_grid,
  control = control_grid(verbose = TRUE)
)

# Save the tune results
save(tune_bt, file ="~/PSTAT131/Final Project/RDAfiles/bt_res.rda")

