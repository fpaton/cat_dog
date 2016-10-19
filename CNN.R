###
# trained on 200 images: 1,000 dog; 1,000

install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")
library(pacman)
pacman::p_load(MXNet, EBImage)
# MXNet is for the CNN, EBImage for image manipulation

#-------------------------------------------------------------------------------
library(mxnet)
# Load datasets

train_dog_64 <- read.csv("dog_images")
test_kiwi <- read.csv("test_cat_kiwi")
test_cat_64 <- read.csv("cat_images")

# Save train-test datasets
setwd("~/Documents/STAT/kaggle/cat_dog_CNN")
write.csv(train_dog_64, "train_dog_64.csv",row.names = FALSE)
write.csv(test_kiwi, "test_cat_kiwi.csv",row.names = FALSE)
write.csv(test_cat_64, "train_cat_64.csv",row.names = FALSE)

# ----------
rm(list=ls())

# Load MXNet
setwd("~/Documents/STAT/kaggle/cat_dog_CNN")

# Train test datasets
train <- read.csv("train_dog_64.csv")
kiwi <- read.csv("test_cat_kiwi.csv")
cats <- read.csv('train_cat_64.csv')

trainOne <- rbind(train, cats)

kiwi$label[c(1, 2,3)] <- 

# Fix train and test datasets
trainOne <- data.matrix(trainOne)
train_x <- t(trainOne[, -1])
train_y <- trainOne[, 1]
train_array <- train_x
dim(train_array) <- c(64, 64, 1, ncol(train_x))

# test dog: 
test__ <- data.matrix(kiwi)
test_x <- t(kiwi[,-1])
test_y <- kiwi[,1]
test_array <- test_x
dim(test_array) <- c(28, 28, 1, ncol(test_x))

# cat test:
test__ <- data.matrix(cats)
test_x <- t(cats[,-1])
test_y <- cats[,1]
test_array <- test_x
dim(test_array) <- c(28, 28, 1, ncol(test_x))

# Model
data <- mxnet::mx.symbol.Variable('data')

# 1st convolutional layer 5x5 kernel and 20 filters.
conv_1 <- mxnet::mx.symbol.Convolution(data= data, kernel = c(5,5), num_filter = 20)
tanh_1 <- mxnet::mx.symbol.Activation(data= conv_1, act_type = "tanh")
pool_1 <- mxnet::mx.symbol.Pooling(data = tanh_1, pool_type = "max", kernel = c(2,2), stride = c(2,2))

# 2nd convolutional layer 5x5 kernel and 50 filters.
conv_2 <- mxnet::mx.symbol.Convolution(data = pool_1, kernel = c(5,5), num_filter = 50)
tanh_2 <- mxnet::mx.symbol.Activation(data = conv_2, act_type = "tanh")
pool_2 <- mxnet::mx.symbol.Pooling(data = tanh_2, pool_type = "max", kernel = c(2,2), stride = c(2,2))

# 1st fully connected layer
flat <-   mxnet::mx.symbol.Flatten(data = pool_2)
fcl_1 <-  mxnet::mx.symbol.FullyConnected(data = flat, num_hidden = 500)
tanh_3 <- mxnet::mx.symbol.Activation(data = fcl_1, act_type = "tanh")

# 2nd fully connected layer
fcl_2 <- mxnet::mx.symbol.FullyConnected(data = tanh_3, num_hidden = 2)

# Output
NN_model <- mxnet::mx.symbol.SoftmaxOutput(data = fcl_2)

# Set seed for reproducibility
mxnet::mx.set.seed(100)

# Device used
device <- mx.cpu()

# Train on 1200 samples
model <- mx.model.FeedForward.create(NN_model, X = train_array, y = train_y,
                                     ctx = device,
                                     num.round = 5,
                                     array.batch.size = 100,
                                     learning.rate = 0.05,
                                     momentum = 0.9,
                                     wd = 0.00001,
                                     eval.metric = mx.metric.accuracy,
                                     epoch.end.callback = mx.callback.log.train.metric(100)
                                     )

# Test

predict_probs <- predict(model, test_array)
test_array$
predicted_labels <- max.col(t(predict_probs)) - 1

table(test__[, 1], predicted_labels)

sum(diag(table(test__[,1], predicted_labels)))/3

