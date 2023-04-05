library(dplyr)
library(ggplot2)
library(stringr)
library(tidyr)

#-------------------------------------------------------------------------------
# Import and clean dataset
#-------------------------------------------------------------------------------
setwd('Data/')
mh<-read.csv("mh_svi_county_20230329.csv", stringsAsFactors = F)

# Set -999 to missing
mh[mh== (-999)]<-NA

# Add leading zero to fips codes
mh$FIPS<-stringr::str_pad(mh$FIPS, 5, side='left', pad='0')

#-------------------------------------------------------------------------------
# Create ranking function that is analogous to SQL PERCENT_RANK().The default dplyr 
# percent_rank() function ranks NA values; however, this function excludes NAs. 
# The function also sets the ties method to "max" when ranking descending values. 
#-------------------------------------------------------------------------------

sql_rank <- function(x, direction='asc'){
  if(direction=='desc') {
    output<-(
      ifelse(is.na(x), NA, 
        round(
          (rank(desc(round(x, 4)), ties.method = "max") - 1) / (sum(!is.na(x))-1), 4)))
  }
  
  if(direction=='asc'){
    output<-(
      ifelse(is.na(x), NA, 
        round(
          (rank(round(x, 4), ties.method = "min") - 1) / (sum(!is.na(x))-1), 4)))
  }
  
  return(output)
}

#-------------------------------------------------------------------------------
#Calculate theme-specific and overall sum scores and percentile rank
#-------------------------------------------------------------------------------
states<-c('AK', 'DE', 'DC', 'IL', 'IN', 'KS', 'KY',  # <<<<<<<<<< UPDATE <<<<<<<
          'LA', 'MI', 'MN', 'NE', 'PA', 'RI', 'WI')  #<<<<<<<<<<<<<<<<<<<<<<<<<<

mh <- mh %>%
  filter(ST_ABBR %in% states) %>%    ### Currently de-activeated so I can verify based on RPL_THEMES field
  mutate(
    new_theme1_sum = round(
                       sql_rank(EP_POV) +
                       sql_rank(EP_UNEMP) +
                       sql_rank(EP_PCI, 'desc') +
                       sql_rank(EP_NOHSDP), 4), 
    
    new_theme1_tile = round(sql_rank(new_theme1_sum), 4),  
    
    new_theme2_sum = round(
                      sql_rank(EP_AGE65) +
                      sql_rank(EP_AGE17) +
                      sql_rank(EP_DISABL) +
                      sql_rank(EP_SNGPNT), 4),
    
    new_theme2_tile = round(sql_rank(new_theme2_sum), 4),  
    
    new_theme3_sum = round(
                      sql_rank(EP_AIAN) +
                      sql_rank(EP_ASIAN) +
                      sql_rank(EP_AFAM) +
                      sql_rank(EP_NHPI) +
                      sql_rank(EP_HISP) +
                      sql_rank(EP_OTHER) +
                      sql_rank(EP_SPAN) +
                      sql_rank(EP_CHIN) +
                      sql_rank(EP_VIET) +
                      sql_rank(EP_KOR) +
                      sql_rank(EP_RUS), 4),
    
    new_theme3_tile = round(sql_rank(new_theme3_sum), 4), 
    
    new_theme4_sum = round(
                      sql_rank(EP_MUNIT) +
                      sql_rank(EP_MOBILE) +
                      sql_rank(EP_CROWD) +
                      sql_rank(EP_NOVEH) +
                      sql_rank(EP_GROUPQ), 4),
    
    new_theme4_tile = round(sql_rank(new_theme4_sum), 4), 
        
    new_theme5_sum =  
                      round(
                        sql_rank(R_HOSP, 'desc') +
                        sql_rank(R_URG, 'desc') +
                        sql_rank(R_PHARM, 'desc') +
                        sql_rank(R_PCP, 'desc') +
                        sql_rank(EP_UNINSUR), 4),
    
    new_theme5_tile = round(sql_rank(new_theme5_sum), 4),
        
    new_theme6_sum =  round(
                        sql_rank(ER_CARDIO) +
                        sql_rank(ER_DIAB) +
                        sql_rank(ER_OBES) +
                        sql_rank(ER_RESPD) +
                        sql_rank(EP_NOINT), 4),
    
    new_theme6_tile = round(sql_rank(new_theme6_sum), 4),
    
    new_themes_spl = new_theme1_sum +
                     new_theme2_sum +
                     new_theme3_sum +
                     new_theme4_sum +
                     new_theme5_sum +
                     new_theme6_sum,
    
    new_rpl_themes = round(sql_rank(new_themes_spl), 4)
  )


#-------------------------------------------------------------------------------
# The code below is optional. This code compares the original SVI scores to the 
# newly calculated scores. 
#-------------------------------------------------------------------------------

#Correlation of originial score with new score
cor.test(mh$RPL_THEMES, mh$new_rpl_themes, na.action=na.omit)

#distribution of score differences 
hist(mh$RPL_THEMES-mh$new_rpl_themes)

mh %>%
  select(contains(c('FIPS', 'RPL_THEME')) | ends_with('_tile')) %>%
  gather(Field, Score, 2:15) %>%
  mutate(Theme = extract_numeric(Field), 
         Source = ifelse(grepl('new', Field)==T, 'New', 'Original')) %>%
  mutate(Theme = ifelse(is.na(Theme), 'Total', Theme), Field = NULL) %>%
  spread(Source, Score) %>%
  ggplot( aes(x=New, y=Original, group=Theme, color=Theme))+
    geom_point() + 
    ylab("Original SVI Score")+
    xlab('Calculated SVI Score')+
    geom_smooth(method='lm', color='black')+
    facet_wrap(~Theme, scales = 'free')+
    theme_bw()+
    theme(legend.position = 'none')

#View distribution of regional SVI score by national tertile
tert_labels<-c('Low', 'Mid', 'High')
mh$Tertile_Old<-cut(mh$RPL_THEMES, breaks=c(0, .33, .66, 1.01), right=F, labels=tert_labels)
mh$Tertile_New<-cut(mh$new_rpl_themes, breaks=c(0, 0.33, 0.66, 1.01), right=F, labels=tert_labels)
  
table(mh$Tertile_New, mh$Tertile_Old)

mh$Discordance<-factor(ifelse(mh$Tertile_New != mh$Tertile_Old, 'Yes', 'No'))

ggplot(mh, aes(x=Tertile_Old, y=new_rpl_themes) ) +
  geom_boxplot(fill="white") +
  geom_jitter(aes(color=Discordance), size=1.5, alpha=0.9) +
  scale_colour_manual(values = c('slateblue4', 'coral2')) +
  ylab("Regional SVI Score")+
  xlab('Terile Based on Distribution of Original SVI Score')+
  theme_bw()



