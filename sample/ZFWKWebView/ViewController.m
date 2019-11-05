//
//  ViewController.m
//  ZFWKWebView
//
//  Created by 张帆 on 2019/9/19.
//  Copyright © 2019 张帆. All rights reserved.
//

#import "ViewController.h"
#import "ZFWKWebVC.h"
#import "ZFWKUserDefaultConf.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // http://10.10.40.32:9999/
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"]] resume];
    
    {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(100, 150, 100, 44)];
        [button setTitle:@"Custom" forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = 1;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(100, 250, 100, 44)];
        button.tag = 2;
        [button setTitle:@"Nomal" forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    UIProgressView *pro = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    pro.progress = .5;
//    [self.view addSubview:pro];
//    [pro setFrame:CGRectMake(0, 200, 200, 100)];
//    pro.transform = CGAffineTransformMakeScale(1, 10);
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 2)];
//    [view setBackgroundColor:[UIColor blueColor]];
//    view.transform = CGAffineTransformMakeScale(1, 10);
//    [self.view addSubview:view];
}

- (void)temp {
    NSLog(@"temp");
}
- (void)buttonClicked:(UIButton *)button {
    if (button.tag == 1) {
        ZFWKUserDefaultConf *userConf = [[ZFWKUserDefaultConf alloc] init];
        ZFWKWebVC *web = [[ZFWKWebVC alloc] initWithConf:userConf];
        [self.navigationController pushViewController:web animated:YES];

    } else {
        ZFWKWebVC *web = [[ZFWKWebVC alloc] initWithDefaultConfig];
        [web.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com.cn"]]];
        [self.navigationController pushViewController:web animated:YES];
    }
    
    
    
}

@end
