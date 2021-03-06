#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)
library(dplyr)
library(tidyr)

#World Bank Data
asiaIMR <- wbstats::wb(country = c('AFG', 'BGD', 'BTN', 'IND', 'MDV', 'NPL', 'PAK', 'LKA'),
                       indicator = 'SP.DYN.IMRT.IN', mrv = 6)

asiaLE <- wbstats::wb(country = c('AFG', 'BGD', 'BTN', 'IND', 'MDV', 'NPL', 'PAK', 'LKA'),
                      indicator = 'SP.DYN.LE00.IN', mrv = 6)

p6 <- ggplot(asiaIMR, aes(x = date, y = value, color = country)) +
  geom_line(aes(group = country), size = 1.2) +
  geom_point() +
  scale_color_brewer(palette = 'Set2') +
  scale_x_discrete(limits = c('2012', '2013', '2014', '2015', '2016'), expand = c(0,0)) +
  labs(x='Year', y='Infant Mortality Rate per 100 births', title='IMR by Country (2012-2016)')
p6

p7 <- ggplot(asiaLE, aes(x = date, y = value, color = country)) +
  geom_line(aes(group = country), size = 1.2) +
  geom_point() +
  scale_color_brewer(palette = 'Set2') +
  scale_x_discrete(limits = c('2012','2013', '2014', '2015', '2016'), expand = c(0,0)) +
  labs(x='Year', y='Life Expectancy per 100 people', title='LE by Country (2012-2016)')
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
  scale_color_gradient(low ='dodgerblue', high ='black') +
  ggrepel::geom_label_repel(data=asiaScatter, 
                            aes(label = asiaScatter$country), direction='both', color = 'black', nudge_x = 0.8)
p4

#Health Scatterplot: R Analysis & Data Manipulation
asiaIMR %>% 
  group_by(country) %>% 
  summarise(avg_imr = mean(value, na.rm = TRUE))
#IMR
long_asiaIMR <- asiaIMR %>% 
  select(c(2,3,7)) %>% 
  spread(date, value)

long_asiaIMR <- long_asiaIMR %>% 
  mutate(diff1 = `2013`-`2012`, 
         diff2 = `2014`-`2013`, 
         diff3 = `2015`-`2014`, 
         diff4 = `2016`-`2015`) %>% 
  select(1, 8:11)

rate_imr <- long_asiaIMR %>% 
  gather(year, value, diff1, diff2, diff3, diff4) %>% 
  spread(country, value) %>% 
  summarise_at(c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'),
               funs(median), na.rm = TRUE) %>% 
  gather(country, avg_imr)

long_asiaIMR
rate_imr

#LE
long_asiaLE <- asiaLE %>% 
  select(c(2,3,7)) %>% 
  spread(date, value)

long_asiaLE <-long_asiaLE %>% 
  mutate(diff1 = `2013`-`2012`, 
         diff2 = `2014`-`2013`, 
         diff3 = `2015`-`2014`, 
         diff4 = `2016`-`2015`) %>% 
  select(1, 8:11)

rate_le <- long_asiaLE %>% 
  gather(year, value, diff1, diff2, diff3, diff4) %>% 
  spread(country, value) %>% 
  summarise_at(c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'),
               funs(median), na.rm = TRUE) %>% 
  gather(country, avg_le)


long_asiaLE
rate_le

#FB
long_asiaBroadband <- asiaBroadband %>% 
  select(c(2,3,7)) %>% 
  spread(date, value)

long_asiaBroadband <- long_asiaBroadband %>% 
  mutate(diff1 = `2013`-`2012`, 
         diff2 = `2014`-`2013`, 
         diff3 = `2015`-`2014`, 
         diff4 = `2016`-`2015`) %>% 
  select(1, 8:11)

rate_asiabroadband <- long_asiaBroadband %>% 
  gather(year, value, diff1, diff2, diff3, diff4) %>% 
  spread(country, value) %>% 
  summarise_at(c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'),
               funs(median), na.rm = TRUE) %>% 
  gather(country, avg_bb)

long_asiaBroadband
rate_asiabroadband

#Joining it all
asiaScatter <- merge(rate_asiabroadband, rate_imr, by.x = 'country', by.y = 'country', all.x = TRUE)
asiaScatter <- merge(asiaScatter, rate_le, by.x = 'country', by.y = 'country', all.x = TRUE)
asiaScatter

p4 <- ggplot(asiaScatter, aes(x=avg_bb, y=avg_imr, color=avg_le)) +
  geom_point(size=5)+
  geom_smooth(se=FALSE, color="black", linetype="solid", method=lm) +
  scale_color_gradient(low ='dodgerblue', high ='black') +
  ggrepel::geom_label_repel(data=asiaScatter, 
                            aes(label = asiaScatter$country), direction='both', color = 'black')
p4

 #Comparing
gridExtra::grid.arrange(p5, p6, p7, p4, ncol=2, nrow=2)


#Populated Places

populatedPlaces <- read.csv('findex-data/populated_places.csv')
summary(populatedPlaces)
