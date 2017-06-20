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

-(UIViewController *)getJSViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(void)setJSInvocation{
    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsc = context;
    [self clearJscMemory];
    
    if (context) {
        
        context[@"__OC_getSelf"] = ^()
        {
            return [self getSelf];
        };
        
        context[@"__OC_getNil"] = ^()
        {
            return [self getNil];
        };

        
        context[@"__OC_getClass"] = ^( JSValue * className )
        {
            return [self getClass:[className toString]];
        };
        
        context[@"__OC_invokeMethod"] = ^id(JSValue * jsObject, JSValue * jsMethod, JSValue * jsArguments) {
            NSObject *object = [self processObjectWithJSObj:jsObject JSMethod:jsMethod JSArgs:jsArguments];
            NSString *selectorName = [self processSelectorWithJSObj:jsObject JSMethod:jsMethod JSArgs:jsArguments];
            NSArray *arguments = [self processArgumentsWithJSObj:jsObject JSMethod:jsMethod JSArgs:jsArguments];
            id result = [self invokeMethodWithObj:object Selector:selectorName Args:arguments];
            return result;
        };
    }
}



-(id)getClass:(NSString*)className{
    Class classType = NSClassFromString( className );
    if ( nil == classType )
    {
        JI_ERROR( @"[JSCore] Class '%@' not found", className );
    }
    return [self __JI__wrap:(NSObject *)classType];
}

-(id)getSelf{
    return [self __JI__wrap:self];
}

-(id)getNil{
    return [self __JI__wrap:nil];
}


-(id)processObjectWithJSObj:(JSValue *)jsObject JSMethod:(JSValue *)jsMethod JSArgs:(JSValue *)jsArguments{
    if ([self __JI_isObj:[jsObject toDictionary]]) {
        id object = [self __JI_getObj:[jsObject toDictionary]];
        return object;
    }
    if ([self __JI_isClass:[jsObject toDictionary]]) {
        id object = [self __JI_getClass:[jsObject toDictionary]];
        return object;
    }
    if ([self __JI_isSelf:[jsObject toDictionary]]) {
        return self;
    }
    return nil;
}
-(NSString *)processSelectorWithJSObj:(JSValue *)jsObject JSMethod:(JSValue *)jsMethod JSArgs:(JSValue *)jsArguments{
    NSString *method = [jsMethod toString];
    return method;
}
-(NSArray *)processArgumentsWithJSObj:(JSValue *)jsObject JSMethod:(JSValue *)jsMethod JSArgs:(JSValue *)jsArguments{
    
    
    id object = nil;
    
    if ([self __JI_isObj:[jsObject toDictionary]]){
        object = [self __JI_getObj:[jsObject toDictionary]];
    }
        
    if([self __JI_isClass:[jsObject toDictionary]]){
        object = [self __JI_getClass:[jsObject toDictionary]];
    }
    
    if ([self __JI_isSelf:[jsObject toDictionary]]) {
        object = self;
    }
    
    if (!object) {
        return nil;
    }
    
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
                    if ([[jsValue toObject] isKindOfClass:[NSNull class]]) {
                        ocValue = [NSNull null];
                        break;
                    }
                    
                    if ([self __JI_isNil:[jsValue toDictionary]]) {
                        ocValue = [NSNull null];
                        break;
                    }
                    
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

-(id)invokeMethodWithObj:(NSObject*)object Selector:(NSString *)sel Args:(NSArray *)arguments{
    if ( nil == object || nil == sel )
        return nil;

    SEL selector = NSSelectorFromString( sel );

    if ( nil == selector || NO == [object respondsToSelector:selector] )
    {
        JI_ERROR( @"[WebView JSCore] Object <%@: %p>, cannot invoke method '%@'", [object class], object, sel );
        return nil;
    }

    NSMethodSignature *	signature = [object methodSignatureForSelector:selector];
    NSInvocation *		invocation = [NSInvocation invocationWithMethodSignature:signature];

    if ( arguments.count + 2 < signature.numberOfArguments )
    {
        JI_ERROR( @"[WebView JSCore] Object <%@: %p>, wrong arguments count", [object class], object );
        return nil;
    }

    //	if ( arguments && [arguments count] )
    //	{
    //		JI_INFO( @"[JSCore] Object <%@: %p>, invoke method '%@' with arguments %@", [object class], object, method, arguments );
    //	}
    //	else
    {
        JI_INFO( @"[WebView JSCore] Object <%@: %p>, invoke method '%@'", [object class], object, sel );
    }

    [invocation setTarget:object];
    [invocation setSelector:selector];

    for ( NSUInteger i = 2; i < signature.numberOfArguments; ++i )
    {
        NSUInteger	argumentIndex = i - 2;
        id			argument = nil;

        if ( argumentIndex < [arguments count] )
        {
            argument = [self __JI_unwrap: [arguments objectAtIndex:argumentIndex]];
        }

        const char *	argEncoding = [signature getArgumentTypeAtIndex:i];
        JIValueType		argType = [JITypeUtil valueTypeOfAttribute:argEncoding];

        switch ( argType )
        {
            case JIValueType_Bit:
            {
                NSInteger value = argument ? [argument integerValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Char:
            {
                char value = argument ? [argument charValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_UChar:
            {
                unsigned char value = argument ? [argument unsignedCharValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Short:
            {
                short value = argument ? [argument shortValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_UShort:
            {
                unsigned short value = argument ? [argument unsignedShortValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Integer:
            {
                int value = argument ? [argument intValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_UInteger:
            {
                unsigned int value = argument ? [argument unsignedIntValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Long:
            {
                long value = argument ? [argument longValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_ULong:
            {
                unsigned long value = argument ? [argument unsignedLongValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_LongLong:
            {
                long long value = argument ? [argument longLongValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_ULongLong:
            {
                unsigned long long value = argument ? [argument unsignedLongLongValue] : 0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Float:
            {
                float value = argument ? [argument floatValue] : 0.0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Double:
            {
                double value = argument ? [argument doubleValue] : 0.0;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Bool:
            {
                BOOL value = argument ? [argument boolValue] : NO;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Object:
            {
                id value = argument;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Struct:
            {
//                char typeName[128] = { 0 };
//                int  typeNameLen = 0;
//
//                for ( const char * pchar = argEncoding + 1; *pchar != '='; ++pchar )
//                {
//                    typeName[typeNameLen++] = *pchar;
//                }
//
//                typeName[typeNameLen] = '\0';
//
//                void * value = argument ? JSStructDecode( typeName, argument ) : NULL;
//
//                [invocation setArgument:value atIndex:i];
//
//                free( value );
            }
                break;

            case JIValueType_Class:
            {
                id value = argument;

                [invocation setArgument:&value atIndex:i];
            }
                break;


            case JIValueType_Block:
            {
                id value = argument;

                [invocation setArgument:&value atIndex:i];
            }
                break;

            case JIValueType_Selector:
            {
                SEL value = NSSelectorFromString(argument);
                [invocation setArgument:&value atIndex:i];
            }
                break;
            case JIValueType_Array:
            case JIValueType_Enum:
            case JIValueType_Pointer:
            case JIValueType_String:
            case JIValueType_Void:
            case JIValueType_Union:
            {
                JI_ERROR(@"unsupport type");
            }
                break;

            default:
            {
                JI_ERROR( @"[JSCore] Object <%@: %p>, unknown argument type '%@'", [object class], object, @(argType) );
            }
                break;
        }
    }

    [invocation retainArguments];
    [invocation invoke];

    __strong id result = nil;

    if ( 0 != strcmp( signature.methodReturnType, @encode(void) )  )
    {
        const char *	valueEncoding = signature.methodReturnType;
        JIValueType		valueType = [JITypeUtil valueTypeOfAttribute:valueEncoding];

        switch ( valueType )
        {
            case JIValueType_Bit:
            {
                char returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithChar:returnValue];
            }
                break;

            case JIValueType_Char:
            {
                char returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithChar:returnValue];
            }
                break;

            case JIValueType_UChar:
            {
                unsigned char returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithChar:returnValue];
            }
                break;

            case JIValueType_Short:
            {
                short returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithShort:returnValue];
            }
                break;

            case JIValueType_UShort:
            {
                unsigned short returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithUnsignedShort:returnValue];
            }
                break;

            case JIValueType_Integer:
            {
                int returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithInt:returnValue];
            }
                break;

            case JIValueType_UInteger:
            {
                unsigned int returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithUnsignedInt:returnValue];
            }
                break;

            case JIValueType_Long:
            {
                long returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithLong:returnValue];
            }
                break;

            case JIValueType_ULong:
            {
                unsigned long returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithUnsignedLong:returnValue];
            }
                break;

            case JIValueType_LongLong:
            {
                long long returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithLongLong:returnValue];
            }
                break;

            case JIValueType_ULongLong:
            {
                unsigned long long returnValue = 0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithUnsignedLongLong:returnValue];
            }
                break;

            case JIValueType_Float:
            {
                float returnValue = 0.0f;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithFloat:returnValue];
            }
                break;

            case JIValueType_Double:
            {
                double returnValue = 0.0;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithDouble:returnValue];
            }
                break;

            case JIValueType_Bool:
            {
                BOOL returnValue = NO;

                [invocation getReturnValue:&returnValue];

                result = [NSNumber numberWithBool:returnValue];
            }
                break;

            case JIValueType_Object:
            {
                __unsafe_unretained id returnValue = nil;

                [invocation getReturnValue:&returnValue];

                result = returnValue;
            }
                break;

            case JIValueType_Struct:
            {
//                void * returnValue = calloc( 1, signature.methodReturnLength + 1 );
//
//                [invocation getReturnValue:returnValue];
//
//                char typeName[128] = { 0 };
//                int  typeNameLen = 0;
//
//                for ( const char * pchar = valueEncoding + 1; *pchar != '='; ++pchar )
//                {
//                    typeName[typeNameLen++] = *pchar;
//                }
//
//                typeName[typeNameLen] = '\0';
//
//                result = JSStructEncode( typeName, returnValue );
//
//                free( returnValue );
            }
                break;

            case JIValueType_Class:
            {
                __unsafe_unretained Class returnValue = nil;

                [invocation getReturnValue:&returnValue];

                result = returnValue;
            }
                break;


            case JIValueType_Block:
            {
                JI_ERROR(@"unsupport type");
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
                JI_ERROR(@"unsupport type");
            }
                break;

            default:
            {
                JI_ERROR( @"[JSCore] Object <%@: %p>, unknown return value type '%@'", [object class], object, @(valueType) );
            }
                break;
        }
    }
    return [self __JI__wrap:result];
}

@end
