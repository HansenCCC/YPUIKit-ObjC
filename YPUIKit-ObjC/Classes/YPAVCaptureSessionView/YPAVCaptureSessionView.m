//
//  YPAVCaptureSessionView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/6/30.
//

#import "YPAVCaptureSessionView.h"

@interface YPAVCaptureSessionView ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureOutput *output;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIView *focusView;

@end

@implementation YPAVCaptureSessionView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    //判断是否支持相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return self;
    }
    _showFocusView = YES;
    _devicePosition = AVCaptureDevicePositionBack;
    _sessionPreset = AVCaptureSessionPresetPhoto;
    //获取当前取景方向摄像头
    self.device = [self cameraWithPosition:self.devicePosition];
    //初始化输入设备
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    //初始化输出
    dispatch_queue_t outputQueue;
    outputQueue = dispatch_queue_create("WDAVCaptureSessionViewQueue", NULL);
    NSString *key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    output.alwaysDiscardsLateVideoFrames = YES;
    [output setVideoSettings:videoSettings];
    [output setSampleBufferDelegate:self queue:outputQueue];
    //
    self.output = output;
    //
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = self.sessionPreset;
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    //输入输出设备结合
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //预览层的生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.previewLayer];
    //设置闪关灯初始状态
    _flashMode = AVCaptureFlashModeAuto;
    //添加手势
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whenTapGesture:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    self.focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.focusView.layer.borderWidth = 1;
    self.focusView.layer.borderColor = [UIColor redColor].CGColor;
    [self addSubview:self.focusView];
    self.focusView.hidden = YES;
    return self;
}

-(void)whenTapGesture:(UITapGestureRecognizer *)tap {
    [self focusAtPoint:[tap locationInView:tap.view]];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //此方法iOS 10 之后已经弃用 "Use AVCaptureDeviceDiscoverySession instead."
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
#pragma clang diagnostic pop
    for ( AVCaptureDevice *device in devices ){
        if ( device.position == position ){
            return device;
        }
    }
    return nil;
}

- (void)startRunning {
    [self.session startRunning];
}

- (void)stopRunning {
    [self.session stopRunning];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.previewLayer.frame = bounds;
}

#pragma mark - setters

- (void)setDevicePosition:(AVCaptureDevicePosition)devicePosition {
    _devicePosition = devicePosition;
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    newCamera = [self cameraWithPosition:devicePosition];
    //生成新的输入
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newInput != nil) {
        [self.session beginConfiguration];
        [self.session removeInput:self.input];
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
        } else {
            [self.session addInput:self.input];
        }
        [self.session commitConfiguration];
    }
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    _flashMode = flashMode;
    if ([_device lockForConfiguration:nil]) {
        // 自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

- (void)setSessionPreset:(AVCaptureSessionPreset)sessionPreset {
    _sessionPreset = sessionPreset;
    if ([self.device lockForConfiguration:nil]) {
        //设置图片品质
        self.session.sessionPreset = sessionPreset;
        [self.device unlockForConfiguration];
    }
}

#pragma mark - Focus

- (void)focusAtPoint:(CGPoint)point {
    if (!self.showFocusView) {
        return;
    }
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    
    CGSize size = self.bounds.size;
    CGPoint focusPoint = CGPointMake(point.y/size.height, 1 - point.x / size.width);
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        /// 对焦模式和对焦点
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        /// 曝光模式和曝光点
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        /// 设置对焦动画
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self performSelector:@selector(__hiddenFocusView) withObject:nil afterDelay:1];
            }];
        }];
    }
}

- (void)__hiddenFocusView {
    self.focusView.hidden = YES;
}

@end
