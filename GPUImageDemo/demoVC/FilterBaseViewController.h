//
//  FilterBaseViewController.h
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/9.
//  Copyright © 2018年 sun. All rights reserved.
//

#import <UIKit/UIKit.h>
/// base view controller

#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@interface FilterBaseViewController : UIViewController
- (void)clickedControlButton:(void(^)(void))start end:(void(^)(void))end;
@end
