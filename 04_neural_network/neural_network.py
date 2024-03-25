# import libraries
import pandas as pd
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import scipy.stats as stats

import operator
import statistics
import statsmodels.api as sm
from statsmodels.formula.api import ols

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import MinMaxScaler

from tensorflow import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import Adam

from keras_visualizer import visualizer

#########################################################
                # Data Processing
#########################################################

# read in pediatric cancer data
dataframe = pd.read_csv("cancer_counts.csv")
# remove first column (contained name/barcode of samples)
dataframe = dataframe.iloc[:, 1:]

# separate gene expression data features from cancer outcome
X = dataframe.iloc[:, 0:-1]
y = dataframe.iloc[:, -1]

# convert predictor categorical variable into numeric labels for the model
convert = LabelEncoder()
convert.fit(y)
y = convert.transform(y)

# normalize values within range (0, 1)
scaler = MinMaxScaler()
X = scaler.fit_transform(X)

# create training, testing and validation sets
X_train,X_test,y_train,y_test = train_test_split(X, y, test_size = 0.2, random_state = 42)
X_train, X_val, y_train, y_val = train_test_split(X_train, y_train, test_size = 0.2, random_state = 42)

#########################################################
                # Model Creation
#########################################################

# find number of input and output
n_input = X_train.shape[1]
n_output = dataframe.cancer_type.nunique()

# create layers
model = Sequential()
model.add(Dense(35, input_dim = n_input, activation = "relu")) # use relu for both hidden layers (usually default for hidden layers)
model.add(Dense(20, activation = "relu"))
model.add(Dense(n_output, activation = "softmax")) # use softmax since we are working with multiclass classification

# compile model
model.compile(loss = tf.keras.losses.SparseCategoricalCrossentropy(), optimizer = Adam(learning_rate = 0.0001), metrics = keras.metrics.SparseCategoricalAccuracy())

# visualization of neural network
visualizer(model, file_name = "graph02", file_format = "png", view = True)

# fit model to training set
fitting = model.fit(X_train, y_train, validation_data = (X_val, y_val), batch_size = 25, epochs = 200, verbose = 0)

#########################################################
                # Model Evaluation
#########################################################

# neural network model summary
model.summary()

# plot model accuracy
plt.plot(fitting.history["sparse_categorical_accuracy"]) # training accuracy
plt.plot(fitting.history["val_sparse_categorical_accuracy"]) # validation accuracy
plt.title("Model Accuracy")
plt.xlabel("Epoch")
plt.ylabel("Accuracy")
plt.legend(["Training", "Validation"], loc = "lower right")
plt.show()

# plot model loss
plt.plot(fitting.history["loss"])
plt.plot(fitting.history["val_loss"])
plt.title("Model Loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.legend(["Training", "Validation"], loc = "upper right")
plt.show()

# evaluate performance for training, testing, validation and all data
scores = model.evaluate(X_train, y_train, verbose = 0)
print("\nTraining Data Accuracy: %.2f%%" % (scores[1]*100))

scores = model.evaluate(X_test, y_test, verbose = 0)
print("\nTesting Data Accuracy: %.2f%%" % (scores[1]*100))

scores = model.evaluate(X_val, y_val, verbose = 0)
print("\nValidation Data Accuracy: %.2f%%" % (scores[1]*100))

scores = model.evaluate(X, y, verbose = 0)
print("\nOverall Data Accuracy: %.2f%%" % (scores[1]*100))

#########################################################
                # Feature Evaluation
#########################################################

# bar plot of weights for each gene
weights = model.get_weights()
feature_importance = np.sum(np.abs(weights[0]), axis=1)

# median weight
median = statistics.median(feature_importance)
print("Median Feature Weight: ", median)

plt.bar(x = range(0, n_input, 1), height = feature_importance)
plt.axhline(y=median, color='r', linestyle='-', label = "Median Weight")
plt.title("Gene-Feature Weights")
plt.xlabel("Gene Index")
plt.ylabel("Weights")
plt.legend()
plt.show()

# sort genes based on descending weights
genes = dataframe.columns

gene_weight = dict(map(lambda i, j : (i, j) , genes, feature_importance))
sorted_gene_weight = dict(sorted(gene_weight.items(), key = operator.itemgetter(1), reverse = True))

# show top 10 highest gene weights
top_10 = dict(sorted(gene_weight.items(), key = operator.itemgetter(1), reverse = True)[:10])

names = list(top_10.keys())
values = list(top_10.values())

plt.barh(range(len(top_10)), values, tick_label = names)
plt.gca().invert_yaxis()
plt.axvline(x = median, color='r', linestyle='-', label = "Median Weight")
plt.xlabel("Weights")
plt.ylabel("Gene")
plt.title("Top Gene-Feature Weights")
plt.legend(loc = "lower right")
plt.show()

# data of specific gene expression for each cancer (replace APBB1)
APBB1_frame = dataframe[["APBB1", "cancer_type"]]

# perform ANOVA for individual gene
lm=ols('APBB1~cancer_type', data = APBB1_frame).fit()
table=sm.stats.anova_lm(lm, typ = 2)
print(table)

# create boxplot for individual gene separated by cancer type
dataframe.boxplot("APBB1", by = "cancer_type")
plt.suptitle('')
plt.title("Boxplot of APBB1 Expression")
plt.show()