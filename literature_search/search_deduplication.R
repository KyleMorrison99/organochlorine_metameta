## Persistent organic pollutant reliability deduplication

rm(list= ls())


## Load Packages
pacman::p_load(tidyverse,
               synthesisr,
               tidystringdist,
               bibliometrix,
               here)

# Load file with all searches combined 
dat <-  read.csv(here("literature_search", "all_search_combined", "all_search_combined_with_duplicates.csv"), skip = 0)
dim(dat)

# Remove all punctuation
dat$title2 <- str_replace_all(dat$title,"[:punct:]","") %>% 
  str_replace_all(.,"[ ]+", " ") %>% 
  tolower()

# Remove exact titles
dat2 <- distinct(dat, title2, .keep_all = TRUE) 
dim(dat2) # 918 remain 


# Save file
write_csv(dat2, here("literature_search", "all_search_combined", "pop_reliability_deduplicated.csv"))



total_rows <- nrow(dat2)
num_chunks <- ceiling(total_rows / 304) # Use ceiling to ensure all data is included

# Create a sequence that assigns each row to a chunk
chunk_assignment <- rep(1:num_chunks, each=306, length.out=total_rows)

# Split the dataset into chunks based on the chunk assignments
chunks <- split(dat2, chunk_assignment)

# Write function
for (i in seq_along(chunks)) {
  # Construct file path
  file_path <- sprintf("literature_screen/abstract_screening_allocated/chunk_%d.csv", i)
  # Use write.csv to save each chunk
  write.csv(chunks[[i]], file_path)
  
}

# Load datsets
dat_result_yes <- read.csv(here("literature_screen", "abstract_screening_results", "abstract_screening_yes.csv"), skip = 0)
dat_result_maybe <- read.csv(here("literature_screen", "abstract_screening_results", "abstract_screening_maybe.csv"), skip = 0)

# Combine files
dat_abstract_results <- rbind(dat_result_yes, dat_result_maybe)

# Get the total number of rows
total_rows_full <- nrow(dat_abstract_results) # 193

# Calculate the number of chunks
num_chunks_full <- ceiling(total_rows_full / 65) # Use ceiling to ensure all data is included

# Create a sequence that assigns each row to a chunk
chunk_assignment_full <- rep(1:num_chunks_full, each=65, length.out=total_rows_full)

# Split the dataset into chunks based on the chunk assignments
chunks_full <- split(dat_abstract_results, chunk_assignment_full)


# Write function
for (i in seq_along(chunks_full)) {
  # Construct file path
  file_path <- sprintf("literature_screen/full_text_screening_allocated/chunk_%d.csv", i)
  # Use write.csv to save each chunk
  write.csv(chunks_full[[i]], file_path)
  
}





