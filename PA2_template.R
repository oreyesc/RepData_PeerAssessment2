# Libraries
for (package in c("ggplot2", "graphics", "knitr", "lattice", "plyr", "reshape2", "R.oo", "R.utils", "scales", "xtable")) {
        if (!(require(package, character.only = TRUE, quietly = TRUE))) {
                install.packages(package)
                library(package, character.only = TRUE)
        }
}


# Variables
main_dir <- "~"
main_folder <- "activity_PA2"
folder <- "Raw Data"
img <- "img"
img_path <- "~/activity_PA2/img"
activity_zip <- "activity.zip"
activity_csv <- "activity.csv"
file_url <- "http://d396qusza40orc.cloudfront.net/repdata/data/StormData.csv.bz2"
setwd (main_dir)
# Validate and create directory
if (!file.exists (main_folder)) {
        dir.create (main_folder)
        setwd (main_folder)
        if (!file.exists (folder)){
                dir.create (folder)
                dir.create (img)
        }
        setwd (folder)

        # Validate if activity.zip and activity.zip files exist, if not download the .zip file
        if (!file.exists (activity_csv)) {
                # Download the file
                download.file (url = file_url,
                               destfile = activity_csv,
                               method = "auto"
                )
                #unzip (activity_zip)
        }
} else {
        # Setting the working directory
        setwd (main_folder)
        setwd (folder)

        # Validate if activity.zip and activity.zip files exist, if not download the .zip file
        if (!file.exists (activity_csv)) {
                # Download the file
                download.file (url = file_url,
                               destfile = activity_csv,
                               method = "auto"
                )
                #unzip (activity_zip)
        }
}

setwd (main_dir)
setwd (main_folder)

# Loading and Processing the Data

## Load the info into a data.frame (info_activity)
all_info_activity <- read.csv (file.path (folder ,activity_csv),
                           header = TRUE,
                           sep = ",",
                           dec = ".",
                           stringsAsFactors = FALSE,
                           strip.white = TRUE
                           )

## Verifying Data
### head (info_activity)
head (all_info_activity)

### Structure of data.frame (info_activity) --> str (info_activity)
str (all_info_activity)

### Summary of data.frame (info_activity) --> summary (info_activity)
summary (all_info_activity)

### Column names
names (all_info_activity)

#### Realease memory to work, select only the required variables/data
## Variable     Description
## STATE        State where the event occurred.  Abbreviations of US States.
## EVTYPE       Event Type.
## FATALITIES   Total number of fatalities assigned to (or caused by) this event. Leave blank for zero amounts.
## INJURIES     Total number of injuries assigned to (or caused by) this event. Leave blank for zero amounts.
## PROPDMG      Total Property Damage assigned to (or caused by) this event in abbreviated dollar amounts according to WSOM Chapter F-42.
## PROPDMGEXP   Multiplier letter, e.g., K, M, B, etc.  Unit of damage (B, M, K, H)
## CROPDMG      Total Crop Damage assigned to (or caused by) this event in abbreviated dollar amounts according to WSOM Chapter F-42.
## CROPDMGEXP   Multiplier letter, e.g., K, M, B, etc. Unit of crop damage (B, M, K, H)

variables_activity <- c("EVTYPE",
                        "FATALITIES",
                        "INJURIES",
                        "PROPDMG",
                        "PROPDMGEXP",
                        "CROPDMG",
                        "CROPDMGEXP",
                        "STATE",
                        "REFNUM")

info_activity <- data.frame (subset (all_info_activity,
                                     subset = nrow (all_info_activity) >0,
                                     select = variables_activity))

length_variables_activity <- length (variables_activity)
all_info_activity <- info_activity

str (info_activity)
names (info_activity)

## Unifying event types
# Actual Storm Data Event Table - NWS Directive 10-1605
#
#       EVENT NAME
##                      Astronomical Low Tide
##                      Avalanche
##                      Blizzard
##                      Coastal Flood
##                      Cold/Wind Chill
##                      Debris Flow
##                      Dense Fog
##                      Dense Smoke
##                      Drought
##                      Dust Devil
##                      Dust Storm
##                      Excessive Heat
##                      Extreme Cold/Wind Chill
##                      Flash Flood
##                      Flood
##                      Frost/Freeze
##                      Funnel Cloud
##                      Freezing Fog
##                      Hail
##                      Heat
##                      Heavy Rain
##                      Heavy Snow
##                      High Surf
##                      High Wind
##                      Hurricane (Typhoon)
##                      Ice Storm
##                      Lake-Effect Snow
##                      Lakeshore Flood
##                      Lightning
##                      Marine Hail
##                      Marine High Wind
##                      Marine Strong Wind
##                      Marine Thunderstorm Wind
##                      Rip Current
##                      Seiche
##                      Sleet
##                      Storm Surge/Tide
##                      Strong Wind
##                      Thunderstorm Wind
##                      Tornado
##                      Tropical Depression
##                      Tropical Storm
##                      Tsunami
##                      Volcanic Ash
##                      Waterspout
##                      Wildfire
##                      Winter Storm
##                      Winter Weather

## PROPOSED NEW EVENTS TYPE
#
# PROPOSED              ACTUAL
# Avalanche     -->     Avalanche, Debris Flow
# Cold          -->     Cold, Extreme Cold
# Drought       -->     Drought
# Dust Storm    -->     Dust Devil, Dust Storm, DustStorm
# Flood         -->     Coastal Flood, CoastalFlood, Fast Flood, Flood, Lakeshore Flood, River Flood
# Fog Smoke     -->     Dense Fog, Dense Smoke, Fog, Freezing Fog, Smoke
# Hail          -->     Hail
# Heat          -->     Excessive, Excessive Heat, Heat
# Hurricaine    -->     Hurricaine, Typhoon
# Freeze Snow   -->     Freeze, Frost, Frost/Freeze, Heavy Snow, Lake Effect Snow, Lake-Effect Snow,
#                       Sleet, Snow
# Lightning     -->     Lightning
# Marine Thunderstorm Wind  -->         Marine Hail, Marine High Wind, Marine Strong Wind,
#                                       Marine Thunderstorm Wind, Thunderstorm Wind
# Other        -->      Tropical Depression, Volcanis Ash, Wild Fire, Seiche, High Surf, Astronimical Low Tide,
#                       Contains all other type of event.
# Rain          -->     Heavy Rain, Rain
# Rip Current   -->     Rip Current
# Storm         -->     Coastal Storm, CoastalStorm, Dust Storm, DustStorm, Ice, Ice Storm, Storm Surge,
#                       Storm Surge/Tide, Storm Tide, Thunderstorm, Tropical storm, Winter Storm,
#                       Winter Weather
# Tsunami       -->     Tsunami
# Tornado       -->     Funnel, Funnel Cloud, Tornado, Waterspout
# Wind          -->     Blizzard, High Wind, High, Strong Wind, Wind, Wind Chill

## New Event    Actual Event

new_events_type <- c ("Flood",
                      "Storm",
                      "Tsunami",
                      "Hurricane",
                      "Tornado",
                      "Avalanche",
                      "Slide",
                      "Cold",
                      "Drought",
                      "Dust Storm",
                      "Erosion",
                      "Fire",
                      "Fog Smoke",
                      "Hail",
                      "Heat",
                      "Freeze Snow",
                      "Lightning",
                      "Marine Thunderstorm Wind",
                      "Rain",
                      "Rip Current",
                      "Wind",
                      "Other")

aux_variables_activity = c("evtype",
                           "fatalities",
                           "injuries",
                           "propdmg",
                           "propdmgexp",
                           "cropdmg",
                           "cropdmgexp",
                           "state",
                           "refnum")

length_new_events_type <- length (new_events_type)
length_aux_variables_activity <- length (aux_variables_activity)

aux_activity <- setNames (data.frame (matrix (ncol = length_aux_variables_activity,
                                              nrow = length (new_events_type))),
                          paste0 (aux_variables_activity))

for (p in 1:length_new_events_type) {
        aux_activity$evtype[p] = new_events_type[p]
        aux_activity$fatalities[p] = 0
        aux_activity$injuries[p] = 0
        aux_activity$propdmg[p] = 0
        aux_activity$propdmgexp[p] = c("")
        aux_activity$cropdmg[p] = 0
        aux_activity$cropdmgexp[p] = c("")
        aux_activity$state[p] = c("")
        aux_activity$refnum[p] = 0
        #aux_activity$ids[p] = vector(mode="numeric", length=1)
}

actual_events_type <- c ("FLOOD|FLD",
                         "STORM|WINTER",
                         "TSUNAMI",
                         "HURRICANE|TYPHON",
                         "FUNNEL|TORNADO|WATERSPOUT",
                         "AVALANCHE|DEBRIS",
                         "SLIDE",
                         "COLD|LOW TEMPERATURE",
                         "DROUGHT",
                         "DUST",
                         "EROSION|EROSIN",
                         "FIRE|WILDFIRE|FOREST FIRE|WILDFIRES",
                         "FOG|SMOKE",
                         "HAIL",
                         "EXCESSIVE|HEAT",
                         "FREEZE|FROST|SNOW|SLEET",
                         "LIGHTNING",
                         "MARINE|THUNDERSTORM WIND",
                         "RAIN",
                         "RIP",
                         "BLIZZARD|WIND|MICROBURST")
# Transform to uppercase all EVTYPE events and to Thousands PROPDMG and CROPDMG to Millions

# Transform to uppercase all EVTYPE events and to Thousands PROPDMG and CROPDMG to Millions
all_info_activity$EVTYPE <- toupper (info_activity$EVTYPE)
all_info_activity$PROPDMGEXP <- toupper (info_activity$PROPDMGEXP)
all_info_activity$CROPDMGEXP <- toupper (info_activity$CROPDMGEXP)

nrow_info_activity <- nrow (all_info_activity)
names (all_info_activity)

table_values_letters <- c ("B",
                           "M",
                           "K",
                           "H",
                           "")

table_values <- c (1000,
                   1,
                   0.001,
                   0.0001,
                   0.000001)

length_table_values <- length (table_values)

temp_info_activity <- all_info_activity

# STANDARDIZING to Millions - PROPDMG

temp_info_activity$ids <- grep ("",
                                temp_info_activity$PROPDMGEXP)

for ( i in 1 : length_table_values) {

        aux_info_activity <- grep (table_values_letters [i],
                                   temp_info_activity$PROPDMGEXP)

        ids_activity <- temp_info_activity$ids [aux_info_activity]

        all_info_activity$PROPDMG[ids_activity] <- lapply (all_info_activity$PROPDMG [ids_activity],
                                                           function(x) x*table_values [i])

        temp_info_activity <- temp_info_activity[-aux_info_activity,]
}

all_info_activity$PROPDMG <- as.numeric (info_activity$PROPDMG)
all_info_activity$CROPDMG <- as.numeric (info_activity$CROPDMG)

# STANDARDIZING to Millions - CROPDMG

temp_info_activity$ids <- grep ("",
                                temp_info_activity$CROPDMGEXP)

for ( i in 1 : length_table_values) {

        aux_info_activity <- grep (table_values_letters [i],
                                   temp_info_activity$CROPDMGEXP)

        ids_activity <- temp_info_activity$ids [aux_info_activity]

        all_info_activity$CROPDMG[ids_activity] <- lapply (all_info_activity$CROPDMG [ids_activity],
                                                           function(x) x*table_values [i])

        temp_info_activity <- temp_info_activity[-aux_info_activity,]
}
all_info_activity$PROPDMG <- as.numeric (info_activity$PROPDMG)
all_info_activity$CROPDMG <- as.numeric (info_activity$CROPDMG)

info_activity <- all_info_activity

### Verifying NAs (missing data)
total_NAs <- sum (is.na (info_activity))
total_NAs


length_actual_events_type <- length (actual_events_type)
nrow_info_activity <- nrow (info_activity)
aux_activity2 <- info_activity

for (i in 1 : length_actual_events_type) {

        aux_activity_ids <- grep (actual_events_type[i],
                                  aux_activity2$EVTYPE,
                                  value = FALSE,
                                  useBytes = TRUE)

        length_aux_activity_ids <- length (aux_activity_ids)

        aux_activity$fatalities[i] <- sum (aux_activity2$FATALITIES[aux_activity_ids])
        aux_activity$injuries[i] <- sum (aux_activity2$INJURIES[aux_activity_ids])
        aux_activity$propdmg[i] <- sum (aux_activity2$PROPDMG[aux_activity_ids])
        aux_activity$cropdmg[i] <- sum (aux_activity2$CROPDMG[aux_activity_ids])

        aux_activity2 <- aux_activity2[-aux_activity_ids,]
}

Other <- length_new_events_type
aux_activity$fatalities[Other] <- sum (aux_activity2$FATALITIES)
aux_activity$injuries[Other] <- sum (aux_activity2$INJURIES)
aux_activity$propdmg[Other] <- sum (aux_activity2$PROPDMG)
aux_activity$cropdmg[Other] <- sum (aux_activity2$CROPDMG)
#info_activity <- all_info_activity


all_info_activity$FATALITIES <- comma_format()(all_info_activity$FATALITIES)
all_info_activity$INJURIES <- comma_format()(all_info_activity$INJURIES)
all_info_activity$PROPDMG <- comma_format()(all_info_activity$PROPDMG)
all_info_activity$CROPDMGEXP <- comma_format()(all_info_activity$CROPDMG)

nrow_aux_activity <- nrow (aux_activity)

fatalities_injuries_vector <- aggregate (cbind (fatalities, injuries) ~ evtype,
                                         aux_activity,
                                         FUN = sum)

fatalities_injuries_toplot <- melt (head(fatalities_injuries_vector[order (-fatalities_injuries_vector$fatalities,
                                                                           -fatalities_injuries_vector$injuries),],
                                         nrow_aux_activity))

colnames (fatalities_injuries_toplot) <- c ("event_type",
                                            "fatalities_injuries",
                                            "value")

ggplot (fatalities_injuries_toplot,
        aes (x = reorder (event_type,
                          value),
             y = value,
             fill = factor (fatalities_injuries,
                            labels = c("Fatalities",
                                       "Injuries")))) +
        geom_bar (stat = "identity") +
        labs (title = "Most Harmful Events - Population Health (1950 - 2011)",
              x = "Event Type",
              y = "Quantity of Affected Persons") +
        scale_fill_manual (values = c ("darkgray",
                                       "darkorange")) +
        guides (fill = guide_legend (title = "Damage Type")) +
        xlab ("Event Type") +
        theme (axis.text = element_text (size = 12,
                                         colour = "darkblue"),
               axis.title = element_text (size = 14,
                                          colour = "darkgreen",
                                          face = "bold"),
               title = element_text (size = 16,
                                     colour = "darkgreen",
                                     face = "bold"),
               legend.text = element_text (size = 12,
                                           colour = "black",
                                           face = "bold")) +
        coord_flip ()



# 2. Across the United States, which types of events have the greatest economic consequences?

prop_crop_dmg_vector <- aggregate (cbind (propdmg, cropdmg) ~ evtype,
                                         aux_activity,
                                         FUN = sum)

prop_crop_dmg_toplot <- melt (head(prop_crop_dmg_vector[order (-prop_crop_dmg_vector$propdmg,
                                                               -prop_crop_dmg_vector$cropdmg),],
                                         nrow_aux_activity))

colnames (prop_crop_dmg_toplot) <- c ("event_type",
                                            "Property_Crop",
                                            "value")

ggplot (prop_crop_dmg_toplot,
        aes (x = reorder (event_type,
                          value),
             y = value,
             fill = factor (Property_Crop,
                            labels = c("Property",
                                       "Crop")))) +
        geom_bar (stat = "identity") +
        labs (title = "Economic Consequences - Weather Events  (1950 - 2011)",
              x = "Event Type",
              y = "Quantity of Economic Consequence (Millions - M)") +
        scale_fill_manual (values = c ("darkgray",
                                       "darkorange")) +
        guides (fill = guide_legend (title = "Damage Type")) +
        xlab ("Event Type") +
        theme (axis.text = element_text (size = 12,
                                         colour = "darkblue"),
               axis.title = element_text (size = 14,
                                          colour = "darkgreen",
                                          face = "bold"),
               title = element_text (size = 16,
                                     colour = "darkgreen",
                                     face = "bold"),
               legend.text = element_text (size = 12,
                                           colour = "black",
                                           face = "bold")) +
        coord_flip ()

# Dataframe with Most Harmful Events, detailed as original table
detailed_HE_DF <- subset (aux_activity, select = c (evtype, fatalities, injuries))
colnames (detailed_HE_DF) <- c ("Event Type", "Fatalities", "Injuries")
print (detailed_HE_DF[with (detailed_HE_DF, order (-Fatalities, -Injuries)),],
       comment = FALSE,
       include.rownames = FALSE,
       type = "html")

# Daatframe with Weather Events with More Economic Consequences, detailed as original table
detailed_EC_DF <- subset (aux_activity, select = c (evtype, propdmg, cropdmg))
colnames (detailed_EC_DF) <- c ("Event Type", "Property_Damages", "Crop_Damages")
print (detailed_EC_DF[with (detailed_EC_DF, order (-Property_Damages, -Crop_Damages)),],
       comment = FALSE,
       include.rownames = FALSE,
       type = "html")
