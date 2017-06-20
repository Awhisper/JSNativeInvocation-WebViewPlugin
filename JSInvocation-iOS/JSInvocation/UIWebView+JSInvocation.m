//
//  UIWebView+JSInvocation.m
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/16.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "UIWebView+JSInvocation.h"
#import "UIWebView+JSInvocationInner.h"
#import "JITypeUtil.h"
#import "JIUtil.h"

@implementation UIWebView (JSInvocation)


-(void)setJSInvocation{
    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsc = context;
    
    if (context) {
        context[@"__OC_invokeMethod"] = ^id(JSValue * jsObject, JSValue * jsMethod, JSValue * jsArguments) {
            NSObject *object = [self processObjectWithJSObj:jsObject JSMethod:jsMethod JSArgs:jsArguments];
            NSString *selectorName = [self processSelectorWithJSObj:jsObject JSMethod:jsMethod JSArgs:jsArguments];
            NSArray *arguments = [self processArgumentsWithJSObj:jsObject JSMethod:jsMethod JSArgs:jsArguments];
//            return __OC__invokeMethod(object, selectorName, arguments, self);
            return nil;
        };
        
    }
    
    
    NSLog(@"11");
}

-(id)processObjectWithJSObj:(JSValue *)jsObject JSMethod:(JSValue *)jsMethod JSArgs:(JSValue *)jsArguments{
    if ([self __JI_isObj:[jsObject toDictionary]]) {
        id object = [self __JI_getObj:[jsObject toDictionary]];
        return object;
    }
    return nil;
}
-(NSString *)processSelectorWithJSObj:(JSValue *)jsObject JSMethod:(JSValue *)jsMethod JSArgs:(JSValue *)jsArguments{
    NSString *method = [jsMethod toString];
    return method;
}
-(NSArray *)processArgumentsWithJSObj:(JSValue *)jsObject JSMethod:(JSValue *)jsMethod JSArgs:(JSValue *)jsArguments{
    
    if (![self __JI_isObj:[jsObject toDictionary]]) {
        return nil;
    }
    id object = [self __JI_getObj:[jsObject toDictionary]];
    
    NSMutableArray *	arguments = [NSMutableArray array];
    NSString *method = [jsMethod toString];

    SEL selector = NSSelectorFromString(method);
    
    if ( selector && [object respondsToSelector:selector] )
    {
        NSMethodSignature *	signature = [object methodSignatureForSelector:selector];
        
        for ( NSUInteger i = 2; i < signature.numberOfArguments; ++i )
        {
            const char *	argEncoding = [signature getArgumentTypeAtIndex:i];
            NSInteger		argIndex = i - 2;
            JIValueType		argType = [JITypeUtil valueTypeOfAttribute:argEncoding];
            
            JSValue *		jsValue = [jsArguments valueAtIndex:argIndex];
            NSObject *		ocValue = nil;
            
            switch ( argType )
            {
                case JIValueType_Bit:			{ ocValue = jsValue ? [NSNumber numberWithChar:0] : [jsValue toNumber]; } break;
                case JIValueType_Char:		{ ocValue = jsValue ? [NSNumber numberWithChar:0] : [jsValue toNumber]; } break;
                case JIValueType_UChar:		{ ocValue = jsValue ? [NSNumber numberWithUnsignedChar:0] : [jsValue toNumber]; } break;
                case JIValueType_Short:		{ ocValue = jsValue ? [NSNumber numberWithShort:0] : [jsValue toNumber]; } break;
                case JIValueType_UShort:		{ ocValue = jsValue ? [NSNumber numberWithUnsignedShort:0] : [jsValue toNumber]; } break;
                case JIValueType_Integer:		{ ocValue = jsValue ? [NSNumber numberWithInteger:0] : [jsValue toNumber]; } break;
                case JIValueType_UInteger:	{ ocValue = jsValue ? [NSNumber numberWithInteger:0] : [jsValue toNumber]; } break;
                case JIValueType_Long:		{ ocValue = jsValue ? [NSNumber numberWithLong:0] : [jsValue toNumber]; } break;
                case JIValueType_ULong:		{ ocValue = jsValue ? [NSNumber numberWithUnsignedLong:0] : [jsValue toNumber]; } break;
                case JIValueType_LongLong:	{ ocValue = jsValue ? [NSNumber numberWithUnsignedLong:0] : [jsValue toNumber]; } break;
                case JIValueType_ULongLong:	{ ocValue = jsValue ? [NSNumber numberWithUnsignedLong:0] : [jsValue toNumber]; } break;
                case JIValueType_Float:		{ ocValue = jsValue ? [NSNumber numberWithUnsignedLong:0] : [jsValue toNumber]; } break;
                case JIValueType_Double:		{ ocValue = jsValue ? [NSNumber numberWithDouble:0] : [jsValue toNumber]; } break;
                case JIValueType_Bool:		{ ocValue = jsValue ? [NSNumber numberWithBool:NO] : [jsValue toNumber]; } break;
                case JIValueType_Object:		{ ocValue = [jsValue toObject]; } break;
                case JIValueType_Struct:		{ ocValue = [jsValue toObject]; } break;
                case JIValueType_Class:		{ ocValue = [jsValue toObject]; } break;
                    
                case JIValueType_Block:
                {
                    __weak typeof(self) weakSelf = self;
                    id block = ^id( id first, ... )
                    {
                        JSValue * jsFunc = [jsValue objectForKeyedSubscript:@"__func__"];
                        JSValue * jsArgs = [jsValue objectForKeyedSubscript:@"__args__"];
                        
                        if ( jsFunc && jsArgs )
                        {
                            NSInteger			argCount = [[jsArgs toNumber] integerValue];
                            NSMutableArray *	argList = [[NSMutableArray alloc] init];
                            
                            if ( [argList count] < argCount )
                            {
                                id wrapItem = [self __JI__wrap:first];
                                [argList addObject:wrapItem];
                            }
                            
                            va_list args;
                            va_start( args, first );
                            
                            for ( ;; )
                            {
                                if ( [argList count] >= argCount )
                                    break;
                                
                                NSObject * value = va_arg( args, NSObject * );
                                if ( nil == value )
                                    break;
                                id wrapItem = [self __JI__wrap:value];
                                [argList addObject:wrapItem];
                            }
                            
                            va_end( args );
                            
                            JSContext * jsContext = weakSelf.jsc;
                            
                            if ( nil == jsContext )
                            {
                                JI_ERROR( @"[JSCore] Invalid invocation context" );
                                return nil;
                            }
                            
                            JSValue * jsCallback = jsContext[@"runtimeFunctionCallback"];
                            
                            if ( nil == jsCallback || jsCallback.isUndefined || jsCallback.isNull )
                            {
                                JI_ERROR( @"[JSCore] Invalid invocation context" );
                                return nil;
                            }
                            
                            JSValue * returnValue = [jsCallback callWithArguments:@[jsFunc, argList]];
                            
                            if ( nil == returnValue )
                                return nil;
                            
                            return [self __JI_unwrap:returnValue];
                        }
                        else
                        {
                            return nil;
                        }
                    };
                    
                    ocValue = block;
                }
                    break;
                    
                case JIValueType_Selector:
                case JIValueType_Array:
                case JIValueType_Enum:
                case JIValueType_Pointer:
                case JIValueType_String:
                case JIValueType_Void:
                case JIValueType_Union:
                {
                    JI_ERROR(@"unsupport union");
                }
                    break;
                    
                default:
                {
                    JI_ERROR( @"[JSCore] Object <%@: %p>, unknown argument type '%@'", [object class], object, @(argType) );
                }
                    break;
            }
            
            if ( nil == ocValue )
            {
                [arguments addObject:[NSNull null]];
            }
            else
            {
                [arguments addObject:ocValue];
            }
        }
    }
    
    return arguments;
}


@end
