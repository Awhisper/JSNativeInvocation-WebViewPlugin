//
//  UIWebView+JSInvocation.m
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/16.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "UIWebView+JSInvocation.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "JSInvocationUtil.h"

#pragma mark -

//static inline BOOL __JI__isNil( NSDictionary * dict )
//{
//    if ( [dict objectForKey:@"__nil__"] )
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//static inline id __JI__makeNil( void )
//{
//    static NSDictionary *	value;
//    static dispatch_once_t	once;
//    
//    dispatch_once( &once, ^{
//        value = @{ @"__nil__" : @"__nil__" };
//    });
//    
//    return value;
//}
//
//#pragma mark -
//
//static inline id __JS__getPtr( NSNumber * object )
//{
//#if __JSRUNTIME_WEAK_OBJECT__
//    return (__bridge id)(void *)[object unsignedLongLongValue];
//#else
//    return object;
//#endif
//}
//
//static inline id __JS__makePtr( id object )
//{
//#if __JSRUNTIME_WEAK_OBJECT__
//    return [NSNumber numberWithUnsignedLongLong:(unsigned long long)object];
//#else
//    return object;
//#endif
//}
//
//#pragma mark -
//
//static inline BOOL __JS__isObj( NSDictionary * dict )
//{
//    if ( [dict objectForKey:@"__obj__"] )
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//static inline id __JS__getObj( NSDictionary * dict )
//{
//    return __JS__getPtr( [dict objectForKey:@"__obj__"] );
//}
//
//static inline id __JS__makeObj( id object )
//{
//    return @{ @"__obj__" : __JS__makePtr( object ), @"__cls__" : [NSString stringWithUTF8String:class_getName([object class])] };
//}
//
//
//
//#pragma mark -
//
//static id __JI__wrap( NSObject * object )
//{
//    if ( nil == object )
//    {
//        return __JS__makeNil();
//    }
//    
//    ClassType objectType = [SamuraiType classTypeOfObject:object];
//    
//    if ( ClassType_NSNull == objectType )
//    {
//        return __JS__makeNil();
//    }
//    else if ( ClassType_NSNumber == objectType )
//    {
//        return object;	// primitive
//    }
//    else if ( ClassType_NSString == objectType )
//    {
//        return object;	// primitive
//    }
//    else if ( ClassType_NSDate == objectType )
//    {
//        return __JS__makeObj( object );
//    }
//    else if ( ClassType_NSData == objectType )
//    {
//        return __JS__makeObj( object );
//    }
//    else if ( ClassType_NSURL == objectType )
//    {
//        return __JS__makeObj( object );
//    }
//    else if ( ClassType_NSArray == objectType )
//    {
//        NSMutableArray * result = [NSMutableArray array];
//        
//        for ( NSObject * elem in (NSArray *)object )
//        {
//            [result addObject:__JS__wrap( elem )];
//        }
//        
//        return result;
//    }
//    else if ( ClassType_NSDictionary == objectType )
//    {
//        NSMutableDictionary * result = [NSMutableDictionary dictionary];
//        
//        for ( NSString * key in (NSDictionary *)object )
//        {
//            NSObject * value = [(NSDictionary *)object objectForKey:key];
//            
//            [result setObject:__JS__wrap( value ) forKey:key];
//        }
//        
//        return result;
//    }
//    else if ( ClassType_NSSet == objectType )
//    {
//        NSMutableArray * result = [NSMutableArray array];
//        
//        for ( NSObject * elem in (NSSet *)object )
//        {
//            [result addObject:__JS__wrap( elem )];
//        }
//        
//        return result;
//    }
//    else if ( ClassType_NSBlock == objectType )
//    {
//        return __JS__makeObj( [object copy] );
//    }
//    else
//    {
//        return __JS__makeObj( object );
//    }
//}
//
//static id __JS__unwrap( NSObject * object )
//{
//    if ( nil == object )
//    {
//        return nil;
//    }
//    
//    ClassType objectType = [SamuraiType classTypeOfObject:object];
//    
//    if ( ClassType_NSNull == objectType )
//    {
//        return nil;
//    }
//    else if ( ClassType_NSNumber == objectType )
//    {
//        return object;
//    }
//    else if ( ClassType_NSString == objectType )
//    {
//        return object;
//    }
//    else if ( ClassType_NSDate == objectType )
//    {
//        return object;
//    }
//    else if ( ClassType_NSData == objectType )
//    {
//        return object;
//    }
//    else if ( ClassType_NSURL == objectType )
//    {
//        return object;
//    }
//    else if ( ClassType_NSArray == objectType )
//    {
//        NSMutableArray * result = [NSMutableArray array];
//        
//        for ( NSObject * elem in (NSArray *)object )
//        {
//            [result addObject:__JS__unwrap(elem)];
//        }
//        
//        return result;
//    }
//    else if ( ClassType_NSDictionary == objectType )
//    {
//        if ( __JS__isNil( (NSDictionary *)object ) )
//        {
//            return nil;
//        }
//        else if ( __JS__isObj( (NSDictionary *)object ) )
//        {
//            return __JS__getObj( (NSDictionary *)object );
//        }
//        else
//        {
//            NSMutableDictionary * result = [NSMutableDictionary dictionary];
//            
//            for ( NSString * key in (NSDictionary *)object )
//            {
//                NSObject * value = [(NSDictionary *)object objectForKey:key];
//                
//                [result setObject:__JS__unwrap(value) forKey:key];
//            }
//            
//            return result;
//        }
//    }
//    else if ( ClassType_NSSet == objectType )
//    {
//        NSMutableSet * result = [NSMutableSet set];
//        
//        for ( NSObject * elem in (NSSet *)object )
//        {
//            [result addObject:__JS__unwrap( elem )];
//        }
//        
//        return result;
//    }
//    else if ( ClassType_NSBlock == objectType )
//    {
//        return [object copy];
//    }
//    else
//    {
//        return object;
//    }
//}
//
//
//#pragma mark -
//
//static id inline __OC__invokeMethod( NSObject * object, NSString * method, NSArray * arguments )
//{
//    if ( nil == object || nil == method )
//        return nil;
//    
//    SEL selector = NSSelectorFromString( method );
//    
//    if ( nil == selector || NO == [object respondsToSelector:selector] )
//    {
//        ERROR( @"[JSCore] Object <%@: %p>, cannot invoke method '%@'", [object class], object, method );
//        TRAP();
//        return nil;
//    }
//    
//    NSMethodSignature *	signature = [object methodSignatureForSelector:selector];
//    NSInvocation *		invocation = [NSInvocation invocationWithMethodSignature:signature];
//    
//    if ( arguments.count + 2 < signature.numberOfArguments )
//    {
//        ERROR( @"[JSCore] Object <%@: %p>, wrong arguments count", [object class], object );
//        return nil;
//    }
//    
//    //	if ( arguments && [arguments count] )
//    //	{
//    //		INFO( @"[JSCore] Object <%@: %p>, invoke method '%@' with arguments %@", [object class], object, method, arguments );
//    //	}
//    //	else
//    {
//        INFO( @"[JSCore] Object <%@: %p>, invoke method '%@'", [object class], object, method );
//    }
//    
//    [invocation setTarget:object];
//    [invocation setSelector:selector];
//    
//    for ( NSUInteger i = 2; i < signature.numberOfArguments; ++i )
//    {
//        NSUInteger	argumentIndex = i - 2;
//        id			argument = nil;
//        
//        if ( argumentIndex < [arguments count] )
//        {
//            argument = __JS__unwrap( [arguments objectAtIndex:argumentIndex] );
//        }
//        
//        const char *	argEncoding = [signature getArgumentTypeAtIndex:i];
//        ValueType		argType = [SamuraiType valueTypeOfAttribute:argEncoding];
//        
//        switch ( argType )
//        {
//            case ValueType_Bit:
//            {
//                NSInteger value = argument ? [argument integerValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Char:
//            {
//                char value = argument ? [argument charValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_UChar:
//            {
//                unsigned char value = argument ? [argument unsignedCharValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Short:
//            {
//                short value = argument ? [argument shortValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_UShort:
//            {
//                unsigned short value = argument ? [argument unsignedShortValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Integer:
//            {
//                int value = argument ? [argument intValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_UInteger:
//            {
//                unsigned int value = argument ? [argument unsignedIntValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Long:
//            {
//                long value = argument ? [argument longValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_ULong:
//            {
//                unsigned long value = argument ? [argument unsignedLongValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_LongLong:
//            {
//                long long value = argument ? [argument longLongValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_ULongLong:
//            {
//                unsigned long long value = argument ? [argument unsignedLongLongValue] : 0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Float:
//            {
//                float value = argument ? [argument floatValue] : 0.0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Double:
//            {
//                double value = argument ? [argument doubleValue] : 0.0;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Bool:
//            {
//                BOOL value = argument ? [argument boolValue] : NO;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Object:
//            {
//                id value = argument;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Struct:
//            {
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
//            }
//                break;
//                
//            case ValueType_Class:
//            {
//                id value = argument;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//                
//            case ValueType_Block:
//            {
//                id value = argument;
//                
//                [invocation setArgument:&value atIndex:i];
//            }
//                break;
//                
//            case ValueType_Selector:
//            case ValueType_Array:
//            case ValueType_Enum:
//            case ValueType_Pointer:
//            case ValueType_String:
//            case ValueType_Void:
//            case ValueType_Union:
//            {
//                ASSERT( 0 );
//            }
//                break;
//                
//            default:
//            {
//                ERROR( @"[JSCore] Object <%@: %p>, unknown argument type '%s'", [object class], object, argType );
//                TRAP();
//            }
//                break;
//        }
//    }
//    
//    [invocation retainArguments];
//    [invocation invoke];
//    
//    __strong id result = nil;
//    
//    if ( 0 != strcmp( signature.methodReturnType, @encode(void) )  )
//    {
//        const char *	valueEncoding = signature.methodReturnType;
//        ValueType		valueType = [SamuraiType valueTypeOfAttribute:valueEncoding];
//        
//        switch ( valueType )
//        {
//            case ValueType_Bit:
//            {
//                char returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithChar:returnValue];
//            }
//                break;
//                
//            case ValueType_Char:
//            {
//                char returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithChar:returnValue];
//            }
//                break;
//                
//            case ValueType_UChar:
//            {
//                unsigned char returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithChar:returnValue];
//            }
//                break;
//                
//            case ValueType_Short:
//            {
//                short returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithShort:returnValue];
//            }
//                break;
//                
//            case ValueType_UShort:
//            {
//                unsigned short returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithUnsignedShort:returnValue];
//            }
//                break;
//                
//            case ValueType_Integer:
//            {
//                int returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithInt:returnValue];
//            }
//                break;
//                
//            case ValueType_UInteger:
//            {
//                unsigned int returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithUnsignedInt:returnValue];
//            }
//                break;
//                
//            case ValueType_Long:
//            {
//                long returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithLong:returnValue];
//            }
//                break;
//                
//            case ValueType_ULong:
//            {
//                unsigned long returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithUnsignedLong:returnValue];
//            }
//                break;
//                
//            case ValueType_LongLong:
//            {
//                long long returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithLongLong:returnValue];
//            }
//                break;
//                
//            case ValueType_ULongLong:
//            {
//                unsigned long long returnValue = 0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithUnsignedLongLong:returnValue];
//            }
//                break;
//                
//            case ValueType_Float:
//            {
//                float returnValue = 0.0f;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithFloat:returnValue];
//            }
//                break;
//                
//            case ValueType_Double:
//            {
//                double returnValue = 0.0;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithDouble:returnValue];
//            }
//                break;
//                
//            case ValueType_Bool:
//            {
//                BOOL returnValue = NO;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = [NSNumber numberWithBool:returnValue];
//            }
//                break;
//                
//            case ValueType_Object:
//            {
//                __unsafe_unretained id returnValue = nil;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = returnValue;
//            }
//                break;
//                
//            case ValueType_Struct:
//            {
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
//            }
//                break;
//                
//            case ValueType_Class:
//            {
//                __unsafe_unretained Class returnValue = nil;
//                
//                [invocation getReturnValue:&returnValue];
//                
//                result = returnValue;
//            }
//                break;
//                
//                
//            case ValueType_Block:
//            {
//                ASSERT( 0 );
//            }
//                break;
//                
//            case ValueType_Selector:
//            case ValueType_Array:
//            case ValueType_Enum:
//            case ValueType_Pointer:
//            case ValueType_String:
//            case ValueType_Void:
//            case ValueType_Union:
//            {
//                ASSERT( 0 );
//            }
//                break;
//                
//            default:
//            {
//                ERROR( @"[JSCore] Object <%@: %p>, unknown return value type '%s'", [object class], object, valueType );
//                TRAP();
//            }
//                break;
//        }
//    }
//    
//    return __JS__wrap( result );
//}


@interface UIWebView (JSInvocationInner)
@property(nonatomic,assign) JSContext *jsc;
@end

@implementation UIWebView (JSInvocation)

- (void)setJsc:(JSContext *)context{
    objc_setAssociatedObject(self,@selector(jsc),context,OBJC_ASSOCIATION_ASSIGN);
}
- (JSContext *)jsc{
    JSContext *n = objc_getAssociatedObject(self, @selector(name));
    return n;
}


-(void)setJSInvocation{
    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsc = context;
    
    if (context) {
        context[@"__OC_invokeMethod"] = ^id(JSValue *obj, NSString *selectorName, JSValue *arguments, BOOL isSuper) {
            NSLog(@"__OC_invokeMethod");
            return nil;
//            return callSelector(nil, selectorName, arguments, obj, isSuper);
        };
        
    }
    
    
    NSLog(@"11");
}





@end
