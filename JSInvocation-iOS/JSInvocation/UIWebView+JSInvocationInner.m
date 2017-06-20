//
//  UIWebView+JSInvocationInner.m
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/19.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "UIWebView+JSInvocationInner.h"
#import <objc/runtime.h>
#import "JIUtil.h"
#import "JITypeUtil.h"

@implementation UIWebView (JSInvocationInner)

- (void)setJsc:(JSContext *)context{
    objc_setAssociatedObject(self,@selector(jsc),context,OBJC_ASSOCIATION_ASSIGN);
}
- (JSContext *)jsc{
    JSContext *n = objc_getAssociatedObject(self, @selector(jsc));
    return n;
}

-(void)setJscMemory:(NSMutableDictionary *)jscMemory{
    objc_setAssociatedObject(self,@selector(jscMemory),jscMemory,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)jscMemory{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(jscMemory));
    return dic;
}


-(void)clearJscMemory{
    if (self.jscMemory) {
        [self.jscMemory removeAllObjects];
    }else{
        self.jscMemory = [[NSMutableDictionary alloc]init];
    }
}


#pragma mark - 

- (BOOL)__JI_isNil:(NSDictionary *)dict{
    if ( [dict objectForKey:@"__nil__"] )
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

- (id)__JI_genNil{
    static NSDictionary *	value;
    static dispatch_once_t	once;
    
    dispatch_once( &once, ^{
        value = @{ @"__nil__" : @"__nil__" };
    });
    
    return value;
}

- (BOOL)__JI_isObj:(NSDictionary *)dict{
    if ( [dict objectForKey:@"__obj__"] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (id)__JI_getObj:(NSDictionary *)dict{
    NSString *hashkey = [dict objectForKey:@"__obj__"];
    if (hashkey && hashkey.length > 0) {
        id obj = [self.jscMemory objectForKey:hashkey];
        return obj;
    }
    return nil;
}

- (id)__JI_genObj:(id)object{
    if (object) {
        NSUInteger hash = [object hash];
        NSString *className = NSStringFromClass([object class]);
        NSString *hashkey = [NSString stringWithFormat:@"__JSCMemory_%@_%@",className,@(hash)];
        [self.jscMemory setObject:object forKey:hashkey];
        
        return @{ @"__obj__" : hashkey, @"__cls__" : className };
    }
    return nil;
}


- (id)__JI__wrap:(NSObject *)object{
    if ( nil == object )
    {
        return [self __JI_genNil];
    }
    
    JIClassType objectType = [JITypeUtil classTypeOfObject:object];
    
    if ( JIClassType_NSNULL == objectType )
    {
        return [self __JI_genNil];
    }
    else if ( JIClassType_NSNumber == objectType )
    {
        return object;	// primitive
    }
    else if ( JIClassType_NSString == objectType )
    {
        return object;	// primitive
    }
    else if ( JIClassType_NSDate == objectType )
    {
        return [self __JI_genObj:object];
    }
    else if ( JIClassType_NSData == objectType )
    {
        return [self __JI_genObj:object];
    }
    else if ( JIClassType_NSURL == objectType )
    {
        return [self __JI_genObj:object];
    }
    else if ( JIClassType_NSArray == objectType )
    {
        NSMutableArray * result = [NSMutableArray array];

        for ( NSObject * elem in (NSArray *)object )
        {
            id wrapItem = [self __JI__wrap:elem];
            [result addObject:wrapItem];
        }

        return result;
    }
    else if ( JIClassType_NSDictionary == objectType )
    {
        NSMutableDictionary * result = [NSMutableDictionary dictionary];

        for ( NSString * key in (NSDictionary *)object )
        {
            NSObject * value = [(NSDictionary *)object objectForKey:key];
            id wrapItem = [self __JI__wrap:value];
            [result setObject:wrapItem forKey:key];
        }

        return result;
    }
    else if ( JIClassType_NSSet == objectType )
    {
        NSMutableArray * result = [NSMutableArray array];

        for ( NSObject * elem in (NSSet *)object )
        {
            id wrapItem = [self __JI__wrap:elem];
            [result addObject:wrapItem];
        }

        return result;
    }
    //    else if ( ClassType_NSBlock == objectType )
    //    {
    //        return __JS__makeObj( [object copy] );
    //    }
    //    else
    //    {
    //        return __JS__makeObj( object );
    //    }
    return nil;
}

- (id)__JI_unwrap:(NSObject *)object{
    if ( nil == object )
    {
        return nil;
    }
    
    JIClassType objectType = [JITypeUtil classTypeOfObject:object];
    
    if ( JIClassType_NSNULL == objectType )
    {
        return nil;
    }
    else if ( JIClassType_NSNumber == objectType )
    {
        return object;
    }
    else if ( JIClassType_NSString == objectType )
    {
        return object;
    }
    else if ( JIClassType_NSDate == objectType )
    {
        return object;
    }
    else if ( JIClassType_NSData == objectType )
    {
        return object;
    }
    else if ( JIClassType_NSURL == objectType )
    {
        return object;
    }
    else if ( JIClassType_NSArray == objectType )
    {
        NSMutableArray * result = [NSMutableArray array];

        for ( NSObject * elem in (NSArray *)object )
        {
            id unwrapItem = [self __JI_unwrap:elem];
            [result addObject:unwrapItem];
        }

        return result;
    }
    else if ( JIClassType_NSDictionary == objectType )
    {
        
        if ([self __JI_isNil:(NSDictionary *)object])
        {
            return nil;
        }
        else if ([self __JI_isObj:(NSDictionary *)object])
        {
            return [self __JI_getObj:(NSDictionary *)object];
        }
        else
        {
            NSMutableDictionary * result = [NSMutableDictionary dictionary];

            for ( NSString * key in (NSDictionary *)object )
            {
                NSObject * value = [(NSDictionary *)object objectForKey:key];
                id unwrapItem = [self __JI_unwrap:value];
                [result setObject:unwrapItem forKey:key];
            }

            return result;
        }
    }
    else if ( JIClassType_NSSet == objectType )
    {
        NSMutableSet * result = [NSMutableSet set];

        for ( NSObject * elem in (NSSet *)object )
        {
            id unwrapItem = [self __JI_unwrap:elem];
            [result addObject:unwrapItem];
        }

        return result;
    }
    //    else if ( ClassType_NSBlock == objectType )
    //    {
    //        return [object copy];
    //    }
    //    else
    //    {
    //        return object;
    //    }
    return nil;
}



@end
