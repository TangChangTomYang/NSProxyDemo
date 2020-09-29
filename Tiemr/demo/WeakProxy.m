//
//  WeakProxy.m
//  Tiemr
//
//  Created by edz on 2020/9/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "WeakProxy.h"
#import "YRTableView.h"



@implementation WeakProxy

/** 注意:
 - NSProxy 存在的意义就是用来解决定时器这类 循环强引用的
 - NSProxy 本来就是设计来做消息转发的
 
 
 */

+(instancetype)proxyWithTarget:(id)target{
    // 注意一点, NSProxy 不需要init, 直接alloc 后就能用
    WeakProxy *proxy = [WeakProxy alloc];
    proxy.target = target;
    return proxy;
}

+(BOOL)respondsToSelector:(SEL)aSelector{
    NSLog(@"");
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = [YRTableView count];
    NSLog(@"count: %ld", count);
    if ([tableView isKindOfClass:[YRTableView class]] && count < 5) {
        NSLog(@"proxy 拦截 didSelectRowAtIndexPath");
        [YRTableView countPlus];
        return;
    }
    if ([self.target respondsToSelector:@selector(tableView:didSelectRowAtIndexPath: )]) {
        [self.target tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
     
}
 



 


// 因为 NSProxy 本来就是设计来做消息转发的, 所以一旦调用 target 的方法
// 就会来到 -(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
// 因为 NSProxy 仅仅是做消息转发, 我们这里只需要将 sel 在 target 中对应的方法签名返回出去即可
// 这样, 消息就被转发到了 -(void)forwardInvocation:(NSInvocation *)invocation
// 我们在 -(void)forwardInvocation:(NSInvocation *)invocation 中调用target的方法即可
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    // 返回指定 对象的方法签名, 由指定对象 去处理这个方法的执行
    return  [self.target methodSignatureForSelector:sel];
}

-(void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}

-(void)dealloc{
    NSLog(@"%s", __func__);
}

// 很遗憾在 NSProxy 中没有 forwardingTargetForSelector:(SEL)aSelector; 方法
@end


/**
NSProxy 代理的使用总结:
 
 我们可以使用 NSProxy 来实现 对任何对象的任何方法的钩子
 
 使用步骤:
 1. 定义一个 weak 引用的 target 来引用需要 钩子的对象
 2. 需要 给 target 对象的那个方法实现 钩子功能就实现那个方法
 3. 不需要 钩子的方法, 全部使用 methodSignatureForSelector 和 forwardInvocation 在转回去即可
 
 
 
 // 这个就是对OC 中方法调用的三大阶段的 使用
 // 1阶段 消息发送
 // 2阶段 动态方法解析( 可以动态的添加方法)
 // 3阶段 消息转发, 将方法调用转移给 特定的对象来执行
 */
