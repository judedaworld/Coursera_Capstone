# Enter folder name which includes spaceX.csv.
setwd("~/IBM Data Science Professional Certificate/Applied Data Science Capstone")
rm(list=ls())


library(sqldf)

data <- read.csv("SpaceX.csv")
head(data)
names(data)[10] <- "Landing"
names(data)

summary(data)
data$Date <- as.Date(data$Date, "%d-%m-%Y")
data$Date <- as.character(data$Date)
data$PAYLOAD_MASS__KG_ <- as.integer(data$PAYLOAD_MASS__KG_)

# Display the names of the unique launch sites in the space mission
sqldf("select distinct Launch_Site from data;")

# Display 5 records where launch sites begin with the string 'CCA'
sqldf("select * from data where Launch_Site like 'CCA%' limit 5;")

# Display the total payload mass carried by boosters launched by NASA (CRS)
sqldf("select sum(PAYLOAD_MASS__KG_) from data group by Customer having Customer='NASA (CRS)';")

# Display average payload mass carried by booster version F9 v1.1
sqldf("select avg(PAYLOAD_MASS__KG_) from data group by Booster_Version having Booster_Version='F9 v1.1';")

# List the date when the first successful landing outcome in ground pad was acheived.
sqldf("select min(Date) from data where Landing='Success';")

# List the names of the boosters which have success in drone ship and 
# have payload mass greater than 4000 but less than 6000.
sqldf("select Booster_Version from data where 
        Mission_Outcome='Success' and 
        PAYLOAD_MASS__KG_ between 4000 and 6000;")

# List the total number of successful and failure mission outcomes
sqldf("select Mission_Outcome, count(*) from data group by Mission_Outcome;")

# List the names of the booster_versions which have carried the maximum payload mass. Use a subquery.
sqldf("select Booster_Version from data 
          where PAYLOAD_MASS__KG_=(select max(PAYLOAD_MASS__KG_) from data);")

# List the failed landing_outcomes in drone ship, their booster versions, and launch site names for in year 2015
sqldf("select Payload, Booster_Version, Launch_Site from data where 
      Mission_Outcome='Success' and strftime('%Y', Date)='2015';")

# Rank the count of landing outcomes (such as Failure (drone ship) or Success (ground pad)) between the date 2010-06-04 and 2017-03-20, in descending order
sqldf("select landing, count(*) as count from data where Date >= '2010-06-04' and Date <= '2017-03-20' 
      group by landing order by count desc;")

