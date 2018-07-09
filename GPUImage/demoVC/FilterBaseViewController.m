//
//  FilterBaseViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/9.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "FilterBaseViewController.h"

@interface FilterBaseViewController ()
@property (nonatomic,strong) UIButton * controlBtn;
@end

@implementation FilterBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.controlBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.controlBtn removeFromSuperview];
}

- (UIButton *)controlBtn {
    if (!_controlBtn) {
        _controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _controlBtn.frame = CGRectMake(20, 150, 100, 50);
        _controlBtn.backgroundColor = [UIColor blackColor];
        _controlBtn.alpha = 0.7;
        [_controlBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        [_controlBtn addTarget:self action:@selector(clickedControlButton:end:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlBtn;
}

- (void)clickedControlButton:(void(^)(void))start end:(void(^)(void))end {
    if ([_controlBtn.titleLabel.text isEqualToString:@"开始录制"]) {
        NSLog(@"点击开始录制 ---");
        [_controlBtn setTitle:@"结束录制" forState:UIControlStateNormal];
        if (start) {
            start();
        }
    }
    else {
        NSLog(@"点击结束录制 ---");
        [_controlBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        if (end) {
            end();
        }
    }
}

//- (void)clickedControlButton {
//    if ([_controlBtn.titleLabel.text isEqualToString:@"开始录制"]) {
//        NSLog(@"开始录制 --- ---");
//        [_controlBtn setTitle:@"结束录制" forState:UIControlStateNormal];
//    }
//    else {
//        NSLog(@"结束录制 --- ---");
//        [_controlBtn setTitle:@"开始录制" forState:UIControlStateNormal];
//    }
//}

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
