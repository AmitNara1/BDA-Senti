# Load required libraries
library(tm)
library(wordcloud2)

# Load your labeled data
data <- read.csv("chat_dataset.csv", stringsAsFactors = FALSE)

# Assuming your dataset has columns named "message" and "sentiment"
# Replace "message" and "sentiment" with your actual column names

# Create text corpora for each sentiment category
positive_corpus <- Corpus(VectorSource(data$message[data$senti == "Positive"]))
negative_corpus <- Corpus(VectorSource(data$message[data$senti == "Negative"]))
neutral_corpus <- Corpus(VectorSource(data$message[data$senti == "Neutral"]))

# Preprocess the text in each corpus
corpus_list <- list(
  positive = positive_corpus,
  negative = negative_corpus,
  neutral = neutral_corpus
)

# Create word clouds for each sentiment category
for (senti in names(corpus_list)) {
  corpus <- corpus_list[[senti]]
  
  # Text preprocessing
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  
  # Create a document-term matrix
  dtm <- DocumentTermMatrix(corpus)
  
  # Convert the DTM to a matrix
  dtm_matrix <- as.matrix(dtm)
  
  # Calculate word frequencies
  word_freq <- rowSums(dtm_matrix)
  
  # Create a word cloud for the current sentiment category
  wordcloud2(
    data = data.frame(word = names(word_freq), freq = word_freq),
    color = senti,
    backgroundColor = "black",
    size = 1.5
  )
}

