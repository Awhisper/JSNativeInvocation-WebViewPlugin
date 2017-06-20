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
    JIClassType_NSNumber,
    JIClassType_NSString,
    JIClassType_NSDate,
    JIClassType_NSData,
    JIClassType_NSURL,
    JIClassType_NSArray,
    JIClassType_NSDictionary,
    JIClassType_NSSet,
    JIClassType_NSBlock,
    JIClassType_NSObject
} JIClassType;

typedef enum : NSUInteger {
    JIValueType_Bit = 1000,
    JIValueType_Char,
    JIValueType_UChar,
    JIValueType_Short,
    JIValueType_UShort,
    JIValueType_Integer,
    JIValueType_UInteger,
    JIValueType_Long,
    JIValueType_ULong,
    JIValueType_LongLong,
    JIValueType_ULongLong,
    JIValueType_Float,
    JIValueType_Double,
    JIValueType_Bool,
    JIValueType_Object,
    JIValueType_Struct,
    JIValueType_Class,
    JIValueType_Block,
    JIValueType_Selector,
    JIValueType_Array,
    JIValueType_Enum,
    JIValueType_Pointer,
    JIValueType_String,
    JIValueType_Void,
    JIValueType_Union,
} JIValueType;

@interface JITypeUtil : NSObject

+(JIValueType)valueTypeOfAttribute:(const char *)valueEncoding;

+(JIClassType)classTypeOfObject:(id)object;


@end
