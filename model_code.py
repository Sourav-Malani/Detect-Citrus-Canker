# -*- coding: utf-8 -*-
"""leaf-disease-detection-with-cnn-98.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1tK77aYRDfxhs7reshE7BmR5H-3SevORX
"""

import warnings
warnings.filterwarnings("ignore")
!pip install pycocotools --user



# import the libraries as shown below

from tensorflow.keras.layers import Input, Lambda, Dense, Flatten, Dropout, GlobalAveragePooling2D
from tensorflow.keras.models import Model
from tensorflow.keras.applications.inception_v3 import InceptionV3
from tensorflow.keras.applications.inception_v3 import preprocess_input
from tensorflow.keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator,load_img
from tensorflow.keras.models import Sequential
import numpy as np
import glob
import matplotlib.pyplot as plt
from keras.models import load_model
import ntpath
from sklearn.metrics import confusion_matrix
from tensorflow.keras.optimizers import Adam

import os
import cv2

from google.colab import drive

drive.mount('/content/gdrive')

# Read the image
image = cv2.imread('/content/gdrive/MyDrive/Training3/CitrusCankerFinal/Canker.f(1014).png')

# Get the shape (height, width, channels) of the image
image_shape = image.shape
print("Image shape:", image_shape)

# re-size all the images to this
IMAGE_SIZE = [224, 224]

train_path = '/content/gdrive/MyDrive/Training3'
valid_path = '/content/gdrive/MyDrive/Training3'

# Set up the data augmentation and preprocessing
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    zoom_range=0.2,
    horizontal_flip=True,
    preprocessing_function=lambda x: cv2.GaussianBlur(x, (5, 5), 0)
)

valid_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    train_path,
    target_size=IMAGE_SIZE,
    batch_size=24,
    class_mode='categorical'
)

valid_generator = valid_datagen.flow_from_directory(
    valid_path,
    target_size=IMAGE_SIZE,
    batch_size=24,
    class_mode='categorical'
)

base_model = InceptionV3(weights='imagenet', include_top=False, input_tensor=Input(shape=(224, 224, 3)))
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(256, activation='relu')(x)
x = Dropout(0.5)(x)
predictions = Dense(3, activation='softmax')(x)  # 3 classes: healthy, initial, final
model = Model(inputs=base_model.input, outputs=predictions)

# Freeze the base model layers
for layer in base_model.layers:
    layer.trainable = False

model.compile(optimizer=Adam(learning_rate=0.012), loss='categorical_crossentropy', metrics=['accuracy'])

model.fit(
    train_generator,
    validation_data=valid_generator,
    epochs=10
)

# Evaluate the model on the test set
test_loss, test_accuracy = model.evaluate(valid_generator)
print("Test loss:", test_loss)
print("Test accuracy:", test_accuracy)

model.save('/content/gdrive/MyDrive/Classroom/inception_v3_canker.h5')

import tensorflow as tf

# Load the Keras model from .h5 file
model = tf.keras.models.load_model('/content/gdrive/MyDrive/Classroom/inception_v3_canker.h5')

# Convert Keras model to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the converted TFLite model
with open('/content/gdrive/MyDrive/Classroom/model.tflite', 'wb') as f:
    f.write(tflite_model)

