//
//  ViewController.m
//  WBNetworkDemo
//
//  Created by sun on 2017/5/9.
//  Copyright © 2017年 sun. All rights reserved.
//

#import "ViewController.h"
#import "WBRequest.h"
#import "WBReqeustHUDPlugIn.h"
#import "OneViewController.h"
#import "TwoViewController.h"


@interface ViewController ()

@end

@implementation ViewController

/**
 wbRequest 设置
 这段代码可以放到 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 */
- (void)wbReqeustSetting {

    WBREQUEST.minRequestInterval = 2;////同一API两次请求之间最小时间间隔 默认 1s
    WBREQUEST.cacheData = YES;////缓存数据 默认 YES
    WBREQUEST.defaultParameters = @{@"appid":@"2016",@"appselect":@"cz2016"};//默认参数 eg: 服务器账号密码
    WBREQUEST.timeoutInterval = 30;//请求超时时间
    WBREQUEST.baseUrlDebug = @"http://kfpet.cz10000.com/index.php?";
    WBREQUEST.baseUrlRelease = @"";
    
    //添加HUD插件
    [WBREQUEST wb_addPlugIn:[WBReqeustHUDPlugIn new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self wbReqeustSetting];
    
    //deleteme
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 90, 90)];
    [b setBackgroundColor:[UIColor orangeColor]];
    [b addTarget:self action:@selector(ddddd:) forControlEvents:(UIControlEventTouchUpInside)];
    b.tag = 1000;
    [b setTitle:@"ONE" forState:(UIControlStateNormal)];
    [self.view addSubview:b];

    
    
    //deleteme
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 90, 90)];
    [c setBackgroundColor:[UIColor blueColor]];
    [c addTarget:self action:@selector(ddddd:) forControlEvents:(UIControlEventTouchUpInside)];
    [c setTitle:@"TWO" forState:(UIControlStateNormal)];
    c.tag = 1001;
    [self.view addSubview:c];
    
    
    //deleteme
    UIButton *d = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 90)];
    [d setBackgroundColor:[UIColor orangeColor]];
    [d addTarget:self action:@selector(ddddd:) forControlEvents:(UIControlEventTouchUpInside)];
    d.tag = 1002;
    [d setTitle:@"同时发起多个请求" forState:(UIControlStateNormal)];
    [self.view addSubview:d];


    //deleteme
    UIButton *e = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 200, 90)];
    [e setBackgroundColor:[UIColor orangeColor]];
    [e addTarget:self action:@selector(ddddd:) forControlEvents:(UIControlEventTouchUpInside)];
    e.tag = 1003;
    [e setTitle:@"接连发起多个批请求" forState:(UIControlStateNormal)];
    [self.view addSubview:e];
}

- (void)ddddd:(UIButton *)sender {
    NSString *url0 = @"http://kfapi.dh10000.cn/index.php?m=Czadver&a=getBannerData";
    NSString *url1 = @"http://kfapi.dh10000.cn/index.php?m=Czadver&a=getAdverData";
    NSString *url2 = @"http://kfapi.dh10000.cn/index.php?m=Czhome&a=tjprod";

    if (sender.tag == 1000) {
        OneViewController *one = [[OneViewController alloc] init];
        [self.navigationController pushViewController:one animated:YES];
    } else if (sender.tag == 1001) {
        TwoViewController *two = [[TwoViewController alloc] init];
        [self.navigationController pushViewController:two animated:YES];
    } else if (sender.tag == 1002) {
        //同时发起多个请求
        WBREQUEST.batchRequestTypes(@[WBPOST,WBPOST,WBPOST]).batchUrls(@[url0,url1,url2]).batchParameters(@[@{},@{},@{}]).batchRequestDone(^(NSDictionary *dic) {
        
            for (id obj in dic.allValues) {
                if ([obj isKindOfClass:[NSError class]]) {
                    WBLog(@"obj 出现了\n有错!");
                } else {
                    WBLog(@"obj 出现了\n数据:%@",obj);
                }
            }
            
        }).startBatchRequest();
    
    } else if (sender.tag == 1003) {
        
        //不要接连发起两个批请求(第一个批请求还没完成就开始了第二个批请求)，这样的话会导致只有第二个批请求的回调
        //接连发起同一个批请求两次，请求会走两次，但是只有第二次的批请求回调会走
        
                WBREQUEST.batchRequestTypes(@[WBPOST]).batchUrls(@[url0]).batchParameters(@[@{}]).batchRequestDone(^(NSDictionary *dic) {
                
                    for (id obj in dic.allValues) {
                        if ([obj isKindOfClass:[NSError class]]) {
                            WBLog(@"obj 出现了\n有错!");
                        } else {
                            WBLog(@"obj 出现了\n数据:%@",obj);
                        }
                    }
        
                }).startBatchRequest();
        
        
                WBREQUEST.batchRequestTypes(@[WBPOST,WBPOST]).batchUrls(@[url1,url2]).batchParameters(@[@{},@{}]).batchRequestDone(^(NSDictionary *dic) {
                
                    for (id obj in dic.allValues) {
                        if ([obj isKindOfClass:[NSError class]]) {
                            WBLog(@"obj 出现了\n有错!");
                        } else {
                            WBLog(@"obj 出现了\n数据:%@",obj);
                        }
                    }
                    
                }).startBatchRequest();
        
    }
}


@end
