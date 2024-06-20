//
//  HLWebView.m
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import "HLWebView.h"
#import "HLWeakScriptMessageDelegate.h"
#import "HLWebKitTool.h"

@interface HLWebView()
@property (nonatomic, strong) NSMutableArray *jsToNativeMethodNames;
@property (nonatomic, assign) BOOL isOpenLog;
@end

@implementation HLWebView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super initWithFrame:frame configuration:configuration]) {
        _isOpenLog = YES;
        _timeoutInternal = 30;
        self.navigationDelegate = self;
    }
    return self;
}

- (void)dealloc {
    [self removeAllScriptMessageHandler];
}

#pragma mark - Private Mehtod

- (void)removeAllScriptMessageHandler
{
    if (self.jsToNativeMethodNames.count == 0) {
        return;
    }
    for (NSString *name in self.jsToNativeMethodNames) {
        [self removeScriptMessageHandlerForName:name];
    }
}

#pragma mark - Public Method

/**
 * 开启日志打印 (Debug级别)，默认YES
 */
- (void)openLog:(BOOL)isOpenLog
{
    _isOpenLog = isOpenLog;
}

#pragma mark - Load Method

/**
 * 加载url字符串
 * @param urlString url字符串
 */
- (void)loadWithURLString:(NSString *)urlString
{
    NSURL *URL = [NSURL URLWithString:urlString];
    [self loadWithURL:URL];
}

/**
 * 加载URL
 * @param URL URL地址
 */
- (void)loadWithURL:(NSURL*)URL
{
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

/**
 * 加载本地html文件
 * @param fileName 文件名
 */
- (void)loadWithFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    [self loadHTMLString:htmlString baseURL:baseURL];
}

#pragma mark - JS Handler Method

/**
 * 添加JS调原生交互
 * @param name JS调原生方法名
 */
- (void)addScriptMessageHandler:(NSString *)name
{
    //解决WKWebView与JS交互造成循环引用的问题
    HLWeakScriptMessageDelegate *weakScriptMessageDelegate = [[HLWeakScriptMessageDelegate alloc] initWithDelegate:self];
    [self.configuration.userContentController addScriptMessageHandler:weakScriptMessageDelegate name:name];
    [self.jsToNativeMethodNames addObject:name];
}

/**
 * 移除JS调原生交互
 * @param name JS调原生方法名
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name
{
    [self.configuration.userContentController removeScriptMessageHandlerForName:name];
    [self.jsToNativeMethodNames removeObject:name];
}

/**
 * 调JS方法
 * @param name JS方法名
 * @param paramsString 参数字符串（一般为JSON字符串）
 * @param completionHandler 回调
 */
- (void)evaluateJavaScript:(NSString *)name
              paramsString:(NSString *)paramsString
         completionHandler:(void (^)(id response, NSError *error))completionHandler
{
    if (self.isOpenLog) {
        HLWebKitLog(@"<----- HLWebView native to js ----->\n name：%@\n params：%@", name, paramsString);
    }
    NSString *script = [NSString stringWithFormat:@"%@('%@')", name, paramsString];
    script = [[script stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:script completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (weakSelf.isOpenLog) {
            HLWebKitLog(@"<----- HLWebView native to js callback ----->\n name：%@\n response：%@\n error：%@", name, response, error);
        }
        if (completionHandler) {
            completionHandler(response, error);
        }
    }];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (self.isOpenLog) {
        HLWebKitLog(@"<----- HLWebView js to native ----->\n name：%@\n body：\n%@", message.name, message.body);
    }
    if (![self.jsToNativeMethodNames containsObject:message.name]) {
        return;
    }
    if ([self.hlDelegate respondsToSelector:@selector(webView:didReceiveScriptMessageBody:name:)]) {
        [self.hlDelegate webView:self didReceiveScriptMessageBody:message.body name:message.name];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme         = [request.URL scheme];
    // decode for all URL to avoid url contains some special character so that it wasn't load.
    NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if (self.isOpenLog) {
        HLWebKitLog(@"HLWebView currentURL：%@", absoluteString);
    }
    
    static NSString *endPayRedirectURL = nil;
    
    NSString *a1 = [HLWebKitTool base64Decoded:@"YWxpcGF5czovLw=="];
    NSString *a2 = [HLWebKitTool base64Decoded:@"YWxpcGF5Oi8v"];
    NSString *a3 = [HLWebKitTool base64Decoded:@"YWxpcGF5Oi8vYWxpcGF5Y2xpZW50Lz8="];
    NSString *a4 = [HLWebKitTool base64Decoded:@"aHR0cHM6Ly93eC50ZW5wYXkuY29tL2NnaS1iaW4vbW1wYXl3ZWItYmluL2NoZWNrbXdlYg=="];
    NSString *a6 = [HLWebKitTool base64Decoded:@"d2VpeGlu"];
    NSString *a7 = [HLWebKitTool base64Decoded:@"d2VpeGluOi8v"];
    NSString *a8 = [HLWebKitTool base64Decoded:@"YWxpcGF5cw=="];
    
    // 解决跳转到本地某宝App不返回的问题
    if ([absoluteString hasPrefix:a1] || [absoluteString hasPrefix:a2])
    {
        NSURL *openedURL = navigationAction.request.URL;
        
        NSString *prefixString = a3;
        //替换里面的默认Scheme为自己的Scheme
        NSString *urlString = [[HLWebKitTool urlDecoded:absoluteString] stringByReplacingOccurrencesOfString:a8 withString:[NSString stringWithFormat:@"%@", self.zfbAppUrlScheme]];
        
        if ([urlString hasPrefix:prefixString]) {
            NSRange rang = [urlString rangeOfString:prefixString];
            NSString *subString = [urlString substringFromIndex:rang.length];
            NSString *encodedString = [prefixString stringByAppendingString:[HLWebKitTool urlEncoded:subString]];
            openedURL = [NSURL URLWithString:encodedString];
        }
        
        BOOL success = [[UIApplication sharedApplication] canOpenURL:openedURL];
        if (!success) {
            if (self.isOpenLog) {
                HLWebKitLog(@"HLWebView 未安装某宝");
            }
            if ([self.hlDelegate respondsToSelector:@selector(webViewUninstalledZFBApp)]) {
                [self.hlDelegate webViewUninstalledZFBApp];
            }
        } else {
            [HLWebKitTool openURL:openedURL];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //解决某信zf后为返回当前应用的问题
    if ([absoluteString hasPrefix:a4] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@://%@", self.wxReferer, endPayRedirectURL]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        // 1. If the url contain "redirect_url" : We need to remember it to use our scheme replace it.
        // 2. If the url not contain "redirect_url" , We should add it so that we will could jump to our app.
        //  Note : 2. if the redirect_url is not last string, you should use correct strategy, because the redirect_url's value may contain some "&" special character so that my cut method may be incorrect.
        NSString *redirectUrl = nil;
        if ([absoluteString containsString:@"redirect_url="]) {
            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
            endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@://%@", self.wxReferer, endPayRedirectURL]];
        }else {
            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@://", self.wxReferer]];
        }
        
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInternal];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        [newRequest setValue:[NSString stringWithFormat:@"%@", self.wxReferer] forHTTPHeaderField:@"Referer"];
        newRequest.URL = [NSURL URLWithString:redirectUrl];
        [webView loadRequest:newRequest];
        return;
    }
    
    if ([absoluteString isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // Judge is whether to jump to other app.
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([scheme isEqualToString:a6]) {
            if (endPayRedirectURL) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPayRedirectURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInternal]];
            }
        }
        
        if ([navigationAction.request.URL.absoluteString hasPrefix:a7]) {
            [HLWebKitTool openURL:navigationAction.request.URL];
        }
        return;
    }
  
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark - Getter

- (NSMutableArray *)jsToNativeMethodNames {
    if (!_jsToNativeMethodNames) {
        _jsToNativeMethodNames = [NSMutableArray new];
    }
    return _jsToNativeMethodNames;
}


@end
