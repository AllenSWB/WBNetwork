# WBNetwork
iOS 网络请求库、基于AFN3、链式调用

###一款基于 AFN3.0 封装链式风格的网络请求库 

####特性

1. 网络请求用的 AFNetworking
2. block 回调方式
3. 集约式的请求方法，链式调用
4. 快速请求同一个 API 时，可以通过设置 minRequestInterval 防止这种情况发生。如果两次请求时间间隔小于 minRequestInterval ，直接从缓存文件拿取数据。(如果对数据即时性要求较高，设置 minRequestInterval 为 0 关闭此功能)
5. 可以同时发起多个请求，全部请求完成后有一个 block 回调，传回来一个 Dictionary。字典 key 是请求的链接，value 是成功返回的数据 data 或者错误 error。
6. 可以设置请求的默认参数。
7. 两个 baseURL，一个测试环境，一个正式环境。
8. 简单数据处理：可以选择交付给业务层三种数据类型: NSDictionary(默认)、NSString、NSData
9. 定义了一个插件机制。eg：加入 HUD 插件

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

        //添加HUD插件
	    [WBREQUEST wb_addPlugIn:[WBReqeustHUDPlugIn new]];

	    
	    /**
	     * 2. 发起一个请求. 最简单可以调用url success startRequest三个方法就可以发起一个请求.
	     */
	    WBReqeustHUDPlugIn *plugIn = (WBReqeustHUDPlugIn *)[WBREQUEST plugInWithIdentifier:@"hud"];//hud插件
	    plugIn.HudInView = self.view;//可以选择将hud加在self.view上而非window上
	    plugIn.HudText = @"正在登录...";

	    //网络请求
	    WBREQUEST.url(@"/user/login").parameters(@{@"phone":@"136********",@"passwd":@""}).success(^(NSURLSessionDataTask *task, id responsedObj){
	        WBLog(@"登录成功");
	    }).failure(^(NSURLSessionDataTask *task, NSError *error){
	        WBLog(@"登录失败");
	    }).startRequest();

	    /**
	     * 3. 同时发起多个请求
	     */
	    WBReqeustHUDPlugIn *plugIn = (WBReqeustHUDPlugIn *)[WBREQUEST plugInWithIdentifier:@"hud"];
	    plugIn.isPlugInFree = YES; // 让插件失效

	    WBREQUEST.batchRequestTypes(@[WBPOST,WBPOST,WBPOST]).batchUrls(@[url0,url1,url2]).batchParameters(@[@{},@{},@{}]).batchRequestDone(^(NSDictionary *dic) {
	    
	    	//记得请求完成奖插件恢复能用
	        plugIn.isPlugInFree = NO;

	        WBLog(@"======================\ndic is %@\n================================",dic);
	        
	        for (id obj in dic.allValues) {
	            if ([obj isKindOfClass:[NSError class]]) {
	                WBLog(@"obj 出现了\n有错!");
	            } else {
	                WBLog(@"obj 出现了\n数据:%@",obj);
	            }
	        }
	        
	    }).startBatchRequest();

####编码过程中的思考

1. 网络请求可以用 NSURLSession 或者 AFNetworking。方便起见，用了 AFNetworking
2. 回调方式可以用 delegate 或者 block。为了使用方便就用了block。
		//回调时，把一个block作为参数，所以这里没法自动生成格式，得手写。使用过程中可以拖到代码块以提高效率，就像 dispatch_once 也是写成了代码块
		success(^(NSURLSessionDataTask *task, id responsedObj){
	        WBLog(@"登录成功");
	    })
3. 请求方式可以用集约式或者离散式。同样是方便起见，选择了集约式的请求方式。YTKNetwork 是离散式请求方式，适用于大型项目。
4. 方便起见，使用链式调用。可以设置baseUrl、默认参数等。最少可以用三个方法发起一个请求: url、success、startRequest。
5. 为了防止快速连续的请求同一个接口。可以设置 minRequestInterval, 默认值是1s。就是说一秒内向一个接口发起两次请求，第二次并不会真正发起请求，而是从缓存拿取数据。判断时间间隔实用的是缓存文件的'最后修改时间'。
6. 同时发起好几个请求时候，因为WBRequest是个单例，所以可能出现回调错乱的情况发生，为了解决这个问题，加了个recorder数组。每一个请求对应一个recorder，recorder持有success回调、failure回调，这样回调就不会找错了。
7. 在A页面发起一个请求，成功回调里面使用了 self，请求没有完成时候用户就点了返回键。这时候A并不会 delloc，而是等待接口请求成功/失败后，走完回调方法才 delloc。这个功能实现是每次发起一个请求时候，就会创建一个 recorder 去持有 url、parameters、success 回调、failure 回调等。请求完成后会把这个 recorder 置 nil。
8. 每发起一个请求前，检查网络状况，没网就直接提示用户。
9. 简单的格式处理，可以直接返回给业务层三种数据类型：NSData、NSDictionary、NSString
10. 缓存使用归档，每个请求的数据写成一个文件。

####Github地址

[WBNetwork](https://github.com/AllenSWB/WBNetwork)

####简书地址

[悟空没空](http://www.jianshu.com/p/1329d863ee5d)

####送上一个代码块 ^^

	 WBREQUEST.url(<#NSString * url#>).parameters(<#NSDictionary * parameters#>).success(^(NSURLSessionDataTask * task,id responseObject){
     <#code#>
    }).startRequest();
