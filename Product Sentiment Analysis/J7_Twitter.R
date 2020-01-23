setwd("") #set working dir

##########################Extracting data for Samsung Galaxy J5  from Twitter##############################
require("twitteR")||install.packages("twitteR")
require("base64enc")||install.packages("base64enc")
#Loading Libraries
library(twitteR)
library(base64enc)
#############################################
# Authentication
#############################################
api_key <- "fnLKeusO9EbIiQL0k8I5juYW9"                                  #Consumer key
api_secret <- "KchEB4KIEY7wuCtnNKsAbWWqmC7fwFKIbQ6KUd9XXNLGAFzdJ4"      #Consumer secret
access_token <- "3987295005-OPRfxUmGU3TyTcw7l5X4Nrl7ZcRxznhiBRSu7k1"    #Access token 
access_token_secret <- "yl7Ob0t8xKxb62KkbCtj8h32LAVjkHUWsUsdyWcs1JrZd"  #Access token secret

#Set up Twitter connection
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#Extracting Tweets
# tweets = searchTwitter('Samsung Galaxy J5 OR Samsung J5 OR #samsunggalaxyj5 OR #samsungj5', n=1000, lang='en' )     # hash tag for tweets search and number of tweets
# tweets = searchTwitter('Samsung Galaxy J7 OR Samsung J7 OR #samsunggalaxyj7 OR #samsungj7', n=1000, lang='en' )     # hash tag for tweets search and number of tweets
tweets = searchTwitter('#GalaxyJ7 OR Samsung Galaxy J7 OR Samsung J7 OR #samsunggalaxyj7 OR #samsungj7',n=1000,lang='en')     # hash tag for tweets search and number of tweets
tweets = twListToDF(tweets)    # Convert from list to dataframe

#Cleaning of Tweets
tweets.df = tweets[,1]  # assign tweets for cleaning
tweets.df = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets.df);head(tweets.df) 
tweets.df = gsub("@\\w+", "", tweets.df);head(tweets.df) # regex for removing @user
tweets.df = gsub("[[:punct:]]", "", tweets.df);head(tweets.df) # regex for removing punctuation mark
#tweets.df = gsub("[[:digit:]]", "", tweets.df);head(tweets.df) # regex for removing numbers
tweets.df = gsub("http\\w+", "", tweets.df);head(tweets.df) # regex for removing links
tweets.df = gsub("\n", " ", tweets.df);head(tweets.df)  ## regex for removing new line (\n)
tweets.df = gsub("[ \t]{2,}", " ", tweets.df);head(tweets.df) ## regex for removing two blank space
tweets.df =  gsub("[^[:alnum:]///' ]", " ", tweets.df)     # keep only alpha numeric 
tweets.df =  iconv(tweets.df, "latin1", "ASCII", sub="")   # Keep only ASCII characters
tweets.df = gsub("^\\s+|\\s+$", "", tweets.df);head(tweets.df)  # Remove leading and trailing white space
tweets.df = gsub("GalaxyJ","GalaxyJ7",tweets.df)
tweets.df = gsub("Galaxy J","Galaxy J7",tweets.df)
tweets.df = gsub("Samsung J","Samsung J7",tweets.df)
tweets.df = gsub("galaxyJ","galaxyJ7",tweets.df)
tweets.df = gsub("samsungj","samsungj7",tweets.df)
tweets.df = gsub("amp","",tweets.df)
tweets[,1] = tweets.df # save in Data frame
#head(tweets$text)

final_tweets = tweets$text
final_tweets = unique(final_tweets)
write.table(final_tweets,"j7_tweets.txt",row.names=F,col.names=F)
