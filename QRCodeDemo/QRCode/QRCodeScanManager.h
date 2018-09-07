//
//  QRCodeScanManager.h
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^GetBrightnessBlock)(CGFloat brightness);
typedef void(^ScanBlock)(NSArray *metadataObjects);

@interface QRCodeScanManager : NSObject

+ (instancetype)sharedManager;

//设置二维码读取率 数据类型 当前控制器
- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController;

//亮度回调
- (void)brightnessChange:(GetBrightnessBlock)getBrightnessBlock;

//扫描结果
- (void)scanResult:(ScanBlock)scanBlock;

/**
 开启会话对象扫描
 */
- (void)startRunning;

/**
 关闭会话对象扫描
 */
- (void)stopRunning;

/**
 移除 videoPreviewLayer对象
 */
- (void)videoPreviewLayerRemoveFromSuperlayer;

/**
 播放音效文件
 */
- (void)playSoundName:(NSString *)name;


/**
 重置根据光线强弱值打开手电筒 delegate方法
 */
- (void)resetSampleBufferDelegate;

/**
 取消根据光线强弱值打开手电筒的delegate方法
 */
- (void)cancelSampleBufferDelegate;

@end
