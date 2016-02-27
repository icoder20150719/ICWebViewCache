//
//  CustomURLPotocol.m
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import "ICURLPotocol.h"
#import "ICLocalStore.h"
#import "ICCacheModel.h"
#import "NSString+ic_MD5.h"
#import "ICWebViewCache.h"



static NSString *URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface ICURLPotocol ()<NSURLConnectionDataDelegate>

@property (nonatomic ,strong)NSURLConnection *connection;

@property (nonatomic ,strong)NSMutableData *responesData;

@property (nonatomic ,strong)ICCacheModel *cache;

@end
@implementation ICURLPotocol

+(void)initialize
{
    [super initialize];
    [ICLocalStore clearLocalStore];
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //防止循环处理
    
    ICWebViewCache *webViewCache = [ICWebViewCache sharedCache];
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
        return  NO;
        //需要缓存并且有缓存过期时间
        
    }else if(webViewCache.isCacheRequest && webViewCache.cacheExpireTime >0){
        return  YES;
    }else {
        return NO;
    }
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    [NSURLProtocol setProperty:@(YES)
                        forKey:URLProtocolHandledKey
                     inRequest:mutableReqeust];
    
    //从缓存里面获取数据
    NSData *data = [ICLocalStore localStoreData:[mutableReqeust.URL.absoluteString md5]];
    if (data > 0) {
        ICCacheModel *cache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //缓存数据有 and 没有过期
       
        if(cache.cacheData.length > 0 && [cache.expireTime compare:[NSDate dateWithTimeIntervalSinceNow:0]] == NSOrderedDescending){
            [[self client] URLProtocol:self didReceiveResponse:cache.response
                                               cacheStoragePolicy:NSURLCacheStorageNotAllowed]; // we handle caching ourselves.
            
            [[self client] URLProtocol:self didLoadData:cache.cacheData];
            
            [[self client] URLProtocolDidFinishLoading:self];

        }
    }else{
       //网络请求
     self.connection = [NSURLConnection connectionWithRequest:mutableReqeust
                                                        delegate:self];
    }
    
}
- (void)stopLoading
{
    [self.connection cancel];
    self.connection = nil;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.responesData = [NSMutableData data];
    self.cache = [[ICCacheModel alloc]init];
    self.cache.response = response;
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responesData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
    //保存数据
    self.cache.cacheData = self.responesData;
    ICWebViewCache *webViewCache = [ICWebViewCache sharedCache];
    
    self.cache.expireTime = [NSDate dateWithTimeIntervalSinceNow:webViewCache.cacheExpireTime];
//    NSLog(@"%@",self.cache.expireTime);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cache];
    [ICLocalStore storeData:data withKey:[connection.currentRequest.URL.absoluteString md5]];
}

@end
