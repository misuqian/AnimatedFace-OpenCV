//
//  PasserDetect.m
//  OpenCVSamples
//
//  Created by misupeng on 16/10/9.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "PasserDetect.h"
#import <opencv2/imgproc/imgproc.hpp>
#import "UIImage+CVMat.h"

@interface PasserDetect ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PasserDetect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self detectImage:[UIImage imageNamed:@"passeger"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)detectImage:(UIImage*)image{
    if(!image){
        return;
    }
    cv::Mat src = [image cvMat];
    
    cv::Mat rgbMat(self.imageView.bounds.size.height, self.imageView.bounds.size.width, CV_8UC3);
    cvtColor(src, rgbMat, CV_RGBA2RGB, 3);
    
    cv::HOGDescriptor hog;
    hog.setSVMDetector(cv::HOGDescriptor::getDefaultPeopleDetector()); //使用SVM分类器默认的检测器
    
    std::vector<cv::Rect> found,found_filtered;
    hog.detectMultiScale(rgbMat,found,0|CV_HAAR_SCALE_IMAGE, cv::Size(8,8),cv::Size(32,32), 1.05, 1);
    
    for(int i = 0;i < found.size();i++){
        const cv::Rect& face = found[i];
        
        // Get top-left and bottom-right corner points
        cv::Point tl(face.x,face.y);
        cv::Point br = tl + cv::Point(face.width, face.height);
        
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(rgbMat, tl, br, magenta, 4, 8, 0);
    }
    
    self.imageView.image = [[UIImage alloc] initWithCVMat:rgbMat originImage:image];
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
