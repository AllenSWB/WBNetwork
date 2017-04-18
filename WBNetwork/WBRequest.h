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
 */
typedef NS_ENUM(NSUInteger, WBRequestType) {
    WBRequestPost,
    WBRequestGet,
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


typedef void(^WBSuccess)(NSURLSessionDataTask *task,id responseObj);
typedef void(^WBFailure)(NSURLSessionDataTask *task,NSError *err);
typedef void(^WBProgress)(NSProgress *progress);


/**
 WB 网络请求类
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
- (WBRequest *(^)())startRequest;//发起请求

@end
