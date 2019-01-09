library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)

vpnList <- read.csv("findex-data/VPN_Comparison.csv")

vpnList <- vpnList %>% 
  rename("VPN Service" = X)


vpnList <- vpnList %>% 
  filter(X.2== "2" | X.2 == "1" | X.2 == "0", 
         X.58 != "Yes", 
         X.59 != "Yes",
         X.42 == "AES-256") 
  
summary(vpnList)

#vpnList <- read.xlsx("findex-data/VPN_Comparison.xlsx", 1)
#summary(vpnList)