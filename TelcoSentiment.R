setwd("/Users/suryakandukuri/Documents/RWorkshop")
# Required packages
library(twitteR)
library(rjson)
library(httr)
library(stringr)
library(ggplot2)
library(RColorBrewer)
library(plyr)
library(bit64)

setup_twitter_oauth("a2WqnFLJxLtehroCRWyLuqvl5", "Dnc8BH3FwDaLJ87KSIZ548CSX2HXtxTS7mkXOzLJYIZK9lDMcm", "3307567015-YuWE96K82q0P4qFOBqhDz1u2kNE0fvFgh0mU4QX","mZPepECiLLA6U7eijStK66iKga1JbEDDOTK4h5oUfcM5T")

### Load the Hu & Liu?s opinion lexicon of positive and negative words

pos.words <- scan('HuLiuOpinionLexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('HuLiuOpinionLexicon/negative-words.txt', what='character', comment.char=';')

#Jeff Green sentiment function
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)
    require(stringr)
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        sentence = tolower(sentence)
        word.list = str_split(sentence, '\\s+')
        words = unlist(word.list)
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
        score = sum(pos.matches) - sum(neg.matches)
        return(score)
    }, pos.words, neg.words, .progress=.progress )
    scores.df = data.frame(score=scores, text=sentences)
    return(scores.df)
}

airtel.tweets <- searchTwitter('to:@airtel_presence', n=500, lang="en")
airtel.text = laply(airtel.tweets, function(t) t$getText())
airtel.text = gsub("[^[:alnum:]|^[:space:]]", "", airtel.text)
airtel.scores <- score.sentiment(airtel.text, pos.words, 
                                   neg.words, .progress='text')
airtel.scores$team = 'Bharti Airtel'
airtel.scores$code = 'AIRTEL'

vodafone.tweets <- searchTwitter('to:@vodafonein', n=500, lang="en")
vodafone.text = laply(vodafone.tweets, function(t) t$getText())
vodafone.text = gsub("[^[:alnum:]|^[:space:]]", "", vodafone.text)
vodafone.scores <- score.sentiment(vodafone.text, pos.words, 
                                   neg.words, .progress='text')
vodafone.scores$team = 'Vodafone India'
vodafone.scores$code = 'vodafone'

telco.scores = rbind(airtel.scores, vodafone.scores)

ggplot(data=telco.scores) +
    geom_histogram(mapping=aes(x=score, fill=team), binwidth=1) + 
    facet_grid(team~.) +
    theme_bw() + scale_color_brewer() +
    labs(title="Telco Teams Sentiment")

