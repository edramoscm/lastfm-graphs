library(data.table)
library(ggplot2)
library(plotly)
library(dplyr)
setwd("PATH/TO/CSV/FOLDER") #path to CSV file

#### Function used ####
mo2Num <- function(x) {match(tolower(x), tolower(month.abb))}

#### Data tidying ####

db <- read.csv("USERNAME.csv", header=F) # CSV file name - change USERNAME to your last.fm username
colnames(db) <- c("Artist", "Album", "Song", "Day")
newcolumns <- transpose(as.data.frame(strsplit(db$Day,"\\s+")))
colnames(newcolumns) <- c("Day", "Month", "Year", "Time")
db$Day <- NULL
db <- data.frame(db,newcolumns)
rm(newcolumns)

db_YEAR <- db[db$Year == 2022,]

db_YEAR$Month <- mo2Num(db_YEAR$Month)
db_YEAR$Time <- as.integer(gsub(":", "", db_YEAR$Time))

#### ARTISTS ####

aux_db <- data.frame(db_YEAR$Artist, db_YEAR$Month)
colnames(aux_db) <- c("Artist", "Month")

top10 <-
  aux_db %>%
    group_by(Artist, Month) %>% 
    summarise(n=n(),.groups="rowwise")

top10 <- top10[order(top10$Month, top10$n, decreasing=T),]

top_artists <- aux_db %>% 
  group_by(Artist) %>% 
  summarise(n=n(),.groups="rowwise")
top_artists <- head(top_artists[order(top_artists$n, decreasing=T),1],10)

top10 <- top10[top10$Artist %in% top_artists$Artist,]

for (i in 1:10){
  for (j in 1:12){
    if (all(top10[top10$Artist == top_artists$Artist[i],2] != j)) {
      top10 <- rbind(top10, c(top10$Artist[i],j,0))
    }
  }
  if (i == 10){
    top10$Month <- as.integer(top10$Month)
    top10$n <- as.integer(top10$n)
    top10 <- top10[order(top10$Month, top10$n, decreasing=T),]
  }
}

rm(top_artists)

#### MOST LISTENED MUSICIANS GRAPH ####
q <- ggplot(data=top10, aes(x=Month, y=n, color=Artist)) 

q + geom_line(size = 1.5) + 
  xlab("Month") + 
  theme_minimal() +
  scale_x_continuous(labels = month.name, breaks= seq_along(month.name)) +
  ylab("Songs listened") + 
  ggtitle("Most listened musicians") + 
  scale_color_manual(values=c("Black", "Green", "Dark Blue", "Yellow", "Pink", "Light Blue", "Gray", "Red", "Purple", "Orange")) + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 40, family="Courier"),
    axis.title.x = element_text(size = 25), 
    axis.title.y = element_text(size=25), 
    axis.text.x= element_text(size=15), 
    axis.text.y= element_text(size=15),
    legend.title = element_text(size=25),
    legend.text = element_text(size=20),
    legend.position = c(0.1,0.775)
  )

#### ALBUMS ####
aux_db <- aux_db <- data.frame(db_YEAR$Album, db_YEAR$Month)
colnames(aux_db) <- c("Album", "Month")

top10_albums<- aux_db %>%
  group_by(Album, Month) %>% 
  summarise(n=n(),.groups="rowwise")

top10_albums <- top10_albums[order(top10_albums$Month, top10_albums$n, decreasing=T),]

top_albums <- aux_db %>% 
  group_by(Album) %>% 
  summarise(n=n(),.groups="rowwise")
top_albums <- head(top_albums[order(top_albums$n, decreasing=T),1],10)

top10_albums <- top10_albums[top10_albums$Album %in% top_albums$Album,]

for (i in 1:10){
  for (j in 1:12){
    if (all(top10_albums[top10_albums$Album == top_albums$Album[i],2] != j)) {
      top10_albums <- rbind(top10_albums, c(top_albums$Album[i],j,0))
    }
  }
  if (i == 10){
    top10_albums$Month <- as.integer(top10_albums$Month)
    top10_albums$count <- as.integer(top10_albums$count)
    top10_albums <- top10_albums[order(top10_albums$Month, top10_albums$count, decreasing=T),]
  }
}

rm(top_albums)

#### MOST LISTENED ALBUMS GRAPH ####

q2 <- ggplot(data=top10_albums, aes(x=Month, y=n, color=Album)) 

q2 + geom_line(size = 1.5) + 
  xlab("Month") + 
  theme_minimal() +
  scale_x_continuous(labels = month.name, breaks= seq_along(month.name)) +
  ylab("Songs listened") + 
  ggtitle("Most listened musicians") + 
  scale_color_manual(values=c("Black", "Green", "Dark Blue", "Yellow", "Pink", "Light Blue", "Gray", "Red", "Purple", "Orange")) + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 40, family="Courier"),
    axis.title.x = element_text(size = 25), 
    axis.title.y = element_text(size=25), 
    axis.text.x= element_text(size=15), 
    axis.text.y= element_text(size=15),
    legend.title = element_text(size=25),
    legend.text = element_text(size=20),
    legend.position = c(0.1,0.775)
  )

#### TOP 100 ALBUMS DISTRIBUTION ####

top100Albums <- distinct(db_YEAR %>% 
          group_by(Album) %>% 
          summarize(n=n(),Artist,.groups="rowwise") %>% 
          arrange(desc(n))) 

top100Albums <- tibble::rowid_to_column(
  head(top100Albums[!duplicated(top100Albums$Album),],100), 
  "Position"
  )

p1 <- plot_ly(data=top100Albums, x=~Position , y=~n,
              type="scatter", mode="markers",
              marker=list(size=12),
              color=~as.factor(Artist),
              hover_info="text",
              text=paste(top100Albums$Album)
) %>% config(displayModeBar =F)

axis <- list(size=30)

layout(p1,
       title=list(text="Top 100 albums of 2022"),
       xaxis=list(title=list(text="Album's position", font=axis)), 
       yaxis=list(title=list(text="Times listened", font=axis))) %>% 
  layout(plot_bgcolor='rgb(0,0,0)') %>% 
  layout(paper_bgcolor='rgb(0,0,0)')

#### FREQUENCY THROUGHOUT THE DAY ####
db_YEAR$Hours <- as.integer(db_YEAR$Time/100)
db_YEAR$Minutes <- db_YEAR$Time%%100
db_YEAR$Time <- NULL

## Time zone correction
## Uncomment only if necessary and insert your time zone in [TIMEZONE]
# tz <- [TIMEZONE]
# db_YEAR$Hours <- db_YEAR$Hours + tz
# time_zone_correction <- ifelse(db_YEAR$Hours < 0, +24, 0)
# db_YEAR$Hours <- db_YEAR$Hours + time_zone_correction

q3 <- ggplot(db_YEAR, aes(x=Hours))

q3 + geom_bar(width=1, color="red", fill="gray") +
  coord_polar(start = -0.15) +
  theme_minimal()+
  ggtitle("Songs listened throughout the day") +
  xlab("Hours") +
  ylab("Quantity")+
  scale_x_continuous(breaks=seq(0,23)) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 30),
    axis.title.y = element_text(size=25)
  )


