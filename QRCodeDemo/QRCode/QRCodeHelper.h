//
//  QRCodeHelper.h
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeHelper : NSObject

//判断授权状态
+ (void)judgeAuthiorizationStatusWithCurrentVc:(UIViewController *)currentVc resultBlock:(void (^)(BOOL goOn))resultBlock;

@end
