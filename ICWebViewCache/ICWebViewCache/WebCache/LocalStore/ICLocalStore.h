//
//  LocalStore.h
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICLocalStore : NSObject
/*
 * 保存数据
 */
+(BOOL)storeData:(NSData *)data withKey:(NSString *)key;
/*
 * 获取本地数据
 */
+(NSData*)localStoreData:(NSString *)key;
/*
 * 清除本地所有数据
 */
+(BOOL)clearLocalStore;

@end
