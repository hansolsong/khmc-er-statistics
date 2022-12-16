library(tidyverse)

raw_records <- read.csv("records.csv", header = TRUE, sep = ",")
raw_records <- distinct(raw_records, 등록번호, 내원일시, .keep_all = TRUE)