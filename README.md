 ZFWKWebView is a Highly customizable WKWebView for iOS.
 Choose ZFWKWebView for your next project, or migrate over your existing projects—you'll be happy you did!

### Installation with CocoaPods
##### Podfile
To integrate ZFWKWebView into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
pod 'ZFWKWebView', '~> 1.1.1'
end
```
Then, run the following command:
```
pod install --repo-update
```

###  Usage
All the usages are equal with UIAlertController
####  DefaultConfig
```
ZFWKWebVC *web = [[ZFWKWebVC alloc] initWithDefaultConfig];
[web.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com.cn"]]];
[self presentViewController:web animated:YES completion:nil];
```
#### Custom Config
Subclass config from ZFWKWebVCConf
```
ZFWKWebVC *web = [[ZFWKWebVC alloc] initWithConf:userConf];
```
#### Register js or event with config
Body is serialization response 
```
[self addMethodName:ZFWKWebViewEventCloseKey callback:^(ZFWKWebVC * _Nonnull target, ZFWKWebVCConf * _Nonnull config, id  _Nullable body) {
    
}];
```
#### EvaluateJavaScript
```
[webVC evaluateJavaScriptMethodName:@"test" params:@{} callback:^(id _Nullable, NSError * _Nullable error) {
    
}];
```


#### MIT License

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
