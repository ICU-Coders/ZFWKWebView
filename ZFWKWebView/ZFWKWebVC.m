//
//  ZFWKWebVC.m
//  ZFWKWebView
//
//  Created by Pokey on 2019/9/19.
//  Copyright © 2019 Pokey. All rights reserved.
//

#import "ZFWKWebVC.h"

#define ZF_WK_BACKGROUD_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]
#define ZF_WK_BLACKCLOLR [UIColor colorWithRed:19/255.0 green:19/255.0 blue:54/255.0 alpha:1.0]
#define ZF_WK_LINE_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:243/255.0 alpha:1.0]
#define ZF_WK_GARY_TEXT_COLOR [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0]
#define ZF_WK_BLUE_COLOR [UIColor colorWithRed:43/255.0 green:123/255.0 blue:245/255.0 alpha:1.0]

#define ZF_SCREEN_WIDTH self.view.frame.size.width
#define ZF_SCREEN_HEIGHT self.view.frame.size.height

#define SOURCE_BUDNLE [NSBundle bundleWithURL:[[NSBundle bundleForClass:[ZFWKWebVC class]] URLForResource:@"ImageResource" withExtension:@"bundle"]?:[NSURL URLWithString:@""]]

NSString * const ZFWKWebViewEventStartLoadKey = @"ZFWKWebViewEventStartLoadKey";
NSString * const ZFWKWebViewEventStartRecevicedKey = @"ZFWKWebViewEventStartRecevicedKey";
NSString * const ZFWKWebViewEventFinishRecevicedKey = @"ZFWKWebViewEventFinishRecevicedKey";
NSString * const ZFWKWebViewEventLoadFailedKey = @"ZFWKWebViewEventLoadFailedKey";
NSString * const ZFWKWebViewEventRefreshKey = @"ZFWKWebViewEventRefreshKey";
NSString * const ZFWKWebViewEventCloseKey = @"ZFWKWebViewEventCloseKey";
NSString * const ZFWKWebViewEventRightButtonClickKey = @"ZFWKWebViewEventRightButtonClickKey";
NSString * const ZFWKWebViewEventGoBackKey = @"ZFWKWebViewEventGoBackKey";
NSString * const ZFWKWebViewEventGoForwardKey = @"ZFWKWebViewEventGoForwardKey";

NSString * const ZFWKWebViewEventViewWillAppear = @"ZFWKWebViewEventViewWillAppear";
NSString * const ZFWKWebViewEventViewWillDisappear = @"ZFWKWebViewEventViewWillDisappear";
NSString * const ZFWKWebViewEventViewDidDisappear = @"ZFWKWebViewEventViewDidDisappear";
NSString * const ZFWKWebViewEventViewDidLoad = @"ZFWKWebViewEventViewDidLoad";
NSString * const ZFWKWebViewEventViewWillLayoutSubviews = @"ZFWKWebViewEventViewWillLayoutSubviews";

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
        [self setBackgroundColor:[UIColor whiteColor]];
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
        _showBottomBar = NO;
        _closeButtonGobackFirst = YES;
        _showCloseButton = YES;
        _callbacks = [NSMutableDictionary dictionaryWithCapacity:100];
        _progressBarHeight = 2;
        _navigationButtonSpace = 0;
        
        NSBundle *imageBundle = SOURCE_BUDNLE;
        
        _backButtonImage = [UIImage imageNamed:@"BackButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
        _closeButtonImage = [UIImage imageNamed:@"CloseButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
        _goBackButtonNomalImage = [UIImage imageNamed:@"BackButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
        _goBackButtonDisableImage =[UIImage imageNamed:@"BackButtonIconUnable" inBundle:imageBundle compatibleWithTraitCollection:nil];
        _goForwardButtonNomalImage = [UIImage imageNamed:@"ForwardButtonIcon" inBundle:imageBundle compatibleWithTraitCollection:nil];
        _goForwardButtonDisableImage = [UIImage imageNamed:@"ForwardButtonIconUnable" inBundle:imageBundle compatibleWithTraitCollection:nil];
        _refreshButtonImage = [UIImage imageNamed:@"refresh" inBundle:imageBundle compatibleWithTraitCollection:nil];
        
        _titleColor = ZF_WK_BLACKCLOLR;
        _titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _useWebTitleAutomatic = YES;
        _navigationBackgroundColor = ZF_WK_BACKGROUD_COLOR;
        
        _rightNavigationButtonTextFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _rightNavigationButtonTextColor = ZF_WK_BLUE_COLOR;
        
    }
    return self;
}
- (void)addMethodName:(NSString *)name callback:(zf_wkWebViewEventCallBack)callback {
    if (callback) self.callbacks[name] = callback;
}


+ (NSString *)localizedStringForKey:(NSString *)key {
    NSString *localizedStr = nil;
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        
        bundle = [NSBundle bundleWithPath:[SOURCE_BUDNLE pathForResource:language ofType:@"lproj"]];
    }
    NSString *value = [bundle localizedStringForKey:key value:nil table:nil];
    localizedStr = [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    return localizedStr;
}

@end

@interface ZFWKWebVC () <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate> {
    float lastPostion;
    int scrollJudgeDistance;
}

@property (nonatomic, strong, readwrite) ZFWKWebVCConf *config;
@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *navigationRightButon;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *originLabel;
@property (nonatomic, strong) ZFWKWebVCLoadFailedView *loadFailedView;
@property (nonatomic, strong) NSURL *previousURL;

@end

@implementation ZFWKWebVC

- (NSArray *)webViewObserverPaths {
    return @[@"title", @"canGoBack", @"canGoForward", @"estimatedProgress", @"URL"];
}

- (NSArray *)configObservePaths {
    return @[@"showBottomBar", @"progressBarHeight",@"backButtonImage", @"closeButtonImage",@"showCloseButton", @"goBackButtonNomalImage", @"goBackButtonDisableImage", @"goForwardButtonNomalImage", @"goForwardButtonDisableImage", @"titleColor", @"titleFont", @"rightNavigationButtonNomalImage", @"showRightNavigationButton", @"rightNavigationButtonTitle", @"rightNavigationButtonTextColor", @"rightNavigationButtonTextFont", @"progressBackgroundColor", @"progressTintColor", @"openUrl"];
}

- (void)dealloc {
//    NSLog(@"%s", __func__);
    [self.config.callbacks removeAllObjects];
    [self removeObserver];
}
- (void)removeObserver {
    if (self.titleLabel) {
        for (NSString *path in [self webViewObserverPaths]) {
            [self.webView removeObserver:self forKeyPath:path context:@"ZFContext"];
        }
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset" context:@"ZFContext"];
        
        for (NSString *path in [self configObservePaths]) {
            [self.config removeObserver:self forKeyPath:path context:@"ZFWKConfig"];
        }
    }
}
- (instancetype)initWithDefaultConfig {
    ZFWKWebVCConf *conf = [[ZFWKWebVCConf alloc] init];
    return [self initWithConf:conf];
}
- (instancetype)initWithConf:(ZFWKWebVCConf *)conf {
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        _config = conf;
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

- (void)addJS {
    [self.webView.configuration.userContentController removeAllUserScripts];
    for (NSString *methodName in self.config.callbacks.allKeys) {
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:methodName];
    }
}
- (void)removeJS {
    for (NSString *name in self.config.callbacks.allKeys) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventViewWillAppear];
    if (callback) callback(self, self.config, nil);
    
    [self addJS];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventViewWillDisappear];
    if (callback) callback(self, self.config, nil);
    
    [self removeJS];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventViewDidDisappear];
    if (callback) callback(self, self.config, nil);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.navigationBar) self.navigationController.navigationBar.hidden = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *navView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:self.config.navigationBackgroundColor];
        self.backButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [view addSubview:self.backButton];
        
        self.closeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [view addSubview:self.closeButton];
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.config.titleText;
            label;
        });
        [view addSubview:self.titleLabel];
        
        self.navigationRightButon = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            [button addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:self.config.rightNavigationButtonTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.config.rightNavigationButtonTextFont;
            button.hidden = YES;
            button;
        });
        [view addSubview:self.navigationRightButon];
        
        self.progressView = ({
            UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
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
    
    if (self.config.showBottomBar) {
        self.bottomBar = ({
            ZFWKWebVCBottomBar *bar = [[ZFWKWebVCBottomBar alloc] initWithFrame:CGRectMake(0, ZF_SCREEN_HEIGHT, ZF_SCREEN_WIDTH, 44)];
            [bar.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            [bar.forwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
            bar;
        });
        [self.view addSubview:self.bottomBar];
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 12.0) {
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    if (@available(iOS 12.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    {
        // Add observer
        for (NSString *path in [self webViewObserverPaths]) {
            [self.webView addObserver:self forKeyPath:path options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld context:@"ZFContext"];
        }
        [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"ZFContext"];
        
        for (NSString *path in [self configObservePaths]) {
            [self.config addObserver:self forKeyPath:path options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:@"ZFWKConfig"];
        }
    }
 
    self.loadFailedView = [[ZFWKWebVCLoadFailedView alloc] initWithFrame:CGRectZero];
    self.loadFailedView.imageView.image = self.config.refreshButtonImage;
    [self.loadFailedView.hoverButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadFailedView];
    
    
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventViewDidLoad];
    if (callback) callback(self, self.config, nil);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id value = change[NSKeyValueChangeNewKey];
    id oldValue = change[NSKeyValueChangeOldKey];
    if ([value isKindOfClass:[NSNull class]]) { 
        value = nil;
    }
    if ([oldValue isKindOfClass:[NSNull class]]) {
        oldValue = nil;
    }
    if ([object isKindOfClass:[WKWebView class]]) {
        if ([keyPath isEqualToString:@"title"]) {
            NSString *title = (NSString *)value;
            if (title && title.length > 0 && self.config.useWebTitleAutomatic) self.titleLabel.text = (NSString *)value;
        } else if ([keyPath isEqualToString:@"canGoBack"]) {
            BOOL canGoBack =  [value boolValue];
            self.config.canGoBack = canGoBack;
            self.bottomBar.backButton.enabled = canGoBack;
            if (self.config.showCloseButton) self.closeButton.hidden = !canGoBack;
        } else if ([keyPath isEqualToString:@"canGoForward"]) {
            BOOL canGoForward =  [value boolValue];
            self.config.canGoForward = canGoForward;
            self.bottomBar.forwardButton.enabled = canGoForward;
        } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            double progress = [value doubleValue];
            self.progressView.progress = progress;
            self.progressView.hidden = progress >= 1.0;
        } else if ([keyPath isEqualToString:@"URL"]) {
            if (value) {
                self.originLabel.text = [NSString stringWithFormat:@"%@%@%@", [ZFWKWebVCConf localizedStringForKey:@"Support by "],((NSURL *)value).host, [ZFWKWebVCConf localizedStringForKey:@"support"]];
                self.previousURL = value;
            } else {
                self.previousURL = oldValue;
            }
            if (!value && !oldValue) {
                [(WKWebView *)object reload];
            }
        }
    } else if ([object isKindOfClass:[UIScrollView class]]) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGPoint offset = [value CGPointValue];
            float currentPostion = offset.y;
            if (currentPostion < -40) {
                self.originLabel.alpha = fabsf(currentPostion + 40) / 40;
            }
            BOOL canGoBool = self.config.canGoForward || self.config.canGoBack;
            if (currentPostion - lastPostion > scrollJudgeDistance)  {
                lastPostion = currentPostion;
                [self bottomBarHidden:YES];
            } else if ((lastPostion - currentPostion > scrollJudgeDistance) && canGoBool) {
                lastPostion = currentPostion;
                [self bottomBarHidden:NO];
            }
        }
    } else if ([object isKindOfClass:[ZFWKWebVCConf class]]) {
        if ([keyPath isEqualToString:@"showBottomBar"]) {
            self.bottomBar.hidden = ![value boolValue];
        } else if ([keyPath isEqualToString:@"progressBarHeight"]) {
            [self.view setNeedsLayout];
        } else if ([keyPath isEqualToString:@"progressTintColor"]) {
            [self.progressView setProgressTintColor:(UIColor *)value];
        } else if ([keyPath isEqualToString:@"progressBackgroundColor"]) {
            [self.progressView setTrackTintColor:(UIColor *)value];
        } else if ([keyPath isEqualToString:@"closeButtonImage"]) {
            [self.closeButton setImage:(UIImage *)value forState:UIControlStateNormal];
        }  else if ([keyPath isEqualToString:@"backButtonImage"]) {
           [self.backButton setImage:(UIImage *)value forState:UIControlStateNormal];
        } else if ([keyPath isEqualToString:@"goBackButtonNomalImage"]) {
            if (self.config.showBottomBar) [self.bottomBar.backButton setImage:(UIImage *)value forState:UIControlStateNormal];
        } else if ([keyPath isEqualToString:@"goBackButtonDisableImage"]) {
            if (self.config.showBottomBar) [self.bottomBar.backButton setImage:(UIImage *)value forState:UIControlStateDisabled];
        } else if ([keyPath isEqualToString:@"goForwardButtonNomalImage"]) {
            if (self.config.showBottomBar) [self.bottomBar.forwardButton setImage:(UIImage *)value forState:UIControlStateNormal];
        } else if ([keyPath isEqualToString:@"goForwardButtonDisableImage"]) {
            if (self.config.showBottomBar) [self.bottomBar.forwardButton setImage:(UIImage *)value forState:UIControlStateDisabled];
        } else if ([keyPath isEqualToString:@"titleColor"]) {
            self.titleLabel.textColor = (UIColor *)value;
        } else if ([keyPath isEqualToString:@"titleFont"]) {
            self.titleLabel.font = (UIFont *)value;
        } else if ([keyPath isEqualToString:@"showRightNavigationButton"]) {
            self.navigationRightButon.hidden = ![value boolValue];
        } else if ([keyPath isEqualToString:@"rightNavigationButtonNomalImage"]) {
            if (self.config.showRightNavigationButton) [self.navigationRightButon setImage:(UIImage *)value forState:UIControlStateNormal];
        } else if ([keyPath isEqualToString:@"rightNavigationButtonTitle"]) {
            if (self.config.showRightNavigationButton) [self.navigationRightButon setTitle:(NSString *)value forState:UIControlStateNormal];
        } else if ([keyPath isEqualToString:@"rightNavigationButtonTextColor"]) {
            if (self.config.showRightNavigationButton) [self.navigationRightButon setTitleColor:(UIColor *)value forState:UIControlStateNormal];
        } else if ([keyPath isEqualToString:@"rightNavigationButtonTextFont"]) {
            if (self.config.showRightNavigationButton) self.navigationRightButon.titleLabel.font = (UIFont *)value;
        } else if ([keyPath isEqualToString:@"openUrl"]) {
            if (!value) return;
            if ([self.webView isLoading]) [self.webView stopLoading];
            NSURL *url = [NSURL URLWithString:value];
            NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.config.timeoutDuration];
            [self.webView loadRequest:req];
        } else if ([keyPath isEqualToString:@"showCloseButton"]) {
            self.closeButton.hidden = !([value boolValue] && self.webView.canGoBack);
        }
        
    }
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventViewWillLayoutSubviews];
    if (callback) callback(self, self.config, nil);
    
    float y = 0;
    float navHeight = 64;
    if (isIPhoneXSeries()) {
        navHeight += 22;
    }
    
    [self.navView setFrame:CGRectMake(0, 0, ZF_SCREEN_WIDTH, navHeight)];
    {
        float btnW = 44 - 10;
        float btnH = 44;
        float nomalMargin = self.config.navigationButtonSpace;
        [self.backButton setFrame:CGRectMake(0, navHeight - btnH, btnW, btnH)];
        [self.closeButton setFrame:CGRectMake(nomalMargin + btnW, navHeight - btnH, btnW, btnH)];
        float rightButtonW = 80;
        float left = nomalMargin + btnW + nomalMargin + btnW + nomalMargin;
        float right = rightButtonW;
        float maxDistance = MAX(left, right);
        float titleLabelWidth = ZF_SCREEN_WIDTH - maxDistance * 2 - nomalMargin * 2;
        [self.titleLabel setFrame:CGRectMake((ZF_SCREEN_WIDTH - titleLabelWidth) * 0.5, navHeight - btnH, titleLabelWidth, btnH)];
        float progress_height = self.config.progressBarHeight * .5;
        [self.progressView setFrame:CGRectMake(0, navHeight - self.config.progressBarHeight, ZF_SCREEN_WIDTH, 2)];
        self.progressView.transform = CGAffineTransformMakeScale(1, progress_height);
        [self.navigationRightButon setFrame:CGRectMake(ZF_SCREEN_WIDTH - 10 - rightButtonW, navHeight - btnH, rightButtonW, btnH)];
    }
    y += navHeight;
    [self.webView setFrame:CGRectMake(0, y, ZF_SCREEN_WIDTH, ZF_SCREEN_HEIGHT - y)];
    [self.originLabel setFrame:CGRectMake(10, 30, ZF_SCREEN_WIDTH - 20, 35)];
    [self.loadFailedView setFrame:CGRectMake(0, y, ZF_SCREEN_WIDTH, ZF_SCREEN_HEIGHT - y)];
}

- (void)bottomBarHidden:(BOOL)flag {
    if (!self.config.showBottomBar) return;
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

- (void)rightButtonClick:(UIButton *)button {
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventRightButtonClickKey];
    if (callback) callback(self, self.config, button);
}

- (void)reloadPreviousRequest {
    [self refresh];
}

- (void)refresh {
    self.titleLabel.text = [ZFWKWebVCConf localizedStringForKey:@"Loading..."];
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventRefreshKey];
    if (callback) callback(self, self.config, nil);
    [self.webView stopLoading];
    if (self.previousURL) {
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:self.previousURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.config.timeoutDuration];
        [self.webView loadRequest:req];
    } else {
        [self.webView reload];
    }
}
- (void)goBack {
    if ([self.webView canGoBack]) [self.webView goBack];
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventGoBackKey];
    if (callback) callback(self, self.config, nil);
}

- (void)goForward {
    if ([self.webView canGoForward]) [self.webView goForward];
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventGoForwardKey];
    if (callback) callback(self, self.config, nil);
}

- (void)close {
    if (self.config.closeButtonGobackFirst) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        } else {
            [self closeVC];
        }
    } else {
        [self closeVC];
    }
}

- (void)closeVC {
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventCloseKey];
    if (callback) callback(self, self.config, nil);
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        switch (self.config.popType) {
            case ZFWKWebVCPopTypeRoot:
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            case ZFWKWebVCPopTypePervious:
            default:
                [self.navigationController popViewControllerAnimated:YES];
                break;
        }
    }
}

- (void)evaluateJavaScriptMethodName:(NSString *)name params:(id _Nullable)params callback:(void (^ _Nullable)(id _Nullable body, NSError * _Nullable error))callback {
    NSString *js = [NSString stringWithFormat:@"%@()", name];
    if (params) {
        if ([NSJSONSerialization isValidJSONObject:params]) {
            NSError *err = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&err];
            if (!err) {
                // fix bug with json dump to nil
                NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
    zf_wkWebViewEventCallBack callback = self.config.callbacks[script];
    if (callback) {
        [self.config.callbacks removeObjectForKey:script];
    }
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:script];
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (self.isViewLoaded) {
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[ZFWKWebVCConf localizedStringForKey:@"Tips"] message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[ZFWKWebVCConf localizedStringForKey:@"Sure"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler();
    }]];
    if (self.config) {
        [self presentViewController:alertController animated:YES completion:^{}];
    } else {
        completionHandler();
    }
        
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventStartLoadKey];
    if (callback) callback(self, self.config, nil);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventStartRecevicedKey];
    if (callback) callback(self, self.config, nil);
    self.loadFailedView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventFinishRecevicedKey];
    if (callback) callback(self, self.config, nil);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showError:error];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showError:error];
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}
- (void)showError:(NSError *)error {
    if (!error) return;
    
    if (error.code == NSURLErrorCancelled) {
        NSLog(@"error.code == NSURLErrorCancelled");
        return;
    }
    
    zf_wkWebViewEventCallBack callback = self.config.callbacks[ZFWKWebViewEventLoadFailedKey];
    if (callback) callback(self, self.config, error);
    self.loadFailedView.hidden = NO;
    NSString *text = [NSString stringWithFormat:@"%@\n\n%@:%@",[ZFWKWebVCConf localizedStringForKey:@"Click to try again"],[ZFWKWebVCConf localizedStringForKey:@"Error"], error.localizedDescription];
    if (error.localizedFailureReason) {
        text = [text stringByAppendingFormat:@"\n%@:%@", [ZFWKWebVCConf localizedStringForKey:@"Reason"], error.localizedFailureReason];
    }
    if (error.localizedRecoverySuggestion) {
        text = [text stringByAppendingFormat:@"\n%@:%@",[ZFWKWebVCConf localizedStringForKey:@"Solution"], error.localizedRecoverySuggestion];
    }
    
    self.titleLabel.text = [ZFWKWebVCConf localizedStringForKey:@"Can't open this page"];
    self.loadFailedView.textLabel.text = text;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%s: %@", __func__, message.name);
    if (!message.name) return;
    zf_wkWebViewEventCallBack callback = self.config.callbacks[message.name];
    if (!callback) return;
    
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        callback(self, self.config, message.body);
    } else if ([message.body isKindOfClass:[NSString class]]) {
        NSString *jsonStr = message.body;
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        id tempBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        if (!err) {
            callback(self, self.config, tempBody);
        } else {
            callback(self, self.config, message.body);
        }
    }
}

- (void)clearAllCaches {
    if (@available(iOS 9.0, *)) {
        NSSet *cacheTypes = [NSSet setWithArray:@[
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeSessionStorage,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeOfflineWebApplicationCache,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeIndexedDBDatabases,
            WKWebsiteDataTypeWebSQLDatabases,
        ]];
        [self clearCachesWithSet:cacheTypes];
    } else {
       NSLog(@"API %s support @available(iOS 9.0, *)", __func__);
    }
}

- (void)clearCachesWithSet:(NSSet *)cacheSet {
    if (@available(iOS 9.0, *)) {
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:cacheSet
                                                   modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                               completionHandler:^{}];
    } else {
        NSLog(@"API %s support @available(iOS 9.0, *)", __func__);
    }
}

@end
