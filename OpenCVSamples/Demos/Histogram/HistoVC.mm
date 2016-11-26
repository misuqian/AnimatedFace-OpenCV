//
//  HistoVC.m
//  OpenCVSamples
//
//  Created by misupeng on 16/10/9.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "HistoVC.h"
#import <opencv2/imgproc/imgproc.hpp>
#import "UIImage+CVMat.h"

@interface HistoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation HistoVC

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
    
    //self.imageView.image = [[UIImage alloc] initWithCVMat:faceImage originImage:image];
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
