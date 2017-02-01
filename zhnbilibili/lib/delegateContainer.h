//
//  delegateContainer.h
//  runtime消息转发
//
//  Created by zhn on 16/4/11.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface delegateContainer : NSObject<UIScrollViewDelegate>

@property (nonatomic,weak) id firstDelegate;

@property (nonatomic,weak) id secondDelegate;

+ (instancetype)containerDelegateWithFirst:(id)firstDelegate second:(id)secondDelegate;

@end
