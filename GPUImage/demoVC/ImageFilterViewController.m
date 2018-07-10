//
//  ImageFilterViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/10.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "ImageFilterViewController.h"
#import <GPUImage.h>

@interface ImageFilterViewController ()
@property (nonatomic,strong) GPUImagePicture * sourcePicture;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *sepiaFilter;

@property (nonatomic,strong) UIButton * keepBtn;

@end

@implementation ImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 原图
    UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"];
    
    //
    _sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    
    // 滤镜
    _sepiaFilter = [[GPUImageTiltShiftFilter alloc] init];
    
    // 显示
    GPUImageView * imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.view = imageView;
    
    //
    [_sepiaFilter forceProcessingAtSize:imageView.sizeInPixels];
 
    //
    [_sourcePicture addTarget:_sepiaFilter];
    
    [_sepiaFilter addTarget:imageView];
    
    [_sourcePicture processImage];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 保存到相册
        UIImage *keepImage = [self.sepiaFilter imageByFilteringImage:inputImage];
        if (keepImage) {
            UIImageWriteToSavedPhotosAlbum(keepImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
