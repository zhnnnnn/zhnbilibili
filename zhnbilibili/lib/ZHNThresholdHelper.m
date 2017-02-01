//
//  ZHNThresholdHelper.m
//  ZHNThresholdHelper
//
//  Created by zhn on 16/11/9.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNThresholdHelper.h"
#import "delegateContainer.h"

@interface ZHNThresholdHelper()<UIScrollViewDelegate,UITableViewDelegate>

@property (nonatomic,assign) CGFloat threshold;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger itemPerpage;
@property (nonatomic,copy) reloadAction action;
@property (nonatomic,strong) delegateContainer * container;
// 判断是否正在加载
@property(nonatomic,getter=isloading) BOOL loading;
@end

@implementation ZHNThresholdHelper

- (instancetype)initWithThreshold:(CGFloat)threshold everyLoadAddCount:(NSInteger)addCount contol:(id)control tableView:(UITableView *)tableView reloadAction:(reloadAction)reloadAction{
    if (self = [super init]) {
        self.threshold = threshold;
        self.action = reloadAction;
        self.itemPerpage = addCount;
        delegateContainer * container = [delegateContainer containerDelegateWithFirst:self second:self];
        self.container = container;
        tableView.delegate = (id)container;
    }
    return self;
}
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat current = scrollView.contentOffset.y + scrollView.frame.size.height;
    CGFloat total = scrollView.contentSize.height;
    CGFloat ratio = current / total;
    
    CGFloat needRead = self.itemPerpage * self.threshold + self.currentPage * self.itemPerpage;
    CGFloat totalItem = self.itemPerpage * (self.currentPage + 1);
    CGFloat newThreshold = needRead / totalItem;
    
    if (ratio >= newThreshold && !self.isloading) {
        self.loading = true;
        self.currentPage += 1;
        if (self.action) {
            self.action();
        }
    }
}

- (void)endLoadDatas{
    self.loading = false;
}
@end

