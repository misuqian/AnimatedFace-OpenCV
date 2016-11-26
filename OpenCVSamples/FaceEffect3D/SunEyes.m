//
//  SunEyes.m
//  OpenCVSamples
//
//  Created by misupeng on 16/10/8.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "SunEyes.h"

@implementation SunEyes{
    SCNNode* sun_left;
    SCNNode* sun_right;
    SCNScene* backScene;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backScene = [SCNScene scene];
        // create and add a camera to the scene
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = [SCNCamera camera];
        [backScene.rootNode addChildNode:cameraNode];
        
        // place the camera
        cameraNode.position = SCNVector3Make(0, 50,250);
        cameraNode.camera.zFar = 2000;
        cameraNode.rotation =  SCNVector4Make(1, 0, 0,-M_PI_4/4);
        
        self.scene = backScene;
        self.backgroundColor = [UIColor clearColor];
        
        [self initSunEyes];
        NSLog(@"init!!!");
    }
    return self;
}

-(void)initSunEyes{
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    sun_left = [SCNNode new];
    sun_right = [SCNNode new];
    
    sun_left.geometry = sun_right.geometry = [SCNSphere sphereWithRadius:height];
    
    sun_left.position = SCNVector3Make(-width / 20.0 * 19.5, 0.0, 0.0);
    sun_right.position = SCNVector3Make(width / 20.0 * 19.5, 0.0, 0.0);
    
    [self.scene.rootNode addChildNode:sun_left];
    [self.scene.rootNode addChildNode:sun_right];
    
    sun_left.geometry.firstMaterial.multiply.contents = sun_right.geometry.firstMaterial.multiply.contents = @"sun.jpg";
    sun_left.geometry.firstMaterial.diffuse.contents = sun_right.geometry.firstMaterial.diffuse.contents = @"sun.jpg";
    sun_left.geometry.firstMaterial.multiply.intensity = sun_right.geometry.firstMaterial.multiply.intensity  = 0.5;
    sun_left.geometry.firstMaterial.lightingModelName = sun_right.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    sun_left.geometry.firstMaterial.multiply.wrapS =
    sun_left.geometry.firstMaterial.diffuse.wrapS  =
    sun_left.geometry.firstMaterial.multiply.wrapT =
    sun_left.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    sun_left.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    sun_right.geometry.firstMaterial.multiply.wrapS =
    sun_right.geometry.firstMaterial.diffuse.wrapS  =
    sun_right.geometry.firstMaterial.multiply.wrapT =
    sun_right.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    sun_right.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    // Achieve a lava effect by animating textures
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 5.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.repeatCount = FLT_MAX;
    [sun_left.geometry.firstMaterial.diffuse addAnimation:animation forKey:@"sun-texture"];
    [sun_right.geometry.firstMaterial.diffuse addAnimation:animation forKey:@"sun-texture"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 15.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.repeatCount = FLT_MAX;
    [sun_left.geometry.firstMaterial.multiply addAnimation:animation forKey:@"sun-texture2"];
    [sun_right.geometry.firstMaterial.multiply addAnimation:animation forKey:@"sun-texture2"];
}

-(void)resetFrame:(CGRect)frame{
    self.frame = frame;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    ((SCNSphere *)sun_left.geometry).radius = height;
    ((SCNSphere *)sun_right.geometry).radius = height;
    sun_left.position = SCNVector3Make(-width / 20.0 * 19.5, 0.0, 0.0);
    sun_right.position = SCNVector3Make(width / 20.0 * 19.5, 0.0, 0.0);
}

@end
