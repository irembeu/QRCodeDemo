//
//  QRScanBottomView.h
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ShowTypeAlbum,//只有相册
    ShowTypeInputCode,//只有输入码
    ShowTypeBoth,//两种都有
} ShowType;

@interface QRScanBottomView : UIView

@property (nonatomic, strong) UIButton *albumBtn;/** 相册按钮*/
@property (nonatomic, strong) UIButton *inputCodeBtn;/** 输入码按钮*/

- (instancetype)initWithFrame:(CGRect)frame showType:(ShowType)showType;

@end
