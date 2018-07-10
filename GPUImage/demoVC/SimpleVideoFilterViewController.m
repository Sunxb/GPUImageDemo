//
//  SimpleVideoFilterViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/9.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "SimpleVideoFilterViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <GPUImage.h>

@interface SimpleVideoFilterViewController ()
@property (nonatomic,strong) GPUImageVideoCamera * videoCamera;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> * filter;
@property (nonatomic,strong) GPUImageMovieWriter * movieWriter;

@property (nonatomic,strong) NSURL * movieURL;
@end

@implementation SimpleVideoFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置摄像头
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    
    // 随意创建了一个滤镜 (好像是有点泛黄色的效果)
    _filter = [[GPUImageSepiaFilter alloc] init];
    
    //
    [_videoCamera addTarget:_filter];
    
    // 显示
    GPUImageView * filterView = [[GPUImageView alloc] init];
    self.view = filterView;
    
    // 存储路径
    NSString * pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    // - 如果文件已存在,AVAssetWriter不允许直接写进新的帧,所以会删掉老的视频文件
    unlink([pathToMovie UTF8String]); 
    self.movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    // 设置writer 后面的size可改 ~ 现在来说480*640有点太差劲了
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(480.0, 640.0)];
    _movieWriter.encodingLiveVideo = YES;
    
    [_filter addTarget:_movieWriter];
    [_filter addTarget:filterView];
    
    
    // 开始
    [_videoCamera startCameraCapture];
}

// 开始录制
- (void)clickedControlButton:(void (^)(void))start end:(void (^)(void))end {
    
    
    start = ^(){
        NSLog(@"开始录制 -");
        self.videoCamera.audioEncodingTarget = self.movieWriter;
        [self.movieWriter startRecording];
        
    };
    
    
    end = ^(){
        [self.filter removeTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = nil;
        [self.movieWriter finishRecording];
        NSLog(@"Movie completed");
        // 写入相册
        [self writeToPhotoAlbum];
    };
    
    [super clickedControlButton:start end:end];
    
}




///////////////////////////////////////////////////////////////////

- (void)writeToPhotoAlbum {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.movieURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:self.movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                    message:@"保存失败"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"保存到相册成功"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            });
        }];
    }
}

- (void)dealloc {
    
    [self.filter removeTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = nil;
    [self.movieWriter finishRecording];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
