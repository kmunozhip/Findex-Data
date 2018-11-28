#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)

#Networks by Department (See Operator Dashboard)
bangladeshProviders <- read.csv('findex-data/provider_metrics.csv')
bangladeshProviders <- subset(bangladeshProviders, country == 'Bangladesh')
bangladeshProviders <- bangladeshProviders[,4:6]
bangladeshProviders

sub1 <- ggplot(bangladeshProviders, aes(x=provider, y=dist)) +
  geom_col(aes(fill=fr)) +
  coord_flip() + 
  scale_fill_gradient(low ='grey', high ='#5077BD')
sub1

sub2 <- ggplot(bangladeshProviders, aes(x=provider, y=fr)) +
  geom_col() +
  coord_flip()
sub2

sub3 <- ggplot(bangladeshProviders, aes(x=provider, y=dist)) +
  geom_col (fill='grey') +
  coord_flip ()
sub3

gridExtra::grid.arrange(sub2, sub3, ncol=2)

                        