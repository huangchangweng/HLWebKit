# HLWebKit

封装iOS中WKWebView和WebViewController，用更少的代码实现一个完美的浏览器。

✅  支持JS交互

✅  支持H5支付

✅  便捷加载各种内容（NSURL、URL字符串、HTML字符串、HTML本地文件）

✅  支持自定义UI等...

##### 支持使用CocoaPods引入, Podfile文件中添加:

```objc
pod 'HLWebKit', '0.1.0'
```

# 使用

项目中使用HLWebViewController时，建议继承HLWebViewController。详情参考demo。

```objc
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
```

```objc
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
```

> 注意：如果使用H5支付需要在`TARGETS`-`Info`-`URL Types`中添加URL Schemes

```objc
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
```

# Requirements

iOS 9.0 +, Xcode 7.0 +

# Version

* 0.1.0 :

  完成HLWebKit基础搭建

# License

HLTool is available under the MIT license. See the LICENSE file for more info.
