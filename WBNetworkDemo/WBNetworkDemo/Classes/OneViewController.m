//
//  OneViewController.m
//  WBNetworkDemo
//
//  Created by sun on 2017/5/9.
//  Copyright © 2017年 sun. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ONE";
    
    //deleteme
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 90, 90)];
    [b setBackgroundColor:[UIColor orangeColor]];
    [b addTarget:self action:@selector(ddddd) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:b];

    
}

- (void)ddddd {
    
    //text hud
    WBReqeustHUDPlugIn *plugIn = (WBReqeustHUDPlugIn *)[WBREQUEST plugInWithIdentifier:@"hud"];
    plugIn.HudInView = self.view;//可以选择将hud加在self.view上而非window上
    plugIn.HudText = @"啊啊啊";
    
    WBREQUEST.url([GlobalPort shopCartRecommendGoods]).success(^(NSURLSessionDataTask *task,id responsedObj){
        WBLog(@"aaaaaaa");
        //
        UIView *a = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 90, 90)];
        a.backgroundColor = [UIColor blueColor];
        [self.view addSubview:a];
        
    }).startRequest();
}


- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
