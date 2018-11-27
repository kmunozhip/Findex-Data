#Install Required Packages
install.packages("rJava")
install.packages("openxlsx")

#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)

#Import Data
findexPage1 <- read.xlsx("findex-data/globalFindexdatabase.xlsx", sheet=1)
providers <- read.csv('findex-data/provider_metrics.csv')
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
asiaFRbar <- data.frame(value=c(40, 62, 34, 60, 45, 75), 
  country=c('Cambodia', 'Indonesia', 'Myanmar', 'Malaysia', 'Philippines', 'Thailand'))

p2 <- ggplot(asiaFRbar, aes(country, value)) +
  geom_col( aes(fill=country)) +
  scale_fill_brewer(palette = 'Set2') +
  geom_hline(yintercept=72, color='#0D6EB8', size=1.5) +
  coord_flip() +
  scale_y_continuous(limits = c(0,80), expand = c(0, 0))
p2

#Providers By Country Bar Chart
asiaProviders <- subset(providers, continent == 'Asia')
asiaProviders <- asiaProviders[c(3:6)]
asiaProviders <- count(asiaProviders, "country")
asiaProviders <- asiaProviders[asiaProviders$country %in%
  c('Cambodia', 'Indonesia', 'Myanmar', 'Malaysia', 'Philippines', 'Thailand'),]
asiaProviders

p3 <- ggplot(asiaProviders, aes(country, freq)) +
  geom_col(aes(fill=country)) +
  scale_fill_brewer(palette = 'Set2') +
  scale_y_continuous(limits = c(0,10), expand = c(0, 0)) +
  coord_flip()
p3

#Dummy Data Line Chart
asiaScatter <- read.csv("findex-data/final.csv", TRUE, sep =",")
asiaScatter <- dplyr::rename(asiaScatter, country = ï..Country)
asiaScatter <- dplyr::transmute(asiaScatter,
  country=country,FB.Growth.Rate=FB.Growth.Rate*100,IMR=IMR*100,LE.Rate=LE.Rate*100)
asiaScatter <- subset(asiaScatter, country %in% 
  c('Cambodia', 'Indonesia', 'Myanmar', 'Malaysia', 'Philippines', 'Thailand'))

p4 <- ggplot(asiaScatter, aes(x=FB.Growth.Rate, y=IMR, color=LE.Rate)) +
  geom_point(size=5)+
  geom_smooth(se = 0, color="black", linetype="solid", method=lm) +
  scale_color_gradient(low='#65C7F7', high='#0052D4') +
  ggrepel::geom_label_repel(data=asiaScatter, 
    aes(label = asiaScatter$country), direction='both', color = 'black', nudge_x = 1.5)
p4
  
