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
        self.progressTintColor = [UIColor redColor];
        self.progressBackgroundColor = [UIColor blackColor];
        self.showRightNavigationButton = YES;
        self.rightNavigationButtonTitle = @"跳过";
        [self addMethodName:@"test" callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, id  _Nullable body) {
            
        }];
    }
    return self;
}
@end
