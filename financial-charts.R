#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)

findexPage1 <- read.xlsx("findex-data/globalFindexdatabase.xlsx", sheet=1)

#Subseting Data for Asia Only
asiaFindex <- subset(findexPage1, X4 == "South Asia")
asiaFindex

#Financial Inclusion Chart 1 (% of Adults with an Account, 2011-2017)
findexChart1 <- subset(asiaFindex, X3 %in% 
                         c('Bangladesh', 'Pakistan', 'Sri Lanka', 'Indonesia', 'Vietnam', 'Thailand', 'Malaysia', 'Philippines', 'Cambodia'))
findexChart1 <- findexChart1[,c(1:29,770:781)]
findexChart1 <- subset(findexChart1, X1 %in% c('2011', '2014', '2017'))

findexChart1 <- dplyr::mutate(findexChart1,
                              `Account.(%.age.15+)`=`Account.(%.age.15+)`*100)

fchart1 <- ggplot(findexChart1, aes(x=X1, y=`Account.(%.age.15+)`, color=X3)) +
  geom_point() +
  geom_line(aes(group=X3), size = 1)
fchart1

cols <- c('2011'='dodgerblue', '2014'='dodgerblue4', '2017'='black')
fchart3 <- ggplot(findexChart1, aes(x=X3, y=`Account.(%.age.15+)`)) +
  geom_col(aes(group = factor(X1), fill = factor(X1)), position = "dodge") +
  scale_fill_manual(values = cols, name = 'Year') +
  labs(x = 'Country', y = 'Adults with an account(%)', title = 'Adults with an account by country')
fchart3

#Financial Inclusion Chart 2 - Pop up from Fiber Front Page
findexChart2 <- subset (asiaFindex, X3 %in%
                          c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'))
findexChart2 <- findexChart2[,c(1:29,770:781)]
findexChart2 <- dplyr::mutate(findexChart2, 
                              `Mobile.money.account.(%.age.15+)`=`Mobile.money.account.(%.age.15+)`*100)

fchart2 <- ggplot(findexChart2, aes(X1, y=`Mobile.money.account.(%.age.15+)`, color=X3)) +
  geom_point() +
  geom_line(aes(group=X3), size = 1)
fchart2

findexChart3 <- subset (asiaFindex, X3 %in%
                          c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'))
findexChart3 <- findexChart3[,c(1:29,770:781)]
