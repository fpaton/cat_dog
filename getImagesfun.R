
# Set dir for images: 
setwd("~/Documents/STAT/kaggle/cat_dog_CNN/dog_images")
dogUrl <- "http://image-net.org/api/text/imagenet.synset.geturls?wnid=n02084071"
catUrl <- "http://image-net.org/api/text/imagenet.synset.geturls?wnid=n02121620"

getImagesNet(urlX = dogUrl, size = 1000, image_name = "dog" )

getImagesNet <- function(urlX, size, image_name){
  # this function downloads images and deletes missing images:
  # parameters:
  # STRING   urlX: A synset of URLs from imagenet
  # INT      size: how many photos you want to download
  # STRING   image_name: the name the images will be saved under eg. image_name = "cat"

  urlX <- urlX
  z <- size
  image_name <- image_name
  
  imagesDf <- fread(urlX, sep=" ", header=FALSE) # read in txt file
  imagesVector <- imagesDf$V1 
  
  holderVector <- imagesVector[1:z]
  # to download images
  for (i in 1:length(holderVector)){
    tryCatch({  # needed to skip urls that result in an error when downloading
      holder_name <- paste(c(image_name, "_", i, ".jpg"), collapse = "")
      download.file(holderVector[i], holder_name, mode = 'wb')
    }, error=function(e){})
  }
  # to remove missing images
  for (i in 1:length(holderVector)){
    tryCatch({
      holderIndex <- paste(c(image_name, "_", i, ".jpg"), collapse = "")
      #dogIndex <- 'dog_1.jpg'
      if (file.info(holderIndex)[1] < 5000) file.remove(holderIndex)
    }, error=function(e){})
  }
 
}
