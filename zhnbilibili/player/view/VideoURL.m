//
//  VideoURL.m
//  bilibili fake
//
//  Created by 翟泉 on 2016/8/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "VideoURL.h"

NSMutableArray<VideoURL *> *__Queue;

@interface VideoURL ()
<NSURLSessionTaskDelegate>
{
    NSInteger _aid;
    NSInteger _cid;
    NSInteger _page;
    void (^_completionBlock)(NSURL *);
    
    NSURLSession *_session;
}
@end

@implementation VideoURL


+ (void)getVideoURLWithAid:(NSInteger)aid cid:(NSInteger)cid page:(NSInteger)page completionBlock:(void (^)(NSURL *))completionBlock {
    
    if (!__Queue) {
        __Queue = [NSMutableArray array];
    }
    
    VideoURL *operation = [[VideoURL alloc] initWithAid:aid cid:cid page:page completionBlock:completionBlock];
    
    if ([__Queue count] == 0) {
        [__Queue addObject:operation];
        [operation getVideoURLMode1];
    }
    else {
        [__Queue addObject:operation];
    }
    
}

+ (VideoURL *)currentOperation {
    return __Queue.firstObject;
}

- (instancetype)initWithAid:(NSInteger)aid cid:(NSInteger)cid page:(NSInteger)page completionBlock:(void (^)(NSURL *))completionBlock {
    self = [super init];
    if (!self) {
        return NULL;
    }
    _aid = aid;
    _cid = cid;
    _page = page;
    _completionBlock = [completionBlock copy];
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)completionWithURL:(NSURL *)url {
    _session = NULL;
    _completionBlock ? _completionBlock(url) : NULL;
    _completionBlock = NULL;
    [__Queue removeObject:self];
    [__Queue.firstObject getVideoURLMode1];
}

#pragma mark - 方法1

- (void)getVideoURLMode1 {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.bilibilijj.com/Files/DownLoad/%ld.mp4/www.bilibilijj.com.mp4?mp3=true", _cid]];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *downloadTask;
    downloadTask = [_session dataTaskWithRequest:request];
    [downloadTask resume];
}

#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    [task cancel];
    [_session finishTasksAndInvalidate];
    [self completionWithURL:request.URL];
}


@end
