//
//  FaecEffect3D.h
//  OpenCVSamples
//
//  Created by misupeng on 16/10/8.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "SunEyes.h"

@interface FaceEffect3D : UIViewController<CvVideoCameraDelegate>

@property(strong,nonatomic)SunEyes *scnView;

@end
