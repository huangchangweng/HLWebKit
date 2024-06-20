//
//  TestWebViewController.m
//  HLWebKit_Example
//
//  Created by 黄常翁 on 2024/6/20.
//  Copyright © 2024 huangchangweng. All rights reserved.
//

#import "TestWebViewController.h"

@interface TestWebViewController ()<HLWebViewDelegate>

@end

@implementation TestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configurationUI];
    [self configurationParams];
}

#pragma mark - Private Method

/// 配置UI
- (void)configurationUI
{
    // 显示关闭按钮
    self.showCloseButton = YES;
    // 设置返回按钮图标
//    [self.backButton setImage:[UIImage imageNamed:@""] forState:0];
    // 设置关闭按钮图标
//    [self.closeButton setImage:[UIImage imageNamed:@""] forState:0];
    // 返回、关闭按钮样式，默认0（如果你项目中导航栏是浅色就设置为0，反之设置为1）
    self.buttonStyle = 0;
    // 设置进度条颜色
    self.progressTintColor = [UIColor redColor];
}

/// 配置自己项目规定的参数
- (void)configurationParams
{
    self.webView.hlDelegate = self;
    
    // 开启日志打印
    [self.webView openLog:YES];
    
    // JS交互相关
    [self.webView addScriptMessageHandler:@"jsToNative"];
    
    // H5支付相关
    self.webView.wxReferer = @"www.xxx.com";
    self.webView.zfbAppUrlScheme = @"www.xxx.com";
}

/// 调JS方法
- (void)sendMessageToJS
{
    [self.webView evaluateJavaScript:@"nativeToJs" 
                        paramsString:@"{\"userId\":\"1\"}"
                   completionHandler:^(id  _Nonnull response, NSError * _Nonnull error) {
        // 注意这里需要weakSelf
    }];
}

#pragma mark - HLWebViewDelegate

/**
 * 收到JS调原生
 * @param mssageBody WKScriptMessage的body
 * @param name JS调原生方法名
 */
- (void)webView:(HLWebView *)webView didReceiveScriptMessageBody:(id)mssageBody name:(NSString *)name
{
    // 根据自己的业务处理
}

/**
 * 未安装某宝
 */
- (void)webViewUninstalledZFBApp
{
    // 可以提示用户
}

@end
