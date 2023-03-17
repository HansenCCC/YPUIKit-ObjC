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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    YPFileBrowser *fileBrowser = [[YPFileBrowser alloc] initWithPath:NSHomeDirectory()];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fileBrowser];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
