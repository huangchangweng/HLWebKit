//
//  HLWebViewController.m
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import "HLWebViewController.h"
#import "HLWebKitTool.h"

@interface HLWebViewController ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *URL;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation HLWebViewController

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    // Set up default values.
    _progressTintColor = [UIColor blueColor];
    _timeoutInternal = 30.0;
    _showCloseButton = NO;
    _buttonStyle = 0;
}

/**
 * 初始化加载url字符串
 * @param urlString url字符串
 */
- (instancetype)initWithURLString:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

/**
 * 初始化加载URL
 * @param URL URL地址
 */
- (instancetype)initWithURL:(NSURL*)URL
{
    if(self = [self init]) {
        _URL = URL;
    }
    return self;
}

/**
 * 初始化加载URL
 * @param URL URL地址
 * @param configuration WKWebViewConfiguration
 */
- (instancetype)initWithURL:(NSURL *)URL
              configuration:(WKWebViewConfiguration *)configuration
{
    if (self = [self initWithURL:URL]) {
        _configuration = configuration;
    }
    return self;
}

/**
 * 初始化加载本地html文件
 * @param fileName 文件名
 */
- (instancetype)initWithFileName:(NSString *)fileName
{
    if(self = [self init]) {
        _fileName = fileName;
    }
    return self;
}

/**
 * 初始化加载url字符串
 * @param htmlString html字符串
 */
- (instancetype)initWithHtmlString:(NSString *)htmlString
                           baseURL:(NSURL *)baseURL
{
    if(self = [self init]) {
        _htmlString = htmlString;
        _baseURL = baseURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupData];
    [self setupButtonStyle];
    [self addObserver];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
}

- (void)dealloc {
    [self removeObserver];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    } else if([keyPath isEqualToString:@"title"]
             && object == self.webView){
        self.title = self.title ? : change[@"new"];
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - Private Method

- (void)setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.timeoutInternal = self.timeoutInternal;
    self.progressView.progressTintColor = self.progressTintColor;
    self.closeButton.hidden = !self.showCloseButton;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.backButton], 
                                               [[UIBarButtonItem alloc] initWithCustomView:self.closeButton]];
}

- (void)setupData
{
    if (self.URL) {
        [self loadURL:self.URL];
    } else if (self.htmlString) {
        [self loadHtmlString:self.htmlString baseURL:self.baseURL];
    } else if (self.fileName) {
        [self loadWithFileName:self.fileName];
    }
}

- (void)setupButtonStyle
{
    if (self.buttonStyle == 0) {
        [self.backButton setImage:[HLWebKitTool imageNamed:@"back_black"]  forState:0];
        [self.closeButton setImage:[HLWebKitTool imageNamed:@"close_black"]  forState:0];
    } else {
        [self.backButton setImage:[HLWebKitTool imageNamed:@"back_white"]  forState:0];
        [self.closeButton setImage:[HLWebKitTool imageNamed:@"close_white"]  forState:0];
    }
}

/// 添加观察者
- (void)addObserver
{
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(title))
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

/// 移除观察者
- (void)removeObserver
{
    [self.webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}

#pragma mark - Public Method

/**
 * 加载url字符串
 * @param urlString url字符串
 */
- (void)loadURLString:(NSString *)urlString
{
    [self loadURL:[NSURL URLWithString:urlString]];
}

/**
 * 加载URL
 * @param URL URL地址
 */
- (void)loadURL:(NSURL*)URL
{
    [self.webView loadWithURL:URL];
}

/**
 * 加载url字符串
 * @param htmlString html字符串
 */
- (void)loadHtmlString:(NSString *)htmlString
               baseURL:(NSURL *)baseURL
{
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

/**
 * 加载本地html文件
 * @param fileName 文件名
 */
- (void)loadWithFileName:(NSString *)fileName
{
    [self.webView loadWithFileName:fileName];
}

#pragma mark - Response Event

- (void)backAction:(UIButton *)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter & Setter

- (WKWebView *)webView {
    if (_webView) return _webView;
    WKWebViewConfiguration *config = _configuration;
    if (!config) {
        config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 9.0;
        if ([config respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
            [config setAllowsInlineMediaPlayback:YES];
        }
        if (@available(iOS 9.0, *)) {
            if ([config respondsToSelector:@selector(setApplicationNameForUserAgent:)]) {
                [config setApplicationNameForUserAgent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
            }
        }
        
        if (@available(iOS 10.0, *)) {
            if ([config respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]){
                [config setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
            }
        }
    }
    _webView = [[HLWebView alloc] initWithFrame:CGRectZero configuration:config];
    _webView.allowsBackForwardNavigationGestures = YES;
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView) return _progressView;
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressView.trackTintColor = [UIColor clearColor];
    return _progressView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, 44, 44);
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    if (_progressTintColor != progressTintColor) {
        _progressTintColor = progressTintColor;
        _progressView.progressTintColor = _progressTintColor;
    }
}

- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;
    _closeButton.hidden = !_showCloseButton;
}

- (void)setButtonStyle:(NSInteger)buttonStyle {
    _buttonStyle = buttonStyle;
    [self setupButtonStyle];
}

@end
