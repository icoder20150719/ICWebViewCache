//
//  ICWebViewCache.h
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICWebViewCache : NSObject

/*是否缓存该request*/
@property (nonatomic ,assign,getter=isCacheRequest) BOOL cacheRequset;
/*  缓存过期时间
 *  时间秒
 *  默认一天为：24*60*60s
 */
@property (nonatomic ,assign) NSTimeInterval cacheExpireTime;
/*单利*/
+(instancetype)sharedCache;
/*取消缓存*/
-(void)cancelCache;

@end
