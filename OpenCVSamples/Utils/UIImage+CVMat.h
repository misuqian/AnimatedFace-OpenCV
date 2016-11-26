//
//  UIImage+CVMat.h
//  OpenCVUtils
//
//  Created by misupeng on 16/9/27.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface UIImage (CVMat)

- (cv::Mat)cvMat;
- (cv::Mat)cvMatGray;
- (UIImage *)initWithCVMat:(cv::Mat)cvMat;
- (UIImage *)initWithCVMat:(cv::Mat)cvMat originImage:(UIImage*)image;
+ (IplImage *)CreateIplImageFromUIImage:(UIImage *)image shouldBeGray:(BOOL)shouldBeGray;
+ (UIImage *)imageWithIplImage:(IplImage *)image isGrayImg:(BOOL)isGrayImg;
@end
