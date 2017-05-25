//
//  UIImage+MSUDecoder.h
//  秀贝
//
//  Created by Zhuge_Su on 2017/5/25.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MSUDecoder)
/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
