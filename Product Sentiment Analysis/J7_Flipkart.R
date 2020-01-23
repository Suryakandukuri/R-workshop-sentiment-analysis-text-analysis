#####################################################################
# Function for downloading product reviews from flipkart
# Usage:
# url = "http://www.flipkart.com/samsung-galaxy-j5/product-reviews/ITME9ZFU2GWV52KZ?pid=MOBE93GWSA63AU7V&rating=1,2,3,4,5&reviewers=all&type=top&sort=most_helpful&start=0"
# pr_review = flipkart(url,10)
#
# url should be product reviews url (Make sure first you click on top reviews or show all)
# refer to the ppt for  getting the url
#
#####################################################################

require(stringr)||install.packages("stringr"); library(stringr)  
require(utils)||install.packages("utils"); library(utils)  


flipkart = function(url,        # Flipkart review URL. first click on show all or top review
                    n )       # Number of pages to extarct
  
{           
  
  text_page=character(0)   # define blank file
  
  pb <- txtProgressBar(min = 1, max = n, style = 3)    # define progress bar
  url = unlist(str_split(url,"&"))[1]
  
  for(i in 0:n){           # loop for url
    
    p =i*10  
    e = "&rating=1,2,3,4,5&reviewers=all&type=top&sort=most_helpful&start="
    url0 = paste(url,e,p,sep="")           # Create flipkart url in correct format
    
    text = readLines(url0)     # Read URL       
    
    text_start = grep("<span class=\"review-text\">",text)   # review start marker
    
    text_stop = grep("<div class=\"tpadding10 line feedback-container\">", text)  # review end marker
    
    
    setTxtProgressBar(pb, i)             # print progress bar
    
    if (length(text_start) == 0) break    # check for loop termination, i.e valid page found      
    
    for(j in 1:length(text_start))        # Consolidate all reviews     
    {
      text_temp = paste(paste(text[(text_start[j]+1):(text_stop[j])]),collapse=" ")
      text_page = c(text_page,text_temp)
    }
    #Sys.sleep(1)
  }
  
  text_page = gsub("<.*?>", "", text_page)       # regex for Removing HTML character 
  text_page = gsub("^\\s+|\\s+$", "", text_page) # regex for removing leading and trailing white space
  #text_page = gsub("Was this review helpful.*?helpful.","",text_page)
  text_page = gsub("&amp","",text_page)
  text_page = gsub("&quot","",text_page)
  
  return(text_page)       # return reviews
}

url = "http://www.flipkart.com/samsung-galaxy-j7/product-reviews/ITMEAFBFJHSYDBPW?pid=MOBE93GWSMGZHFSK"
j7_gold= flipkart(url,30)
# length(j7_gold)
# j7_gold=gsub("Was this review helpful.*?helpful.","",j7_gold)

url = "http://www.flipkart.com/samsung-galaxy-j7/product-reviews/ITMEAFBYQP7KAYAV?pid=MOBE93GWZDQ4NJ9Z"
j7_black= flipkart(url,20)
# length(j7_black)
# j7_black=gsub("Was this review helpful.*?helpful.","",j7_black)

url = "http://www.flipkart.com/samsung-galaxy-j7/product-reviews/ITME9C8ET7PARVHY?pid=MOBE93GW9XJXNXES"
j7_white= flipkart(url,20)
# length(j7_white)
# j7_white=gsub("Was this review helpful.*?helpful.","",j7_white)

j7=c(j7_gold,j7_black,j7_white)
# length(j7)

# setwd("E:/WorkspaceTheory/CBA_5/Term-1/Data_Collection/Assignment/Assignment-DC-4-Group-Text_analytics_topic_modeling/DC_Assignment4_Final/Flipkart")

writeLines(j7,"j7_flipkart.txt")

