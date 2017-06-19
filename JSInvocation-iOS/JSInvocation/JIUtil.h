//
//  JSInvocationUtil.h
//  JSInvocationDemo
//
//  Created by Awhisper on 2017/6/18.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JI_LOG(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#define JI_ASSERT(condition, desc)	 NSCAssert(condition, desc)

#define JI_INFO JI_LOG
#define JI_ERROR(fmt, ...)  JI_LOG((fmt), ##__VA_ARGS__) ;\
                            JI_ASSERT(NO,([NSString stringWithFormat:(fmt), ##__VA_ARGS__]))


@interface JIUtil : NSObject

@end
