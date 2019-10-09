//
//  ZFWKWebVC.m
//  ZFWKWebView
//
//  Created by 张帆 on 2019/9/19.
//  Copyright © 2019 张帆. All rights reserved.
//

#import "ZFWKWebVC.h"

#define ZF_WK_BACKGROUD_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]
#define ZF_WK_BLACKCLOLR [UIColor colorWithRed:19/255.0 green:19/255.0 blue:54/255.0 alpha:1.0]
#define ZF_WK_LINE_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]
#define ZF_WK_GARY_TEXT_COLOR [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0]

#define ZF_SCREEN_WIDTH self.view.frame.size.width
#define ZF_SCREEN_HEIGHT self.view.frame.size.height

static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) return iPhoneXSeries;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) iPhoneXSeries = YES;
    }
    return iPhoneXSeries;
}

@interface ZFWKWebVCLoadFailedView ()
@property (nonatomic, strong) UIButton *hoverButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextView *textLabel;
@end
@implementation ZFWKWebVCLoadFailedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        [self addSubview:self.imageView];
        
        self.textLabel = ({
            UITextView *label = [[UITextView alloc] init];
            label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.userInteractionEnabled = NO;
            label.textColor = ZF_WK_GARY_TEXT_COLOR;
            label;
        });
        [self addSubview:self.textLabel];
        
        self.hoverButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            button;
        });
        [self addSubview:self.hoverButton];
        
        self.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.hoverButton setFrame:self.bounds];
    [self.imageView setFrame:CGRectMake(0, 0, 44, 44)];
    [self.imageView setCenter:CGPointMake(self.center.x, self.center.y  - 22 - 200)];
    [self.textLabel setFrame:CGRectMake(20, self.center.y - 200 + 10, self.frame.size.width - 40, 300)];
}
@end

@interface ZFWKWebVCBottomBar ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@end
@implementation ZFWKWebVCBottomBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:ZF_WK_LINE_COLOR];
        
        self.backButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.enabled = NO;
            button;
        });
        [self addSubview:self.backButton];
        float margin = 80;
        float btnW = 44;
        float centerX = frame.size.width * .5;
        [self.backButton setFrame:CGRectMake(centerX - margin, 0, btnW, btnW)];

        self.forwardButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.enabled = NO;
            button;
        });
        [self addSubview:self.forwardButton];
        [self.forwardButton setFrame:CGRectMake(centerX + margin - btnW, 0, btnW, btnW)];

    }
    return self;
}
@end

@interface ZFWKWebVCConf ()
@property(nonatomic, assign) BOOL canGoBack;
@property(nonatomic, assign) BOOL canGoForward;
@property (nonatomic, strong) NSMutableDictionary *callbacks;

@end

@implementation ZFWKWebVCConf
- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeoutDuration = 15;
        _progressTintColor = [UIColor colorWithRed:86/255.0 green:187/255.0 blue:59/255.0 alpha:1];
        _progressBackgroundColor = [UIColor clearColor];
        _showBottomBar = YES;
        _callbacks = [NSMutableDictionary dictionaryWithCapacity:100];
        _progressBarHeight = 2.5;
        
        NSBundle *bundle = [NSBundle bundleForClass:[ZFWKWebVC class]];
        NSURL *url = [bundle URLForResource:@"ImageResource" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        _closeButtonImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"CloseButtonIcon@2x" ofType:@"png"]];
        _goBackButtonNomalImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"BackButtonIcon@2x" ofType:@"png"]];
        _goBackButtonDisableImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"BackButtonIconUnable@2x" ofType:@"png"]];
        _goForwardButtonNomalImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"ForwardButtonIcon@2x" ofType:@"png"]];
        _goForwardButtonDisableImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"ForwardButtonIconUnable@2x" ofType:@"png"]];
        _refreshButtonImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"refresh@2x" ofType:@"png"]];
        
        
//        _closeButtonImage = [UIImage imageNamed:@"CloseButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
//        _goBackButtonNomalImage = [UIImage imageNamed:@"BackButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
//        _goBackButtonDisableImage =[UIImage imageNamed:@"BackButtonIconUnable" inBundle:imageBundle compatibleWithTraitCollection:nil];
//        _goForwardButtonNomalImage = [UIImage imageNamed:@"ForwardButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
//        _goForwardButtonDisableImage = [UIImage imageNamed:@"ForwardButtonIconUnable" inBundle:imageBundle compatibleWithTraitCollection:nil];
//        _refreshButtonImage = [UIImage imageNamed:@"refresh" inBundle:imageBundle compatibleWithTraitCollection:nil];
        
        _titleColor = ZF_WK_BLACKCLOLR;
        _titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    }
    return self;
}
- (void)addMethodName:(NSString *)name callback:(jsBrigeCallBack)callback {
    if (callback) self.callbacks[name] = callback;
}

@end

@interface ZFWKWebVC () <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate> {
    float lastPostion;
    int scrollJudgeDistance;
}

@property (nonatomic, strong) ZFWKWebVCConf *conf;

@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *originLabel;
@property (nonatomic, strong) ZFWKWebVCLoadFailedView *loadFailedView;
@end

@implementation ZFWKWebVC

- (void)dealloc {
    NSLog(@"%s", __func__);
    if (self.titleLabel) {
        
        [self.webView removeObserver:self forKeyPath:@"title" context:@"ZFContext"];
        [self.webView removeObserver:self forKeyPath:@"canGoBack" context:@"ZFContext"];
        [self.webView removeObserver:self forKeyPath:@"canGoForward" context:@"ZFContext"];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:@"ZFContext"];
        [self.webView removeObserver:self forKeyPath:@"URL" context:@"ZFContext"];
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset" context:@"ZFContext"];
    }
    
}
- (instancetype)initWithDefaultConfig {
    ZFWKWebVCConf *conf = [[ZFWKWebVCConf alloc] init];
    return [self initWithConf:conf];
}
- (instancetype)initWithConf:(ZFWKWebVCConf *)conf {
    self = [super init];
    if (self) {
        _conf = conf;
        lastPostion = 0;
        scrollJudgeDistance = 100;
        self.webView = ({
            WKWebViewConfiguration *webViewConf = [[WKWebViewConfiguration alloc] init];
            WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConf];
            webView.navigationDelegate = self;
            webView.UIDelegate = self;
            webView.scrollView.backgroundColor = ZF_WK_BACKGROUD_COLOR;
            webView.backgroundColor = ZF_WK_BACKGROUD_COLOR;
            webView.opaque = NO;
            webView;
        });
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (NSString *methodName in self.conf.callbacks.allKeys) {
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:methodName];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (NSString *name in self.conf.callbacks.allKeys) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
    [self.conf.callbacks removeAllObjects];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.conf = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.navigationBar) self.navigationController.navigationBar.hidden = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *navView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:ZF_WK_BACKGROUD_COLOR];
        self.closeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:self.conf.closeButtonImage forState:UIControlStateNormal];
            [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [view addSubview:self.closeButton];
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [label setTextColor:self.conf.titleColor];
            [label setFont:self.conf.titleFont];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        [view addSubview:self.titleLabel];
        self.progressView = ({
            UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            [progressView setProgressTintColor:self.conf.progressTintColor];
            [progressView setTrackTintColor:self.conf.progressBackgroundColor];
            progressView;
        });
        [view addSubview:self.progressView];
        view;
    });
    
    self.navView = navView;
    [self.view addSubview:navView];
    [self.view addSubview:self.webView];
    
    self.originLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.webView insertSubview:self.originLabel belowSubview:self.webView.scrollView];
    
    if (self.conf.showBottomBar) {
        self.bottomBar = ({
            ZFWKWebVCBottomBar *bar = [[ZFWKWebVCBottomBar alloc] initWithFrame:CGRectMake(0, ZF_SCREEN_HEIGHT, ZF_SCREEN_WIDTH, 44)];
            [bar.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            [bar.backButton setImage:self.conf.goBackButtonNomalImage forState:UIControlStateNormal];
            [bar.backButton setImage:self.conf.goBackButtonDisableImage forState:UIControlStateDisabled];
            [bar.forwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
            [bar.forwardButton setImage:self.conf.goForwardButtonNomalImage forState:UIControlStateNormal];
            [bar.forwardButton setImage:self.conf.goForwardButtonDisableImage forState:UIControlStateDisabled];
            bar;
        });
        [self.view addSubview:self.bottomBar];
    }
    
    if (self.conf.openUrl) {
        NSString *urlStr = [self.conf.openUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.conf.timeoutDuration];
        [self.webView loadRequest:req];
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 12.0) {
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    if (@available(iOS 12.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:@"ZFContext"];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:@"ZFContext"];
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:@"ZFContext"];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:@"ZFContext"];
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:@"ZFContext"];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"ZFContext"];
 
    self.loadFailedView = [[ZFWKWebVCLoadFailedView alloc] initWithFrame:CGRectZero];
    self.loadFailedView.imageView.image = self.conf.refreshButtonImage;
    [self.loadFailedView.hoverButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadFailedView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"]) {
        self.titleLabel.text = change[NSKeyValueChangeNewKey];
    }
    else if ([keyPath isEqualToString:@"canGoBack"]) {
        BOOL canGoBack =  [change[NSKeyValueChangeNewKey] boolValue];
        self.conf.canGoBack = canGoBack;
        self.bottomBar.backButton.enabled = canGoBack;
    }
    else if ([keyPath isEqualToString:@"canGoForward"]) {
        BOOL canGoForward =  [change[NSKeyValueChangeNewKey] boolValue];
        self.conf.canGoForward = canGoForward;
        self.bottomBar.forwardButton.enabled = canGoForward;
    }
    else if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        float currentPostion = offset.y;
        if (currentPostion < -40) {
            self.originLabel.alpha = fabsf(currentPostion + 40) / 40;
        }
        BOOL canGoBool = self.conf.canGoForward || self.conf.canGoBack;
        if (currentPostion - lastPostion > scrollJudgeDistance)  {
            lastPostion = currentPostion;
            [self bottomBarHidden:YES];
        }
        else if ((lastPostion - currentPostion > scrollJudgeDistance) && canGoBool) {
            lastPostion = currentPostion;
            [self bottomBarHidden:NO];
        }
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = [change[NSKeyValueChangeNewKey] doubleValue];
        self.progressView.hidden = progress >= 1.0;
        self.progressView.progress = progress;
    }
    else if ([keyPath isEqualToString:@"URL"]) {
        NSURL *url = change[NSKeyValueChangeNewKey];
        if (url && ![url isKindOfClass:[NSNull class]]) self.originLabel.text = [NSString stringWithFormat:@"此网页由%@提供", url.host];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    float y = 0;
    float navHeight = 64;
    if (isIPhoneXSeries()) {
        navHeight += 22;
    }
    
    [self.navView setFrame:CGRectMake(0, 0, ZF_SCREEN_WIDTH, navHeight)];
    {
        float btnW = 44;
        float nomalMargin = 10;
        [self.closeButton setFrame:CGRectMake(nomalMargin, navHeight - btnW, btnW, btnW)];
        float titleLabelWidth = 300;
        [self.titleLabel setFrame:CGRectMake((ZF_SCREEN_WIDTH - titleLabelWidth) * 0.5, navHeight - btnW, titleLabelWidth, btnW)];
        [self.progressView setFrame:CGRectMake(0, navHeight - self.conf.progressBarHeight, ZF_SCREEN_WIDTH, self.conf.progressBarHeight)];
    }
    y += navHeight;
    [self.webView setFrame:CGRectMake(0, y, ZF_SCREEN_WIDTH, ZF_SCREEN_HEIGHT - y)];
    [self.originLabel setFrame:CGRectMake(10, 30, ZF_SCREEN_WIDTH - 20, 35)];
    [self.loadFailedView setFrame:CGRectMake(0, y, ZF_SCREEN_WIDTH, ZF_SCREEN_HEIGHT - y)];
}

- (void)bottomBarHidden:(BOOL)flag {
    float barH = 44;
    if (isIPhoneXSeries()) {
        if (@available(iOS 11.0, *)) {
            float safeMargin = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
            barH += safeMargin;
        }
    }
    float y = flag? ZF_SCREEN_HEIGHT: ZF_SCREEN_HEIGHT - barH;
    [UIView animateWithDuration:.3 animations:^{
        [self.bottomBar setFrame:CGRectMake(0, y, ZF_SCREEN_WIDTH, barH)];
    }];
}
- (void)refresh {
    NSLog(@"%s", __func__);
    [self.webView stopLoading];
//    self.loadFailedView.hidden = YES;
    [self.webView reload];
}
- (void)goBack {
    if ([self.webView canGoBack]) [self.webView goBack];
}

- (void)goForward {
    if ([self.webView canGoForward]) [self.webView goForward];
}

- (void)close {
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)evaluateJavaScriptMethodName:(NSString *)name params:(id _Nullable)params callback:(void (^)(id _Nullable, NSError * _Nullable))callback {
    NSString *js = [NSString stringWithFormat:@"%@()", name];
    if (params) {
        if ([NSJSONSerialization isValidJSONObject:params]) {
            NSError *err = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&err];
            if (!err) {
                NSString *paramStr = [NSString stringWithCString:data.bytes encoding:NSUTF8StringEncoding];
                js = [NSString stringWithFormat:@"%@(%@)", name, paramStr];
            } else {
                NSLog(@"%s, format params error:%@", __func__, err.localizedDescription);
            }
        } else {
            js = [NSString stringWithFormat:@"%@(%@)", name, params];
        }
    }
    [self.webView evaluateJavaScript:js completionHandler:callback];
}


- (void)removeUserScript:(NSString *)script {
    jsBrigeCallBack callback = self.conf.callbacks[script];
    if (callback) {
        [self.conf.callbacks removeObjectForKey:script];
    }
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:script];
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (self.isViewLoaded) {
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler();
    }]];
    if (self.conf) {
        [self presentViewController:alertController animated:YES completion:^{}];
    }
    else {
        completionHandler();
    }
        
}
// 页面开始加载时调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
    self.loadFailedView.hidden = YES;
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showError:error];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showError:error];
}

- (void)showError:(NSError *)error {
    if (!error) return;
    NSLog(@"%s: %@ %@ %@", __func__, error.localizedDescription, error.localizedFailureReason, error.localizedRecoverySuggestion);
        if (error.code == NSURLErrorCancelled) {
    //        return;
        }
    self.loadFailedView.hidden = NO;
    NSString *text = [NSString stringWithFormat:@"点击屏幕重试\n\n错误:%@", error.localizedDescription];
    if (error.localizedFailureReason) {
        text = [text stringByAppendingFormat:@"\n原因:%@", error.localizedFailureReason];
    }
    if (error.localizedRecoverySuggestion) {
        text = [text stringByAppendingFormat:@"\n解决:%@", error.localizedRecoverySuggestion];
    }
    self.titleLabel.text = @"无法打开此网页";
    self.loadFailedView.textLabel.text = text;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%s: %@", __func__, message.name);
    if (!message.name) return;
    jsBrigeCallBack callback = self.conf.callbacks[message.name];
    if (!callback) return;
    NSString *jsonStr = message.body;
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id tempBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    if (!err) {
        callback(self, tempBody);
    } else {
        callback(self, message.body);
    }
}

@end
