//
//  QRCodeScanManager.m
//  QRCodeDemo
//
//  Created by lgj on 2018/9/6.
//  Copyright © 2018年 lgj. All rights reserved.
//

#import "QRCodeScanManager.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanManager()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;/** 会话*/
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;/** 视频输出*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;/** 画面layer*/
@property (nonatomic, copy) GetBrightnessBlock brightnessBlock;
@property (nonatomic, copy) ScanBlock scanBlock;

@end

@implementation QRCodeScanManager

+ (instancetype)sharedManager {
    static QRCodeScanManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QRCodeScanManager alloc] init];
    });
    return manager;
}

- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController {
    if (sessionPreset == nil || metadataObjectTypes == nil || currentController == nil) {
        NSException *excp = [NSException exceptionWithName:@"excp" reason:@"setupSessionPreset:metadataObjectTypes:currentController: 方法中的 sessionPreset 参数不能为空"  userInfo:nil];
        [excp raise];
    }
    
    //1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2、创建设备输入流
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //3、创建数据输出流
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //3(1)、创建设备输出流
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）; 如需限制扫描范围，打开下一句注释代码并进行相应调试
    //    metadataOutput.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    //4、创建会话对象
    _session = [[AVCaptureSession alloc] init];
    //会话采集率：AVCaptureSessionPresetHigh
    _session.sessionPreset = sessionPreset;
    
    //5、添加设备输出流到会话对象
    [_session addOutput:metadataOutput];
    //5(1)添加设备输出流到会话对象；与3(1)构成识别光纤强弱
    [_session addOutput:_videoDataOutput];
    
    //6、添加设备输入流到会话对象
    [_session addInput:deviceInput];
    
    //7、设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    // @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
    metadataOutput.metadataObjectTypes = metadataObjectTypes;
    
    //8、实例化预览图层，传递_session是为了告诉图层将来显示什么内容
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    //保持纵横比；填充层边界
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    _videoPreviewLayer.frame = CGRectMake(x, y, w, h);
    [currentController.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    
    //9、启动会话
    [_session startRunning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.scanBlock) {
        self.scanBlock(metadataObjects);
    }
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f",brightnessValue);
    if (self.brightnessBlock) {
        self.brightnessBlock(brightnessValue);
    }
}

- (void)brightnessChange:(GetBrightnessBlock)getBrightnessBlock {
    _brightnessBlock = getBrightnessBlock;
}

- (void)scanResult:(ScanBlock)scanBlock {
    _scanBlock = scanBlock;
}

- (void)startRunning {
    [_session startRunning];
}

- (void)stopRunning {
    [_session stopRunning];
}

- (void)videoPreviewLayerRemoveFromSuperlayer {
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)resetSampleBufferDelegate {
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
}

- (void)cancelSampleBufferDelegate {
    [_videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}
#pragma mark 播放扫描提示音
- (void)playSoundName:(NSString *)name {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(soundID); // 播放音效
}

void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    
}

@end
