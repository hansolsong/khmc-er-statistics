library(tidyverse)
library(lubridate)

source("./datetime.R", encoding = "UTF-8")

start_date <- ymd("2022-05-01", tz = "Asia/Seoul")
end_date <- ymd("2022-12-17", tz = "Asia/Seoul")

all_records <- read.csv("records.csv", header = TRUE, sep = ",") %>%
       distinct(등록번호, 내원일시, .keep_all = TRUE) %>%
       mutate(
              내원일시 = ymd_hm(내원일시, tz = "Asia/Seoul"),
              당직일 = as_workday(내원일시),
              체류시간 = hm(체류시간) %>% as.duration()
       ) %>%
       filter(당직일 >= start_date & 당직일 <= end_date)

analysis_start_date <- start_date
analysis_end_date <- ymd("2022-10-29", tz = "Asia/Seoul") # 토요일

excluded_dates <- c(
       # 공휴일 및 연휴
       ymd("2022-05-05", tz = "Asia/Seoul"), # 목, 어린이날
       ymd("2022-06-01", tz = "Asia/Seoul"), # 수, 지방선거
       ymd("2022-06-06", tz = "Asia/Seoul"), # 월, 현충일
       ymd("2022-08-15", tz = "Asia/Seoul"), # 월, 광복절
       ymd("2022-09-09", tz = "Asia/Seoul"), # 9/9-12(금-월), 추석 연휴
       ymd("2022-09-10", tz = "Asia/Seoul"),
       ymd("2022-09-11", tz = "Asia/Seoul"),
       ymd("2022-09-12", tz = "Asia/Seoul"),
       ymd("2022-10-03", tz = "Asia/Seoul"), # 월, 개천절
       ymd("2022-10-10", tz = "Asia/Seoul"), # 월, 한글날 대체 휴일
       # 단축 운영일
       ymd("2022-07-18", tz = "Asia/Seoul"),
       ymd("2022-07-27", tz = "Asia/Seoul"),
       ymd("2022-08-03", tz = "Asia/Seoul"),
       ymd("2022-08-08", tz = "Asia/Seoul")
)

records <- all_records %>%
       filter(당직일 >= analysis_start_date & 당직일 <= analysis_end_date) %>%
       filter(!당직일 %in% excluded_dates)
