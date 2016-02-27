//
//  CacheModel.h
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICCacheModel : NSObject<NSCoding>

@property (nonatomic,strong)NSData *cacheData;
@property (nonatomic,strong)NSURLResponse *response;
@property (nonatomic,strong)NSDate *expireTime;

@end
