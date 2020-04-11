# run 'correlations.do' prior to using this, as it depends on clean HICPS_predicted
library(haven)
HICPS_predicted <- read_dta("C:/Users/kurczew2/Box/Research/HICPS/Data/HICPS_predicted.dta")
hp = HICPS_predicted

sv0 = hp$severedrought_length[hp$drought == 0]
sv1 = hp$severedrought_length[hp$drought == 1]

summary(sv1[which(sv1 %in% sv0)])

pvb1 = sv1[which(sv1 %in% sv0)] 
pvb0 = sv0[which(sv1 %in% sv0)]

pvb1[pvb1 - pvb0 ==0]



xd0 = density(hp$severedrought_length[hp$drought == 0])
xd1 = density(hp$severedrought_length[hp$drought == 1])


