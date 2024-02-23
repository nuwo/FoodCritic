from flask import Flask,request,jsonify
test_model_app=Flask(__name__)
import werkzeug
import glob
import tensorflow as tf
import keras
import cv2
import os
import mahotas as mt
import numpy as np
from keras.models import load_model



#test_model_app=Flask(__name__)
mapLabelToNumbers={}
with open("mapLabelsToNumbers.txt","r") as f:
	for line in f:
		k,v=line.split(':');
		index=v.find('\n');
		mapLabelToNumbers[k]=int(v[0:index])
			
def extract_features(image):
	textures = mt.features.haralick(image)
	return textures.mean(axis=0)


test_path='/Users/sripriya/Downloads/project/test'
def getLabel(number):

        for k,v in mapLabelToNumbers.items():
                if v== number:
                        return k


#flask server running at 192.168.0.119
@test_model_app.route('/api',methods=['POST'])
def test_model():
	d={}
	print('loading model.....')
	saved_model = keras.models.load_model('/Users/sripriya/development/project/clf_svm.keras')


	print('Received file')
	file= request.args['file']
	print(request.headers)
	print(request.files)
	images= request.files.getlist("images")
	img=request.files['image']

	trainingLabels=list(mapLabelToNumbers.values())

	fileread=werkzeug.utils.secure_filename(img.filename)
	img.save(os.path.join(test_path,fileread))

	for f in glob.glob(test_path +'/*.jpg'):
		image=cv2.imread(f)
		gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
		feature=extract_features(gray)
		d['probability']=feature.tolist()
	return jsonify(d)

if (__name__) == '__main__':
	test_model_app.run(host='192.168.0.119', port=5000)
