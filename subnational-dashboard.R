#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)

#Networks by Department (See Operator Dashboard) Bangladesh
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

#Fiber Distance by Operator

#Fiber Reach by Operator

#Fiber Distance by Administrative Layer 1

#Fiber Reach by Admnisitrative 1

#Fiber Distance vs Population (?? GDP)

#Bangladesh InfraNav Data
bangladeshAdm3 <- read.xlsx('findex-data/bgd_adm3.xlsx', 1)
str(bangladeshAdm3$name_1)

sub4 <- ggplot(bangladeshAdm3, aes(name_1, popden)) +
  geom_col() +
  coord_flip()
sub4

sub5 <- ggplot(bangladeshAdm3, aes(name_1, no_banks)) +
  geom_col() + coord_flip()
sub5

gridExtra::grid.arrange(sub4, sub5, ncol=2)
