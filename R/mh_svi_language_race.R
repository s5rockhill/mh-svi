library(dplyr)
library(ggplot2)
library(tidyr)
library(tidycensus)

#-------------------------------------------------------------------------------
# Function used to calculate percents and percentiles 
#-------------------------------------------------------------------------------
percent <- function(num,denom) {
  require(dplyr)
  if_else(denom == 0, 
          0, if_else(denom < 0 | is.na(num), 
                     -999, num / denom * 100))
}

percentile <- function(value,total) {
  require(dplyr)
  if_else(total == 0 | total < 0 | is.na(value), 
          -999, percent_rank(value))
}

#-------------------------------------------------------------------------------
# Import denominators used to calculate percents in language and race/ethnicity
# indicators from the U.S. Census Bureau 5-Year American Community Survey API. 

# More information on the ACS API can be found at:
# https://www.census.gov/data/developers/data-sets/acs-5year.html
#-------------------------------------------------------------------------------

# 1 - Language Note, language data is derived from the 2015 ACS because these 
# data are not available for 2018
langvars=c(lang_total='B16001_001', chinese='B16001_068',spanish='B16001_005', 
           vietnamese='B16001_089', korean='B16001_074', russian='B16001_035')

lang<-get_acs('County', variables=langvars, survey='acs5', year=2015, output='wide')

# 2 - Race
racevars<-c(race_total='DP05_0033', asian='DP05_0044PE',aian='DP05_0039PE', 
            afam='DP05_0038PE', hisp='DP05_0071PE', nhpi='DP05_0052PE')

race<-get_acs('County', variables=racevars, survey='acs5', year=2018, output = 'wide')

other<-get_acs('County', variables=c(totl_other='B02001_001E', other_est= 'B02001_007E'), 
               survey='acs5', year=2018, output = 'wide')

#-------------------------------------------------------------------------------
# Calculate percents in language and other race categories
#-------------------------------------------------------------------------------

lang$chin_percent<-percent(lang$chinE, lang$lang_totalE)
lang$span_percent<-percent(lang$spanE, lang$lang_totalE)
lang$viet_percent<-percent(lang$vietE, lang$lang_totalE)
lang$korn_percent<-percent(lang$kornE, lang$lang_totalE)
lang$russ_percent<-percent(lang$russE, lang$lang_totalE)
other$other<-percent(other$other_est, other$totl_other)

#-------------------------------------------------------------------------------
#Merge language, race, and other race datasets
#-------------------------------------------------------------------------------

temp<-merge(lang, race, by='GEOID', all=T)
temp<-merge(temp, other, by='GEOID', all=T)

#-------------------------------------------------------------------------------
#Calculate percentiles 
#-------------------------------------------------------------------------------

temp$chin_tile<-percentile(temp$chinE, temp$lang_totalE)  
temp$span_tile<-percentile(temp$spanE, temp$lang_totalE) 
temp$viet_tile<-percentile(temp$vietE, temp$lang_totalE) 
temp$korn_tile<-percentile(temp$kornE, temp$lang_totalE) 
temp$russ_tile<-percentile(temp$russE, temp$lang_totalE) 
temp$asian_tile<-percentile(temp$asian, temp$race_totalE) 
temp$aian_tile<- percentile(temp$aian, temp$race_totalE) 
temp$afam_tile<-percentile(temp$afam, temp$race_totalE) 
temp$hisp_tile<-percentile(temp$hisp, temp$race_totalE) 
temp$nhpi_tile<-percentile(temp$nhpi, temp$race_totalE) 
temp$othr_tile<-percentile(temp$other, temp$totl_other)

temp$Theme3<-temp$chin_tile + temp$span_tile + temp$viet_tile + temp$korn_tile + 
  temp$russ_tile + temp$asian_tile + temp$aian_tile + temp$afam_tile + 
  temp$hisp_tile + temp$nhpi_tile + temp$othr_tile

test<-merge(mh, temp, by.x='FIPS', by.y='GEOID', all.x=T)

table(round(test$chin_tile, 4)==test$EPL_CHIN)
table(round(test$span_tile, 4)==test$EPL_SPAN)
table(round(test$viet_tile, 4)==test$EPL_viet)
table(round(test$viet_tile, 4)==test$EPL_VIET)
table(round(test$korn_tile, 4)==test$EPL_KOR)
table(round(test$russ_tile, 4)==test$EPL_RUS)

table(round(test$Theme3, 4)==test$SPL_THEME3)



test$Percent<-round(test$E_ASIAN/test$estimate*100, 4)
test$NewPercent<-percent(test$E_ASIAN, test$estimate)

test$PrcTile<-sql_rank(test$Percent)

test$NewPercentile<-percentile(test$NewPercent, test$estimate)