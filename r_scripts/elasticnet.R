library(tidymodels)
library(tidyverse)
library(ggplot2)
library(kknn)
library(yardstick)
library(themis)
library(glmnet)
library(dplyr)

load("~/PSTAT131/Final Project/RDAfiles/splitrecipefold.rda")

# Elastic Net wkflow
glm_mod <- logistic_reg(mixture = tune(), penalty = tune()) %>%
  set_mode("classification") %>%
  set_engine("glmnet")

glm_wkflow <- workflow() %>% 
  add_model(glm_mod) %>% 
  add_recipe(LoL_recipe)

# grid
glm_grid <- grid_regular(penalty(range = c(0, 1), trans = identity_trans()), mixture(range = c(0, 1)), levels = 10)

# tune grid

glm_res <- tune_grid(
  object = glm_wkflow, 
  resamples = df_folds, 
  grid = glm_grid,
  control = control_grid(verbose = TRUE)
)

save(glm_res, file="~/PSTAT131/Final Project/RDAfiles/glm_res.rda")
