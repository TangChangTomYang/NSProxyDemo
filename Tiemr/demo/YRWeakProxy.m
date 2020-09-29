//
//  YRWeakProxy.m
//  Tiemr
//
//  Created by edz on 2020/9/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "YRWeakProxy.h"

@implementation YRWeakProxy

+(instancetype)proxyWithTarget:(id)target{
    YRWeakProxy *proxy = [[YRWeakProxy alloc] init];
    proxy.target = target;
    return  proxy;
}

//消息转发一共有三个方法
//-(id)forwardingTargetForSelector:(SEL)aSelector
//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//-(void)forwardInvocation:(NSInvocation *)anInvocation


// 使用消息转发机制, 将方法转发出去
-(id)forwardingTargetForSelector:(SEL)aSelector{
//    错误做法
//    if ([self.target respondsToSelector:aSelector]) {
//        return self.target;
//    }
//    return  [super forwardingTargetForSelector:aSelector];;
    
//    正确做法, 直接返回target, 这样当target中没有实现对应方法时才知道报错, target 中没有对应的方法, 我们就在 target 中添加即可 
    return self.target;
}


 


@end
