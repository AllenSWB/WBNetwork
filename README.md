# WBNetwork
iOS 网络请求库、基于AFN3、链式调用

####特性：
1. 网络请求用的 AFNetworking
2. block 回调方式
3. 集约式的请求方法，链式调用
4. 快速请求同一个 API 时，可以通过设置 minRequestInterval 防止这种情况发生。如果两次请求时间间隔小于 minRequestInterval ，直接从缓存文件拿取数据。(如果对数据即时性要求较高，设置 minRequestInterval 为 0 关闭此功能)
5. 可以设置默认参数。eg: 服务器访问需要账号密码，每个接口都有这两个参数，可以将其设置为默认参数
6. 简单数据处理：可以选择交付给业务层三种数据类型: NSDictionary(默认)、NSString、NSData
7. Loading HUD 是否显示

####使用示例

        //默认参数
        WBREQUEST.defaultParameters = @{@"appid":@"000",@"appselect":@"00000"};
        //开始一个请求
        WBREQUEST.url([GlobalPort getVerifyCodeAPI]).parameters(@{@"mobile":@"136********"}).success(^(NSURLSessionDataTask *task, id responsedObj) {
            //成功回调
        }).showHUD(YES).startRequest();

