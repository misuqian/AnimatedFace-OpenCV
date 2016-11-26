//
//  FaecEffect3D.m
//  OpenCVSamples
//
//  Created by misupeng on 16/10/8.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "FaceEffect3D.h"
#import "UIImage+CVMat.h"

@interface FaceEffect3D (){
    CvVideoCamera* videoCamera;
    cv::CascadeClassifier faceDetector;
    cv::CascadeClassifier eyesDetector;
    BOOL isStart;
    int disappearCount;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FaceEffect3D

- (void)viewDidLoad {
    [super viewDidLoad];
    //(VieoCamera)
    videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    videoCamera.delegate = self; //set CvVideoCameraDelegate
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30; //sets the FPS of the camera.If the processing is less fast than the desired FPS, frames are automatically dropped.
    videoCamera.grayscaleMode = NO; //grayscale=NO will output 32 bit BGRA
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"cascade_frontalface_alt" ofType:@"xml"];
    faceDetector = cv::CascadeClassifier();
    faceDetector.load([filePath UTF8String]);
    
    filePath = [[NSBundle mainBundle] pathForResource:@"cascade_mcs_eyepair_big" ofType:@"xml"];
    eyesDetector = cv::CascadeClassifier();
    eyesDetector.load([filePath UTF8String]);
    
    self.scnView = [[SunEyes alloc] initWithFrame:self.view.bounds];
    self.scnView.hidden = YES;
    [self.view insertSubview:self.scnView aboveSubview:self.imageView];
    
    disappearCount = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(videoCamera.running){
        [videoCamera stop];
    }
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scnView.hidden = YES;
    });
}

//回调处理图片.识别人脸数据(FaceDetect)，将图片和当前内容合并(MixImage)
-(void)processImage:(cv::Mat &)image{
    cv::Mat image_gray;
    cv::cvtColor(image, image_gray, CV_BGR2GRAY); //灰度处理
    
    // Detect faces 使用detectMultiScale检测
    std::vector<cv::Rect> faces;
    faceDetector.detectMultiScale(image_gray,faces,1.1,2,0|CV_HAAR_SCALE_IMAGE, cv::Size(50, 50));
    
    for(int i =0;i<faces.size();i++){
        cv::Rect faceRect = faces[i];
        cv::Mat faceMat = image_gray(faceRect); // 截取对应区域的脸部图像
        
        std::vector<cv::Rect> eyes;
        eyesDetector.detectMultiScale(faceMat,eyes,1.1,2,CV_HAAR_FIND_BIGGEST_OBJECT, cv::Size(faces[i].size().width * 0.6, faces[i].size().height * 0.2));
        if(eyes.size()>0){
            cv::Rect eyeRect = eyes[0];
            CGRect rect = CGRectMake(faceRect.x + eyeRect.x + 10.0,74.0 + faceRect.y + eyeRect.y, eyeRect.width, eyeRect.height);
            [self.scnView resetFrame:rect];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.scnView.hidden = NO;
            });
            disappearCount = 0;
            //NSLog(@"eyes detect! %d %f %f %f %f",self.scnView.isHidden,rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.scnView.hidden = YES;
            });
        }
    }
}

@end
