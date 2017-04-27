//
//  WBRequest.h
//  SnakeChainNetwork
//
//  Created by sun on 2017/4/18.
//  Copyright © 2017年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>



#if DEBUG

# define WBLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define WBBaseUrl self.baseUrlDebug

#else

# define WBLog(...);
#define WBBaseUrl self.baseUrlRelease

#endif


#define WBREQUEST WBRequest.sharedWBRequest
#define KEYWINDOW [UIApplication sharedApplication].keyWindow

#define WBWeakObj(o) __weak typeof(o) o##Weak = o;
#define WBStrongObj(o) __strong typeof(o) o##Strong = o;


/**
 HTTP方法
 
 - WBRequestPost: POST
 - WBRequestGet: GET
 - WBRequestUplaod: 上传文件
 */
typedef NS_ENUM(NSUInteger, WBRequestType) {
    WBRequestPost,
    WBRequestGet,
    WBRequestUpload,
};

/**
 传递给业务层的数据类型
 
 - WBResponseData: NSData
 - WBResponseDictionary: NSDictionary
 - WBResponseString: NSString
 */
typedef NS_ENUM(NSUInteger, WBResponseType) {
    WBResponseDictionary,
    WBResponseString,
    WBResponseData,
};

//成功回调
typedef void(^WBSuccess)(NSURLSessionDataTask *task,id responseObj);
//失败回调
typedef void(^WBFailure)(NSURLSessionDataTask *task,NSError *err);
//进度回调
typedef void(^WBProgress)(NSProgress *progress);
//上传文件拼接数据
typedef void(^WBConstructBody)(id<AFMultipartFormData> formData);


#pragma mark - Class请求
/**
 WBRequest网络请求类
 */
@interface WBRequest : NSObject

+ (instancetype)sharedWBRequest;

//同一API两次请求之间最小时间间隔 默认 1s
@property (assign, nonatomic) NSTimeInterval minRequestInterval;
//缓存数据 默认 YES
@property (assign, nonatomic) BOOL cacheData;
//默认参数 默认 @{}
@property (strong, nonatomic) NSDictionary *defaultParameters;
//请求超时时长 默认 10s
@property (assign, nonatomic) NSTimeInterval timeoutInterval;
//debug base url. base url 后如果需要的话，可以自己拼接 '/'
@property (strong, nonatomic) NSString *baseUrlDebug;
//release base url
@property (strong, nonatomic) NSString *baseUrlRelease;
#pragma mark - chain
- (WBRequest *(^)(WBRequestType requestType))requestType;
- (WBRequest *(^)(NSString *urlString))url;
- (WBRequest *(^)(NSDictionary *parameters))parameters;
- (WBRequest *(^)(WBSuccess success))success;
- (WBRequest *(^)(WBFailure failure))failure;
- (WBRequest *(^)(WBProgress progress))progress;
- (WBRequest *(^)(BOOL isShowHUD))showHUD;
- (WBRequest *(^)(BOOL isShowHUD,NSString *text))showTextHUD;
- (WBRequest *(^)())startRequest;//发起请求

- (WBRequest *(^)(WBConstructBody constructBody))constructBody;

@end


#pragma mark - Class请求记录器
/**
 请求记录器
 */
@interface WBRequestRecorder : NSObject
@property (strong, nonatomic) NSURLSessionDataTask *rr_task;
@property (strong, nonatomic) NSString *rr_url;
@property (strong, nonatomic) NSDictionary *rr_parameters;
@property (copy, nonatomic) WBSuccess rr_success;
@property (copy, nonatomic) WBFailure rr_failure;
@property (strong, nonatomic) NSString *rr_cachePath;
//@property (copy, nonatomic) WBProgress rr_progress;

@end
