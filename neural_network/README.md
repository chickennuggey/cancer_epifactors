# Neural Network

## Methodology:

The data was initially preprocessed by label encoding the cancer types into numerical variables, normalizing the gene expression data within the range (0, 1), and splitting the data into training, validation, and testing sets. The model was then created using the keras Sequential model with a total of 4 layers: 1 input layer with 525 neurons and a “relu” activation function, 2 hidden layers with a total of 55 neurons, and the “relu” activation functions, and 1 output layer with 5 neurons and a “softmax” activation function. The number of hidden neurons was also based on the value, number of input neurons *number of  output layer neurons. After, the model was compiled using the keras Sparse Categorical Cross Entropy loss function and the Adam optimizer with a learning rate of 0.0001 and fitted using the training and validation data. Model performance was then evaluated by comparing accuracy and loss and feature importance by comparing feature weights.     

NeuralNetworkModel.ipynb contains Python code for creating and evaluating the neural network accuracy.
