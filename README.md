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
