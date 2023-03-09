library(tidymodels)
library(tidyverse)
library(ggplot2)
library(kknn)
library(yardstick)
library(themis)
library(glmnet)

load("~/PSTAT131/Final Project/RDAfiles/splitrecipefold.rda")

# Knn
knn_mod <- nearest_neighbor(neighbors = tune()) %>%
  set_mode("classification") %>%
  set_engine("kknn")

knn_wkflow <- workflow() %>% 
  add_model(knn_mod) %>% 
  add_recipe(LoL_recipe)

# Logistic
log_reg <- logistic_reg() %>% 
  set_engine("glm") %>% 
  set_mode("classification")

log_wkflow <- workflow() %>% 
  add_model(log_reg) %>% 
  add_recipe(LoL_recipe)

neighbors_grid <- grid_regular(neighbors(range = c(1, 10)), levels = 10)

# Fit Models
knn_res <- tune_grid(
  object = knn_wkflow, 
  resamples = df_folds, 
  grid = neighbors_grid
)

log_res <- fit_resamples(
  object = log_wkflow, 
  resamples = df_folds
)

# Best model for Knn
show_best(knn_res, metric = "roc_auc")
bestmodel <- select_by_one_std_err(knn_res,
                                   metric = "roc_auc", neighbors)
final_knnwf <- finalize_workflow(knn_wkflow, bestmodel)
final_knnfit <- fit(final_knnwf, df_train)

# Log model Final Fit
final_logfit <- fit(log_wkflow, df_train)

save(final_knnfit, file="~/PSTAT131/Final Project/RDAfiles/knn_model.rda")
save(final_logfit, file="~/PSTAT131/Final Project/RDAfiles/log_model.rda")
