//
//  ViewController.m
//  缓存webView用NSURLProtocol
//
//  Created by andy  on 16/2/26.
//  Copyright © 2016年 andy . All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "ICWebViewCache.h"

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置webView的代理
    self.webView.delegate = self;
    //缓存加载的网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    //设置缓存参数
    ICWebViewCache *webViewCache = [ICWebViewCache sharedCache];
    webViewCache.cacheRequset = YES;//设置缓存request
    webViewCache.cacheExpireTime = 24*60*60;//缓存过期时间默认为一天
    
    [self.webView loadRequest:request];
    
                    /*测试是否影响程序中其他请求*/
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userName"] = @"lakecloud001";
//    params[@"password"] = @"123456";
//
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    [mgr POST:@"http://api.mipopos.com/pos/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    
    
}


#warning  一定要实现此方法 否则会缓存程序中其他请求
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //取消缓存程序请求
    [[ICWebViewCache sharedCache] cancelCache];

}


@end
