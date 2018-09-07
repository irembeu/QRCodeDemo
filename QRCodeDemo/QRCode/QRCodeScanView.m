//
//  QRCodeScanView.m
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import "QRCodeScanView.h"
#import "QRLightManager.h"
#import "UIView+Frame.h"

@interface QRCodeScanView()

@property (nonatomic, strong) UIImageView *scanningLine;/** 扫描线*/
@property (nonatomic, strong) NSTimer *timer;/** 定时器*/

@end

@implementation QRCodeScanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initilize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initilize];
    }
    return self;
}

- (void)initilize {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.borderColor = [UIColor whiteColor];
    _cornerLocation = CornerLoactionDefault;
    _cornerColor = [UIColor colorWithRed:50/255.0f green:210/255.0f blue:220/255.0f alpha:1.0];
    _cornerWidth = 2.0;
    self.timeInterval = 0.02;
    _backgroundAlpha = 0.5;
    
    [self addSubview:self.lightBtn];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //边框 frame
    CGFloat borderW = self.frame.size.width;
    CGFloat borderH = borderW;
    CGFloat borderX = 0;
    CGFloat borderY = 0;
    CGFloat borderLineW = 0.2;
    
    //空白区域设置
    [[[UIColor blackColor] colorWithAlphaComponent:self.backgroundAlpha] setFill];
    UIRectFill(rect);
    //获取上下文，并设置混合模式 -> kCGBlendModeDestinationOut
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    //设置空白区
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX + 0.5 * borderLineW, borderY+ 0.5 * borderLineW, borderW - borderLineW, borderH - borderLineW)];
    [bezierPath fill];
    //执行混合模式
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //边框设置
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX, borderY, borderW, borderH)];
    borderPath.lineCapStyle = kCGLineCapButt;
    borderPath.lineWidth = borderLineW;
    [self.borderColor set];
    [borderPath stroke];
    
    CGFloat cornerLength = 20;
    //左上角小图标
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    CGFloat insideExcess = fabs(0.5 * (self.cornerWidth - borderLineW));
    CGFloat outsideExcess = 0.5 * (borderLineW + self.cornerWidth);
    if (self.cornerLocation == CornerLoactionInside) {
        [leftTopPath moveToPoint:CGPointMake(borderX + insideExcess, borderY + cornerLength + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLength + insideExcess, borderY + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftTopPath moveToPoint:CGPointMake(borderX - outsideExcess, borderY + cornerLength - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLength - outsideExcess, borderY - outsideExcess)];
    } else {
        [leftTopPath moveToPoint:CGPointMake(borderX, borderY + cornerLength)];
        [leftTopPath addLineToPoint:CGPointMake(borderX, borderY)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLength, borderY)];
    }
    [leftTopPath stroke];
    
    //左下角小图标
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLength + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - cornerLength - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLength - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH - cornerLength + outsideExcess)];
    } else {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLength, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH - cornerLength)];
    }
    [leftBottomPath stroke];
    
    
    //右上角小图标
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLength - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + cornerLength + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLength + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + cornerLength - outsideExcess)];
    } else {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLength, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY + cornerLength)];
    }
    [rightTopPath stroke];
    
    //右下角小图标
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - cornerLength - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLength - insideExcess, borderY + borderH - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH - cornerLength + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLength + outsideExcess, borderY + borderH + outsideExcess)];
    } else {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW, borderY + borderH - cornerLength)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW, borderY + borderH)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLength, borderY + borderH)];
    }
    
    [rightBottomPath stroke];
}

- (void)addTimer {
    [self addSubview:self.scanningLine];
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(beginAnimaiton) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark 动画
- (void)beginAnimaiton {
    static BOOL isOrignPostion = YES;
    
    if (isOrignPostion) {
        _scanningLine.y = 0;
        isOrignPostion = NO;
        [UIView animateWithDuration:self.timeInterval animations:^{
            self->_scanningLine.y += 2;
        } completion:nil];
    } else {
        if (_scanningLine.frame.origin.y >= 0) {
            CGFloat scanContent_MaxY = self.frame.size.width;
            if (_scanningLine.y >= scanContent_MaxY - 10) {
                _scanningLine.y = 0;
                isOrignPostion = YES;
            } else {
                [UIView animateWithDuration:0.02 animations:^{
                    self->_scanningLine.y += 2;
                    
                } completion:nil];
            }
        } else {
            isOrignPostion = !isOrignPostion;
        }
    }
}

#pragma mark 根据灯光判断
- (void)lightBtnChangeWithBrightnessValue:(CGFloat)brightnessValue {
    if (!self.lightBtn.selected) {
        self.lightBtn.hidden = !(brightnessValue < -1);
    }
}

#pragma mark 移除定时器
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningLine removeFromSuperview];
    self.scanningLine = nil;
}

- (UIImageView *)scanningLine {
    if (!_scanningLine) {
        _scanningLine = [[UIImageView alloc] init];
        _scanningLine.image = [UIImage imageNamed:@"QRCodeScanningLine"];
        _scanningLine.frame = CGRectMake(0, 0, self.frame.size.width, 12);
    }
    return _scanningLine;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
}

- (void)setCornerLocation:(CornerLoaction)cornerLocation {
    _cornerLocation = cornerLocation;
}

- (void)setCornerColor:(UIColor *)cornerColor {
    _cornerColor = cornerColor;
}

- (void)setCornerWidth:(CGFloat)cornerWidth {
    _cornerWidth = cornerWidth;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    _backgroundAlpha = backgroundAlpha;
}

- (void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
}

- (UIButton *)lightBtn {
    if (!_lightBtn) {
        _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightBtn setImage:[UIImage imageNamed:@"openImage"] forState:UIControlStateNormal];
        [_lightBtn setImage:[UIImage imageNamed:@"closeImage"] forState:UIControlStateSelected];
        _lightBtn.frame = CGRectMake(self.width/2 -15, self.height - 50, 30, 30);
        [_lightBtn addTarget:self action:@selector(lightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightBtn;
}

- (void)lightBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [QRLightManager openFlashLight];
    } else {
        [QRLightManager closeFlashLight];
    }
}

@end
