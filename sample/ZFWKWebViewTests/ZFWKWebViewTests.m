//
//  ZFWKWebViewTests.m
//  ZFWKWebViewTests
//
//  Created by Pokey on 2019/10/24.
//  Copyright © 2019 Pokey. All rights reserved.
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
    XCTAssertEqualObjects(loc, @"Support by");
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
