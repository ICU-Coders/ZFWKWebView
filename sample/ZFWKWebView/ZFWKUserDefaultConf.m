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
        self.rightNavigationButtonTitle = @"跳过";
        self.showBottomBar = NO;
        self.closeButtonGobackFirst = YES;
        [self addMethodName:ZFWKWebViewEventCloseKey callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, id  _Nullable body) {
            
        }];
        [self addMethodName:@"formPost" callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, NSDictionary  *_Nullable body) {
            NSString *callback = body[@"callback"];
            [target evaluateJavaScriptMethodName:callback params:@{@"test": @"test"} callback:nil];
            NSLog(@"formPost %@", body);
            
            [target evaluateJavaScriptMethodName:@"test" params:@{} callback:^(id _Nullable, NSError * _Nullable error) {
                
            }];
        }];
        
    }
    return self;
}

@end
