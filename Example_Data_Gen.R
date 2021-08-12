library(tidyr)
library(lubridate)
library(readxl)
library(writexl)

Psychometrist <- sample(x = c("AA", "AB", "AC", "AD"), size = 200, replace = TRUE)

Age <- rnorm(n = 200, mean = 50, sd = 15) %>%
       trunc()

Gender <- sample(x = c("F", "M"), size = 200, replace = TRUE

DATE <- rep(times = 10, x = c(20210101, 
                  20210102, 
                  20210103, 
                  20210104, 
                  20210105, 
                  20210106, 
                  20210107, 
                  20210108, 
                  20210109,
                  20210110,
                  20210111,
                  20210112,
                  20210113,
                  20210114,
                  20210115,
                  20210116,
                  20210117,
                  20210118,
                  20210119,
                  20210120)) %>%
        ymd()

data <- tibble(DATE, Age, Gender, Psychometrist)

write_xlsx(x = data, path = "Example_data.xlsx")
