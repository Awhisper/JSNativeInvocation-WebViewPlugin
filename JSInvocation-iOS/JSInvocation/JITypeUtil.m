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
//JIValueType_Bit = 1000,
//JIValueType_Char,
//JIValueType_UChar,
//JIValueType_Short,
//JIValueType_UShort,
//JIValueType_Integer,
//JIValueType_UInteger,
//JIValueType_Long,
//JIValueType_ULong,
//JIValueType_LongLong,
//JIValueType_ULongLong,
//JIValueType_Float,
//JIValueType_Double,
//JIValueType_Bool,
//JIValueType_Object,
//JIValueType_Struct,
//JIValueType_Class,
//JIValueType_Block,
//JIValueType_Selector,
//JIValueType_Array,
//JIValueType_Enum,
//JIValueType_Pointer,
//JIValueType_String,
//JIValueType_Void,
//JIValueType_Union,

+(JIValueType)valueTypeOfAttribute:(const char *)valueEncoding{
  
    switch(valueEncoding[0] == 'r' ? valueEncoding[1] : valueEncoding[0]){
        case 'b':
        {
            return JIValueType_Bit;
        }
            break;
        case 'c':
        {
            return JIValueType_Char;
        }
            break;
        case 'C':
        {
            return JIValueType_UChar;
        }
            break;
        case 's':
        {
            return JIValueType_Short;
        }
            break;
        case 'S':
        {
            return JIValueType_UShort;
        }
            break;
        case 'i':
        {
            return JIValueType_Integer;
        }
            break;
        case 'I':
        {
            return JIValueType_UInteger;
        }
            break;
        case 'l':
        {
            return JIValueType_Long;
        }
            break;
        case 'L':
        {
            return JIValueType_ULong;
        }
            break;
        case 'q':
        {
            return JIValueType_LongLong;
        }
            break;
        case 'Q':
        {
            return JIValueType_ULongLong;
        }
            break;
        case 'f':
        {
            return JIValueType_Float;
        }
            break;
        case 'd':
        {
            return JIValueType_Double;
        }
            break;
        case 'B':
        {
            return JIValueType_Bool;
        }
            break;
        case '@':
        {
            if (valueEncoding[1] == '?') {
                return JIValueType_Block;
            }else{
                return JIValueType_Object;
            }
        }
            break;
        case '{':
        {
            return JIValueType_Struct;
        }
            break;
        case '#':
        {
            return JIValueType_Class;
        }
            break;
        case ':':
        {
            return JIValueType_Selector;
        }
            break;
        case '^':
        case '*':
        {
            return JIValueType_Pointer;
        }
            break;
        default:
        {
            return 0;
        }
            break;
            
    }
    return 0;
}

+(JIClassType)classTypeOfObject:(id)object{
    
    if (class_isMetaClass(object_getClass(object)))
    {
        return JIClassType_Class;
    }
    
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
    
    if ([object isKindOfClass:NSClassFromString(@"NSBlock")]) {
        return JIClassType_NSBlock;
    }

    return JIClassType_NSObject;
}

@end
