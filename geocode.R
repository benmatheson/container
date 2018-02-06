library(tidyverse)
library(jsonlite)
library(ggmap)

getwd()
setwd("projects/container")

json <- "data/containerAlaska.json"
ak <- read_json(json)
ak <- fromJSON(json)
  
View(ak)
colnames(ak) <- c(  "identifier",
                    "trade_update_date",
                    "run_date",
                    "vessel_name",
                    "port_of_unlading",
                    "estimated_arrival_date",
                    "foreign_port_of_lading",
                    "record_status_indicator",
                    "place_of_receipt",
                    "port_of_destination",
                    "foreign_port_of_destination",
                    "secondary_notify_party_1",
                    "actual_arrival_date",
                    "consignee_name",
                    "consignee_address",
                    "consignee_contact_name",
                    "consignee_comm_number_qualifier",
                    "consignee_comm_number",
                    "shipper_party_name",
                    "shipper_address",
                    "shipper_contact_name",
                    "shipper_comm_number_qualifier",
                    "shipper_comm_number",
                    "container_number",
                    "description_sequence_number",
                    "piece_count",
                    "description_text",
                    "harmonized_number",
                    "harmonized_value",
                    "harmonized_weight",
                    "harmonized_weight_unit")


ak <- as.data.frame(ak, stringsAsFactors = FALSE)
ak_df <- filter(ak, description_text != "EMPTY CONTAINER")

uniqueForeign <- unique(ak_df$foreign_port_of_lading)


# uniqueContents <- unique(ak_df$description_text)
unique_df <- as.data.frame(uniqueForeign, stringsAsFactors = F)
uniqueForeignlimit <- filter(unique_df, uniqueForeign != "Luda,China (Mainland)" )

View(uniqueForeignlimit)

for(i in 1:nrow(uniqueForeignlimit))
{
  # Print("Working...")
  result <- geocode(uniqueForeignlimit$uniqueForeign[i], output = "latlona", source = "google")
  uniqueForeignlimit$lon[i] <- as.numeric(result[1])
  uniqueForeignlimit$lat[i] <- as.numeric(result[2])
  uniqueForeignlimit$geoAddress[i] <- as.character(result[3])
}






View(ak_df)
str(ak_df)


ak_df1 <- ak_df[1:100,]

write.csv(ak_df1, "ak_df1.csv")

write.csv(ak_df, "ak_df.csv")


for(i in 1:nrow(ak_df))
{
  # Print("Working...")
  result <- geocode(ak_df$foreign_port_of_lading[i], output = "latlona", source = "google")
  ak_df$lon[i] <- as.numeric(result[1])
  ak_df$lat[i] <- as.numeric(result[2])
  ak_df$geoAddress[i] <- as.character(result[3])
}


text <- ak_df$description_text
text

text_df <- data_frame(item = 1:length(text), text = text)

head(text_df)

text_nest <- unnest_tokens(text_df, word, text)
head(text_nest)

sorted <- sort(text_nest$item, decreasing=TRUE)
head(sorted)
asia <- filter(ak_df, lon > 0 )
head(asia)
View(asia)
head(ak_df)



summary(ak)
str(ak)





# 
# "fields": [
#   "identifier",
#   "trade_update_date",
#   "run_date",
#   "vessel_name",
#   "port_of_unlading",
#   "estimated_arrival_date",
#   "foreign_port_of_lading",
#   "record_status_indicator",
#   "place_of_receipt",
#   "port_of_destination",
#   "foreign_port_of_destination",
#   "secondary_notify_party_1",
#   "actual_arrival_date",
#   "consignee_name",
#   "consignee_address",
#   "consignee_contact_name",
#   "consignee_comm_number_qualifier",
#   "consignee_comm_number",
#   "shipper_party_name",
#   "shipper_address",
#   "shipper_contact_name",
#   "shipper_comm_number_qualifier",
#   "shipper_comm_number",
#   "container_number",
#   "description_sequence_number",
#   "piece_count",
#   "description_text",
#   "harmonized_number",
#   "harmonized_value",
#   "harmonized_weight",
#   "harmonized_weight_unit"
#   ],