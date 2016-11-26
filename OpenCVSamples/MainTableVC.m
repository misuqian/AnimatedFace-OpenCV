//
//  ViewController.m
//  OpenCVSamples
//
//  Created by misupeng on 16/9/27.
//  Copyright © 2016年 misuqian. All rights reserved.
//

#import "MainTableVC.h"

@interface MainTableVC (){
    NSArray* headers;
    NSArray* titles;
}
@end

@implementation MainTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    headers = [[NSArray alloc] initWithObjects:@"兼容组件",@"物体检测",@"图像处理",@"综合", nil];
    titles = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"摄像头动态处理",@"摄像头拍照处理", nil],
                                            [[NSArray alloc] initWithObjects:@"脸部检测",@"行人HOG检测",@"边缘检测",@"轮廓检测",nil],
                                            [[NSArray alloc] initWithObjects:@"图片合成", nil],
                                            [[NSArray alloc] initWithObjects:@"脸部特效2D",@"脸部特效3D", nil],
                                            nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray* arr = titles[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray*)titles[section]).count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return headers.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return headers[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* arr = titles[indexPath.section];
    [self performSegueWithIdentifier:arr[indexPath.row] sender:self];
}

@end
