//
//  ZFWKWebVC.h
//  ZFWKWebView
//
//  Created by 张帆 on 2019/9/19.
//  Copyright © 2019 张帆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZFWKWebVCLoadFailedView : UIView @end
@interface ZFWKWebVCBottomBar : UIView @end
@interface ZFWKWebVCTipsView : UIView @end

@class ZFWKWebVC;
@class ZFWKWebVCConf;
typedef void(^zf_wkWebViewEventCallBack)(ZFWKWebVC *target, ZFWKWebVCConf *config, id _Nullable body);

typedef NS_ENUM(NSUInteger, ZFWKWebVCPopType) {
    ZFWKWebVCPopTypePervious,
    ZFWKWebVCPopTypeRoot,
};


typedef NSString * ZFWKWebViewEventKey NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventStartLoadKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventStartRecevicedKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventFinishRecevicedKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventLoadFailedKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventRefreshKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventCloseKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventRightButtonClickKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventGoBackKey;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventGoForwardKey;

@interface ZFWKWebVCConf : NSObject
@property(nonatomic, assign) ZFWKWebVCPopType popType;

@property(nonatomic, copy) NSString *openUrl;

@property(nonatomic, assign) int timeoutDuration; // default 15s

@property(nonatomic, assign) BOOL showBottomBar; // default NO

@property(nonatomic, assign) float progressBarHeight; // default 2.5
@property (nonatomic, strong) UIColor *progressBackgroundColor; // [UIColor clearColor]
@property (nonatomic, strong) UIColor *progressTintColor; // [UIColor colorWithRed:86/255.0 green:187/255.0 blue:59/255.0 alpha:1]

@property (nonatomic, strong) UIImage *closeButtonImage;

@property (nonatomic, strong) UIImage *goBackButtonNomalImage;
@property (nonatomic, strong) UIImage *goBackButtonDisableImage;

@property (nonatomic, strong) UIImage *goForwardButtonNomalImage;
@property (nonatomic, strong) UIImage *goForwardButtonDisableImage;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIImage *refreshButtonImage;

@property(nonatomic, copy) NSString *customUserAgent; // TODO

@property(nonatomic, assign) BOOL showRightNavigationButton; // defult NO
@property (nonatomic, strong) UIImage *rightNavigationButtonNomalImage;
@property (nonatomic, strong) UIImage *rightNavigationButtonDisableImage;
@property(nonatomic, copy) NSString *rightNavigationButtonTitle;
@property (nonatomic, strong) UIFont *rightNavigationButtonTextFont;
@property (nonatomic, strong) UIColor *rightNavigationButtonTextColor;

@property(nonatomic, assign) BOOL closeButtonGobackFirst; // if can goback, close button go back first


/**
 * Desc 注册方法，当js调用时会回调到OC
 * name js执行方法名
 * callback 回调 NSArray/NSDictionary/NSString/NSNumber
 */
- (void)addMethodName:(NSString *)name callback:(zf_wkWebViewEventCallBack)callback;

@end

@interface ZFWKWebVC : UIViewController
- (instancetype)initWithDefaultConfig;
- (instancetype)initWithConf:(ZFWKWebVCConf *)conf;
/**
 * Desc 执行JS方法，传入参数
 * name 执行js方法名
 * params 传给js的参数 NSArray/NSDictionary/NSString/NSNumber
 * callback 执行返回参数/Error
 */
- (void)evaluateJavaScriptMethodName:(NSString *)name params:(id _Nullable)params callback:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))callback;

- (void)removeUserScript:(NSString *)script;

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, nullable) ZFWKWebVCBottomBar *bottomBar;
@property (nonatomic, strong, readonly) ZFWKWebVCConf *config;


@end

NS_ASSUME_NONNULL_END
