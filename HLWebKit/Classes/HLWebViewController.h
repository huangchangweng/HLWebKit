//
//  HLWebViewController.h
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import <UIKit/UIKit.h>
#import "HLWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLWebViewController : UIViewController
@property (nonatomic, strong) HLWebView *webView;
/// 超时时间，默认30s
@property(assign, nonatomic) NSTimeInterval timeoutInternal;
/// 进度条颜色，默认[UIColor blueColor]
@property (nonatomic, strong) UIColor *progressTintColor;
/// 是否显示关闭按钮，默认NO
@property (nonatomic, assign) BOOL showCloseButton;
/// 导航栏上返回按钮，可修改UI
@property (nonatomic, strong) UIButton *backButton;
/// 导航栏上关闭按钮，可修改UI
@property (nonatomic, strong) UIButton *closeButton;
/// 返回、关闭按钮样式，默认0
/// 0黑色 1白色
@property (nonatomic, assign) NSInteger buttonStyle;

/**
 * 初始化加载url字符串
 * @param urlString url字符串
 */
- (instancetype)initWithURLString:(NSString *)urlString;

/**
 * 初始化加载URL
 * @param URL URL地址
 */
- (instancetype)initWithURL:(NSURL*)URL;

/**
 * 初始化加载URL
 * @param URL URL地址
 * @param configuration WKWebViewConfiguration
 */
- (instancetype)initWithURL:(NSURL *)URL
              configuration:(WKWebViewConfiguration *)configuration;

/**
 * 初始化加载本地html文件
 * @param fileName 文件名
 */
- (instancetype)initWithFileName:(NSString *)fileName;

/**
 * 初始化加载url字符串
 * @param htmlString html字符串
 */
- (instancetype)initWithHtmlString:(NSString *)htmlString 
                           baseURL:(NSURL *)baseURL;

/**
 * 加载url字符串
 * @param urlString url字符串
 */
- (void)loadURLString:(NSString *)urlString;

/**
 * 加载URL
 * @param URL URL地址
 */
- (void)loadURL:(NSURL*)URL;

/**
 * 加载url字符串
 * @param htmlString html字符串
 */
- (void)loadHtmlString:(NSString *)htmlString 
               baseURL:(NSURL *)baseURL;

/**
 * 加载本地html文件
 * @param fileName 文件名
 */
- (void)loadWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
