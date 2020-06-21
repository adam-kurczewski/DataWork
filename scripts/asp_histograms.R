library(dplyr)
library(tidyr)
library(haven)
library(ggplot2)
library(knitr)

setwd("C:/Users/kurczew2/Box/Research/HICPS/Data")

HICPS = read_dta("HICPS-preresults.dta")



## Land Ownership Aspirations

ggplot(data = HICPS, aes(rank_land_10)) + 
  geom_histogram(na.rm = T, binwidth = 4, fill = "#E69F00", alpha = 0.5) +
  geom_histogram(aes(x=rank_land), na.rm = T, binwidth = 4,fill = "#999999", alpha = 0.5) +
  scale_y_continuous(expand = c(0,0), limits = c(0, 150)) +
  labs(title = "Distribution of Land Aspirations",
       subtitle = "Grey - Current Ownership; Gold - Aspired Ownership",
       x = "Ownership Level",
       y = "Frequency",
       caption = "'Aspired Level' represents the level of ownership for a given dimension \n relative to the rest of the village, the individual aspires for in ten years time") +
  theme_grey()






## Livestock Ownership Aspirations

ggplot(data = HICPS, aes(rank_livestock_10)) + 
  geom_histogram(na.rm = T, binwidth = 4, fill = "#E69F00", alpha = 0.5) +
  geom_histogram(aes(x=rank_livestock), na.rm = T, binwidth = 4,fill = "#999999", alpha = 0.5) +
  scale_y_continuous(expand = c(0,0), limits = c(0,150)) +
  labs(title = "Distribution of Livestock Aspirations",
       subtitle = "Grey - Current Ownership; Gold - Aspired Ownership",
       x = "Ownership Level",
       y = "Frequency",
       caption = "'Aspired Level' represents the level of ownership for a given dimension \n relative to the rest of the village, the individual aspires for in ten years time") +
  theme_grey()






## Asset Ownership Aspirations

ggplot(data = HICPS) + 
  geom_histogram(aes(x=rank_asset_10), na.rm = T, binwidth = 4, fill = "#E69F00", alpha = 0.5) +
  geom_histogram(aes(x=rank_asset), na.rm = T, binwidth = 4, fill = "#999999", alpha = 0.5) +
  scale_y_continuous(expand = c(0,0), limits = c(0,175)) +
  labs(title = "Distribution of Asset Aspirations",
       subtitle = "Grey - Current Ownership; Gold - Aspired Ownership",
       x = "Ownership Level",
       y = "Frequency",
       caption = "'Aspired Level' represents the level of ownership for a given dimension \n relative to the rest of the village, the individual aspires for in ten years time") +
  theme_grey()
