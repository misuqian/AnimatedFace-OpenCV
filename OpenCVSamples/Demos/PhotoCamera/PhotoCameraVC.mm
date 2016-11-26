//
//  PhotoCameraVC.m
//  OpenCVSamples
//
//  Created by misupeng on 16/9/27.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "PhotoCameraVC.h"
#import "UIImage+CVMat.h"

@interface PhotoCameraVC (){
    CvPhotoCamera* photoCamera;
    BOOL isStart;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

@end

@implementation PhotoCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    photoCamera = [[CvPhotoCamera alloc]initWithParentView:self.imageView];
    photoCamera.delegate = self;
    photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    photoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    photoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    photoCamera.defaultFPS = 30;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(photoCamera.running){
        [photoCamera stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startTap:(UIButton *)sender {
    if(!isStart){
        [photoCamera start];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        isStart = YES;
    }else{
        [photoCamera stop];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        isStart = NO;
    }
}

- (IBAction)takePic:(UIButton *)sender {
    if(photoCamera.running)
        [photoCamera takePicture];
}

//capturedImage is flip image.拍摄的照片相对于显示图像是水平翻转的
- (void)photoCamera:(CvPhotoCamera*)photoCamera capturedImage:(UIImage *)image{
    NSLog(@"photoCamera capturedImage");
    cv::Mat image_copy;
    cv::cvtColor([image cvMat],image_copy, CV_BGRA2BGR); //converts image from one color space to another.拷贝一份图片
    
    cv::bitwise_not(image_copy, image_copy); //inverts each bit of array (dst = ~src).处理拷贝的图片
    self.thumbImageView.image = [[UIImage alloc] initWithCVMat:image_copy originImage:image];
}

- (void)photoCameraCancel:(CvPhotoCamera*)photoCamera{
    NSLog(@"photoCameraCancel");
}

@end
