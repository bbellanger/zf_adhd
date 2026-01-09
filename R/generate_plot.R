print('#-----------------------------------------------------------------#')
print('#                                                                 #')
print('#        GENERATING ALL THE PLOTS FROM VIDEO TRACKING DATA        #')
print('#                                                                 #')
print('#-----------------------------------------------------------------#')

# Load tidyverse
library('tidyverse')

# Beautiful theme
my.theme <- theme(legend.position="none",
                      axis.line=element_line(linewidth=0.25),
                      axis.ticks=element_line(linewidth=0.25),
                      axis.title=element_text(size=8),
                      axis.text=element_text(size=6),
                      strip.placement="outside",
                      strip.text=element_text(size=8),
                      strip.background=element_blank())
    update_geom_defaults("point", list(fill="white", shape=21, size=1.1))
    update_geom_defaults("line", list(linewidth=0.25))

# Change your sample accordingly to your study
#analysis_vars <- c("Rb346", "Rb349", "Rb3830", "Rb384", "Rb385", "Rb389", "Rb390")
# Testing with:
analysis_vars <- c("Rb346", "Rb349", "Rb384", "Rb385")

# Import and combine dataframes
folder_path <- "./build/LocationOutputs/"
csv_files <- list.files(path = folder_path, pattern = "\\.csv", full.names = TRUE)
list_of_dataframes <- lapply(csv_files, read.csv)
combined_data <- bind_rows(list_of_dataframes)

combined_data <- (
    combined_data %>% mutate(File = str_sub(File, end = -5))
)

# Import reference table
reference_path <- "./tables/videos.csv"
reference_csv <- read.csv(reference_path)

# Import the surgery reference
virus_path <- "./tables/all-birds.csv"
virus_csv <- read.csv(virus_path)

# Keep only the interesting vars
virus_csv <- virus_csv %>% select(bird, injected_with)

# Create mastersheet
mastersheet <- inner_join(reference_csv, combined_data, by="File")
mastersheet <- left_join(mastersheet, virus_csv, by="bird")

# Filter_out outliers
mastersheet <- (
    mastersheet %>% filter (Frame < 20000, Distance_px < 80)
)

# Save mastersheet in output
# Sanity check
write.csv(mastersheet, "./output/mastersheet.csv")

# Modify Distance_px to 0 where Frame == 0 for each bird
mastersheet <- mastersheet %>%
  mutate(Distance_px = ifelse(Frame == 0, 0, Distance_px))

# loop through analysis_vars
for (var_name in analysis_vars) {
    #print(paste("Processing variable:", var_name))
    filter <- (
        mastersheet %>% filter(bird == var_name)
        %>% filter(Frame < 20000, Distance_px < 80)
    )
    options(repr.plot.width=9, repr.plot.height=2)
    plot <- (
        ggplot(filter, aes(x=Frame, y=Distance_px))
        + geom_line()
        + ylim(0, 80)                             # Keep the same scale for all plots
        + facet_grid(. ~ File)
        )
    p2 <- (plot + ggtitle(paste0(var_name, " distance travelled depending on broadcast")))
    ggsave(paste0("./output/distance_travelled/", var_name, ".pdf"), plot = p2, width = 7, height = 5, units = "in")
    print(p2)
}

# loop through analysis_vars
for (var_name in analysis_vars) {
    #print(paste("Processing variable:", var_name))
    filter <- (
        mastersheet %>% filter(bird == var_name)
        %>% filter(Frame < 20000, Distance_px < 80)
    )
    #print(head(filter))
    options(repr.plot.width=9, repr.plot.height=3.5)
    p <- (
        ggplot(filter, aes(x=X, y=Y))
        + geom_point()
        + facet_grid(. ~ File)
        + my.theme
        + ggtitle(paste(var_name, " path depending on broadcast"))
    )
    ggsave(paste0("./output/path_travelled/", var_name, ".pdf"), plot = p2, width = 7, height = 5, units = "in")
    print(p)
}

bird_avg_distances <- sapply(analysis_vars, function(var_name) {
  filtered_data <- mastersheet %>%
    filter(bird == var_name, Frame < 20000, Distance_px < 80)
  
  mean(filtered_data$Distance_px, na.rm = TRUE)
})

# Result: a named numeric vector
print("#-----------|    STATISTICS OF THE TRACKING    |----------#")
print(bird_avg_distances)

