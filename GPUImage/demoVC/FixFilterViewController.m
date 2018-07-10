//
//  FixFilterViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/10.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "FixFilterViewController.h"
#import <GPUImage.h>

@interface FixFilterViewController ()

@end

@implementation FixFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 原图
    UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"];
    
    GPUImagePicture * pic = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // 显示
    GPUImageView * imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.view = imageView;
    
    // 混合滤镜关键
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    
    // 添加 filter
    /**
     原理：
     1. filterGroup(addFilter) 滤镜组添加每个滤镜
     2. 按添加顺序（可自行调整）前一个filter(addTarget) 添加后一个filter
     3. filterGroup.initialFilters = @[第一个filter]];
     4. filterGroup.terminalFilter = 最后一个filter;
     */
    GPUImageColorInvertFilter *filter1 = [[GPUImageColorInvertFilter alloc] init];
    
    //伽马线滤镜
    GPUImageGammaFilter *filter2 = [[GPUImageGammaFilter alloc]init];
    filter2.gamma = 0.2;
    
    //曝光度滤镜
    GPUImageExposureFilter *filter3 = [[GPUImageExposureFilter alloc]init];
    filter3.exposure = -1.0;
    
    //怀旧
    GPUImageSepiaFilter *filter4 = [[GPUImageSepiaFilter alloc] init];
    
    
    // 所有的filter添加到filterGroup上
    [filterGroup addFilter:filter1];
    [filterGroup addFilter:filter2];
    [filterGroup addFilter:filter3];
    [filterGroup addFilter:filter4];
    
    // 注意下面的add ~ (感觉就是一个摞一个.)
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    [filter3 addTarget:filter4];
    
    filterGroup.initialFilters = @[filter1];
    filterGroup.terminalFilter = filter4;

    [pic removeAllTargets];
    [pic addTarget:filterGroup];
    [filterGroup addTarget:imageView];
    
    [pic processImage];
    
    [filterGroup useNextFrameForImageCapture];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 保存到相册
        UIImage * outImage = [filterGroup imageFromCurrentFramebuffer];
        if (outImage) {
            UIImageWriteToSavedPhotosAlbum(outImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    });
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存处理后的图片到相册"
                                                        message:@"保存成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
