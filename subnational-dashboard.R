#Load Required Packages
library(openxlsx)
library(ggplot2)
library(plyr)
library(magrittr)

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
  coord_flip() +
  labs(x='Provider' , y='Fiber Reach (% of Population)') +
  scale_y_continuous(limits = c(0,100), expand = c(0,1))
sub2

sub3 <- ggplot(bangladeshProviders, aes(x=provider, y=dist)) +
  geom_col (fill='grey') +
  coord_flip () +
  labs(x='Provider' , y='Fiber Distance (km)') +
  scale_y_continuous(limits = c(0,10000), expand = c(0,250))
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
  coord_flip() +
  labs(x='Adminstrative Division 1', y='Number of Banks') +
  scale_y_continuous(limits = c(0,200000), expand = c(0,5000))
sub4

sub5 <- ggplot(bangladeshAdm3, aes(name_1, no_banks)) +
  geom_col(fill='grey') + 
  coord_flip() +
  labs(x='Administrative Division 1', y='Population Density') +
  scale_y_continuous(limits = c(0,3000), expand = c(0,100))
sub5

gridExtra::grid.arrange(sub4, sub5, ncol=2)

#Number of Banks vs. Population Density
str(bangladeshAdm3$name_1)

aggregate(bangladeshAdm3$no_banks, by=list(name_1=bangladeshAdm3$name_1), FUN=sum)

bangladeshAdm3 %>% dplyr::group_by(name_1) %>%  dplyr::summarise(no_banks = sum(no_banks), pop_den = sum(popden))

bangladeshAccessPoints1 <- bangladeshAdm3 %>% 
  dplyr::group_by(name_1) %>% 
  dplyr::summarise(pop_den = sum(popden),
                   pop = sum(pop),
                   no_banks = sum(no_banks, na.rm = TRUE), 
                   no_sacco = sum(no_sacco, na.rm = TRUE),
                   no_atms = sum(no_atms, na.rm = TRUE),
                   no_mma = sum(no_mma, na.rm = TRUE))

bangladeshAccessPoints2 <- bangladeshAdm3 %>% 
  dplyr::group_by(name_2) %>% 
  dplyr::summarise(pop_den = sum(popden),
                   pop = sum(pop),
                   no_banks = sum(no_banks, na.rm = TRUE), 
                   no_sacco = sum(no_sacco, na.rm = TRUE),
                   no_atms = sum(no_atms, na.rm = TRUE),
                   no_mma = sum(no_mma, na.rm = TRUE))

bangladeshAccessPoints3 <- bangladeshAdm3 %>% 
  dplyr::group_by(name_3) %>% 
  dplyr::summarise(pop_den = sum(popden),
                   pop = sum(pop),
                   no_banks = sum(no_banks, na.rm = TRUE), 
                   no_sacco = sum(no_sacco, na.rm = TRUE),
                   no_atms = sum(no_atms, na.rm = TRUE),
                   no_mma = sum(no_mma, na.rm = TRUE))

bangladeshAccessPoints1
bangladeshAccessPoints2
bangladeshAccessPoints3

sub6 <- ggplot(bangladeshAccessPoints1, aes(x=pop_den, y=no_mma)) +
  geom_point(aes(color=name_1), size = 3)+
  geom_smooth(method = lm, se = FALSE, color='black') +
  theme(legend.position = 'right') +
  labs(x='Population Density', y='Number of Mobile Money Agents') +
  scale_color_brewer(palette='Set2')
sub6

sub7 <- ggplot(bangladeshAccessPoints2, aes(x=pop_den, y=no_mma)) +
  geom_point(aes(color=name_1), size = 3)+
  geom_smooth(method = lm, se = FALSE, color='black') +
  theme(legend.position = 'right') +
  labs(x='Population Density', y='Number of Mobile Money Agents') +
  scale_color_brewer(palette='Set2')
sub7

#Total Access Points
totalaccessp <- bangladeshAccessPoints1 %>% 
  mutate(total_ap = no_banks + no_sacco + no_atms + no_mma) %>% 
  select(name_1, no_banks, no_sacco, no_atms, no_mma) %>% 
  tidyr::gather(type, count, 2:5)
totalaccessp

sub8 <- ggplot(totalaccessp, aes(x=reorder(name_1, desc(name_1)), y=count)) +
  geom_col(aes(fill=type)) +
  coord_flip() +
  scale_fill_manual(values=c('no_atms'='grey60', 
                             'no_banks'='dodgerblue',
                             'no_mma'='dodgerblue4', 
                             'no_sacco'='black')) +
  labs(x = 'Adm1', y='Count')
sub8

sub9 <- ggplot(bangladeshAccessPoints1, aes(x=pop_den, y=no_banks)) +
  geom_point(aes(color=name_1), size=4) +
  theme(legend.position = 0)
sub9

sub10 <- ggplot(bangladeshAccessPoints1, aes(x=pop_den, y=no_mma)) +
  geom_point(aes(color=name_1), size=4)
sub10
