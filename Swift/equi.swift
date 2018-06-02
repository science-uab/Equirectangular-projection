//
//  main.swift
//  Equirectangular
//
//  Created by Alexandru Cristian Donea on 02/06/2018.
//  Copyright © 2018 Final project. All rights reserved.
//

import Foundation
#import <opencv2/opencv.hpp>

var PROJECTION_SIZE:Int=500
var X_AXIS:Int=0
var Y_AXIS:Int=0
var Z_AXIS:Int=2

cv:Mat image_top, image_left, image_right, image_bottom, image_front, image_back
UIImage* img1,img2,img3,img4,img5,img6
if NSFileManager.defaultManager().fileExistsAtPath("/images/top.jpg") {
    let url = NSURL(string: imageUrlPath)
    let data = NSData(contentsOfURL: url!)
    img1.image = UIImage(data: data!)
}
if NSFileManager.defaultManager().fileExistsAtPath("/images/bottom.jpg") {
    let url = NSURL(string: imageUrlPath)
    let data = NSData(contentsOfURL: url!)
    img2.image = UIImage(data: data!)
}

if NSFileManager.defaultManager().fileExistsAtPath("/images/left.jpg") {
    let url = NSURL(string: imageUrlPath)
    let data = NSData(contentsOfURL: url!)
    img3.image = UIImage(data: data!)
}

if NSFileManager.defaultManager().fileExistsAtPath("/images/right.jpg") {
    let url = NSURL(string: imageUrlPath)
    let data = NSData(contentsOfURL: url!)
    img4.image = UIImage(data: data!)
}

if NSFileManager.defaultManager().fileExistsAtPath("/images/front.jpg") {
    let url = NSURL(string: imageUrlPath)
    let data = NSData(contentsOfURL: url!)
    img5.image = UIImage(data: data!)
}

if NSFileManager.defaultManager().fileExistsAtPath("/images/back.jpg") {
    let url = NSURL(string: imageUrlPath)
    let data = NSData(contentsOfURL: url!)
    img6.image = UIImage(data: data!)
}
cv:Mat projection(PROJECTION_SIZE,PROJECTION_SIZE, CV_8UC3, Scalar(255, 255, 255))

for row in 0...PROJECTION_SIZE{
    for col in 0...PROJECTION_SIZE{
        var phi:Double=col/Double(PROJECTION_SIZE*2*Double.pi)
        var theta:Double=row/Double(PROJECTION_SIZE*Double.pi-pow(Double.pi, 2))
        var radius:Double=1
        var x:Double=sin(theta)*cos(phi)*radius
        var y:Double=sin(phi)*sin(theta)*radius
        var z:Double=cos(theta)*radius;
        var maximum_axis=Int()
        var positive_axis=Bool()
        var u=Double()
        var v=Double()
        
        if(cv:fab(x)>cv:fab(y)){
            if(cv:fab(x)>cv:fab(z)){
                maximum_axis=X_AXIS
                positive_axis=(x>0.0)
                u=y
                v=z
             }
            else{
                maximum_axis=Z_AXIS
                positive_axis=(x>0.0)
                u=x
                v=y
            }
        }
        else{
            if (fabs(y) > fabs(z)) {
                maximum_axis = Y_AXIS
                positive_axis = (y >= 0.0)
                u = x
                v = z
            }
            else {
                maximum_axis = Z_AXIS
                positive_axis = z >= 0.0
                u = x
                v = y
            }
        }
    }
    switch(maximum_axis){
        case X_AXIS:
            if (positive_axis){
                projection.at<Vec3b>(row, col) =cv:image_front.at<Vec3b>(int((u + 1) / 2.0 * (image_front.rows - 1)),Int((v + 1) / 2.0 * (image_front.cols - 1)))
            }
            else{
                projection.at<Vec3b>(row, col) =image_back.at<Vec3b>(Int((u + 1) / 2.0 * (image_back.rows - 1)),Int((v + 1) / 2.0 * (image_back.cols - 1)))
            }
        break
        case Y_AXIS:
            if (positive_axis){
                projection.at<Vec3b>(row, col) =image_right.at<Vec3b>(Int((u + 1) / 2.0 * (image_right.rows - 1)),Int((v + 1) / 2.0 * (image_right.cols - 1)))
        }
            else{
                projection.at<Vec3b>(row, col) =image_left.at<Vec3b>(Int((u + 1) / 2.0 * (image_left.rows - 1)),Int((v + 1) / 2.0 * (image_left.cols - 1)))
        break
        }
        case Z_AXIS:
            if (positive_axis){
            projection.at<Vec3b>(row, col) =image_top.at<Vec3b>(Int((u + 1) / 2.0 * (image_top.rows - 1)),Int((v + 1) / 2.0 * (image_top.cols - 1)))
            }
            else{
                projection.at<Vec3b>(row, col) =image_bottom.at<Vec3b>(Int((u + 1) / 2.0 * (image_bottom.rows - 1)),Int((v + 1) / 2.0 * (image_bottom.cols - 1)))
            }
        break
    }
    cv:namedWindow("projection")
    cv:imshow("projection", projection)
    cv:cvWaitKey(0)
}




