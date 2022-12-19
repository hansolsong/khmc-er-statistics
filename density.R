library(IRanges)

source("./dataset.R", encoding = "UTF-8")

datetime_to_minutes <- function(dt) {
    return(as.integer(dt) / 60)
}

dataset <- records %>%
    mutate(
        visit_i = as.integer(내원일시),
        visit_m = as.integer(내원일시) / 60,
        dur_m = 체류시간 / dminutes(1),
    )

stay <- IRanges(start = dataset$visit_m, width = dataset$dur_m)

# 전체 기간을 60분 단위의 view로 분할
views <- Views(coverage(stay),
    start = seq(
        datetime_to_minutes(analysis_start_date + dhours(8)),
        datetime_to_minutes(analysis_end_date + dhours(31)),
        by = 60
    ),
    width = 60
)

# 각 시간 단위로 나뉜 view의 평균을 구함.
# matrix로 변환한 후 행과 열을 바꿔야 한다.
hourly_avg <- matrix(sum(views) / 60, nrow = 24) %>% t()

# dataframe으로 변환하고, 날짜와 요일을 추가
df_hourly_avg <- as_tibble(hourly_avg) %>%
    mutate(
        date = seq(analysis_start_date, analysis_end_date, by = "day"),
        weekday = wday(date)
    )

# 집계하지 않는 날짜를 제거
df_hourly_avg <- df_hourly_avg %>%
    filter(!date %in% excluded_dates)

# 각 요일별로 시간대별 평균을 구함
patient_density <- df_hourly_avg %>%
    group_by(weekday) %>%
    summarise_all(mean) %>%
    mutate(
        weekday = c("일", "월", "화", "수", "목", "금", "토")
    )
