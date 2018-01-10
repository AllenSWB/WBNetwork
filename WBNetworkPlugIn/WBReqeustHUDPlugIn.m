//
//  WBReqeustHUDPlugIn.m
//  ChongZu
//
//  Created by sun on 2017/5/16.
//  Copyright © 2017年 cz10000. All rights reserved.
//

#import "WBReqeustHUDPlugIn.h"

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
#import <MBProgressHUD/MBProgressHUD.h>
#else
#import "MBProgressHUD.h"
#endif

@implementation WBReqeustHUDPlugIn

- (instancetype)initWithHudText:(NSString *)hudText hudInView:(UIView *)hudInView {
    self = [super init];
    if (self) {
        _HudText = hudText;
        _HudInView = hudInView;
        self.plugInIdentifier = @"hud";
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.plugInIdentifier = @"hud";
    }
    return self;
}

- (void)showLoadingHUD {
    
    MBProgressHUD *hud;
    
    if (_HudInView) {
        hud = [MBProgressHUD showHUDAddedTo:_HudInView animated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW?:[UIView new] animated:YES];
    }
    [hud removeFromSuperViewOnHide];
    
    if (_HudText && _HudText.length > 0) {
        hud.labelText = _HudText;
    }
}

- (void)hideLoadingHUD {
  
    if (KEYWINDOW) {
        [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
    }
    if (_HudInView) {
        [MBProgressHUD hideAllHUDsForView:_HudInView animated:YES];
    }
    
    _HudText = nil;
    _HudInView = nil;
}
#pragma mark - WBRequestPlugIn
- (void)wb_requestWillStart:(WBRequestRecorder *)recorder {
    [self showLoadingHUD];
}
- (void)wb_requestWillComplete:(WBRequestRecorder *)recorder {
    [self hideLoadingHUD];
}

@end
