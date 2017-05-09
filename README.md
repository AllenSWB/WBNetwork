# WBNetwork
iOS 网络请求库、基于AFN3、链式调用

###一款基于 AFN3.0 封装链式风格的网络请求库 

####特性：
1. 网络请求用的 AFNetworking
2. block 回调方式
3. 集约式的请求方法，链式调用
4. 快速请求同一个 API 时，可以通过设置 minRequestInterval 防止这种情况发生。如果两次请求时间间隔小于 minRequestInterval ，直接从缓存文件拿取数据。(如果对数据即时性要求较高，设置 minRequestInterval 为 0 关闭此功能)
5. 可以同时发起多个请求，全部请求完成后又一个block回调，传回来一个Dictionary。字典key是请求的链接，value是成功返回的数据data或者错误error
6. 可以设置请求的默认参数。
7. 两个baseURL，一个测试环境，一个正式环境。
8. 简单数据处理：可以选择交付给业务层三种数据类型: NSDictionary(默认)、NSString、NSData
9. Loading HUD 是否显示

####使用示例

        
        /**
	     * 1. 在合适的地方设置默认参数, 例如AppDelegate中didFinishLaunch方法
	     */
	     //设置好baseUrl,发起请求的时候就可以写部分URL。例如：url(@"/user/login")
	    WBREQUEST.baseUrlDebug = @"http://www.debug.com";//测试环境baseURL
	    WBREQUEST.baseUrlRelease = @"http://www.release.com";//正式环境baseURL
	    //默认请求参数,发起请求的时候可以不调用parameters方法，或者传入除了默认参数之外的其他参数。
	    WBREQUEST.defaultParameters = @{@"appid":@"",@"appPass":@""};//访问服务器的账号和密码。
	    //是否使用缓存，默认YES
	    WBREQUEST.cacheData = NO;
	    //发起同一请求最小时间间隔，默认1s
	    WBREQUEST.minRequestInterval = 2;
	    
	    /**
	     * 2. 发起一个请求. 最简单可以调用url success startRequest三个方法就可以发起一个请求.
	     */
	    WBREQUEST.url(@"/user/login").parameters(@{@"phone":@"136********",@"passwd":@""}).success(^(NSURLSessionDataTask *task, id responsedObj){
	        WBLog(@"登录成功");
	    }).failure(^(NSURLSessionDataTask *task, NSError *error){
	        WBLog(@"登录失败");
	    }).showTextHUD(YES, @"正在登录...").startRequest();

	    /**
	     *  同时发起多个请求
	     */
	    WBREQUEST.batchRequestTypes(@[WBPOST,WBPOST,WBPOST]).batchUrls(@[url0,url1,url2]).batchParameters(@[@{},@{},@{}]).batchRequestDone(^(NSDictionary *dic) {
	    
	        WBLog(@"======================\ndic is %@\n================================",dic);
	        
	        for (id obj in dic.allValues) {
	            if ([obj isKindOfClass:[NSError class]]) {
	                WBLog(@"obj 出现了\n有错!");
	            } else {
	                WBLog(@"obj 出现了\n数据:%@",obj);
	            }
	        }
	        
	    }).startBatchRequest();

####简书地址
[悟空没空](http://www.jianshu.com/p/1329d863ee5d)

