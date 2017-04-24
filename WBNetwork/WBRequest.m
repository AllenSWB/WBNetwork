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
@interface WBRequest ()

@property (strong, nonatomic) AFHTTPSessionManager *wb_AFManager;

@property (assign, nonatomic) WBRequestType wb_requestType;
@property (assign, nonatomic) WBResponseType wb_responseType;
@property (strong, nonatomic) NSString *wb_url;
@property (strong, nonatomic) NSMutableDictionary *wb_parameters;
@property (copy, nonatomic) WBSuccess wb_success;
@property (copy, nonatomic) WBFailure wb_failure;
@property (copy, nonatomic) WBProgress wb_progress;
@property (copy, nonatomic) WBConstructBody wb_constructBody;

@property (strong, nonatomic) NSString *wb_loadingHudText;//加载hud文字

@property (strong, nonatomic) NSMutableArray *recorderArray;//请求记录器数组

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
        _wb_AFManager = [AFHTTPSessionManager manager];
        _wb_AFManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _wb_AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _wb_AFManager.requestSerializer.timeoutInterval = 10;
        
        //默认属性值
        _wb_requestType = WBRequestPost;
        _wb_responseType = WBResponseDictionary;
        _minRequestInterval = 1;
        _cacheData = YES;
        _defaultParameters = @{};
        _wb_isShowHUD = NO;

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
        self.wb_url = url;
        return self;
    };
}
- (WBRequest *(^)(NSDictionary *))parameters {
    return ^(NSDictionary *para) {
        
        if (![_defaultParameters isEqual:@{}]) {
            //有默认参数
            self.wb_parameters = [NSMutableDictionary dictionaryWithDictionary:_defaultParameters];
        }
        //有传参进来
        if (![para isEqual:@{}] && para) {
            [self.wb_parameters addEntriesFromDictionary:para];
        }
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
        
        NSString *cachePath = [self pathForCache];
        
        if (_minRequestInterval > 0 && [self timerIntervalOfCache:cachePath] < _minRequestInterval) {
            //去拿缓存
            id data = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
            if (data) {
                if (_wb_success) {
                    WBLog(@"两次请求时间间隔太短，直接从缓存拿数据");
                    _wb_success(nil,data);
                }
            }
        } else {
            //默认回调
            [self defaultCallBack];
            if ([self isNetworkReachable]) {
                //开始请求
                [self startRequestAPI:cachePath];
            } else {
                WBLog(@"没网啊...")
            }
        }
        
        //恢复默认参数
        if (![_defaultParameters isEqual:@{}]) {//有默认参数
            self.wb_parameters = [NSMutableDictionary dictionaryWithDictionary:_defaultParameters];
        } else {
            self.wb_parameters = [NSMutableDictionary dictionaryWithCapacity:0];
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

#pragma mark - network
- (void)startRequestAPI:(NSString *)cachePath {
    
    if (_wb_isShowHUD) {
        [self showLoadingHUD];
    }
    
    NSURLSessionDataTask *task;
    
    switch (_wb_requestType) {
        case WBRequestPost:
        {
         task = [_wb_AFManager POST:_wb_url parameters:self.wb_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
             
                if (_wb_progress) {
                    _wb_progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self requestSuccessComplete:task obj:responseObject cachePath:cachePath];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestFailureHandler:task error:error];
                
            }];
        }
            break;
        case WBRequestGet:
        {
          task = [_wb_AFManager GET:_wb_url parameters:self.wb_parameters progress:^(NSProgress * _Nonnull downloadProgress) {

                if (_wb_progress) {
                    _wb_progress(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
                [self requestSuccessComplete:task obj:responseObject cachePath:cachePath];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestFailureHandler:task error:error];
            }];
        }
            break;
        case WBRequestUpload:
        {
           task = [_wb_AFManager POST:_wb_url parameters:self.wb_parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (_wb_constructBody) {
                    _wb_constructBody(formData);
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (_wb_progress) {
                    _wb_progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestSuccessComplete:task obj:responseObject cachePath:cachePath];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestFailureHandler:task error:error];
            }];
        }
            break;
        default:
            break;
    }
    
    WBLog(@"===========================请求开始========================\n[DataTask:%@]\n[URL:]%@\n[参数:]%@\n===============================\n",task,_wb_url,_wb_parameters);

    WBRequestRecorder *recorder = [self getRecorderFromUrl:_wb_url];
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
        case WBResponseDictionary:
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
    if (_wb_success) {
        WBRequestRecorder *recorder = [self getRecorderformTask:task];
        recorder.rr_success(task, data);

        WBLog(@"===================================请求成功===================\n[DataTask:%@]\n[URL:]%@\n[数据:]%@\n==========================================\n",task,recorder.rr_url,data);
        
        //删除记录器
        [self deleteRecorder:recorder];
    }
}

/**
 请求失败回调
 */
- (void)requestFailureHandler:(NSURLSessionDataTask *)task error:(NSError *)error {
    if (_wb_isShowHUD) {
        [self hideLoadingHUD];
    }
    if (_wb_failure) {
        
        WBRequestRecorder *recorder = [self getRecorderformTask:task];
        recorder.rr_failure(task, error);
        WBLog(@"===================================请求失败===================\n[DataTask:%@]\n[URL:]%@\n[失败原因:]%@\n==========================================\n",task,recorder.rr_url,error.description);
        [self deleteRecorder:recorder];
    }
}

/**
 删除记录器

 @param recorder 记录器
 */
- (void)deleteRecorder:(WBRequestRecorder *)recorder {
    [self.recorderArray removeObject:recorder];
}
/**
 网络是否可用
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
    
#ifdef DEBUG
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

#pragma mark - cache
/**
 缓存文件路径
 */
- (NSString *)pathForCache {
    NSString *basePath = [self baseCachePath];
    if (basePath.length == 0) {
        return @"";
    } else {
        return [basePath stringByAppendingPathComponent:[self nameForCache]];
    }
}

/**
 缓存文件名 由'请求方式+URL'拼接而成
 */
- (NSString *)nameForCache {
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
    NSString *name = [NSString stringWithFormat:@"%@+%@",reqType,_wb_url];
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


- (WBRequestRecorder *)getRecorderFromUrl:(NSString *)url {
    for (WBRequestRecorder *recorder in self.recorderArray) {
        if ([recorder.rr_url isEqualToString:url]) {
            return recorder;
        }
    }
    return nil;
}

- (WBRequestRecorder *)getRecorderformTask:(NSURLSessionDataTask *)task {
    
    for (WBRequestRecorder *recorder in self.recorderArray) {
        if ([recorder.rr_task isEqual:task]) {
            return recorder;
        }
    }
    return nil;
}

#pragma mark - setter
- (void)setDefaultParameters:(NSDictionary *)defaultParameters {
    _defaultParameters = defaultParameters;
    _wb_parameters= [NSMutableDictionary dictionaryWithDictionary:defaultParameters];
}

- (void)setWb_success:(WBSuccess)wb_success {
    _wb_success = wb_success;
    
    WBRequestRecorder *recorder = [self getRecorderFromUrl:_wb_url];
    if (recorder) {
        recorder.rr_success = wb_success;
    } else {
        WBLog(@"出错，没有获取到recorder");
    }
}

- (void)setWb_failure:(WBFailure)wb_failure {
    _wb_failure = wb_failure;
    
    WBRequestRecorder *recorder = [self getRecorderFromUrl:_wb_url];
    if (recorder) {
        recorder.rr_failure = wb_failure;
    } else{
        WBLog(@"出错，没有获取到recorder");
    }
}

- (void)setWb_url:(NSString *)wb_url {
    _wb_url = wb_url;
    //创建记录器
    WBRequestRecorder *recorder = [[WBRequestRecorder alloc] init];
    recorder.rr_url = wb_url;
    [self.recorderArray addObject:recorder];
}


#pragma mark - lazy
- (NSMutableDictionary *)wb_parameters {
    if (!_wb_parameters) {
        _wb_parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _wb_parameters;
}

- (NSMutableArray *)recorderArray {
    if (!_recorderArray) {
        _recorderArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _recorderArray;
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


@implementation WBRequestRecorder

@end

