# ICWebViewCache
一个简单而又方便的本地缓存webView内容，提高访问速度，节省用户流量。


###用法
#1、导入libsqlite3.0.tbd 动态库
#2、导入头文件 #import "ICWebViewCache.h"
#3、设置缓存
<pre>
//缓存加载的网页
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//设置缓存参数
ICWebViewCache *webViewCache = [ICWebViewCache sharedCache];
webViewCache.cacheRequset = YES;//设置缓存request
webViewCache.cacheExpireTime = 24*60*60;//缓存过期时间默认为一天

[self.webView loadRequest:request];
</pre>
#4、注意事项
在使用完webView一定要取消缓存请求
<pre>
#warning  一定要实现此方法 否则会缓存程序中其他请求
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//取消缓存程序请求
[[ICWebViewCache sharedCache] cancelCache];

}
</pre>

#5、如果您有更好方法或者发现bug
请联系qq：1209996080

