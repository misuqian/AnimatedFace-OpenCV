//
//  EdgeDetect.m
//  OpenCVSamples
//
//  Created by misupeng on 2016/10/10.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "EdgeDetect.h"
#import <opencv2/imgproc/imgproc.hpp>
#import "UIImage+CVMat.h"

@interface EdgeDetect (){
    UIImage* IMG;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation EdgeDetect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self detectImage:[UIImage imageNamed:@"face"] value:50.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)detectImage:(UIImage*)image value:(CGFloat)v{
    if(!image){
        return;
    }
    IMG = image;
    
    IplImage* src = [UIImage CreateIplImageFromUIImage:image shouldBeGray:YES];
    IplImage* output = cvCreateImage(cvGetSize(src), src->depth, 1);
    cvCanny(src,output,v,v * 3.0,3);
    self.imageView.image = [UIImage imageWithIplImage:output isGrayImg:YES];
}

- (IBAction)selectPhoto:(UIBarButtonItem *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [self detectImage:image value:50.0];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
