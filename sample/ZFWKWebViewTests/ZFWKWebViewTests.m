//
//  ZFWKWebViewTests.m
//  ZFWKWebViewTests
//
//  Created by 张帆 on 2019/10/24.
//  Copyright © 2019 张帆. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZFWKWebVC.h"

@interface ZFWKWebViewTests : XCTestCase

@end

@implementation ZFWKWebViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLocalizedString {
    NSString *loc = [ZFWKWebVCConf localizedStringForKey:@"Support by"];
    XCTAssertEqualObjects(loc, @"此网页由");
    NSLog(@"loc:%@", loc);
}

- (void)testExample {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
