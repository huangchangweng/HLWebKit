//
//  HLWebView.h
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLWebView;
@protocol HLWebViewDelegate <NSObject>
@optional
/**
 * 收到JS调原生
 * @param mssageBody WKScriptMessage的body
 * @param name JS调原生方法名
 */
- (void)webView:(HLWebView *)webView didReceiveScriptMessageBody:(id)mssageBody name:(NSString *)name;
/**
 * 未安装某宝
 */
- (void)webViewUninstalledZFBApp;
@end

@interface HLWebView : WKWebView<WKScriptMessageHandler, WKNavigationDelegate>
@property (nonatomic, weak) id<HLWebViewDelegate> hlDelegate;
/// 超时时间，默认30s
@property(assign, nonatomic) NSTimeInterval timeoutInternal;

/**
 * 微信H5支付的 Referer -- 即完成回跳 App 的 Scheme
 * @note 这个参数必须为申请微信支付的”授权安全域名“
 * @note 在 Info.plist 中 @b 必须 设置相同的 App 回调 URL Scheme
 */
@property (nonatomic, copy) NSString *wxReferer;

/**
 * 支付宝H5支付的 AppUrlScheme -- 即完成回跳 App 的 Scheme
 * @note 在 Info.plist 中 @b 必须 设置相同的 App 回调URL Scheme
 */
@property (nonatomic, copy) NSString *zfbAppUrlScheme;

/**
 * 开启日志打印 (Debug级别)，默认YES
 */
- (void)openLog:(BOOL)isOpenLog;

#pragma mark - Load Method

/**
 * 加载url字符串
 * @param urlString url字符串
 */
- (void)loadWithURLString:(NSString *)urlString;

/**
 * 加载URL
 * @param URL URL地址
 */
- (void)loadWithURL:(NSURL*)URL;

/**
 * 加载本地html文件
 * @param fileName 文件名
 */
- (void)loadWithFileName:(NSString *)fileName;

#pragma mark - JS Handler Method

/**
 * 添加JS调原生交互
 * @param name JS调原生方法名
 */
- (void)addScriptMessageHandler:(NSString *)name;

/**
 * 移除JS调原生交互
 * @param name JS调原生方法名
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;

/**
 * 调JS方法
 * @param name JS方法名
 * @param paramsString 参数字符串（一般为JSON字符串）
 * @param completionHandler 回调
 */
- (void)evaluateJavaScript:(NSString *)name
              paramsString:(NSString *)paramsString
         completionHandler:(void (^)(id response, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
