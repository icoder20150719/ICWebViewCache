//
//  LocalStore.m
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import "ICLocalStore.h"
#import "FMDB.h"

@implementation ICLocalStore
static FMDatabase *_db;
+(void)initialize
{
    //1.获取数据库路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"DB_Path--%@",doc);
    NSString *path = [doc stringByAppendingPathComponent:@"brower.sqlite"];
    //2.得到数据库
    _db = [FMDatabase databaseWithPath:path];
//    NSLog(@"%@",path);
    //3.打开数据库
    if( [_db open]){
//        NSLog(@"打开数据库成功。");
        //4.执行数据库语句创表
        int localStore = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_brower (id integer primary key autoincrement,store_data blob NOT NULL,time_string text NOT NULL,urlString text NOT NULL);"];
        if (localStore) {
//            NSLog(@"创建localStore表成功 。");
        }else{
//            NSLog(@"创建表失败 。");
        }
        
    }else{
        
//        NSLog(@"打开数据库失败。");
    }
    
    
}

+(BOOL)storeData:(NSData *)data withKey:(NSString *)key
{
    if (!key) {
        return NO;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [fmt stringFromDate:[NSDate new] ];

    FMResultSet *resultSet = nil;
    if (key) {
        resultSet = [_db executeQuery:@"select * from t_brower where urlString = ?",key];
    }
    if (resultSet != nil)//数据库中已经存在删除该数据
    {
        NSString *deletSql = [NSString stringWithFormat:@"delete from t_brower where urlString ='%@'",key];
        [_db executeUpdate:deletSql];
    }
    //更新表数据
    ;
    BOOL isUpSuccess = [_db executeUpdate:@"INSERT INTO t_brower (store_data,time_string,urlString)VALUES (?,?,?)",data,dateStr,key];
//    NSLog(@"更新表数据 %d",isUpSuccess);
    return isUpSuccess;

}
+(NSData *)localStoreData:(NSString *)key{
    //1.根据请求参数查询数据
       FMResultSet *resultSet = nil;
    NSString *sql = [NSString stringWithFormat:@"select * from t_brower where urlString = '%@'",key];
    resultSet = [_db executeQuery:sql];\
    NSMutableArray *itemArray = [NSMutableArray array];
    //遍历查询结果
    while (resultSet.next) {
        NSData *data = [resultSet objectForColumnName:@"store_data"];
        [itemArray insertObject:data atIndex:0];
    }
    
    if (itemArray.count > 0) {
        return itemArray[0];
    }else{
        return nil;
    }
    
}
+(BOOL)clearLocalStore{
        
    NSString *deletSql = [NSString stringWithFormat:@"delete from t_brower" ];
    return  [_db executeUpdate:deletSql];
}


@end
