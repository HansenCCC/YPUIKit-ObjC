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

@end

@implementation ViewController

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
    
    [self.view addSubview:self.swiperView];
    self.swiperView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 150.f);
    [self.swiperView reloadData];
}

- (void)didClickButton {
    YPMultiLineInputViewController *vc = [[YPMultiLineInputViewController alloc] init];
    vc.title = @"修改昵称";
    vc.text = @"程恒盛";
    vc.placeholder = @"我不知道哈哈哈哈";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSArray *colors = [UIColor yp_allColors];
//    YPDatePickerAlert *picker = [YPDatePickerAlert popupWithDate:[NSDate date] completeBlock:^(NSDate * _Nonnull date) {
//
//    }];
//    picker.datePickerMode = UIDatePickerModeTime;
//    [self presentViewController:picker animated:NO completion:nil];
    
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
