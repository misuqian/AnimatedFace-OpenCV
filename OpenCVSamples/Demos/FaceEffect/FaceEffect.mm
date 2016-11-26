//
//  FaceEffect.m
//  OpenCVSamples
//
//  Created by misupeng on 16/9/29.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "FaceEffect.h"
#import "UIImage+CVMat.h"

@interface FaceEffect (){
    CvVideoCamera* videoCamera;
    cv::CascadeClassifier faceDetector;
    cv::CascadeClassifier eyesDetector;
    BOOL isStart;
    int frameNum;
}


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FaceEffect

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
    
    frameNum = 0;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"cascade_frontalface_alt" ofType:@"xml"];
    faceDetector = cv::CascadeClassifier();
    faceDetector.load([filePath UTF8String]);
    
    filePath = [[NSBundle mainBundle] pathForResource:@"cascade_mcs_eyepair_big" ofType:@"xml"];
    eyesDetector = cv::CascadeClassifier();
    eyesDetector.load([filePath UTF8String]);
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
}

//回调处理图片.识别人脸数据(FaceDetect)，将图片和当前内容合并(MixImage)
-(void)processImage:(cv::Mat &)image{
    cv::Mat image_copy;
    cv::cvtColor(image, image_copy, CV_BGRA2BGR); //拷贝一份图片
    
    cv::Mat image_gray;
    cv::cvtColor(image, image_gray, CV_BGR2GRAY); //灰度处理
    
    // Detect faces 使用detectMultiScale检测
    std::vector<cv::Rect> faces;
    faceDetector.detectMultiScale(image_gray,faces,1.1,2,0|CV_HAAR_SCALE_IMAGE, cv::Size(50, 50));
    
    for(int i =0;i<faces.size();i++){
        cv::Rect faceRect = faces[i];
        cv::Mat faceMat = image_gray(faceRect); // 截取对应区域的脸部图像
        
        /*
        cv::Point tl(faces[i].x,faces[i].y);
        cv::Point br = tl + cv::Point(faces[i].width, faces[i].height);
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image_copy, tl, br, magenta, 4, 8, 0);
        */
        
        std::vector<cv::Rect> eyes;
        eyesDetector.detectMultiScale(faceMat,eyes,1.1,2,CV_HAAR_FIND_BIGGEST_OBJECT, cv::Size(faces[i].size().width * 0.6, faces[i].size().height * 0.2));
        if(eyes.size()>0){
            cv::Rect eyeRect = eyes[0];
            
            /*
            cv::Point tl(faceRect.x + eyeRect.x,faceRect.y + eyeRect.y);
            cv::Point br = tl + cv::Point(eyeRect.width,eyeRect.height);
            cv::Scalar magenta = cv::Scalar(255, 0, 255);
            cv::rectangle(image_copy, tl, br, magenta, 4, 8, 0); 
            */
            
            if(frameNum>15){
                frameNum=0;
            }
            frameNum++;
            NSLog(@"eyes detect!%d",frameNum);
            cv::Mat eyeMat = [[UIImage imageNamed:[NSString stringWithFormat:@"eye%d",frameNum]] cvMat];
            //cv::cvtColor(eyeMat,eyeMat, CV_BGRA2RGBA);
            if(eyeMat.flags==0){
                continue;
            }
            
            cv::Mat alpha;
            std::vector<cv::Mat> channels;
            split(eyeMat, channels);
            channels[3].copyTo(alpha); //alpha通道
            
            //合并眼睛和当前图片
            cv::Size size = cv::Size(eyeRect.width * 1.1,float(eyeRect.width * 1.1)/float(eyeMat.size().width)*eyeMat.size().height);
            cv::resize(eyeMat,eyeMat,size); //眼睛图片适配当前图片
            cv::resize(alpha,alpha,size);
            
            float x = MAX(faceRect.x+eyeRect.x - 0.2 * eyeRect.width, 0);
            float y = MAX(faceRect.y+eyeRect.y - 0.1 * eyeRect.height,0);
            cv::Mat part = image_copy(cv::Rect(x,
                                               y,
                                               MIN(eyeRect.width * 1.1,image_copy.size().width - x),
                                               MIN(eyeRect.height * 1.1,image_copy.size().height - y))
                                      );
            
            for(int i=0;i<eyeMat.rows;i++){
                for(int j=0;j<eyeMat.cols;j++){
                    float weight = float(alpha.at<uchar>(i, j)) / 255.0f;
                    if(weight!=0)
                        part.at<cv::Vec4b>(i,j) = weight * eyeMat.at<cv::Vec4b>(i,j) + (1 - weight) * part.at<cv::Vec4b>(i,j);
                }
            }
        }
    }
    // invert image
    cv::cvtColor(image_copy, image, CV_BGR2BGRA);// 将处理过的拷贝的图片替换原先图片
}

@end
