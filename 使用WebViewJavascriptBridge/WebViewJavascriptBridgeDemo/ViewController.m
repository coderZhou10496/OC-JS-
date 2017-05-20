//
//  ViewController.m
//  WebViewJavascriptBridgeDemo
//
//  Created by watchnail on 2017/5/15.
//  Copyright © 2017年 watchnail. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,strong)WebViewJavascriptBridge *webViewBridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"WebViewJavaScriptBridge" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    //这里不要为UIWebView设置代理 UIWebView的代理被赋值给WebViewJavascriptBridge。
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadHTMLString:appHtml baseURL:url];
    [self.view addSubview:webView];
    self.webView = webView;
    
    WebViewJavascriptBridge *webViewBridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    //将UIWebView的代理，从webViewBridge中再传递出来。意思是假如你要在控制器中实现UIWebView的代理方法时，添加下面这样代码
    [webViewBridge setWebViewDelegate:self];
    self.webViewBridge = webViewBridge;
    
    

    // JS调用OC的方法
    
    
    [self.webViewBridge registerHandler:@"changeColor" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //data就是JS传给OC的参数
        NSDictionary *tempDic = data;
        CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
        CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
        CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
        CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
        
        self.webView.scrollView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }];
    

    [self.webViewBridge registerHandler:@"JS调用OC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //data就是JS传给OC的参数
        NSLog(@"data from JS ：%@", data);
        
        if (responseCallback) {
            
            //OC反馈给JS
            responseCallback(@"我是OC传给JS的数据");
            
        }
    }];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");

    
}

// OC调用JS
- (IBAction)click:(id)sender {
    
    // 不传参数，直接调用，无回调
    [self.webViewBridge callHandler:@"myOperation"];
    
    // 传参数 有回调
    [self.webViewBridge callHandler:@"factorial" data:@(4) responseCallback:^(id responseData) {
        NSLog(@"OC端得到responseData: %@",responseData);
    }];

    // 传参数 有回调
    NSArray *array = @[@(1),@(2)];
    [self.webViewBridge callHandler:@"calculate" data:array responseCallback:^(id responseData) {
        NSLog(@"OC端得到responseData: %@",responseData);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
