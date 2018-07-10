//
//  ViewController.m
//  GPUImage
//
//  Created by sunxiaobin on 2018/7/9.
//  Copyright © 2018年 sun. All rights reserved.
//

#import "ViewController.h"


#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * rootTableView;
@property (nonatomic,strong) NSArray * dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.rootTableView];

}

- (UITableView *)rootTableView {
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, KWidth, KHeight-80) style:UITableViewStylePlain];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
    }
    return _rootTableView;
}

-(NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"相机录像添加实时滤镜",
                     @"相册内视频添加滤镜处理",
                     @"相机拍照添加实时滤镜",
                     @"给已有的图片/照片添加滤镜",
                     @"混合滤镜"].copy;
    }
    return _dataArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * vcStr = @"";
    switch (indexPath.row) {
        case 0:
            //相机录像添加实时滤镜
            vcStr = @"SimpleVideoFilterViewController";
            break;
        case 1:
            //相册内视频添加滤镜处理
            vcStr = @"PhotoAlbumVideoFilterViewController";
            break;
        case 2:
            //相机拍照添加实时滤镜
            vcStr = @"PhotoFilterViewController";
            break;
        case 3:
            //给已有的图片/照片添加滤镜
            vcStr = @"ImageFilterViewController";
            break;
        case 4:
            //混合滤镜
            vcStr = @"FixFilterViewController";
            break;
        default:
            break;
    }
    
    Class vc = NSClassFromString(vcStr);
    [self.navigationController pushViewController:[[vc alloc]init] animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
