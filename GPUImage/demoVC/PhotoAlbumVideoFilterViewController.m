//
//  PhotoAlbumVideoFilterViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/10.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "PhotoAlbumVideoFilterViewController.h"
#import <GPUImage.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface PhotoAlbumVideoFilterViewController ()
@property (nonatomic,strong) UILabel * progressLabel;
@property (nonatomic,strong) UIButton * startBtn;
@property (nonatomic,strong) NSURL * movieURL;

@property (nonatomic,strong) GPUImageMovie * movieFile;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> * filter;
@property (nonatomic,strong) GPUImageMovieWriter * movieWriter;
@property (nonatomic,strong) NSTimer * timer;

@end

@implementation PhotoAlbumVideoFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.startBtn];

    
    // 要转换的视频
    NSURL * pathUrl = [[NSBundle mainBundle] URLForResource:@"sample_iPod" withExtension:@"m4v"];
    //
    _movieFile = [[GPUImageMovie alloc] initWithURL:pathUrl];
    _movieFile.runBenchmark = YES;
    _movieFile.playAtActualSpeed = NO;
    
    // 随便创建一个滤镜
    // (这个是一个像素化的滤镜 结果就跟马赛克了一样)
    _filter = [[GPUImagePixellateFilter alloc] init];

    
    [_movieFile addTarget:_filter];
    
    
    
    // 设置输出路径
    NSString * pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    // - 如果文件已存在,AVAssetWriter不允许直接写进新的帧,所以会删掉老的视频文件
    unlink([pathToMovie UTF8String]); 
    self.movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    // 输出 后面的size可改 ~ 现在来说480*640有点太差劲了
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(480.0, 640.0)];
    
    [_filter addTarget:_movieWriter];
    
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    // 完成之后的回调 - 为啥100%了之后还会待一会才调用这个completeBlock
    __weak typeof(self) weakself = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof (weakself) strongSelf = weakself;
        [strongSelf.filter removeTarget:strongSelf.movieWriter];
        [strongSelf.movieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.timer invalidate];
            strongSelf.progressLabel.text = @"完成 !";
        });
        
        // 异步写入相册
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            [strongSelf writeToPhotoAlbum];
        });  
        
    }];
    
    
}

- (void)retrievingProgress {
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", (self.movieFile.progress * 100)];
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 150, 60)];
        _progressLabel.text = @"进度:0%";
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor blackColor];
    }
    return _progressLabel;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 180, 150, 60)];
        [_startBtn setTitle:@"开  始" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(clickStartBtn) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _startBtn;
}

- (void)clickStartBtn {
    if (![self.progressLabel.text isEqualToString:@"进度:0%"]) {
        return;
    }
    
    // 开始转换
    [self.movieWriter startRecording];
    [self.movieFile startProcessing];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                  target:self
                                                selector:@selector(retrievingProgress)
                                                userInfo:nil
                                                 repeats:YES];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)dealloc {
   
    [_movieFile endProcessing];
    [_filter removeTarget:_movieWriter];
    [_movieWriter finishRecording];
    _movieFile = nil;
    _movieWriter = nil;
    _filter = nil;
     _progressLabel = nil;
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
