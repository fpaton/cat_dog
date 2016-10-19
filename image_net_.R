
# cNN
install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")
library(pacman)
pacman::p_load(MXNet, EBImage)
# MXNet is for the CNN, EBImage for image manipulation

# Resize images and convert to grayscale

rm(list=ls())
require(EBImage)

# Set wd where images are located
setwd("~/Documents/STAT/kaggle/cat_dog_CNN/dog_images")

# Set d where to save images
save_in <- "~/Documents/STAT/kaggle/cat_dog_CNN/reshaped_dogs/reshaped_"

# Load images names
images <- list.files()
# Set width
w <- 64
# Set height
h <- 64

# Main loop resize images and set them to greyscale
for(i in 1:length(images))
{
  # Try-catch is necessary since some images
  # may not work.
  result <- tryCatch({
    # Image name
    imgname <- images[i]
    # Read image
    img <- readImage(imgname)
    # Resize image 28x28
    img_resized <- resize(img, w = w, h = h)
    # Set to grayscale
    grayimg <- channel(img_resized,"gray")
    # Path to file
    path <- paste(save_in, imgname, sep = "")
    # Save image
    writeImage(grayimg, path, quality = 70)
    # Print status
    print(paste("Done",i,sep = " "))},
    # Error function
    error = function(e){print(e)})
}

# Generate a train-test dataset

# Clean environment and load required packages
rm(list=ls())
require(EBImage)

# Set wd where resized greyscale images are located
setwd("~/Documents/STAT/kaggle/cat_dog_CNN/reshaped_dogs")
# Out file
out_file <- "dog_images"

# List images in path
images <- list.files()

# Set up df
df <- data.frame()

# Set image size. In this case 28x28
img_size <- 64*64

# Set label
label <- 0

# Main loop. Loop over each image
for(i in 1:length(images))
{
  # Read image
  img <- readImage(images[i])
  # Get the image as a matrix
  img_matrix <- img@.Data
  # Coerce to a vector
  img_vector <- as.vector(t(img_matrix))
  # Add label
  vec <- c(label, img_vector)
  # Bind rows
  df <- rbind(df,vec)
  # Print status info
  print(paste("Done ", i, sep = ""))
}

# Set names
names(df) <- c("label", paste("pixel", c(1:img_size)))

# Write out dataset
write.csv(df, out_file, row.names = FALSE)