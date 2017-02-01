//
//  ZHNThresholdHelper.h
//  ZHNThresholdHelper
//
//  Created by zhn on 16/11/9.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^reloadAction)();
@interface ZHNThresholdHelper : NSObject
/**
 初始化helper的方法 （addcout需要和reloadaction里面添加的个数相等）
 
 @param threshold 加载的百分比
 @param addCount 每次加载数据的个数
 @param reloadAction 刷新的方法
 @return helper
 */
- (instancetype)initWithThreshold:(CGFloat)threshold everyLoadAddCount:(NSInteger)addCount contol:(id)control tableView:(UITableView *)tableView reloadAction:(reloadAction)reloadAction;

/**
 结束刷新的时候需要调用（必须要调用一下这个方法也就是reloadAction里结束的时候需要调用一下）
 */
- (void)endLoadDatas;
@end
