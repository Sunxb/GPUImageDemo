//
//  PhotoFilterViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/10.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "PhotoFilterViewController.h"
#import <GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoFilterViewController ()
@property (nonatomic,strong) GPUImageStillCamera * stillCamera;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> * filter;
@end

@implementation PhotoFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //相机
    _stillCamera = [[GPUImageStillCamera alloc] init];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    // 随便一个滤镜
    _filter = [[GPUImageSketchFilter alloc] init];

    [_stillCamera addTarget:_filter];
    
    //显示
    GPUImageView * filterView = [[GPUImageView alloc] init];
    self.view = filterView;
    
    [_filter addTarget:filterView];
    
    [_stillCamera startCameraCapture];
    
}

- (void)clickedControlButton:(void (^)(void))start end:(void (^)(void))end {
    start = ^(){
        [self takePhoto];
    };
    
    [super clickedControlButton:start end:nil];
}

- (void)takePhoto {
    [_stillCamera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        
        // !!!! 下面这种写法 - 生成的图片会右转90°
        
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//
//        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:_stillCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error2) {
//             if (error2) {
//                 NSLog(@"ERROR: the image failed to be written");
//             }
//             else {
//                 NSLog(@"保存成功 - assetURL: %@", assetURL);
//             }
//         }];
        
        UIImage * chooseImage = [UIImage imageWithData:processedJPEG];
        if (chooseImage) {
            UIImageWriteToSavedPhotosAlbum(chooseImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"保存到相册成功"
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
