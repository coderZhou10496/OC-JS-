//
//  ViewController.m
//  OCAndJS
//
//  Created by watchnail on 2017/5/9.
//  Copyright © 2017年 watchnail. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
}
- (IBAction)click:(id)sender
{
    //     OC 调用 JS
    //    在OC中通过代码调用JS中名为calculate的方法,并传入两个参数
    NSString *string =  [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"calculate('%d','%d')",1,2]];
    
    NSLog(@"resultString: %@",string);

}

// JS 调用 OC
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
//    通过 scheme 来拦截是否是自定义的 URL
    if([[request.URL scheme] isEqualToString:@"myaction"])
    {
        if([[request.URL host] isEqualToString:@"scanClickOperation"])
        {
            NSLog(@"扫一扫");
        }
        if([[request.URL host] isEqualToString:@"shakeClickOperation"])
        {
            NSLog(@"摇一摇");
        }
    }
    return YES;
    
////    也可以通过这种方式来
//    if([request.URL.absoluteString rangeOfString:@"scanClickOperation"].location != NSNotFound)
//    {
//        NSLog(@"扫一扫");
//    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:[self loadJsFile:@"test"]];

}
- (NSString *)loadJsFile:(NSString*)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsScript;
}

@end
