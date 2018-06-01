# -*- coding: utf-8 -*-
"""
Created on Tue May 22 11:16:36 2018

@author: dani
"""

import math
import cv2
import PIL
import numpy as np

PROJECTION_SIZE = 500
X_AXIS = 0
Y_AXIS = 1
Z_AXIS = 2
#image_top = np.zeros((256, 256, 1), dtype = "uint8")
#image_left = cv2.cv.CreateMat();
#image_right = cv2.cv.CreateMat();
#image_bottom = cv2.cv.CreateMat();
#image_front = cv2.cv.CreateMat();
#image_back = cv2.cv.CreateMat();

image_top = cv2.imread("C:/Users/danie/Documents/GitHub/equirectangular/data/000000_top.jpg");
image_left = cv2.imread("C:/Users/danie/Documents/GitHub/equirectangular/data/000000_left.jpg");
image_right = cv2.imread("C:/Users/danie/Documents/GitHub/equirectangular/data/000000_right.jpg");
image_bottom = cv2.imread("C:/Users/danie/Documents/GitHub/equirectangular/data/000000_bottom.jpg");
image_front = cv2.imread("C:/Users/danie/Documents/GitHub/equirectangular/data/000000_front.jpg");
image_back = cv2.imread("C:/Users/danie/Documents/GitHub/equirectangular/data/000000_back.jpg");
projection = np.zeros((PROJECTION_SIZE, PROJECTION_SIZE, 3), dtype = "uint8");
for row in range(0, PROJECTION_SIZE):
		for col in range(0, PROJECTION_SIZE):
			phi = col / PROJECTION_SIZE * 2 * math.pi
			theta = row / PROJECTION_SIZE * math.pi - math.pi/2;
			
			radius = 1;
			x = math.sin(theta) * math.cos(phi) * radius;
			y = math.sin(phi) * math.sin(theta) * radius;
			z = math.cos(theta) * radius;

			if (math.fabs(x) > math.fabs(y)):
				if (math.fabs(x) > math.fabs(z)):
					maximum_axis= X_AXIS;
					positive_axis = x >= 0.0;
					u = y;
					v = z;
				else:
					maximum_axis = Z_AXIS;
					positive_axis = z >= 0.0;
					u = x;
					v = y;
	
			else :
				if (math.fabs(y) > math.fabs(z)):
					maximum_axis = Y_AXIS;
					positive_axis = y >= 0.0;
					u = x;
					v = z;
				else:
						maximum_axis = Z_AXIS;
						positive_axis = z >= 0.0;
						u = x;
						v = y;
                   			
			def X_AXIS():
				if (positive_axis): #[-1...1] -> [0, image_front.rows - 1]
					projection[row,col] = image_front[((u + 1) /2.0 * (image_front.rows - 1), (v + 1) / 2.0 * (image_front.cols - 1))];
	
				else:
					projection[row, col] = image_back[((u + 1) / 2.0 * (image_back.rows - 1), (v + 1) / 2.0 * (image_back.cols - 1))];
				
			def Y_AXIS():
				if (positive_axis): #[-1...1] -> [0, image_front.rows - 1]
					projection[row, col] = image_right[((u + 1) / 2.0 * (image_right.rows - 1), (v + 1) / 2.0 * (image_right.cols - 1))];

				else:
					projection[row, col] = image_left[((u + 1) / 2.0 * (image_left.rows - 1), (v + 1) / 2.0 * (image_left.cols - 1))];
#				break;
			def Z_AXIS():
				if (positive_axis): #[-1...1] -> [0, image_front.rows - 1]
					projection[row, col] = image_top[((u + 1) / 2.0 * (image_top.rows - 1), (v + 1) / 2.0 * (image_top.cols - 1))];

				else:
					projection[row, col] = image_bottom[((u + 1) / 2.0 * (image_bottom.rows - 1), (v + 1) / 2.0 * (image_bottom.cols - 1))];
#				break;
			def switch_demo(maximum_axis):
				switcher = {
                    1: "X_AXIS",
                    2: "Y_AXIS",
                    3: "Z_AXIS",
                    }
				func = switcher.get( "Invalid month")
				print (func())
cv2.imshow("projection",projection);