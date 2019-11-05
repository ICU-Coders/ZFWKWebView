<p align="center" >
   <img src="https://raw.githubusercontent.com/ICU-Coders/IconLib/master/icon.jpg" alt="ICU-Coders" title="ICU-Coders">
 </p>

![MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)
[![Build Status](https://travis-ci.org/FranLucky/ZFWKWebView.svg?branch=master)](https://travis-ci.org/FranLucky/ZFWKWebView)
![podversion](https://img.shields.io/cocoapods/v/ZFWKWebView.svg)
[![Platform](https://img.shields.io/cocoapods/p/ZFWKWebView.svg?style=flat)](http://cocoadocs.org/docsets/ZFWKWebView)


`ZFWKWebView` is a Highly customizable WKWebView for iOS.
 Choose `ZFWKWebView` for your next project, or migrate over your existing projects—you'll be happy you did!

## Adding `ZFWKWebView` to your project
### CocoaPods
[CocoaPods](http://cocoapods.org) is the recommended way to add `ZFWKWebView` to your project.
Specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
pod 'ZFWKWebView', '~> 1.1.6'
end
```
Then, run the following command:
```
pod install --repo-update
```
### Source files
Alternatively you can directly add the `ZFWKWebView.h` and `ZFWKWebView.m` source files to your project.
1. Download the [latest code version](https://github.com/ICU-Coders/ZFWKWebView/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `ZFWKWebView.h` and `ZFWKWebView.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
3. Include `ZFWKWebView` wherever you need it with `#import "ZFWKWebView.h"`.

##  Usage

###  DefaultConfig
```
ZFWKWebVC *web = [[ZFWKWebVC alloc] initWithDefaultConfig];
[web.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com.cn"]]];
[self presentViewController:web animated:YES completion:nil];
```
### Custom Config
Subclass config from `ZFWKWebVCConf`
```
ZFWKWebVC *web = [[ZFWKWebVC alloc] initWithConf:userConf];
```
### Register js or event with config
Body is serialization response 
```
[self addMethodName:ZFWKWebViewEventCloseKey callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, id  _Nullable body) {
    
}];
```

Per-define event key
```
ZFWKWebViewEventStartLoadKey 
ZFWKWebViewEventStartRecevicedKey 
ZFWKWebViewEventFinishRecevicedKey 
ZFWKWebViewEventLoadFailedKey 
ZFWKWebViewEventRefreshKey 
ZFWKWebViewEventCloseKey 
ZFWKWebViewEventRightButtonClickKey 
ZFWKWebViewEventGoBackKey 
ZFWKWebViewEventGoForwardKey 
```

### EvaluateJavaScript
```
[webVC evaluateJavaScriptMethodName:@"test" params:@{} callback:^(id _Nullable, NSError * _Nullable error) {
    
}];
```

### Custom UI

It's realy flexible.

![Custom_UI](https://raw.githubusercontent.com/ICU-Coders/IconLib/master/ZFWKWebView/customUI.jpg)

```
{
   self.titleFont = [UIFont systemFontOfSize:33 weight:UIFontWeightBold];
   self.titleColor = [UIColor redColor];
   self.navigationBackgroundColor = [UIColor greenColor];
}

{
   self.showRightNavigationButton = YES;
   self.rightNavigationButtonTitle = @"Skip";
    self.rightNavigationButtonTextFont = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.rightNavigationButtonTextColor = [UIColor yellowColor];
}
{
   self.progressBarHeight = 40;
   self.progressTintColor = [UIColor colorWithRed:86/255.0 green:187/255.0 blue:59/255.0 alpha:1];
   self.progressBackgroundColor = [UIColor clearColor];
}
```

Custom progress bar

![Custom_progress_bar](https://raw.githubusercontent.com/ICU-Coders/IconLib/master/ZFWKWebView/custom_progress_small.gif)

```
ZFWKUserDefaultConf *userConf = [[ZFWKUserDefaultConf alloc] init];
userConf.progressBarHeight = 40;
userConf.progressTintColor = [UIColor colorWithRed:86/255.0 green:187/255.0 blue:59/255.0 alpha:1];
userConf.progressBackgroundColor = [UIColor clearColor];
```

Show Bottom Bar

![Custom_UI](https://raw.githubusercontent.com/ICU-Coders/IconLib/master/ZFWKWebView/bottomBar.jpg)

```
{
	self.showBottomBar = YES;
	self.showCloseButton = NO; 
}
```



## MIT License

Copyright (c) 2019 Pokeey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
