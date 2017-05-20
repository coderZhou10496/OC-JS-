//
//  ViewController.m
//  JavaScriptCoreDemo
//
//  Created by watchnail on 2017/5/16.
//  Copyright © 2017年 watchnail. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) JSContext *OCCallJScontext;
@property (strong, nonatomic) JSContext *JSCallOCcontext;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"WebViewJavaScriptBridge" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    //这里不要为UIWebView设置代理 UIWebView的代理被赋值给WebViewJavascriptBridge。
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [webView loadHTMLString:appHtml baseURL:url];
    [self.view addSubview:webView];
    
    // 初始化 JSContext 对象
    self.OCCallJScontext = [[JSContext alloc] init];
    
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
     [self.OCCallJScontext evaluateScript:jsScript];
    
}
//  OC调用JS
// 通过调用JS的方法，来计算两数之和
- (IBAction)click:(id)sender
{
    JSValue *function = [self.OCCallJScontext objectForKeyedSubscript:@"calculate"];
    
    // 3 + 4
    JSValue *result = [function callWithArguments:@[@(3),@(4)]];
    
    NSLog(@"通过js方法计算两数之和为 %@",[result toString]);
    
}
// JS调用OC
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.JSCallOCcontext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 以 block 形式关联 JavaScript function
    
    
    self.JSCallOCcontext[@"methodA"] =
    ^()
    {
        NSLog(@"直接调用不传参数");
        // 可以写自己的方法
        // [self customMethod];
    };
    
    self.JSCallOCcontext[@"methodB"] =
    ^(NSString *str)
    {
        NSLog(@"得到JS的参数为 %@",str);
        // 可以写自己的方法
        // [self customMethod];

    };
    
    
    self.JSCallOCcontext[@"methodC"] =
    ^(NSString *str1,NSString *str2)
    {
        NSLog(@"得到JS的多参数为 %@ %@ ",str1,str2);
        // 可以写自己的方法
        //  [self customMethod];
    };
    
    // 并将值返回给js
    __weak ViewController *weakSelf = self;
    self.JSCallOCcontext[@"methodD"] =
    ^(NSString *str)
    {
        NSLog(@"得到JS的参数为 %@",str);
        str = [NSString stringWithFormat:@"呵呵哒%@",str];
        JSValue *callback = weakSelf.JSCallOCcontext[@"callback"];
        [callback callWithArguments:@[str]];
    };
}



@end
