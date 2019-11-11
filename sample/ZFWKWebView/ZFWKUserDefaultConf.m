//
//  ZFWKUserDefaultConf.m
//  ZFWKWebView
//
//  Created by 张帆 on 2019/10/8.
//  Copyright © 2019 张帆. All rights reserved.
//

#import "ZFWKUserDefaultConf.h"

@implementation ZFWKUserDefaultConf
- (instancetype)init
{
    self = [super init];
    if (self) {
        {
            self.openUrl = @"https://www.baidu.com/";
            self.timeoutDuration = 2;
        }
        {
           self.titleFont = [UIFont systemFontOfSize:33 weight:UIFontWeightBold];
           self.titleColor = [UIColor redColor];
            self.navigationBackgroundColor = [UIColor greenColor];
        }
        {
//           self.showBottomBar = YES;
//           self.showCloseButton = NO;
        }
        {
           self.showRightNavigationButton = YES;
           self.rightNavigationButtonTitle = @"Skip";
//            self.rightNavigationButtonTextFont = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
//            self.rightNavigationButtonTextColor = [UIColor yellowColor];
        }
        {
           self.progressBarHeight = 40;
           self.progressTintColor = [UIColor colorWithRed:86/255.0 green:187/255.0 blue:59/255.0 alpha:1];
           self.progressBackgroundColor = [UIColor clearColor];
        }
        
        // register event
        [self addMethodName:ZFWKWebViewEventCloseKey callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, id  _Nullable body) {
            NSLog(@"ZFWKWebViewEventCloseKey");
        }];
        [self addMethodName:ZFWKWebViewEventRightButtonClickKey callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, id  _Nullable body) {
            NSLog(@"ZFWKWebViewEventRightButtonClickKey");
        }];
        
        // register javastript
        [self addMethodName:@"formPost" callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, NSDictionary  *_Nullable body) {
            NSString *callback = body[@"callback"];
            [target evaluateJavaScriptMethodName:callback params:@{@"test": @"test"} callback:nil];
            NSLog(@"formPost %@", body);
            [target evaluateJavaScriptMethodName:@"" params:nil callback:^(id  _Nullable body, NSError * _Nullable error) {
                
            }];
        }];
        
    }
    return self;
}

@end
