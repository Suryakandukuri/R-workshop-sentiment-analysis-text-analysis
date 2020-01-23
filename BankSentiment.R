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

icici.tweets <- searchTwitter('to:@ICICIBank_Care', n=1000, lang="en")
icici.text = laply(icici.tweets, function(t) t$getText())
icici.text = gsub("[^[:alnum:]|^[:space:]]", "", icici.text)
icici.scores <- score.sentiment(icici.text, pos.words, 
                                   neg.words, .progress='text')
icici.scores$team = 'ICICI Bank'
icici.scores$code = 'ICICI'

axis.tweets <- searchTwitter('to:@AxisBankSupport', n=1000, lang="en")
axis.text = laply(axis.tweets, function(t) t$getText())
axis.text = gsub("[^[:alnum:]|^[:space:]]", "", axis.text)
axis.scores <- score.sentiment(axis.text, pos.words, 
                                   neg.words, .progress='text')
axis.scores$team = 'Axis Bank'
axis.scores$code = 'axis'

sbi.tweets <- searchTwitter('to:@SBICard_Connect', n=1000, lang="en")
sbi.text = laply(sbi.tweets, function(t) t$getText())
sbi.text = gsub("[^[:alnum:]|^[:space:]]", "", sbi.text)
sbi.scores <- score.sentiment(sbi.text, pos.words, 
                                   neg.words, .progress='text')
sbi.scores$team = 'State Bank'
sbi.scores$code = 'sbi'

hdfc.tweets <- searchTwitter('to:@HDFCBank_Cares', n=1000, lang="en")
hdfc.text = laply(hdfc.tweets, function(t) t$getText())
hdfc.text = gsub("[^[:alnum:]|^[:space:]]", "", hdfc.text)
hdfc.scores <- score.sentiment(hdfc.text, pos.words, 
                                   neg.words, .progress='text')
hdfc.scores$team = 'HDFC Bank'
hdfc.scores$code = 'hdfc'

bank.scores = rbind(icici.scores, axis.scores, sbi.scores, hdfc.scores)

ggplot(data=bank.scores) +
    geom_bar(mapping=aes(x=score, fill=team), binwidth=1) + 
    facet_grid(team~.) +
    theme_bw() + scale_color_brewer() +
    labs(title="Telco Teams Sentiment")

ggplot(data=bank.scores) +
    geom_histogram(mapping=aes(x=score, fill=team), binwidth=1) + 
    facet_grid(team~.) +
    theme_bw() + scale_color_brewer() +
    labs(title="Telco Teams Sentiment")

