# Load required libraries

library(ggplot2)
library(dplyr)
library(tm)
library(wordcloud)
data <- read.csv("chat_dataset.csv")

head(data) # View the first few rows of the data
summary(data) # Summary statistics of the data
str(data) # Data structure

sentiment_distribution <- data %>%
  group_by(Sentiment) %>%
  summarize(count = n())

# View the distribution
print(sentiment_distribution)
# Analysis done


# Calculate summary statistics
summary_stats <- data %>%
  group_by(sentiment) %>%
  summarize(
    count = n(),
    value = max(sentiment, na.rm = TRUE)
  )

# View summary statistics
print(summary_stats)


# Create a bar plot for sentiment distribution
ggplot(data, aes(x = sentiment, fill = sentiment)) +
  geom_bar() +
  labs(title = "Sentiment Distribution", x = "Sentiment") +
  theme_minimal()


