library(dplyr)
library(stringr) #  string manipulation
library("readxl")#read excel file

#load data
loans_original <- read.csv('kiva_loans.csv')
country_stats<-read.csv('country_stats.csv')
mpi_on_regions<- read_excel("mpi_on_regions.xlsx") #for region_mpi
multipoverty<-read.csv('MPI_subnational.csv')# for country_mpi
loan_theme_by_region<-read.csv('loan_themes_by_region.csv')
loan_theme_id<-read.csv('loan_theme_ids.csv')
UN<-read.csv('kiva_country_profile_variables.csv')


#world_region
unique_world_region<-unique(country_stats$region)
world_region<-data.frame('world_region_id'=c(1:length(unique_world_region)),'world_region_name'=unique_world_region)
write.csv(world_region,'world_region.csv')

#Prepare loans_original for extraction
loans_original$borrower_id=c(1:dim(loans_original)[1])#Assume each loan record corresponds to a distinct borrower (group or individual)
loans_original$region_id<-as.numeric(factor(loans_original$region))
loans_original$country_id<-as.numeric(factor(loans_original$country))
loans_original$category_id<-as.numeric(factor(loans_original$activity))
loans_original$sector_id<-as.numeric(factor(loans_original$sector))
loans_original$world_region = country_stats$region[match(loans_original$country,country_stats$kiva_country_name)] #inner join country_stats and loans_original on country_name to find world_region_name for each country in loans_original
loans_original$world_region_id<-world_region$world_region_id[match(loans_original$world_region,world_region$world_region_name)]
loans_original$geo<-loan_theme_by_region$geo[match(loans_original$region,loan_theme_by_region$region)]

write.csv(loans_original,'loans_original.csv')

#loan entity
which(colnames(loans_original)=="lender_count")
loan<-c('id','funded_amount','loan_amount','partner_id','posted_time','disbursed_time','funded_time','lender_count','borrower_id')
loan<-match(loan,colnames(loans_original))
loans<-loans_original[,loan]
loans$region_id = loans_original$region_id
loans$country_id<-loans_original$country_id
loans$category_id <-loans_original$category_id
loans$repayment_interval<-loans_original$repayment_interval
loans$repayment_term<-loans_original$term_in_months
write.csv(loans,'loans.csv')
#sum(is.na(loans_original$region))
#sum(!complete.cases(loans_original$region))
#sum(loans_original$region=="")



#region entity
#region_original <- read.csv('kiva_mpi_region_locations.csv')
region<-data.frame('region_id'=loans_original$region_id,'country_id'=loans_original$country_id,'region_name'=loans_original$region)
region$region_mpi<-mpi_on_regions$`region MPI`[match(loans_original$geo,mpi_on_regions$geo)]
region<-region%>%distinct(region_id,.keep_all = TRUE)
sum(is.na(region$region_mpi))
write.csv(region,'region.csv')


#borrower
borrower<-data.frame('borrower_id'=loans_original$borrower_id,'gender'=loans_original$borrower_genders,'region_id'=loans_original$region_id)
borrower<-borrower %>%
  filter(!is.na(gender)) %>%
  mutate(gender = ifelse(str_detect(gender,"female"), "female","male")) 

write.csv(borrower,'borrower.csv')

#category
category1<-data.frame('category_id'=loans_original$category_id,'category_name'=loans_original$activity,'sector_id'=loans_original$sector_id)
category<-unique(category1[c('category_id','category_name','sector_id')])
#regions<-unique(regions[c("region", "region_id","country_id")])
write.csv(category,'category.csv')

#sector
sector<-data.frame('sector_id'=loans_original$sector_id,'sector_name'=loans_original$sector)
sector<-unique(sector[c('sector_id','sector_name')])
write.csv(sector,'sector.csv')

#country
country<-data.frame('country_id'=loans_original$country_id,'country_code'=loans_original$country_code,'country_name'=loans_original$country,'currency'=loans_original$currency,'world_region'=loans_original$world_region)
country$population_in_thousands<-country_stats$population[match(loans_original$country,country_stats$kiva_country_name)]
country$hdi<-country_stats$hdi[match(loans_original$country,country_stats$kiva_country_name)]
country$population_below_poverty_line<-country_stats$population_below_poverty_line[match(loans_original$country,country_stats$kiva_country_name)]
country$life_expectancy<-country_stats$life_expectancy[match(loans_original$country,country_stats$kiva_country_name)]
country$gni<-country_stats$gni[match(loans_original$country,country_stats$kiva_country_name)]
country$gdp<-UN$GDP..Gross.domestic.product..million.current.US..[match(loans_original$country,UN$country)]
country$gdp_growth_rate <-UN$GDP.growth.rate..annual....const..2005.prices.[match(loans_original$country,UN$country)]
country$country_mpi<-multipoverty$MPI.National[match(loans_original$country,multipoverty$Country)]
country<-country%>% distinct(country_name,.keep_all = TRUE)

write.csv(country,'country.csv')


#partner
partner<-data.frame('partner_id'=loans_original$partner_id)
partner$partner_name<-loan_theme_by_region$Field.Partner.Name[match(partner$partner_id,loan_theme_by_region$Partner.ID)]
partner<-partner%>%distinct()                                                              
write.csv(partner,'partner.csv')

#loan_theme_profile
loan_theme_id$theme_id<-as.numeric(factor(loan_theme_id$Loan.Theme.Type))
loan_theme_profile<-data.frame("loan_id"=loan_theme_id$id,'loan_theme_id'=loan_theme_id$theme_id) #loan_theme_id$id does not match all of the loans$loan_id, but when importing into mysql, those don't match will be dropped automatically because of foreign key relationship;
write.csv(loan_theme_profile,'loan_theme_profile.csv')

#loan_theme
loan_theme<-data.frame('loan_theme_id'=loan_theme_id$theme_id,'loan_theme_type'=loan_theme_id$Loan.Theme.Type)
loan_theme<-loan_theme%>%distinct()
write.csv(loan_theme,'loan_theme.csv')
unique(loan_theme_id$Loan.Theme.Type)
