//
//  QRScanBottomView.m
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import "QRScanBottomView.h"

@interface QRScanBottomView()

@property (nonatomic, assign) ShowType showType;

@end

@implementation QRScanBottomView

- (instancetype)initWithFrame:(CGRect)frame showType:(ShowType)showType {
    if (self = [super initWithFrame:frame]) {
        self.showType = showType;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIButton *albumBtn = [self configButtonWithTitle:@"相册" imgName:@""];
    self.albumBtn = albumBtn;
    [self addSubview:albumBtn];
    
    UIButton *inputBtn = [self configButtonWithTitle:@"输入" imgName:@""];
    self.inputCodeBtn = inputBtn;
    [self addSubview:inputBtn];
    
    CGFloat btnW = 100;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat centerY = self.frame.size.height/2;
    
    if (self.showType == ShowTypeAlbum) {
        //只有相册
        self.albumBtn.frame = CGRectMake(0, 0, btnW, btnW);
        self.albumBtn.center = CGPointMake(screenW/2, centerY);
    } else if (self.showType == ShowTypeInputCode) {
        //只有输入
        self.inputCodeBtn.frame = CGRectMake(0, 0, btnW, btnW);
        self.inputCodeBtn.center = CGPointMake(screenW/2, centerY);
    } else {
        self.albumBtn.frame = CGRectMake(0, 0, btnW, btnW);
        self.albumBtn.center = CGPointMake(screenW/4, centerY);
        
        self.inputCodeBtn.frame = CGRectMake(0, 0, btnW, btnW);
        self.inputCodeBtn.center = CGPointMake(screenW*3/4, centerY);
    }
    
}

- (UIButton *)configButtonWithTitle:(NSString *)title imgName:(NSString *)imgName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}


@end
