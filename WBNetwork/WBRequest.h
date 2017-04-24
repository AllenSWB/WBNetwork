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



#ifdef DEBUG
# define WBLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define WBLog(...);
#endif


#define WBREQUEST WBRequest.sharedWBRequest
#define KEYWINDOW [UIApplication sharedApplication].keyWindow

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
//是否显示HUD 默认 NO
@property (assign, nonatomic) BOOL wb_isShowHUD;

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


/**
 请求记录器
 */
@interface WBRequestRecorder : NSObject
@property (strong, nonatomic) NSURLSessionDataTask *rr_task;
@property (strong, nonatomic) NSString *rr_url;
@property (copy, nonatomic) WBSuccess rr_success;
@property (copy, nonatomic) WBFailure rr_failure;
//@property (copy, nonatomic) WBProgress rr_progress;

@end
