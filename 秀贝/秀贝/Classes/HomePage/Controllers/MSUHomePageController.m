//
//  MSUHomePageController.m
//  秀贝
//
//  Created by Zhuge_Su on 2017/5/24.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUHomePageController.h"
#import "MSUPrefixHeader.pch"
#import "MSUHomeNavView.h"
#import "MSUScanController.h"

@interface MSUHomePageController ()

@end

@implementation MSUHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 背景颜色
    self.view.backgroundColor = NavColor;
    
    // 导航栏
    [self createNavView];
    // 中部视图
    [self createCenterView];
    
}

#pragma mark - 视图相关
/// 导航栏视图
- (void)createNavView{
    MSUHomeNavView *nav = [[MSUHomeNavView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44) showNavWithNumber:0];
    nav.backgroundColor = NavColor;
    [nav.scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:nav];
}

/// 中部视图
- (void)createCenterView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    navView.backgroundColor = CyanColor;
    [self.view addSubview:navView];

}

#pragma mark - 点击事件
- (void)scanBtnClick:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    MSUScanController *scan = [[MSUScanController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
