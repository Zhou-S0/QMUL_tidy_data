# Student ID - 210928411
# Personal tokem - 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
# Assessment two - Data tidying

spotify_messy <- read.table("Spotify_datasets_2024/Spotify_Messy_210928411.txt", sep='\t', header=T)
# Using the read.table function to allow the data set to be view on my environment to see what needs to be tidied on the Spotify dataset

install.packages("tidyr")
library(tidyr)
# Install the tidyr package to use it's functions to help data tidying

install.packages("dplyr")
library(dplyr)
# Install the dplyr package to use it's functions to help data tidying like renaming

# First issue that needs to be tidied up is changing the column name from 'ZZtrack_name89' to 'track_name'
spotify_messy <- spotify_messy %>% rename(c("track_name" = "ZZtrack_name89"))
# Using the rename function, I can change the name from 'ZZtrack_name89' to the preferred named of 'track_name' to keep everything tidy and consistent

# Second issue that needs to be tidied is splitting the danceablity and energy columns
spotify_messy <- spotify_messy %>% separate_wider_delim('danceability.energy',"_",
                                                        names=c("danceability",
                                                                "energy"))
# The new columns should be called 'danceability' and 'energy' after using the separate_wider_delim function

# Third issue to fix is to remove the character 'Q' from the mode column
spotify_messy <- spotify_messy %>% mutate("mode"=gsub("Q","",mode))
# The mutate function should remove the Q from the mode column since the values should be only either 0 or 1 according to the Spotify dictionary

# Fourth issue I need to fix is the spelling mistake of the artist 'The Four Owls' -> Turning the 'Fourty' into 'Four'
spotify_messy <- spotify_messy %>% mutate(track_artist = gsub("The Fourty Owls", "The Four Owls", track_artist))
# Using the mutate function, I can change the name to all the mispellings on 'The Four Owls' without doing them individually

# Fifth issue I need to tidy is by separating the genres and subgenres into two different columns using pivot_longer
spotify_messy <- spotify_messy %>%
  pivot_longer(cols = c(rap, rock, latin, r.b),
               names_to = "playlist_genre",
               values_to = "playlist_subgenre",
               values_drop_na = TRUE)
# The pivot_longer function turns the data selected from a wide format to a long format. This allows me to add two new columns called 'playlist_genre' and 'playlist_subgenre'
 # This means the genres do not have their own variable, making the data file look more tidier.

# Sixth issue I need to tidy is round up the danceability values to two decimal places allowing consistancy and the numbers not be too long
str(spotify_messy$danceability)
spotify_messy$danceability <- as.numeric(spotify_messy$danceability)
# To make sure everything is numberic for the 'round' function to work, I need to convert the danceability column into a numeric data type 
spotify_messy <- spotify_messy %>% mutate(danceability = round(danceability, digits = 2))

# Repeat and continue rounding the columns that are able to be presented in 2 decimal places with the same coding - Energy, Loudness, Speechiness, Liveness, Valence and Tempo
# Energy column
spotify_messy$energy <- as.numeric(spotify_messy$energy)
spotify_messy <- spotify_messy %>% mutate(energy = round(energy, digits = 2))

# Loudness column 
spotify_messy$loudness <- as.numeric(spotify_messy$loudness)
spotify_messy <- spotify_messy %>% mutate(loudness = round(loudness, digits = 2))

# Speechiness column
spotify_messy$speechiness <- as.numeric(spotify_messy$speechiness)
spotify_messy <- spotify_messy %>% mutate(speechiness = round(speechiness, digits = 2)) 

# Liveness column
spotify_messy$liveness <- as.numeric(spotify_messy$liveness)
spotify_messy <- spotify_messy %>% mutate(liveness = round(liveness, digits = 2)) 

# Valence column
spotify_messy$valence <- as.numeric(spotify_messy$valence)
spotify_messy <- spotify_messy %>% mutate(valence = round(valence, digits = 2)) 

# Tempo column
spotify_messy$tempo <- as.numeric(spotify_messy$tempo)
spotify_messy <- spotify_messy %>% mutate(tempo = round(tempo, digits = 2)) 

# The last issue that I needed to tidy was the '0.5' in the 'track_album_release_date' column - 0.5 to 2005
spotify_messy <- spotify_messy %>% mutate(track_album_release_date = sub("^0.5", "2005", track_album_release_date))
# The mutate allows me to change the 0.5 to the correct year 2005 in the column needed along with the sub function

# This is to export the clean/tidy data into a suitable format using write.table
write.table(spotify_messy, "Spotify2020_210928411_clean.txt",
            sep="\t",
            col.names = T,
            row.names = F,
            quote =F)