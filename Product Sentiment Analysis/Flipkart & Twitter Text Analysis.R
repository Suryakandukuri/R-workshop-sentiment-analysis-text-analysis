#####################################################################
# Set the directory & Env.
#####################################################################
setwd("/Users/suryakandukuri/Documents/RWorkshop/Product Sentiment Analysis") 
# Sys.setenv(JAVA_HOME='C:/Program Files/Java/jdk1.8.0_20') # for 64-bit version

######################################################################################################
# ****************************************************************************************************
# 1. Pick up any well-known brand- product or service.  E.g. Xbox360 or Jabong or iphoneX or Nike.
# 
# Samsung J7
# ****************************************************************************************************
######################################################################################################




######################################################################################################
# ****************************************************************************************************
# 2. Collect 3 sets of data for it:
# 
# (a) 100+ consumer reviews from either flipkart
# ****************************************************************************************************
######################################################################################################

source("J7_Flipkart.R")
# source(file.choose())  #    Select J7_Flipkart.R



######################################################################################################
# ****************************************************************************************************
# 2. Collect 3 sets of data for it:
# 
# (b) 500+ tweets
# ****************************************************************************************************
######################################################################################################

source("J7_Twitter.R")
# source(file.choose())  #    Select J7_Twitter.R


######################################################################################################
# ****************************************************************************************************
# 2. Collect 3 sets of data for it:
# 
# (c) 50+ articles from Googlenews or any other news aggregator sites.
#      ->Covered in separate section
# ****************************************************************************************************
######################################################################################################


######################################################################################################
# ****************************************************************************************************
# 4. For each set of data, perform the following analyses:
# 
# (a) General wordcloud using both TF and TFIDF weighing schemes. Update stopwords list to filter out 
#     noisy or irrelevant terms. 
# (b) Sentiment analysis. Display wordclouds separately for the top 50 most positive and most negative words. 
# (c) Identify the top few most positive and most negative documents. Read them and speculate on why 
#     they are so positive or negative about it.
# 
# 
# Ans. All the (a), (b) and (c) will run with the interval of 15 seconds. Execute the below functions for each 
#       Flipkart & Twitter by calling their respective file mentioned in comments.
# 
# 
# ****************************************************************************************************
######################################################################################################



#########################################----FLIPKART----START----################################################

source("J7_TextAnalysis.R") #Select j7_flipkart.txt

#########################################----FLIPKART----END----##################################################

#########################################----TWITTER----START----################################################

source("J7_TextAnalysis.R") #Select j7_tweets.txt

#########################################----TWITTER----END----################################################



######################################################################################################
# ****************************************************************************************************
# 5. Latent topic mining: Topic mine a corpus from any one dataset. Use no more than 2 or 3 topics. 
#    Make wordclouds of the topic's tokens. Interpret in a few lines what the topics are saying.
# 
# Ans. A file of Latent top topics will be created on the drive and word cloud will be displayed max to 3 for any data.
# ****************************************************************************************************
######################################################################################################

source("J7_TextAnalysis_LatentTopicMinig.R") #Select Any file j7_flipkart.txt OR j7_tweets.txt
