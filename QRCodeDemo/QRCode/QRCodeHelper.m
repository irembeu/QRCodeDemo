//
//  QRCodeHelper.m
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import "QRCodeHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation QRCodeHelper

+ (void)judgeAuthiorizationStatusWithCurrentVc:(UIViewController *)currentVc resultBlock:(void (^)(BOOL))resultBlock {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (resultBlock) {
                            resultBlock(YES);
                        }
                    });
                } else {
                    //用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) {
            //用户允许当前应用访问相机
            if (resultBlock) {
                resultBlock(YES);
            }
        } else if (status == AVAuthorizationStatusDenied) {
            //用户拒绝当前应用访问相机
            NSString *message = @"请允许当前应用使用相机";
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertA];
            [currentVc presentViewController:alertC animated:YES completion:nil];
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因系统原因，无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到您的摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:alertA];
        [currentVc presentViewController:alertC animated:YES completion:nil];
    }
}

@end
