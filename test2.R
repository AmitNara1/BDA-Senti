# Load required libraries
library(tm)
library(caret)
install.packages("textdata")
library(textdata)
install.packages("textTinyR")
library(textTinyR)



# Load your labeled data (replace "your_data.csv" with your data file)
data <- read.csv("chat_dataset.csv", stringsAsFactors = FALSE)

# Create a corpus from the message column
corpus <- Corpus(VectorSource(data$message))

# Text preprocessing
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

# Create a document-term matrix (DTM)
dtm <- DocumentTermMatrix(corpus)

# Convert the DTM to a data frame
dtm_df <- as.data.frame(as.matrix(dtm))

# Add the sentiment labels
dtm_df$sentiment <- data$sentiment
library(e1071)

# Train a Naive Bayes model
model <- naiveBayes(sentiment ~ ., data = dtm_df)

#new_message <- "i am getting angry as this is not working"
new_message <- readline("Enter your message: ")

# Print the input
cat("You entered:", new_message, "\n")

# Create a data frame for the new message
new_data <- data.frame(message = new_message)

# Preprocess the new message
new_data_corpus <- Corpus(VectorSource(new_data$message))
new_data_corpus <- tm_map(new_data_corpus, content_transformer(tolower))
new_data_corpus <- tm_map(new_data_corpus, removePunctuation)
new_data_corpus <- tm_map(new_data_corpus, removeNumbers)
new_data_corpus <- tm_map(new_data_corpus, removeWords, stopwords("english"))
new_data_corpus <- tm_map(new_data_corpus, stripWhitespace)
new_data_dtm <- DocumentTermMatrix(new_data_corpus)
new_data_df <- as.data.frame(as.matrix(new_data_dtm))

# Predict sentiment for the new message
new_message_sentiment <- predict(model, new_data_df)

print(new_message_sentiment)

