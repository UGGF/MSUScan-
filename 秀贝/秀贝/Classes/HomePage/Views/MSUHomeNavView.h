//
//  MSUHomeNavView.h
//  秀贝
//
//  Created by Zhuge_Su on 2017/5/24.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSUHomeNavView : UIView

@property (nonatomic , strong) UIButton *LocationBtn;
@property (nonatomic , strong) UIButton *scanBtn;
@property (nonatomic , strong) UIButton *arrowBtn;
@property (nonatomic , strong) UIButton *photoBtn;


- (instancetype)initWithFrame:(CGRect)frame showNavWithNumber:(NSInteger)number;


@end
