library(dplyr)
library(ggplot2)
library(tidyr)

# Import dataset
setwd('Data/')
mh<-read.csv('mh_svi_county_2018.csv', stringsAsFactors = F)

# Set -999 to missing
mh[mh== (-999)]<-NA

#-------------------------------------------------------------------------------
#create a ranking function that is analogous to SQL PERCENT_RANK()
#the dplyr function by default ranks NA values, so I am overwriting that to 
#exclude NAs. The function also needs to set the ties method to "max" if you are
#using it to rank descending values. 

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
#Calculate state-specific percentile rank
mh <- mh %>%
  #group_by('STATE') %>%    ### Currently de-activeated so I can verify based on RPL_THEMES field
  mutate(
    state_theme1_sum = 
      round(
      sql_rank(EP_POV) +
      sql_rank(EP_UNEMP) +
      sql_rank(EP_PCI, 'desc') +
      sql_rank(EP_NOHSDP), 4), 
    
    state_theme2_sum = 
      round(
      sql_rank(EP_AGE65) +
      sql_rank(EP_AGE17) +
      sql_rank(EP_DISABL) +
      sql_rank(EP_SNGPNT), 4),
    
    state_theme3_sum = 
      round(
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
    
    state_theme4_sum = 
      round(
      sql_rank(EP_MUNIT) +
      sql_rank(EP_MOBILE) +
      sql_rank(EP_CROWD) +
      sql_rank(EP_NOVEH) +
      sql_rank(EP_GROUPQ), 4),
        
    state_theme5_sum =  
      round(
      sql_rank(R_HOSP, 'desc') +
      sql_rank(R_URG, 'desc') +
      sql_rank(R_PHARM, 'desc') +
      sql_rank(R_PCP, 'desc') +
      sql_rank(EP_UNINSUR), 4),
        
    state_theme6_sum =  
      round(
      sql_rank(ER_CARDIO) +
      sql_rank(ER_DIAB) +
      sql_rank(ER_OBES) +
      sql_rank(ER_RESPD) +
      sql_rank(EP_NOINT), 4),
    
    state_themes_spl = state_theme1_sum +
      state_theme2_sum +
      state_theme3_sum +
      state_theme4_sum +
      state_theme5_sum +
      state_theme6_sum,
    
    state_rpl_themes = sql_rank(state_themes_spl)
  )

table(mh$SPL_THEME1==mh$state_theme1_sum)
table(mh$SPL_THEME2==mh$state_theme2_sum)
table(mh$SPL_THEME3==mh$state_theme3_sum)
table(mh$SPL_THEME4==mh$state_theme4_sum)
table(mh$SPL_THEME5==mh$state_theme5_sum)
table(mh$SPL_THEME6==mh$state_theme6_sum)

cor.test(mh$RPL_THEMES, mh$state_rpl_themes, na.action=na.omit)

mh %>%
  select(starts_with(c('GRASP_ID', 'state_theme', 'SPL_THEME'))) %>%
  gather(Field, Score, 2:15) %>%
  mutate(Theme = extract_numeric(Field), 
         Source = ifelse(grepl('SPL', Field)==T, 'Original', 'New')) %>%
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


### STOP HERE! THE CODE BELOW IS JUST RETAINED FOR REFERENCE

#View distribution of national MH SVI score within Arkansas
#--------------------------------------------------------------------------

#View distribution of national MH SVI score within Arkansas
mh %>% 
  filter(STATE=='ARKANSAS') %>%
  ggplot(aes(x=RPL_THEMES)) +
  geom_density(fill='darkgray', alpha=0.5)+
  geom_vline(xintercept=quantile(mh$RPL_THEMES, .33, na.rm=T), linewidth=1.1, color="darkred", linetype = "dashed")+
  geom_vline(xintercept=quantile(mh$RPL_THEMES, .66, na.rm=T), linewidth=1.1, color="darkred", linetype = "dashed")

ar<-mh %>% 
  filter(STATE=='ARKANSAS')

ar %>%
  ggplot(aes(x=state_rpl_themes)) +
  geom_density(fill='darkgray', alpha=0.5)

#Classify AR counties by tertile
tert_labels<-c('Low', 'Mid', 'High')
ar$Tertile_Old<-cut(ar$RPL_THEMES, 
                        breaks=c(0, quantile(ar$RPL_THEMES, .33), quantile(ar$RPL_THEMES, .66), 1.01), 
                        right=F, labels=tert_labels)

ar$Tertile_New<-cut(ar$state_rpl_themes, breaks=c(0, 0.33, 0.66, 1.01), right=F, labels=tert_labels)
  
table(ar$Tertile_New, ar$Tertile_Old)

ar$Discordance<-factor(ifelse(ar$Tertile_New != ar$Tertile_Old, 'Yes', 'No'))

ggplot(ar, aes(x=Tertile_Old, y=state_rpl_themes) ) +
  geom_boxplot(fill="white") +
  geom_jitter(aes(color=Discordance), size=1.5, alpha=0.9) +
  scale_colour_manual(values = c('slateblue4', 'coral2')) +
  ylab("State-Specific SVI Score")+
  xlab('Terile Based on Distribution of Original SVI Score')+
  theme_bw()



