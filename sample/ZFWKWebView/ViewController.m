//
//  ViewController.m
//  ZFWKWebView
//
//  Created by Pokey on 2019/9/19.
//  Copyright © 2019 Pokey. All rights reserved.
//

#import "ViewController.h"
#import "ZFWKWebVC.h"
#import "ZFWKUserDefaultConf.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        NSURL *fileUrl =  [[NSBundle mainBundle] URLForResource:@"temp.html" withExtension:nil];
        [web.webView loadFileURL:fileUrl allowingReadAccessToURL:fileUrl];
        
//        [web.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
        [self.navigationController pushViewController:web animated:YES];
    }
    
    
    
}

@end
