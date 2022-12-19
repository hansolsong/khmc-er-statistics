# 날짜 및 시간을 다루는 함수들
library(lubridate)
library(aweek)
library(glue)

as_workday <- function(dt, tz = "Asia/Seoul") { # nolint
  #' 내원시각에 따라 당직일로 변환
  #' 8시 이전에 내원한 경우 전일 내원환자로 집계

  return((dt - hours(8)) %>% as_date() %>% force_tz(tz))
}

count_wday <- function(day_of_week, dates) {
  #' dates 내의 해당 요일의 횟수를 반환
  #'
  #' @param day_of_week 요일 (1:일요일, 2:월요일, ..., 7:토요일)
  #' @param dates 날짜 벡터
  #'
  #' @return 요일의 횟수

  # day_of_week가 1~7 사이의 값이 아니면 NA를 반환
  if (day_of_week < 1 || day_of_week > 7) {
    return(NA)
  }

  return(length(which(wday(dates) == day_of_week)))
}

count_wdays <- function(dates) {
  #' dates 내의 요일별 횟수를 반환
  #'
  #' @param dates 날짜 벡터
  #'
  #' @return 요일별 횟수

  return(sapply(1:7, count_wday, dates))
}

first_day_of_week <- function(week, year, tz = "Asia/Seoul") {
  #' 주차의 첫번째 날짜를 반환
  #'
  #' @param week 주차
  #' @param year 년도
  #' @param tz 타임존
  #'
  #' @return 주차의 첫번째 날짜

  return(ymd(week2date(glue("{year}-W{week}"), week_start = 7), tz = tz))
}
