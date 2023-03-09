library(tidymodels)
library(tidyverse)
library(ggplot2)
library(kknn)
library(yardstick)
library(themis)
library(glmnet)

load("~/PSTAT131/Final Project/RDAfiles/splitrecipefold.rda")

# Tree
tree_spec <- decision_tree(cost_complexity = tune()) %>%
  set_engine("rpart") %>% 
  set_mode("classification")

tree_wf <- workflow() %>% 
  add_model(tree_spec) %>% 
  add_recipe(LoL_recipe)

tree_grid <- grid_regular(cost_complexity(range = c(-3, -1)), levels = 10)

# Fit Model
tune_tree <- tune_grid(
  tree_wf, 
  resamples = df_folds, 
  grid = tree_grid
)

# Chose best complexity

autoplot(tune_tree)

collect_metrics(tune_tree)

best_complexity <- select_best(tune_tree)

tree_final <- finalize_workflow(tree_wf, best_complexity)

tree_final_fit <- fit(tree_final, data = df_train)

save(tree_final_fit, file="~/PSTAT131/Final Project/RDAfiles/prunedtree_model.rda")
