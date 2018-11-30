#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)

providers <- read.csv('findex-data/provider_metrics.csv')

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
  labs(title="South Asia: Fiber Reach (%)")
p1

#Donut Chart for Each Country

#Dummy Data Fiber Reach Bar Chart 
asiaFRbar <- data.frame(value=c(40, 62, 34, 60, 45, 75, 80, 68), 
                        country=c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'))

p2 <- ggplot(asiaFRbar, aes(x = reorder(country, desc(country)), value)) +
  geom_col( aes(fill=country)) +
  scale_fill_brewer(palette = 'Set2') +
  geom_hline(yintercept=72, color='#0D6EB8', size=1.5) +
  coord_flip() +
  scale_y_continuous(limits = c(0,85), expand = c(0, 0)) +
  theme(legend.position = 'None') +
  labs(x = "Country", y = "Fiber Reach (% of Population)", title = 'Fiber Reach by Country')
p2

#Providers By Country Bar Chart
asiaProviders <- subset(providers, continent == 'Asia')
asiaProviders <- asiaProviders[c(3:6)]
asiaProviders <- count(asiaProviders, "country")
asiaProviders <- asiaProviders[asiaProviders$country %in%
                                 c('Afghanistan', 'Bangladesh', 'Bhutan', 'India', 'Maldives', 'Nepal', 'Pakistan', 'Sri Lanka'),]
asiaProviders

p3 <- ggplot(asiaProviders, aes(x = reorder(country, desc(country)), freq)) +
  geom_col(aes(fill=country)) +
  scale_fill_brewer(palette = 'Set2') +
  scale_y_continuous(limits = c(0,11), expand = c(0, 0)) +
  coord_flip() +
  theme() +
  labs(x = 'Country', y = 'Count', title = 'Number of Networks by Country')
p3

#WorldBank Data
asiaBroadband <- wbstats::wb(country = c('AFG', 'BGD', 'BTN', 'IND', 'MDV', 'NPL', 'PAK', 'LKA'), 
                             indicator = 'IT.NET.BBND.P2', mrv = 6)

p5 <- ggplot(asiaBroadband, aes(x = date, y = value, color = country)) +
  geom_line(aes(group = country), size = 1.2) +
  geom_point() +
  scale_color_brewer(palette = 'Set2') +
  scale_x_discrete(limits = c('2012', '2013', '2014', '2015', '2016'), expand = c(0,0))
p5