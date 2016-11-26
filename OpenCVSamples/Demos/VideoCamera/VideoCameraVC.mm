//
//  VideoCameraVC.m
//  OpenCVSamples
//
//  Created by misupeng on 16/9/27.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "VideoCameraVC.h"
#import <opencv2/opencv.hpp>

@interface VideoCameraVC (){
    CvVideoCamera* videoCamera;
    BOOL isStart;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation VideoCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    videoCamera.delegate = self; //set CvVideoCameraDelegate
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30; //sets the FPS of the camera.If the processing is less fast than the desired FPS, frames are automatically dropped.
    videoCamera.grayscaleMode = NO; //grayscale=NO will output 32 bit BGRA
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(videoCamera.running){
        [videoCamera stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startTap:(UIButton *)sender {
    if(!isStart){
        [videoCamera start];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        isStart = YES;
    }else{
        [videoCamera stop];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        isStart = NO;
    }
}

//回调处理图片
-(void)processImage:(cv::Mat &)image{
    // Do some OpenCV stuff with the image
    cv::Mat image_copy;
    cv::cvtColor(image, image_copy, CV_BGRA2BGR); //converts image from one color space to another.拷贝一份图片
    
    cv::bitwise_not(image_copy, image_copy); //inverts each bit of array (dst = ~src).处理拷贝的图片
    // invert image
    cv::cvtColor(image_copy, image, CV_BGR2BGRA);// 将处理过的拷贝的图片替换原先图片
}

@end
