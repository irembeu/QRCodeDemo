//
//  QRLightManager.h
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRLightManager : NSObject


/**
 打开手电筒
 */
+ (void)openFlashLight;


/**
 关闭手电筒
 */
+ (void)closeFlashLight;

@end
