//
//  WBRequest.m
//  SnakeChainNetwork
//
//  Created by sun on 2017/4/18.
//  Copyright © 2017年 sun. All rights reserved.
//

#import "WBRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>


/**
 请求记录器
 */
@interface WBRequestRecorder : NSObject
@property (strong, nonatomic) NSURLSessionDataTask *rr_task;
@property (assign, nonatomic) WBRequestType rr_requestType;
@property (strong, nonatomic) NSString *rr_url;
@property (strong, nonatomic) NSDictionary *rr_parameters;
@property (copy, nonatomic) WBSuccess rr_success;
@property (copy, nonatomic) WBFailure rr_failure;
@property (strong, nonatomic) NSString *rr_cachePath;
//@property (copy, nonatomic) WBProgress rr_progress;

@end

@implementation WBRequestRecorder

@end


@interface WBRequest ()

@property (strong, nonatomic) AFHTTPSessionManager *wb_AFManager;

//
@property (strong, nonatomic) NSArray *wb_batchRequestTypes;
@property (strong, nonatomic) NSArray *wb_batchUrls;
@property (strong, nonatomic) NSArray *wb_batchParamters;
@property (copy, nonatomic) WBBatchRequestDone wb_batchRequestDone;
@property (strong, nonatomic) NSMutableArray *wb_batchRecorderArray;
//完成请求之后的{@"url":@"data"} {@"url",@"error"}
@property (strong, nonatomic) NSMutableDictionary *wb_batchDoneRequestDic;

//
@property (assign, nonatomic) WBRequestType wb_requestType;
@property (assign, nonatomic) WBResponseType wb_responseType;
@property (strong, nonatomic) NSString *wb_url;
@property (strong, nonatomic) NSDictionary *wb_parameters;
@property (copy, nonatomic) WBSuccess wb_success;
@property (copy, nonatomic) WBFailure wb_failure;
@property (copy, nonatomic) WBProgress wb_progress;
@property (copy, nonatomic) WBConstructBody wb_constructBody;
@property (assign, nonatomic) BOOL wb_isShowHUD;//是否显示HUD 默认 NO
@property (strong, nonatomic) NSString *wb_loadingHudText;//加载hud文字
@property (strong, nonatomic) NSMutableArray *wb_recorderArray;//请求记录器数组

@end

static WBRequest *wb_request = nil;

@implementation WBRequest

+ (instancetype)sharedWBRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wb_request = [[WBRequest alloc] init];
    });
    return wb_request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //默认属性值
        _wb_requestType = WBRequestPost;
        _wb_responseType = WBResponseDictionary;
        _minRequestInterval = 1;
        _cacheData = YES;
        _defaultParameters = @{};
        _wb_isShowHUD = NO;
        _timeoutInterval = 10;
        

        _wb_AFManager = [AFHTTPSessionManager manager];
        _wb_AFManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _wb_AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _wb_AFManager.requestSerializer.timeoutInterval = _timeoutInterval;
        
    }
    return self;
}

#pragma mark - chain
- (WBRequest *(^)(WBRequestType))requestType {
    return ^(WBRequestType type) {
        _wb_requestType = type;
        return self;
    };
}
- (WBRequest *(^)(NSString *))url {
    return ^(NSString *url) {
        self.wb_url = [self finalUrl:url];
        return self;
    };
}
- (WBRequest *(^)(NSDictionary *))parameters {
    return ^(NSDictionary *para) {
        self.wb_parameters = [self finalParameter:para];
        return self;
    };
}
- (WBRequest *(^)(WBSuccess))success {
    return ^(WBSuccess success) {
        self.wb_success = success;
        return self;
    };
}
- (WBRequest *(^)(WBFailure))failure {
    return ^(WBFailure failure) {
        self.wb_failure = failure;
        return self;
    };
}
- (WBRequest *(^)(WBProgress))progress {
    return ^(WBProgress progress) {
        self.wb_progress = progress;
        return self;
    };
}
- (WBRequest *(^)(BOOL))showHUD {
    return ^(BOOL isShow) {
        _wb_isShowHUD = isShow;
        return self;
    };
}
- (WBRequest *(^)(BOOL, NSString *))showTextHUD {
    return ^(BOOL isShow,NSString *text) {
        _wb_isShowHUD = isShow;
        _wb_loadingHudText = text;
        return self;
    };
}
- (WBRequest *(^)())startRequest {
    return ^() {
        
        //创建recorder
        WBRequestRecorder *recorder = [[WBRequestRecorder alloc] init];
        recorder.rr_requestType = self.wb_requestType;
        recorder.rr_url = self.wb_url;
        recorder.rr_parameters = self.wb_parameters;
        NSString *cachePath = [self pathForCache:recorder.rr_url];
        recorder.rr_cachePath = cachePath;
        [self.wb_recorderArray addObject:recorder];
        
        
        if (_minRequestInterval > 0 && [self timerIntervalOfCache:cachePath] < _minRequestInterval) {
            //去拿缓存
            id data = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
            if (data) {
                if (_wb_success) {
                    WBLog(@"两次请求时间间隔太短，直接从缓存拿数据");
                    _wb_success(nil,data);
                    //没有走请求
                    [self afterRequestThing:recorder];
                }
            }
        } else {
            //默认回调
            [self defaultCallBack];
            if ([self isNetworkReachable]) {
                //开始请求
                [self startRequestAPIWithRecorder:recorder];
            } else {
                WBLog(@"没网啊...")
            }
        }
        
        //恢复默认参数
        if (![_defaultParameters isEqual:@{}]) {//有默认参数
            self.wb_parameters = _defaultParameters;
        } else {
            self.wb_parameters = nil;
        }
       
        return self;
    };
}


- (WBRequest *(^)(WBConstructBody))constructBody {
    
    return ^(WBConstructBody constructBody) {
        _wb_constructBody = constructBody;
        return self;
    };
}

// batch request
- (WBRequest *(^)(NSArray *))batchRequestTypes {
    return ^(NSArray *types) {
        _wb_batchRequestTypes = types;
        return self;
    };
}
- (WBRequest *(^)(NSArray<NSString *> *))batchUrls {
    return ^(NSArray<NSString *> *urls) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (NSString *url in urls) {
            [tempArr addObject:[self finalUrl:url]];
        }
        _wb_batchUrls = tempArr;
        return self;
    };
}
- (WBRequest *(^)(NSArray<NSDictionary *> *))batchParameters {
    return ^(NSArray <NSDictionary *> *paramters) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in paramters) {
            [tempArr addObject:[self finalParameter:dic]];
        }
        _wb_batchParamters = tempArr;
        return self;
    };
}

- (WBRequest *(^)(WBBatchRequestDone))batchRequestDone {
    return ^(WBBatchRequestDone batchDone) {
        _wb_batchRequestDone = batchDone;
        return self;
    };
}

- (WBRequest *(^)())startBatchRequest {
    return ^() {
        
        if (_wb_batchUrls.count == _wb_batchParamters.count && _wb_batchParamters.count != 0) {
            
            NSInteger requestCount = _wb_batchUrls.count;
            [self.wb_batchRecorderArray removeAllObjects];//清空
            
            for (NSInteger i = 0; i < requestCount; i++) {
              //创建recorder
                WBRequestRecorder *recorder = [[WBRequestRecorder alloc] init];
                NSString *typeStr = self.wb_batchRequestTypes[i];
                if ([typeStr isEqualToString:WBPOST]) {
                    recorder.rr_requestType = WBRequestPost;
                } else if ([typeStr isEqualToString:WBGET]) {
                    recorder.rr_requestType = WBRequestGet;
                }
                recorder.rr_url = self.wb_batchUrls[i];
                recorder.rr_parameters = self.wb_batchParamters[i];
                NSString *cachePath = [self pathForCache:recorder.rr_url];
                recorder.rr_cachePath = cachePath;
                [self.wb_batchRecorderArray addObject:recorder];
            }
            
            //不去管缓存了
            
            //请求
            if ([self isNetworkReachable]) {
                for (WBRequestRecorder *recorder in self.wb_batchRecorderArray) {
                    //开始请求
                    [self startRequestAPIWithRecorder:recorder];
                }
            } else {
                WBLog(@"没网啊...")
            }
        }

        return self;
    };
}

#pragma mark - network
- (void)startRequestAPIWithRecorder:(WBRequestRecorder *)recorder {
    
    if (_wb_isShowHUD) {
        [self showLoadingHUD];
    }
    
    NSURLSessionDataTask *task;
    
    switch (recorder.rr_requestType) {//_wb_requestType
        case WBRequestPost:
        {
            task = [_wb_AFManager POST:recorder.rr_url parameters:recorder.rr_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
                if (_wb_progress) {
                    _wb_progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self requestSuccessComplete:task obj:responseObject cachePath:recorder.rr_cachePath];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestFailureHandler:task error:error];
                
            }];
        }
            break;
        case WBRequestGet:
        {
            task = [_wb_AFManager GET:recorder.rr_url parameters:recorder.rr_parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
                if (_wb_progress) {
                    _wb_progress(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self requestSuccessComplete:task obj:responseObject cachePath:recorder.rr_cachePath];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestFailureHandler:task error:error];
            }];
        }
            break;
        case WBRequestUpload:
        {
            task = [_wb_AFManager POST:recorder.rr_url parameters:recorder.rr_parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (_wb_constructBody) {
                    _wb_constructBody(formData);
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (_wb_progress) {
                    _wb_progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestSuccessComplete:task obj:responseObject cachePath:recorder.rr_cachePath];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestFailureHandler:task error:error];
            }];
        }
            break;
        default:
            break;
    }
    
    WBLog(@"===========================请求开始========================\n[DataTask:%@]\n[URL:]%@\n[参数:]%@\n===============================\n",task,recorder.rr_url,recorder.rr_parameters);
    
    recorder.rr_success = _wb_success;
    recorder.rr_failure = _wb_failure;
    recorder.rr_task = task;
}

- (void)defaultCallBack {
    
    __weak typeof(self) weakSelf = self;
    if (!_wb_success) {
        _wb_success = ^(NSURLSessionDataTask *task, id responsedObj) {
            
        };
    }
    if (!_wb_failure) {
        _wb_failure = ^(NSURLSessionDataTask *task, NSError *error) {
            WBLog(@"==========================请求失败============================\n[URL:]%@\n[参数:]%@\n[失败原因:]%@\n============================================",weakSelf.wb_url,weakSelf.wb_parameters,error.description);
        };
    }
    if (!_wb_progress) {
        _wb_progress = ^(NSProgress *progress) {
            
        };
    }
}

- (id)responseObj:(id)data {
    id responseObject;
    switch (_wb_responseType) {
        case WBResponseData:
            return data;
            break;
        case WBResponseString:
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return str;
        }
            break;
        case WBResponseDictionary:{
            NSError *err;
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                WBLog(@"\n=====================[解析Data出错:]=================\n%@\n=====================================",err.description);
            }
        }
            break;
        default:
            break;
    }
    return responseObject;
}

/**
 请求成功回调
 */
- (void)requestSuccessComplete:(NSURLSessionDataTask *)task obj:(id)responseObject cachePath:(NSString *)cachePath {
    id data = [self responseObj:responseObject];
    if (_wb_isShowHUD) {
        [self hideLoadingHUD];
    }
    if (_cacheData) {
        BOOL cache = [NSKeyedArchiver archiveRootObject:data toFile:cachePath];
        if (cache) {
            WBLog(@"\n=====================================\n[缓存成功, 缓存路径:]\n%@\n=====================================\n",cachePath);
        } else {
            WBLog(@"缓存失败");
        }
    }
    
    
    WBRequestRecorder *recorder = [self getRecorderfromTask:task];

    if (self.wb_batchRecorderArray.count > 0) {
        //batch 请求
        [self batchDoneActionRecorder:recorder Obj:data];
    } else {
        //正常的请求
        if (recorder && recorder.rr_success) {
            recorder.rr_success(task, data);
            
            WBLog(@"===================================请求成功===================\n[DataTask:%@]\n[URL:]%@\n[数据:]%@\n==========================================\n",task,recorder.rr_url,data);
        }
        [self afterRequestThing:recorder];
    }
    
    
    
    
}

/**
 请求失败回调
 */
- (void)requestFailureHandler:(NSURLSessionDataTask *)task error:(NSError *)error {
    if (_wb_isShowHUD) {
        [self hideLoadingHUD];
    }
    
    WBRequestRecorder *recorder = [self getRecorderfromTask:task];
    
    if (self.wb_batchRecorderArray.count > 0) {
        //batch 请求
        [self batchDoneActionRecorder:recorder Obj:error];
    } else {
        //正常请求
        if (recorder && recorder.rr_failure) {
            recorder.rr_failure(task, error);
            WBLog(@"===================================请求失败===================\n[DataTask:%@]\n[URL:]%@\n[失败原因:]%@\n==========================================\n",task,recorder.rr_url,error.description);
            
            //尝试去拿缓存
            id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForCache:recorder.rr_url]];
            if (data) {
                if (recorder.rr_success) {
                    WBLog(@"从缓存拿数据成功");
                    recorder.rr_success(nil,data);
                }
            }
        }
        [self afterRequestThing:recorder];
        
    }
    
}

- (void)batchDoneActionRecorder:(WBRequestRecorder *)recorder Obj:(id)obj {
    if (!recorder) {
        WBLog(@"recorder 取不到!!!!");
        return;
    }
    WBLog(@"recorders: %@",self.wb_batchRecorderArray);
    [self.wb_batchDoneRequestDic setValue:obj forKey:recorder.rr_url];
    
    if (self.wb_batchDoneRequestDic.allKeys.count == self.wb_batchRecorderArray.count && self.batchRequestDone) {
        self.wb_batchRequestDone(self.wb_batchDoneRequestDic);
        [self afterBatchRequestThing];
    }
}

/**
 根据task获取recorder
 */
- (WBRequestRecorder *)getRecorderfromTask:(NSURLSessionDataTask *)task {
    
    if (self.wb_batchRecorderArray.count > 0) {
        //batch 请求 从wb_batchRecorderArray 查找
        for (WBRequestRecorder *recorder in self.wb_batchRecorderArray) {
            if ([recorder.rr_task isEqual:task]) {
                return recorder;
            }
        }
    } else {
        //正常请求从 wb_recorderArray 查找
        for (WBRequestRecorder *recorder in self.wb_recorderArray) {
            if ([recorder.rr_task isEqual:task]) {
                return recorder;
            }
        }
        
    }
    
    return nil;
}


/**
 请求完成之后的事情 -> 请求成功、请求失败、网络不好没有请求
 1. 删除记录器
 2. 清空WBRequest的一些属性
 */
- (void)afterRequestThing:(WBRequestRecorder *)recorder {
    [self nilParameters];
    [self deleteRecorder:recorder];
}


/**
 batch 请求完成之后的事情
 */
- (void)afterBatchRequestThing {
    if (self.wb_batchDoneRequestDic) {
        self.wb_batchDoneRequestDic = nil;
    }
    if (self.wb_batchRequestDone) {
        self.wb_batchRequestDone = nil;
    }
    if (self.wb_batchRecorderArray) {
        self.wb_batchRecorderArray = nil;
    }
    if (self.wb_batchUrls) {
        self.wb_batchUrls = nil;
    }
    if (self.wb_batchParamters) {
        self.wb_batchParamters = nil;
    }
    if (self.wb_batchRequestTypes) {
        self.wb_batchRequestTypes = nil;
    }
}

/**
 删除记录器
  */
- (void)deleteRecorder:(WBRequestRecorder *)recorder {
    [self.wb_recorderArray removeObject:recorder];
}

/**
 置空一些属性
 */
- (void)nilParameters {
    self.wb_url = nil;
    self.wb_success = nil;
    self.wb_failure = nil;
    self.wb_progress = nil;
}

/**
 网络是否可用
 1. 状态栏不可见，此方法失效
 2. 模拟器测试，关掉电脑Wi-Fi，模拟器还是显示Wi-Fi，也是失效了
 */
- (BOOL)isNetworkReachable {
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    BOOL isStautsVisiable = app.statusBarHidden;
    if (isStautsVisiable) {
        return YES;//如果不可见，下面的监测网络状态代码就没用了，直接去请求API去吧
    }
    
    int type = 0;
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            @try {
                type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            } @catch (NSException *exception) {
                type = 99;//系统的key变了，取不到了
                WBLog(@"获取私有类属性失败了[%@]",exception);
            } @finally {
                
            };
        }
    }
    
#if DEBUG
    switch (type) {
        case 1:
            WBLog(@"[网络：2G]");
            break;
        case 2:
            WBLog(@"[网络：3G]");
            break;
        case 3:
            WBLog(@"[网络：4G]");
            break;
        case 5:
            WBLog(@"[网络：WIFI]");
            break;
        default:
            WBLog(@"[网路未知]");
            break;
    }
#else
#endif
    
    if (type == 1 || type == 2 || type == 3 || type == 5 || type == 99) {
        return YES;
    } else {
        return NO;
    }
    
}
- (NSString *)finalUrl:(NSString *)str {
    if ([str hasPrefix:@"https://"] || [str hasPrefix:@"http://"]) {
        return str;
    } else {
        return [self constructUrl:str];
    }
}
- (NSDictionary *)finalParameter:(NSDictionary *)parameter {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (![_defaultParameters isEqual:@{}]) {
        //有默认参数
        tempDic = [NSMutableDictionary dictionaryWithDictionary:_defaultParameters];
    }
    //有传参进来
    if (![parameter isEqual:@{}] && parameter) {
        [tempDic addEntriesFromDictionary:parameter];
    }
    return tempDic;
}
//拼接链接
- (NSString *)constructUrl:(NSString *)url {
    if (WBBaseUrl && WBBaseUrl.length>0 && ([WBBaseUrl hasPrefix:@"http://"] || [WBBaseUrl hasPrefix:@"https://"])) {
        NSString *finalUrl = [WBBaseUrl stringByAppendingString:url];
        return finalUrl;
    }
    return nil;
}
#pragma mark - cache
/**
 缓存文件路径
 */
- (NSString *)pathForCache:(NSString *)url {
    NSString *basePath = [self baseCachePath];
    if (basePath.length == 0) {
        return @"";
    } else {
        return [basePath stringByAppendingPathComponent:[self nameForCache:url]];
    }
}

/**
 缓存文件名 由'请求方式+URL'拼接而成
 */
- (NSString *)nameForCache:(NSString *)url {
    // requestType + URL
    NSString *reqType;
    switch (_wb_requestType) {
        case WBRequestPost:
            reqType = @"POST";
            break;
        case WBRequestGet:
            reqType = @"GET";
            break;
        default:
            break;
    }
    NSString *name = [NSString stringWithFormat:@"%@+%@",reqType,url];
    return [self md5:name];
}
- (NSString *)baseCachePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"WBNetworkCache"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        return path;
    } else {
        BOOL createDoc = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (createDoc) {
            WBLog(@"创建base路径成功");
            return path;
        } else {
            return @"";//失败
        }
    }
}

/**
 缓存文件最后修改时间到现在的时间间隔
 */
- (NSTimeInterval)timerIntervalOfCache:(NSString *)filePath {
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error) {
        return 999999;//发生错误，返回一个极大值，直接请求后台
    } else {
        NSDate *modificationDate = attributes[NSFileModificationDate];
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:modificationDate];
        NSLog(@"time is %g",time);
        return time;
    }
}
#pragma mark - hud
- (void)showLoadingHUD {
    if (KEYWINDOW) {
        if (_wb_loadingHudText && _wb_loadingHudText.length>0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
            [hud removeFromSuperViewOnHide];
            hud.labelText = _wb_loadingHudText;
        } else {
            [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
        }
    }
}
- (void)hideLoadingHUD {
    if (KEYWINDOW) {
        [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
        _wb_loadingHudText = nil;
    }
}

#pragma mark - setter
- (void)setDefaultParameters:(NSDictionary *)defaultParameters {
    _defaultParameters = defaultParameters;
    self.wb_parameters= defaultParameters;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
    _wb_AFManager.requestSerializer.timeoutInterval = timeoutInterval;
}

#pragma mark - lazy
- (NSDictionary *)wb_parameters {
    if (!_wb_parameters) {
        _wb_parameters = [[NSDictionary alloc] init];
    }
    return _wb_parameters;
}

- (NSMutableArray *)wb_recorderArray {
    if (!_wb_recorderArray) {
        _wb_recorderArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _wb_recorderArray;
}
- (NSMutableArray *)wb_batchRecorderArray {
    if (!_wb_batchRecorderArray) {
        _wb_batchRecorderArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _wb_batchRecorderArray;
}
- (NSMutableDictionary *)wb_batchDoneRequestDic {
    if (!_wb_batchDoneRequestDic) {
        _wb_batchDoneRequestDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _wb_batchDoneRequestDic;
}


#pragma mark - other
/**
 MD5 加密 32位 小写
 */
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    
    unsigned char result[32];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15]];
}

@end


