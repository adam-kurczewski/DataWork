# run 'correlations.do' prior to using this, as it depends on clean HICPS_predicted
library(haven)
HICPS_predicted <- read_dta("C:/Users/kurczew2/Box/Research/HICPS/Data/HICPS_predicted.dta")
hp = HICPS_predicted

dx0 = density(subset(hp, drought == 0)$severedrought_length,
              from = min(hp$severedrought_length), to = max(hp$severedrought_length), n = 2^10)
dx1 = density(subset(hp, drought == 1)$severedrought_length,
              from = min(hp$severedrought_length), to = max(hp$severedrought_length), n = 2^10)

intersection = dx0$x[which(diff((dx0$y - dx1$y) > 0) != 0) + 1]

###############################################
#                                             #
### stack overflow example for follow along ###
#                                             #
###############################################

#value<-cbind(c(rnorm(100,500,90),rnorm(100,800,120)))
#genotype<-cbind(c(rep("A",100),rep("B",100)))
#df<-cbind(value,genotype)
#df<-as.data.frame(df)
#colnames(df)<-c("value","genotype")
#df$value<-as.numeric(as.character(df$value))

#subset(df, genotype == "A")$value

#A.density <- density(subset(df, genotype == "A")$value, from = min(df$value), to = max(df$value), n = 2^10)
#B.density <- density(subset(df, genotype == "B")$value, from = min(df$value), to = max(df$value), n = 2^10)
#intersection.point <- A.density$x[which(diff((A.density$y - B.density$y) > 0) != 0) + 1]





