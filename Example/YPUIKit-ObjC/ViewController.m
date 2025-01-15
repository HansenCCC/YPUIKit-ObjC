//
//  YPViewController.m
//  YPUIKit-ObjC
//
//  Created by chenghengsheng on 07/11/2022.
//  Copyright (c) 2022 chenghengsheng. All rights reserved.
//

#import "ViewController.h"
#import <YPUIKit/YPUIKit.h>

@interface ViewController () <YPSwiperViewDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) YPSwiperView *swiperView;
@property (nonatomic, strong) YPRunLabel *runLabel;
@property (nonatomic, strong) YPFloatingView *floatingView;

@end

@implementation ViewController {
    CGFloat _progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"阿萨德发送到发";
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    self.button.frame = CGRectMake(100, 100, 100, 100);
    self.button.backgroundColor = [UIColor redColor];
    
//    [self.view addSubview:self.swiperView];
//    self.swiperView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 150.f);
//    [self.swiperView reloadData];
    
    self.runLabel = [[YPRunLabel alloc] init];
    self.runLabel.titleLabel.text = @"你好啊，我是程恒盛";
    CGSize f1 = [self.runLabel sizeThatFits:CGSizeZero];
    self.runLabel.frame = CGRectMake(100, 200, f1.width, f1.height);
    [self.view addSubview:self.runLabel];
    
    self.floatingView = [[YPFloatingView alloc] initWithFrame:CGRectMake(20, 100, 100.f, 100.f)];
    self.floatingView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.floatingView];
}

- (void)didClickButton {
    _progress += 0.01;
    NSString *text = [NSString stringWithFormat:@"%.2f%%", _progress * 100];
    [YPRingProgressView showProgress:_progress text:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_progress > 1) {
            [YPRingProgressView showProgress:1 text:@"下载完成"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [YPRingProgressView hideProgress];
                self->_progress = 0;
            });
        } else {
            [self didClickButton];
        }
    });
    
//    YPColorPickerViewController *vc = [YPColorPickerViewController popupPickerWithCompletion:^(UIColor *selectedColor) {
//        NSLog(@"%@",selectedColor);
//    }];
//    [[UIViewController yp_topViewController] presentViewController:vc animated:YES completion:nil];
//    [[YPAppManager shareInstance] sendFeedbackEmail];
//    [YPBadgeView showBadgeToView:self.button badgeInteger:99];
//    YPMultiLineInputViewController *vc = [[YPMultiLineInputViewController alloc] init];
//    vc.title = @"修改昵称";
//    vc.text = @"程恒盛";
//    vc.placeholder = @"我不知道哈哈哈哈";
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
////    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    YPAVCaptureSessionView *vc = [[YPAVCaptureSessionView alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    
//    NSArray *colors = [UIColor yp_allColors];
//    YPDatePickerAlert *picker = [YPDatePickerAlert popupWithDate:[NSDate date] completeBlock:^(NSDate * _Nonnull date) {
//
//    }];
//    picker.datePickerMode = UIDatePickerModeTime;
//    [self presentViewController:picker animated:YES completion:nil];
    
//    NSArray *colors = [UIColor yp_allColors];
//    YPColorPickerAlert *picker = [YPColorPickerAlert popupWithOptions:colors completeBlock:^(NSInteger index) {
//
//    }];
//    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - getters | setters

- (YPSwiperView *)swiperView {
    if (!_swiperView) {
        _swiperView = [[YPSwiperView alloc] init];
        _swiperView.delegate = self;
        _swiperView.autoplay = YES;
        _swiperView.cellClass = @[
            [UICollectionViewCell class],
        ];
    }
    return _swiperView;
}

#pragma mark - YPSwiperViewDelegate

- (UICollectionViewCell *)swiperCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (![cell viewWithTag:100]) {
        UIView *bgView = [[UIView alloc] init];
        bgView.tag = 100;
        bgView.frame = CGRectMake(10.f, 0.f, cell.frame.size.width - 20.f, cell.frame.size.height);
        [cell addSubview:bgView];
        bgView.layer.cornerRadius = 10.f;
        bgView.backgroundColor = [UIColor yp_randomColor];
    }
    return cell;
}

- (NSInteger)swiperCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

@end
