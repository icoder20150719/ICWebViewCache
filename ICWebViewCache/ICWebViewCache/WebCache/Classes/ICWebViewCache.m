//
//  ICWebViewCache.m
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import "ICURLPotocol.h"
#import "ICWebViewCache.h"

@implementation ICWebViewCache
+(instancetype)sharedCache{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        //注册自己的协议类
        [NSURLProtocol registerClass:[ICURLPotocol class]];
    });
    return instance;
}
-(void)cancelCache
{
    self.cacheRequset = NO;
    self.cacheExpireTime = 0;
}
@end
