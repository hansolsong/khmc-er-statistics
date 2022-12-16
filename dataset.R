library(tidyverse)
library(lubridate)

source("./datetime.R", encoding = "UTF-8")

start_date <- ymd("2022-06-01")
end_date <- ymd("2022-06-30")

raw_records <- read.csv("records.csv", header = TRUE, sep = ",") %>%
    distinct(등록번호, 내원일시, .keep_all = TRUE) %>%
    mutate(내원일시 = ymd_hm(내원일시, tz = "Asia/Seoul"),
           당직일 = as_workday(내원일시),
           체류시간 = hm(체류시간) %>% as.duration
           ) %>%
    filter(당직일 >= start_date & 당직일 <= end_date)
