//
//  JSInvocationType.m
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/18.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "JITypeUtil.h"
#import <objc/runtime.h>
@implementation JITypeUtil


+(JIValueType)valueTypeOfAttribute:(const char *)valueEncoding{
    return 0;
}

+(JIClassType)classTypeOfObject:(id)object{
    
    if (!object) {
        return JIClassType_NSNULL;
    }
    
    if ([object isKindOfClass:[NSNull class]]) {
        return JIClassType_NSNULL;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return JIClassType_NSNumber;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return JIClassType_NSString;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return JIClassType_NSString;
    }
    
    if ([object isKindOfClass:[NSDate class]]) {
        return JIClassType_NSDate;
    }
    
    if ([object isKindOfClass:[NSData class]]) {
        return JIClassType_NSData;
    }
    
    if ([object isKindOfClass:[NSURL class]]) {
        return JIClassType_NSURL;
    }
    
    if ([object isKindOfClass:[NSArray class]]) {
        return JIClassType_NSArray;
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        return JIClassType_NSDictionary;
    }
    
    if ([object isKindOfClass:[NSSet class]]) {
        return JIClassType_NSSet;
    }
    
//    if ([object isKindOfClass:[NSBlock class]]) {
//        return JIClassType_NSBlock;
//    }

    return JIClassType_NSObject;
}

@end
