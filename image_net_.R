# download images: 

?read.table

dogs_urls <- read.table("imagenet.synset.geturls.dogs.txt", stringsAsFactors = FALSE)

setwd("~/Documents/Kaggle/CNN presentation/cat_images")
dogs_100 <- dogs_urls[11:30, ]

for (i in 1:length(dogs_100)){
  dog.1 <- paste(c("dog_2_", i, ".jpg"), collapse = "")
  download.file(dogs_100[i], dog.1, mode = 'wb')
}

?download.file

setwd("~/Documents/Kaggle/CNN presentation/cat_images")
cats_urls <- read.table("imagenet.url.cats.txt", stringsAsFactors = FALSE)

cats_100 <- cats_urls[6:30, ]

for (i in 1:length(cats_100)){
  cat.1 <- paste(c("cat_2", i, ".jpg"), collapse = "")
  download.file(cats_100[i], cat.1, mode = 'wb')
}
