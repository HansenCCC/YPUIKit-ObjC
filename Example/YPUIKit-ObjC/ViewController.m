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
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    self.button.frame = CGRectMake(100, 100, 100, 100);
    self.button.backgroundColor = [UIColor redColor];
}

- (void)didClickButton {
    NSArray *colors = [UIColor yp_allColors];
    YPDatePickerAlert *picker = [YPDatePickerAlert popupWithDate:[NSDate date] completeBlock:^(NSDate * _Nonnull date) {
        
    }];
    [self presentViewController:picker animated:YES completion:nil];
    
}

@end
