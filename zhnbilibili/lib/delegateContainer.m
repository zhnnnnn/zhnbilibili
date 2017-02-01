//
//  delegateContainer.m
//  runtime消息转发
//
//  Created by zhn on 16/4/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "delegateContainer.h"

@implementation delegateContainer

+ (instancetype)containerDelegateWithFirst:(id)firstDelegate second:(id)secondDelegate{
    
    
    delegateContainer * container  =  [[delegateContainer alloc]init];
    container.firstDelegate = firstDelegate;
    container.secondDelegate = secondDelegate;
    
    return container;
}



- (void)forwardInvocation:(NSInvocation *)anInvocation{

    if ([self.firstDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.firstDelegate];
    }
    
    if ([self.secondDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.secondDelegate];
    }
}

// 这个方法先执行，需要方法的签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
      
    NSMethodSignature * firstMethodSignature = [self.firstDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature * secondMethodSignature = [self.secondDelegate methodSignatureForSelector:aSelector];
        
    if (firstMethodSignature) {
        return firstMethodSignature;
    }else if(secondMethodSignature){
        return secondMethodSignature;
    }return nil;

}
// 一般代理方法都是[delegate respondsToSelector] 如果没这个方法就不执行下面的方法(如果没有实现就卡在这里没有下面转发的事情了)
- (BOOL)respondsToSelector:(SEL)aSelector{
    if([self.firstDelegate respondsToSelector:aSelector] || [self.secondDelegate respondsToSelector:aSelector]){// 一般代理方法都是[delegate respondsToSelector]
        return YES;
    } else {
        return NO;
    }
}

@end
