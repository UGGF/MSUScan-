//
//  MSUTabbarController.m
//  秀贝
//
//  Created by Zhuge_Su on 2017/5/24.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUTabbarController.h"
#import "MSUHomePageController.h"
#import "MSUVideoController.h"
#import "MSUShopStoreController.h"
#import "MSUPersonCenterController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width


@interface MSUTabbarController ()

@end

@implementation MSUTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更改tabbar 选中字体颜色
    self.tabBar.tintColor = [UIColor orangeColor];

    // tabbar创建方法
    [self createSystemTabbar];
}

//自封装方法
-(UINavigationController*)createNavWithViewController:(UIViewController *)viewController WithTitle:(NSString*) title image:(UIImage*)image
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:nil];
    nav.navigationBar.hidden = YES;
    return nav;
}

//创建系统tabbar
- (void)createSystemTabbar{
    MSUHomePageController *home = [[MSUHomePageController alloc] init];
    MSUVideoController *video = [[MSUVideoController alloc] init];
    UIViewController *vc = [[UIViewController alloc] init];
    MSUShopStoreController *shop = [[MSUShopStoreController alloc] init];
    MSUPersonCenterController *center = [[MSUPersonCenterController alloc] init];
    
    // 图片数组
    NSArray *imageArr = @[@"icon-d-4",@"icon-d-3",@"icon-d-2",@"icon-d-1"];
    
    //数组设置
    self.viewControllers = [NSArray arrayWithObjects:[self createNavWithViewController:home WithTitle:@"首页"  image:[UIImage imageNamed:imageArr[0]]],
                            [self createNavWithViewController:shop WithTitle:@"商城" image:[UIImage imageNamed:imageArr[1]]],
                            [self createNavWithViewController:vc WithTitle:nil image:nil],
                            [self createNavWithViewController:video WithTitle:@"视频" image:[UIImage imageNamed:imageArr[2]]],
                            [self createNavWithViewController:center WithTitle:@"我的" image:[UIImage imageNamed:imageArr[3]]],
                            nil];
    
    
    //中间突出按钮设置
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0.0,0.0,65,65)];
    button.center = CGPointMake(WIDTH/2,15);
    [button setBackgroundImage:[UIImage imageNamed:@"icon-z"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pickClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:button];
    
    
}

//点击事件
- (void)pickClick{
    
}

@end
