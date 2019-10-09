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

@class ZFWKWebVC;
typedef void(^zf_wkWebViewEventCallBack)(ZFWKWebVC *target, id _Nullable body);

typedef NS_ENUM(NSUInteger, ZFWKWebVCPopType) {
    ZFWKWebVCPopTypePervious,
    ZFWKWebVCPopTypeRoot,
};


typedef NSString * ZFWKWebViewEventKey NS_STRING_ENUM;
FOUNDATION_EXPORT ZFWKWebViewEventKey const ZFWKWebViewEventStartLoadKey;
FOUNDATION_EXPORT ZFWKWebViewEventKey const ZFWKWebViewEventStartRecevicedKey;
FOUNDATION_EXPORT ZFWKWebViewEventKey const ZFWKWebViewEventFinishRecevicedKey;
FOUNDATION_EXPORT ZFWKWebViewEventKey const ZFWKWebViewEventLoadFailedKey;
FOUNDATION_EXPORT ZFWKWebViewEventKey const ZFWKWebViewEventRefreshKey;
FOUNDATION_EXPORT ZFWKWebViewEventKey const ZFWKWebViewEventCloseKey;


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

@property(nonatomic, copy) NSString *customUserAgent;


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



@end

NS_ASSUME_NONNULL_END
