//
//  UIWebView+JSInvocationInner.h
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/19.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface UIWebView (JSInvocationInner)

@property(nonatomic,assign) JSContext *jsc;
@property(nonatomic,retain) NSMutableDictionary *jscMemory;

-(void)clearJscMemory;

- (BOOL)__JI_isNil:(NSDictionary *)dict;

- (id)__JI_genNil;

- (BOOL)__JI_isObj:(NSDictionary *)dict;

- (id)__JI_getObj:(NSDictionary *)dict;

- (id)__JI_genObj:(id)object;

- (id)__JI__wrap:(NSObject *)object;

- (id)__JI_unwrap:(NSObject *)object;

@end
