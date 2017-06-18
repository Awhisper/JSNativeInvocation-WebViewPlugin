//
//  ViewController.m
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/16.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+JSInvocation.h"
#import "JSInvocationUtil.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView* webv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * webv = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webv];
    webv.delegate = self;
    self.webv = webv;
    NSURLRequest *urlreq = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://cp01-awhisper.epc.baidu.com:8085/home/jsinvoke"]];
    [webv loadRequest:urlreq];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webv setJSInvocation];
    JI_INFO(@"AAAAAAAA%@",@"abc");
    JI_ERROR(@"aaaaaaa%@",@"abc");
    JI_ASSERT(NO, @"AAAAA");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
