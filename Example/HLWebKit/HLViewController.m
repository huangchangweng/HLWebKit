//
//  HLViewController.m
//  HLWebKit
//
//  Created by huangchangweng on 06/19/2024.
//  Copyright (c) 2024 huangchangweng. All rights reserved.
//

#import "HLViewController.h"
#import "TestWebViewController.h"

@interface HLViewController ()

@end

@implementation HLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Response Event

- (IBAction)jumpAction:(UIButton *)sender {
    TestWebViewController *vc = [[TestWebViewController alloc] initWithURLString:@"https://www.baidu.com"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
