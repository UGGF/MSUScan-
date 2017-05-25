//
//  MSUHomeNavView.m
//  秀贝
//
//  Created by Zhuge_Su on 2017/5/24.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUHomeNavView.h"
#import "MSUPrefixHeader.pch"

@implementation MSUHomeNavView

- (instancetype)initWithFrame:(CGRect)frame showNavWithNumber:(NSInteger)number
{
    if (self = [super initWithFrame:frame]) {
        switch (number) {
            case 0:
            {
                [self createHomePageNavView];
            }
                break;
            case 1:
            {
                [self createScanNavView];
            }
                break;

            default:
                break;
        }
    }
    return self;
}

/// 首页的导航视图
- (void)createHomePageNavView{
    // 定位按钮
    self.LocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _LocationBtn.backgroundColor = [UIColor whiteColor];
    [_LocationBtn setTitle:@"杭州" forState:UIControlStateNormal];
    _LocationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_LocationBtn];
//    [_LocationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_LocationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(17);
        make.left.equalTo(self.left).offset(15);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
    
    // 中部标识
    UIImageView *logoIma = [[UIImageView alloc] init];
    logoIma.image = nil;
    logoIma.backgroundColor = [UIColor whiteColor];
    [self addSubview:logoIma];
    [logoIma makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(7);
        make.left.equalTo(self.left).offset(WIDTH * 0.5 - 50);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];

    // 扫描按钮
    self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:_scanBtn];
    [_scanBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(7);
        make.right.equalTo(self.right).offset(-15);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
}

/// 扫描页面的导航视图
- (void)createScanNavView{
    // 左箭头
    self.arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _arrowBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:_arrowBtn];
    [_arrowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(7);
        make.left.equalTo(self.left).offset(15);
        make.width.equalTo(20);
        make.height.equalTo(30);
    }];
    
    // 扫描二维码
    UILabel *scanLab = [[UILabel alloc] init];
    scanLab.text = @"扫描二维码";
    scanLab.font = [UIFont systemFontOfSize:20];
    [scanLab setTextColor:WHITECOLOR];
    [self addSubview:scanLab];
    [scanLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(5);
        make.left.equalTo(self.left).offset(WIDTH * 0.5 - 60);
        make.width.equalTo(120);
        make.height.equalTo(34);
    }];
    
    // 相册
    _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_photoBtn];
    [_photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    _photoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_photoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(7);
        make.right.equalTo(self.right).offset(-15);
        make.width.equalTo(40);
        make.height.equalTo(30);
    }];

}





@end
