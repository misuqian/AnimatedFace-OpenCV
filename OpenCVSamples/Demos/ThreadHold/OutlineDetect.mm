//
//  OutlineDetect.m
//  OpenCVSamples
//
//  Created by misupeng on 2016/10/10.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "OutlineDetect.h"
#import <opencv2/imgproc/imgproc.hpp>
#import "UIImage+CVMat.h"

@interface OutlineDetect ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation OutlineDetect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self detectImage:[UIImage imageNamed:@"face"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)detectImage:(UIImage*)image{
    if(!image){
        return;
    }
    //CV_THRESH_BINARY      =0,  /* value = value > threshold ? max_value : 0       */
    //CV_THRESH_BINARY_INV  =1,  /* value = value > threshold ? 0 : max_value       */
    //CV_THRESH_TRUNC       =2,  /* value = value > threshold ? threshold : value   */
    //CV_THRESH_TOZERO      =3,  /* value = value > threshold ? value : 0           */
    //CV_THRESH_TOZERO_INV  =4,  /* value = value > threshold ? 0 : value           */
    //CV_THRESH_MASK        =7,
    //CV_THRESH_OTSU        =8  /* use Otsu algorithm to choose the optimal threshold value; combine the flag with one of the above CV_THRESH_* values */
    IplImage* src = [UIImage CreateIplImageFromUIImage:image shouldBeGray:NO];
    IplImage *pGrayImage =  cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
    cvCvtColor(src, pGrayImage, CV_BGR2GRAY); //拷贝一份灰色IPL_DEPTH_8U深度的图像
    
    IplImage* output = cvCreateImage(cvGetSize(pGrayImage),IPL_DEPTH_8U, 1);
    cvThreshold(pGrayImage,output,50,60, CV_THRESH_TOZERO); //二值化

    CvMemStorage* cvMStorage = cvCreateMemStorage();
    CvSeq *pcvSeq = nil;
    cvFindContours(output,cvMStorage, &pcvSeq);//轮廓检测
    
    NSLog(@"%d",pcvSeq->total);
    
    IplImage* pOutput = cvCreateImage(cvGetSize(output),IPL_DEPTH_8U, 1);
    cvZero(pOutput);
    cvDrawContours(pOutput, pcvSeq,cvScalar(-1), cvScalar(255),5);//绘制轮廓
    
    self.imageView.image = [UIImage imageWithIplImage:pOutput isGrayImg:YES];
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

