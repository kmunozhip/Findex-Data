#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)

#World Bank Data
asiaIMR <- wbstats::wb(country = c('AFG', 'BGD', 'BTN', 'IND', 'MDV', 'NPL', 'PAK', 'LKA'),
                       indicator = 'SP.DYN.IMRT.IN', mrv = 6)

asiaLE <- wbstats::wb(country = c('AFG', 'BGD', 'BTN', 'IND', 'MDV', 'NPL', 'PAK', 'LKA'),
                      indicator = 'SP.DYN.LE00.IN', mrv = 6)

p6 <- ggplot(asiaIMR, aes(x = date, y = value, color = country)) +
  geom_line(aes(group = country), size = 1.2) +
  geom_point() +
  scale_color_brewer(palette = 'Set2') +
  scale_x_discrete(limits = c('2013', '2014', '2015', '2016', '2017'), expand = c(0,0))
p6

p7 <- ggplot(asiaLE, aes(x = date, y = value, color = country)) +
  geom_line(aes(group = country), size = 1.2) +
  geom_point() +
  scale_color_brewer(palette = 'Set2') +
  scale_x_discrete(limits = c('2013', '2014', '2015', '2016', '2017'), expand = c(0,0))
p7

#Health Scatterplot
asiaScatter <- read.csv("findex-data/final.csv", TRUE, sep =",")
asiaScatter <- dplyr::rename(asiaScatter, country = ï..Country)
asiaScatter <- dplyr::transmute(asiaScatter,
                                country=country,FB.Growth.Rate=FB.Growth.Rate*100,IMR=IMR*100,LE.Rate=LE.Rate*100)
asiaScatter <- subset(asiaScatter, country %in% 
                        c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'))

p4 <- ggplot(asiaScatter, aes(x=FB.Growth.Rate, y=IMR, color=LE.Rate)) +
  geom_point(size=5)+
  geom_smooth(se=FALSE, color="black", linetype="solid", method=lm) +
  scale_color_gradient(low ='#65C7F7', high ='#5077BD') +
  ggrepel::geom_label_repel(data=asiaScatter, 
                            aes(label = asiaScatter$country), direction='both', color = 'black', nudge_x = 0.8)
p4

#Comparing
gridExtra::grid.arrange(p5, p6, p7, p4, ncol=2, nrow=2)