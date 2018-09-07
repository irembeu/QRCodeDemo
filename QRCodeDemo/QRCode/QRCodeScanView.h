//
//  QRCodeScanView.h
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CornerLoactionDefault,//默认与边框同中心点
    CornerLoactionInside,//在边框线内部
    CornerLoactionOutside,//在边框线外部
} CornerLoaction;

@interface QRCodeScanView : UIView

@property (nonatomic, strong) UIColor *borderColor;/** 边框颜色*/
@property (nonatomic, assign) CornerLoaction cornerLocation;/** 边角位置 默认default*/
@property (nonatomic, strong) UIColor *cornerColor;/** 边角颜色 默认正保蓝#32d2dc*/
@property (nonatomic, assign) CGFloat cornerWidth;/** 边角宽度 默认2.f*/
@property (nonatomic, assign) CGFloat backgroundAlpha;/** 扫描区周边颜色的alpha 默认0.5*/
@property (nonatomic, assign) CGFloat timeInterval;/** 扫描间隔 默认0.02*/
@property (nonatomic, strong) UIButton *lightBtn;/** 闪光灯*/


/**
 添加定时器
 */
- (void)addTimer;

/**
 移除定时器
 */
- (void)removeTimer;

/**
 根据灯光判断
 */
- (void)lightBtnChangeWithBrightnessValue:(CGFloat)brightnessValue;

@end
