//
//  GlobalPort.m
//  AngelPlanets
//
//  Created by KongLT on 15/12/30.
//  Copyright © 2015年 SheChongKeJi. All rights reserved.
//

#import "GlobalPort.h"
@implementation GlobalPort

+ (NSString *)appendPortWithHeaderAndFooter:(NSString *)footer
{
        return [NSString stringWithFormat:@"%@%@",@"http://kfpet.cz10000.com/index.php?",footer];

}

+ (NSString *)shopCartRecommendGoods
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=tjprod"];
}


@end


















