//
//  JSInvocationType.h
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/18.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JIClassType_NSNULL = 0,
    JIClassType_NSNumber
} JIClassType;

typedef enum : NSUInteger {
    JIValueType_Bit = 1000,
    JIValueType_Char
} JIValueType;

@interface JITypeUtil : NSObject

+(JIValueType)valueTypeOfAttribute:(char *)valueEncoding;

+(JIClassType)classTypeOfObject:(id)object;


@end
