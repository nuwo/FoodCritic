import tensorflow as tf
import tensorflow.keras.layers as layers
import matplotlib.pyplot as pl
from keras.models import Sequential 
import os 
import cv2
import glob
import pickle
import numpy as np
import mahotas as mt
from sklearn.svm import LinearSVC
import sklearn



#load the training dataset

train_path = "/Users/sripriya/Downloads/project/train/Cake"
train_names=os.listdir(train_path)

train_features=[]
train_label=[]

#using Haralick features
def extract_features(image):
	textures = mt.features.haralick(image)

	ht_mean=textures.mean(axis=0)
	return ht_mean



for train_name in train_names :
	cur_path = train_path +'/'+train_name
	cur_label= train_name

	#print('cur_label',cur_label)
	#print('cur_path',cur_path)

	i=1
	for file in glob.glob(cur_path+'/*.jpg'):

		#print('processing image - {}'.format(cur_label))

		image=cv2.imread(file)
		
		gray=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)

		features=extract_features(gray)


		train_features.append(features)
		train_label.append(cur_label)	
		
		i+=1

	

with open("Label.txt",'w') as f:
	for line in train_label:
		f.write(f"{line}\n")

mapLabelToNumbers={}

trainingLabels=np.zeros(len(train_label),dtype=int)

for i,label in enumerate(train_label):

	if label not in mapLabelToNumbers:
		mapLabelToNumbers[label] = len(mapLabelToNumbers)
	trainingLabels[i] = mapLabelToNumbers[label]	


with open('mapLabelsToNumbers.txt','w') as f:
	for label,number in mapLabelToNumbers.items():
		f.write(f"{label}:{number}\n")


train_features=np.array(train_features)
train_label=trainingLabels

train_data,validate_data,train_labels,val_label = sklearn.model_selection.train_test_split(train_features,train_label,test_size=0.4,random_state=0)

print('Training Data :' ,len(train_data))
print('Test Data :' ,len(validate_data))



#Creating a tensorflow keras Sequential classifier
clf_svm=Sequential()

clf_svm.add(tf.keras.layers.Dense(128,input_shape=(13,),activation='relu',kernel_regularizer=tf.keras.regularizers.l2()))
clf_svm.add(tf.keras.layers.Dense(4,activation='softmax'))

#compile model
clf_svm.compile(optimizer='adam',loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),metrics=['accuracy'])

clf_svm.build()
clf_svm.summary()

#clfmodel=clf_svm.fit(train_data,train_labels,5,validation_data=(validate_data,val_label))

clfmodel=clf_svm.fit(train_data,train_labels,epochs=30)

#Evaluating the model with test data  for loss and accuracy
clf_test = clf_svm.evaluate(validate_data,val_label,verbose=2)
clf_test = clf_svm.predict(validate_data)

print('test image predictions')
print(clf_test[0])
print(val_label[0])

probability=tf.keras.Sequential([clf_svm,tf.keras.layers.Softmax()])
predict = probability.predict(validate_data)

print('Test image with softmax')
print(predict[0])
print(val_label[0])


print(type(clfmodel))
print('saving keras model')
clf_svm.save('clf_svm.keras')

#converting to a tflite converter
converter=tf.lite.TFLiteConverter.from_keras_model(clf_svm)
model_tflite=converter.convert()
open("LinearRegressionModel.tflite","wb").write(model_tflite)


test_path='/Users/sripriya/Downloads/project/test'

def getLabel(number):

	for k,v in mapLabelToNumbers.items():
		if v== number:
			return k

"""
#testing an image for prediction
for file in glob.glob(test_path +'/*.jpg'):
	image=cv2.imread(file)
	gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
	feature=extract_features(gray)
	prediction=clf_svm.predict(feature.reshape(1,-1))[0]
	print('prediction')
	print(prediction)

	number= trainingLabels[np.argmax(prediction)]
	predicted=getLabel(number)

	print('predicted',predicted)

	cv2.putText(image,predicted,(20,30),cv2.FONT_HERSHEY_SIMPLEX,1.0,(0,255,255))

	cv2.imshow("ShowingTest_image",image)
	cv2.waitKey(0)

"""
