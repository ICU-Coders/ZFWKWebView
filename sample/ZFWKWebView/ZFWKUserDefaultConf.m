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
        self.showRightNavigationButton = YES;
        self.rightNavigationButtonTitle = @"Skip";
        self.showBottomBar = YES;
        self.closeButtonGobackFirst = YES;
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
