//
//  WBReqeustHUDPlugIn.h
//  ChongZu
//
//  Created by sun on 2017/5/16.
//  Copyright © 2017年 cz10000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRequest.h"

@interface WBReqeustHUDPlugIn : WBRequestPlugInBase

- (instancetype)initWithHudText:(NSString *)hudText hudInView:(UIView *)hudInView;

@property (strong, nonatomic) NSString *HudText;
@property (strong, nonatomic) UIView *HudInView;

@end
