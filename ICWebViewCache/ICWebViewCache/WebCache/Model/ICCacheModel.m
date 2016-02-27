//
//  CacheModel.m
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import "ICCacheModel.h"

@implementation ICCacheModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.response forKey:@"response"];
    [aCoder encodeObject:self.cacheData forKey:@"cacheData"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.response = [aDecoder decodeObjectForKey:@"response"];
        self.cacheData = [aDecoder decodeObjectForKey:@"cacheData"];
        self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
    }
    
    return self;
}



@end
