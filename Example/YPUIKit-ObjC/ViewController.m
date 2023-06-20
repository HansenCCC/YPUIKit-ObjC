//
//  YPViewController.m
//  YPUIKit-ObjC
//
//  Created by chenghengsheng on 07/11/2022.
//  Copyright (c) 2022 chenghengsheng. All rights reserved.
//

#import "ViewController.h"
#import <YPUIKit/YPUIKit.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

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
}

- (void)didClickButton {
    YPSingleLineInputViewController *vc = [[YPSingleLineInputViewController alloc] init];
    vc.title = @"修改昵称";
    vc.text = @"程恒盛";
    vc.placeholder = @"我不知道哈哈哈哈";
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

@end
