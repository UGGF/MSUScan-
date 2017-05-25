//
//  YTPromptView.h
//  CityYouTian
//
//  Created by MSU on 16/4/13.
//  Copyright © 2016年 qz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface MSUHUD :NSObject

+ (instancetype )shareInstance;

/**
 *  主动消失"菊花"
 */
+ (void)dismiss;
/**
 *  显示菊花+提示内容(需主动调用dismiss)
 *
 *  @param string 提示内容
 */
+ (void)showStatusWithString:(NSString *)string;
/**
 *  显示错误信息(自动消失)
 *
 *  @param string 错误信息
 */
+ (void)showErrorWithString:(NSString *)string;
/**
 *  显示成功信息(自动消失)
 *
 *  @param string 成功信息
 */
+ (void)showSuccessWithString:(NSString *)string;
/**
 *  显示"菊花"转+提示信息
 *
 *  @param string 提示信息
 *  @param delay  几秒后消失
 */
+ (void)showStatusWithString:(NSString *)string hideAfterDelay:(CGFloat)delay;
/**
 *  ///安卓版提示语(默认1s后消失)
 *
 *  @param string 提示内容
 *  @param Y      Y轴基于屏幕中间哪里
 */
+ (void)showFileWithString:(NSString *)string OffsetY:(CGFloat)Y;

/**
 *  安卓版提示语(固定在屏幕下方80像素处)
 *
 *  @param string 提示内容
*/
+ (void)showFileWithString:(NSString *)string;

@end
