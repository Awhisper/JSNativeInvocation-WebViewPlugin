//
//  ViewController.m
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/16.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+JSInvocation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * webv = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webv];
    [webv setJSInvocation];
    NSURLRequest *urlreq = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://cp01-awhisper.epc.baidu.com:8085/home/jsinvoke"]];
    [webv loadRequest:urlreq];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
