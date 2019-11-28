//
//  ZFWKWebVC.h
//  ZFWKWebView
//
//  Created by Pokey on 2019/9/19.
//  Copyright © 2019 Pokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZFWKWebVCLoadFailedView : UIView @end
@interface ZFWKWebVCBottomBar : UIView @end

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

UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventViewWillAppear;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventViewWillDisappear;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventViewDidDisappear;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventViewDidLoad;
UIKIT_EXTERN ZFWKWebViewEventKey const ZFWKWebViewEventViewWillLayoutSubviews;

@interface ZFWKWebVCConf : NSObject
/**
 *  ZFWKWebVCPopTypePervious => popViewControllerAnimated (default)
 *  ZFWKWebVCPopTypeRoot => popToRootViewControllerAnimated
 */
@property(nonatomic, assign) ZFWKWebVCPopType popType;

@property(nonatomic, copy) NSString *openUrl;

@property(nonatomic, assign) int timeoutDuration; // default 15s
@property(nonatomic, assign) float progressBarHeight; // default 2
@property(nonatomic, assign) float navigationButtonSpace; // default 0;

@property (nonatomic, strong) UIColor *navigationBackgroundColor; // ZF_WK_BACKGROUD_COLOR
@property (nonatomic, strong) UIColor *progressBackgroundColor; // [UIColor clearColor]
@property (nonatomic, strong) UIColor *progressTintColor; // [UIColor colorWithRed:86/255.0 green:187/255.0 blue:59/255.0 alpha:1]
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *rightNavigationButtonTextColor;

@property (nonatomic, strong) UIImage *backButtonImage;
@property (nonatomic, strong) UIImage *closeButtonImage;
@property (nonatomic, strong) UIImage *goBackButtonNomalImage;
@property (nonatomic, strong) UIImage *goBackButtonDisableImage;
@property (nonatomic, strong) UIImage *goForwardButtonNomalImage;
@property (nonatomic, strong) UIImage *goForwardButtonDisableImage;
@property (nonatomic, strong) UIImage *refreshButtonImage;
@property (nonatomic, strong) UIImage *rightNavigationButtonNomalImage;
@property (nonatomic, strong) UIImage *rightNavigationButtonDisableImage;

@property(nonatomic, assign) BOOL showBottomBar; // default NO
@property(nonatomic, assign) BOOL showCloseButton; // default YES
@property(nonatomic, assign) BOOL showRightNavigationButton; // defult NO

@property(nonatomic, copy) NSString *rightNavigationButtonTitle;

@property (nonatomic, strong) UIFont *rightNavigationButtonTextFont;
@property (nonatomic, strong) UIFont *titleFont;
@property(nonatomic, copy, nullable) NSString *titleText; // 默认标题
@property(nonatomic, assign) BOOL useWebTitleAutomatic; // default YES
/**
 * If can goback,the back button go back first, close when page is last
 */
@property(nonatomic, assign) BOOL closeButtonGobackFirst; // default YES

/**
 * Register javascript call name or event ZFWKWebViewEventKey
 * Callback NSArray/NSDictionary/NSString/NSNumber
 */
- (void)addMethodName:(NSString *)name callback:(zf_wkWebViewEventCallBack)callback;

+ (NSString *)localizedStringForKey:(NSString *)key;
@end








@interface ZFWKWebVC : UIViewController
- (instancetype)initWithDefaultConfig;
- (instancetype)initWithConf:(ZFWKWebVCConf *)conf;

- (void)evaluateJavaScriptMethodName:(NSString *)name params:(id _Nullable)params callback:(void (^ _Nullable)(id _Nullable body, NSError * _Nullable error))callback;
- (void)removeUserScript:(NSString *)script;
- (void)reloadPreviousRequest;

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, nullable) ZFWKWebVCBottomBar *bottomBar;
@property (nonatomic, strong, readonly) ZFWKWebVCConf *config;



@end

NS_ASSUME_NONNULL_END
