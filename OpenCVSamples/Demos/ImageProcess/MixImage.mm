//
//  PostCardEffect.m
//  OpenCVSamples
//
//  Created by misupeng on 16/9/28.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "MixImage.h"
#import <opencv2/imgproc/imgproc.hpp>
#import "UIImage+CVMat.h"

@interface MixImage ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MixImage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mixImage:[UIImage imageNamed:@"face"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)selectPhoto:(UIBarButtonItem *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [self mixImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)mixImage:(UIImage*)image{
    UIImage* maskImg = [UIImage imageNamed:@"mask"];
    cv::Mat mask = [maskImg cvMat];
    cv::Mat img = [image cvMat];
    
    cv::Size size = cv::Size(image.size.width,image.size.height);
    cv::resize(mask, mask, size); //蒙版边框适配当前图片
    
    //两张图片每个像素点进行值合并,weight为权值
    for(int i=0;i<mask.rows;i++){
        for(int j=0;j<mask.cols;j++){
            float weight = 0.5f;
            img.at<cv::Vec4b>(i,j) = weight * img.at<cv::Vec4b>(i,j) + (1 - weight) * mask.at<cv::Vec4b>(i,j);
        }
    }
    self.imageView.image = [[UIImage alloc] initWithCVMat:img];
}

@end
