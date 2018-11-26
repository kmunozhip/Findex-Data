#Install Required Packages
install.packages("rJava")
install.packages("openxlsx")

#Load Required Packages
library(xlsx)
library(ggplot2)
library(dplyr)

#Import Data
findexPage1 <- read.xlsx("findex-data/globalFindexdatabase.xlsx", sheet=1)
str(findexPage1$X4)
summary(findexPage1$X3)


#Subseting Data for Asia Only
asiaFindex <- subset(findexPage1, X4 == "East Asia & Pacific (excluding high income)")
asiaFindex

#Dummy Data Donut Chart
asiaDonut <- data.frame(count=c(28, 72), category=c('A', 'B'))
asiaDonut$fraction = asiaDonut$count / sum(asiaDonut$count)
asiaDonut = asiaDonut[order(asiaDonut$fraction), ]
asiaDonut$ymax = cumsum(asiaDonut$fraction)
asiaDonut$ymin = c(0, head(asiaDonut$ymax, n=-1))

p1 <- ggplot(asiaDonut, aes(fill=category, ymax=ymax, ymin=ymin, xmax=4, xmin=3)) + 
  geom_rect(colour="grey30") + 
  coord_polar(theta="y") + 
  xlim(c(0, 4)) +
  theme_bw() +
  theme(panel.grid=element_blank()) +
  theme(axis.text=element_blank()) +
  theme(axis.ticks=element_blank()) +
  scale_fill_manual(values = c('#e0e0e0','#0D6EB8')) +
  labs(title="Southeast Asia: Fiber Reach (%)")
p1

#Dummy Data Fiber Reach Bar Chart 
asiaFRbar <- data.frame(value=c(40, 62, 34, 60, 45, 75, 38, 48), 
  country=c('Cambodia', 'Indonesia', 'Lao PDR', 'Myanmar', 'Malaysia', 'Philippines', 'Thailand', 'Vietnam'))

p2 <- ggplot(asiaFRbar, aes(country, value)) +
  geom_col( aes(fill=country)) +
  theme_light() +
  scale_fill_brewer(palette = 'Set2') +
  geom_hline(yintercept=72, color='#0D6EB8', size=1) +
  coord_flip() +
  scale_y_continuous(limits = c(0,80), expand = c(0, 0))
p2

#Dummy Data Scatterplot
asiaScatter <- data.frame(value=c(), fr=c())

#Dummy Data Line Chart
