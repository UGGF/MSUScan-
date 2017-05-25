//
//  MSUScanController.m
//  秀贝
//
//  Created by Zhuge_Su on 2017/5/24.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "MSUScanController.h"
#import "MSUPrefixHeader.pch"
#import "MSUHomeNavView.h"
#import "MSUScanView.h"
#import "UIImage+MSUDecoder.h"

/// 工具类
#import "MSUPermissionTool.h"
#import "MSUHUD.h"

@interface MSUScanController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/// 二维码扫描相关
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * previewLayer;

/*** 专门用于保存描边的图层 ***/
@property (nonatomic,strong) MSUScanView *scanView;

@end

@implementation MSUScanController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = NavColor;
    
    // 导航栏
    [self createNavView];
    // 中部视图
    [self.view addSubview:self.scanningView];
    [self setupMSUCodeScanning];
    
    //代码封装抽离用 , 将扫描方法和扫描结果两块处理逻辑分开 此处为接收扫描结果并进行处理
    // 注册观察者
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSUCodeResultFromeAibum:) name:@"MSUCodeResultFromeAibum" object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MSUCodeResultFromeScanning:) name:@"MSUCodeResultFromeScanning" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

- (void)dealloc {
    NSLog(@"dealloc");
    [self removeScanningView];
}

- (MSUScanView *)scanningView {
    if (!_scanView) {
        _scanView = [MSUScanView scanningViewWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) layer:self.view.layer];
    }
    return _scanView;
}

#pragma mark - 视图相关
/// 导航栏视图
- (void)createNavView{
    MSUHomeNavView *nav = [[MSUHomeNavView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44) showNavWithNumber:1];
    [self.view addSubview:nav];
    [nav.arrowBtn addTarget:self action:@selector(arrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav.photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setupMSUCodeScanning {
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
    output.rectOfInterest = CGRectMake(-0.2, 0.2, 0.7, 0.6);
//    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 添加会话输入
    [_session addInput:input];
    
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    // 8、将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、启动会话
    [_session startRunning];
}

#pragma mark - 点击事件
// 返回按钮点击
- (void)arrowBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// 相册按钮点击
- (void)photoBtnClick:(UIButton *)sender{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        [MSUPermissionTool getPhotosPermission:^(NSInteger authStatus) {
            if (authStatus == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
                    imagePicker.delegate = self;
                    [self presentViewController:imagePicker animated:YES completion:^{
                        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                    }];
                });

            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 照片 - 秀贝] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //确定按钮点击事件处理
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
    //内存相关
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 栅栏函数
    dispatch_barrier_async(queue, ^{
        [self removeScanningView];
    });
     */
    
}

//移除扫描视图
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanView = nil;
}

#pragma mark - 代理事件
 #pragma mark -- 二维码代理（AVCaptureMetadataOutputObjectsDelegate）
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 扫描成功之后的提示音
   [self MN_playSoundEffect:@"sound.caf"];

    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        //代码封装抽离用 , 将扫描方法和扫描结果两块处理逻辑分开 此处为发送扫描结果
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"MSUCodeResultFromeScanning" object:metadataObject.stringValue];

        if ([stringValue hasPrefix:@"http"]) {// 扫描结果为二维码
            NSLog(@"二维码%@",stringValue);
            
        } else { // 扫描结果为条形码
            NSLog(@"条形码%@",stringValue);

        }
    }
}

//代码封装抽离用 , 将扫描方法和扫描结果两块处理逻辑分开 此处为接收扫描结果并进行处理
/*
- (void)MSUCodeResultFromeAibum:(NSNotification *)noti{
    NSLog(@"noti -- %@",noti.object);
    NSString *stringValue = noti.object;
    
    if ([stringValue hasPrefix:@"http"]) {// 扫描结果为二维码
        NSLog(@"二维码%@",stringValue);
        
    } else { // 扫描结果为条形码
        NSLog(@"条形码%@",stringValue);
        
    }
}
 */


/** 播放音效文件 */
- (void)MN_playSoundEffect:(NSString *)name {
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/** 播放完成回调函数 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //NSLog(@"播放完成...");
}

 #pragma mark -- 相册代理（UIImagePickerControllerDelegate）
/** 相册选择 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.view addSubview:self.scanningView];
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanMSUResultromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

/** 相册取消 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.view addSubview:self.scanningView];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

/** 播放完成回调函数 */
- (void)scanMSUResultromPhotosInTheAlbum:(UIImage *)image{
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    image = [UIImage imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *stringValue = feature.messageString;
        NSLog(@"scannedResult - - %@", stringValue);
        
        //代码封装抽离用 , 将扫描方法和扫描结果两块处理逻辑分开 此处为发送扫描结果
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"MSUCodeResultFromeAibum" object:scannedResult];
        
        // 处理相关逻辑地方
        
    }

}

@end
