//
//  UIView+extendTouchSize.m
//  swizzing
//
//  Created by zhn on 16/4/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "UIView+extendTouchSize.h"
#import <objc/runtime.h>


void swizzingMethod(Class class,SEL orig,SEL new){
    
    Method origMethod = class_getInstanceMethod(class, orig);
    Method newMethod = class_getInstanceMethod(class, new);
    
    if (class_addMethod(class, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }

}
static const NSString *edgeInsetsKey = @"edgeinsetKey";
@implementation UIView (extendTouchSize)

+(void)load{
    
    swizzingMethod([self class], @selector(pointInside:withEvent:), @selector(myPointInside:withEvent:));
    
}

- (BOOL)myPointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchEdgeInsets, UIEdgeInsetsZero)||self.hidden||([self isKindOfClass:[UIControl class]] && !((UIControl *)self).enabled)) {// 不需要响应时间的情况
        [self myPointInside:point withEvent:event];// 不是递归 方法交换了
    }
    
    CGRect hitRect = UIEdgeInsetsInsetRect(self.bounds, self.touchEdgeInsets);
    hitRect.size.width  = MAX(hitRect.size.width, 0);// 防止宽度是赋值报错
    hitRect.size.height = MAX(hitRect.size.height, 0);
    return CGRectContainsPoint(hitRect, point);
}



// category @property不会知道生成setter getter方法要手动写
- (void)setTouchEdgeInsets:(UIEdgeInsets)touchEdgeInsets{
    objc_setAssociatedObject(self, (__bridge const void *)(edgeInsetsKey), [NSValue valueWithUIEdgeInsets:touchEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)touchEdgeInsets{
    return [objc_getAssociatedObject(self, (__bridge const void *)(edgeInsetsKey)) UIEdgeInsetsValue];
}




@end
