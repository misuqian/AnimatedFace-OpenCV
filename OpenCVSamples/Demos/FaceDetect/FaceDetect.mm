//
//  FaceDetect.m
//  OpenCVSamples
//
//  Created by misupeng on 16/9/27.
//  Copyright © 2016年 misuqian. All rights reserved.
//
//  Doc : http://www.opencv.org.cn/opencvdoc/2.3.2/html/modules/objdetect/doc/cascade_classification.html
//  A classifier (namely a cascade of boosted classifiers working with haar-like features) is trained with a few hundred sample views of a particular object (i.e., a face or a car), called positive
//  examples, that are scaled to the same size (say, 20x20), and negative examples - arbitrary images of the same size

#import "FaceDetect.h"
#import <opencv2/objdetect/objdetect.hpp>
#import "UIImage+CVMat.h"

@interface FaceDetect (){
    cv::CascadeClassifier faceDetector;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FaceDetect

- (void)viewDidLoad {
    [super viewDidLoad];
    //Load cascade classifier from the XML file 读取特征值XML数据
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"cascade_frontalface_alt" ofType:@"xml"];
    faceDetector = cv::CascadeClassifier();
    faceDetector.load([filePath UTF8String]);
    
    [self detectImage:[UIImage imageNamed:@"face"]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)detectImage:(UIImage*)image{
    if(!image){
        return;
    }
    
    cv::Mat faceImage = [image cvMat];
    
    // Convert to grayscale 转成灰色图像
    cv::Mat gray;
    cv::cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    // Detect faces 使用detectMultiScale检测
    std::vector<cv::Rect> faces;
    faceDetector.detectMultiScale(gray,faces,1.1,2,0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    // Draw all detected faces
    for(int i =0;i<faces.size();i++){
        const cv::Rect& face = faces[i];
        
        // Get top-left and bottom-right corner points
        cv::Point tl(face.x,face.y);
        cv::Point br = tl + cv::Point(face.width, face.height);
        
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(faceImage, tl, br, magenta, 4, 8, 0); //draws the rectangle outline or a solid rectangle with the opposite corners pt1 and pt2 in the image
    }
    
    self.imageView.image = [[UIImage alloc] initWithCVMat:faceImage originImage:image];
}

- (IBAction)selectPhoto:(UIBarButtonItem *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [self detectImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
