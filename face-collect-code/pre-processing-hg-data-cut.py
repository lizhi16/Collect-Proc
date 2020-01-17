import numpy as np 
import os

names = os.listdir('./pic-HGdata')
targetpath = "./pic-HGdata-cut/"

for file in names:
	print (file)
	target = "./pic-HGdata/" + file
	res = np.load(target).T[1950000:2500000].T
	im_path = targetpath + file
	print ("picture path: ", im_path)
	np.save(im_path,res)
