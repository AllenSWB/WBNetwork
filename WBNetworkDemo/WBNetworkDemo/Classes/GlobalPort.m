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
+ (NSString *)uploadDeviceTocken
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdevicetoken&a=gettoken"];
}
+ (NSString *)ExamineVersion
{
    return [self appendPortWithHeaderAndFooter:@"m=Czupdate&a=getversion"];
}
+ (NSString *)IndexAdvantagePort
{ 
    return [self appendPortWithHeaderAndFooter:@"m=Czhome&a=adpic"];
}
+(NSString *)IndexProductCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czhome&a=prodcat"];
}
+ (NSString *)IndexProductAdvantage
{
    return [self appendPortWithHeaderAndFooter:@"m=Czhome&a=adprod"];
}
+ (NSString *)IndexProductRecommend
{
    return [self appendPortWithHeaderAndFooter:@"m=Czhome&a=tjprod"];
    
}

+(NSString *)mallGoodsDetailHtmlPage
{
    return [self appendPortWithHeaderAndFooter:@"m=Hfive&a=spshow&id="];
}
+ (NSString *)mallStoreRecommendGoods
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprodlist&a=tjprod"];
}
+(NSString *)mallQueryGoodsCollection
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=collectprod"];
}

+ (NSString *)mallAddGoodsToShopCart
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=gwcadd"];
}

+ (NSString *)isLivingBodyAgreementAgreed
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=checkAgre"];
}

+(NSString *)mallPayNow
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=paynow"];
}
+ (NSString *)mallPayNowNew
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=frepaynow"];
}
+ (NSString *)mallGoodsListWithCategoryId
{
    return [self appendPortWithHeaderAndFooter:@"m=Czsearchnew&a=plist"];
}
+(NSString *)mallGoodsListSearched
{
    return [self appendPortWithHeaderAndFooter:@"m=Czsearchnew&a=slist"];
}
+ (NSString *)mallShopListSearched
{
    return [self appendPortWithHeaderAndFooter:@""];
}
+(NSString *)mallCategoryList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprod&a=prodcat"];
}
+(NSString *)mallGoodsDetailBaseInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprodlist&a=pshow"];
}
+ (NSString *)mallGoodsDetailStoreInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprodlist&a=pshop"];
}
+ (NSString *)mallGoodsDetailProperty
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprodlist&a=prodattr"];
}




+ (NSString *)classifySliderTitles
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprod&a=scat"];
}
+ (NSString *)classifyHotGoods
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprod&a=tjcat"];
}
+ (NSString *)classifyTitleDetail
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprod&a=tcat"];
}

+ (NSString *)classifyAdvert
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprod&a=hotad"];
}

+(NSString *)baikeTitlesData
{
    return [self appendPortWithHeaderAndFooter:@"m=Czbknew&a=bkcat"];
}
+(NSString *)baikePageData
{
    return [self appendPortWithHeaderAndFooter:@"m=Czbknew&a=bklist"];
}
+ (NSString *)baikeRecommendList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czbknew&a=getrecommend"];
}

+ (NSString *)baikeSearch
{
    return [self appendPortWithHeaderAndFooter:@"m=Czbknew&a=serach"];
}

+ (NSString *)baikeComment
{
    return [self appendPortWithHeaderAndFooter:@"m=Czbknew&a=discuss"];
}

+ (NSString *)verifyUserStoreApply
{
    return [self appendPortWithHeaderAndFooter:@"m=Czsjrz&a=sjyz"];
}

+ (NSString *)storeApply
{
    return [self appendPortWithHeaderAndFooter:@"m=Czsjrz&a=sjrz"];
}

+(NSString *)storeApplyUploadPic
{
    return [self appendPortWithHeaderAndFooter:@"m=Czsjrz&a=addimg"];
}



+ (NSString *)shopcartNumber
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=getCareSum"];
}
+(NSString *)shopCartQuery
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=gwclist"];
}
+(NSString *)deleteGoodsFromShopCart
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=gwcdel"];
}
+(NSString *)reviseGoodsInfo{
 
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=gwcedit"];
}
+(NSString *)AddressList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=dzlist"];
}

+(NSString *)addressEdit
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=dzadd"];
}
+(NSString *)addressDelete
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=dzdel"];
}

+ (NSString *)payByAlipay
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=alipay"];
}

+ (NSString *)clearingSelectedGoods
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=freight"];
}
+ (NSString *)submitOrderFromShopCart
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=neworder"];
}
+ (NSString *)submitOrderFromShopCartNew;
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=freorder"];
}
+ (NSString *)submitOrderFromGoodsDetail
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=payorder"];
}
+ (NSString *)submitOrderFromGoodsDetailNew
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=frepayorder"];
}
+(NSString *)payReturnUrl
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=returnurl"];
}
+ (NSString *)payByWXPay
{
    return [self appendPortWithHeaderAndFooter:@"m=Czwxpay&a=wxpay"];
}
+ (NSString *)shopCartRecommendGoods
{
    return [self appendPortWithHeaderAndFooter:@"m=Czgwc&a=tjprod"];
}

+ (NSString *)loginSignIn
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=login"];
}
+ (NSString *)loginRegister
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=reg"];
}

+ (NSString *)fastLoginAPI {
    /*
     * @param user_mobile string 手机号
     * @param user_code string 验证码
     * @param pushid string 极光推送标识
     * @param device string 设备标识 iOS或android
     * @return result int 状态码 0 接口账号或密码为空 1 登陆成功 2 接口账号或密码错误 3 手机号不存在 4 短信验证码错误 5 注册失败

     */
    return [self appendPortWithHeaderAndFooter:@"m=Czquicklogin&a=login"];
}

+ (NSString *)fastRegistAPI {
    /*
     * 注册接口
     * 2017-04-12
     * ?m=Czquicklogin&a=reg
     * @param user_mobile string 手机号
     * @param pass string 密码 md5加密后的
     * @param pushid string 极光推送标识
     * @param device string 设备标识 iOS或android
     * @return result int 状态码 0 接口账号或密码为空 1 注册成功 2 接口账号或密码错误 3 手机号已存在 4 注册失败
     */
    
    return [self appendPortWithHeaderAndFooter:@"m=Czquicklogin&a=reg"];
}

+ (NSString *)getVerifyCodeAPI {
    
    /*
     * @param mobile string 手机号
     * @return result int 状态码 1 成功
     */
    return [self appendPortWithHeaderAndFooter:@"m=Czquicklogin&a=yzmobile"];
    
}
+ (NSString *)signOut
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=signout"];
}
+ (NSString *)registDevice
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=registDevice"];
}
+(NSString *)loginReturnPinCode
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=yzmobile"];
}
+ (NSString *)loginModifyPassword
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=xgmm"];
}
+(NSString *)loginModifyCustomInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=xgreg"];
}
+(NSString *)loginLoadUserInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=loginhy"];
}
+ (NSString *)queryAuthBindingStatus
{
    return [self appendPortWithHeaderAndFooter:@"m=Czloginapi&a=checkopenid"];
}
+ (NSString *)createUserWithAuthInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czloginapi&a=regopenid"];
}
+ (NSString *)bindingUserWithAuthInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czloginapi&a=boundopenid"];
}
+ (NSString *)createUserWithAuthInfoAndPhoneNumber
{
    return [self appendPortWithHeaderAndFooter:@"m=Czloginapi&a=regmember"];
}
+ (NSString *)bindingTelNumber
{
    return [self appendPortWithHeaderAndFooter:@"m=Czloginapi&a=setpass"];
}

+(NSString *)mallGoodsCommentList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czprodlist&a=discuss"];
}
+ (NSString *)mallGoodsApproveInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=getCertification"];
}

+(NSString *)orderQueryOrder
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=orderlist"];
}
+(NSString *)orderCancelUnpay
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=orderdel"];
}
+(NSString *)orderClearingUnoay
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=zhorder"];
}
+(NSString *)orderDetailAddress
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=ordershow"];
}

+ (NSString *)modifyOrderStatus
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=editordernew"];
}

+ (NSString *)drawBackUploadImage
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=pic"];
}

+ (NSString *)drawBackSubmit
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=refund"];
}
+ (NSString *)appraiseImgUpload
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=plpic"];
}
+ (NSString *)appraiseSubmit
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=discuss"];
}

+ (NSString *)modiftOrderPrice
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=preprice"];
}
+ (NSString *)auditDrawBack
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=tkcheck"];
}
+ (NSString *)closeOrder
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=ddclose"];
}
+ (NSString *)EMSList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=kdgs"];
}
+ (NSString *)appealSubmit
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=appeal"];
}
+ (NSString *)queryEmsInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=logistics"];
}
+ (NSString *)drawBackDetial
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=refundcheck"];
}
+(NSString *)StoreManageIndexInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=dpindex"];
}
+ (NSString *)goodsReleaseImgUpload
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=addimg"];
}

+ (NSString *)goodsReleaseBannerImgUpload
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=addxqimg"];
}
+(NSString *)goodsDetailEditorImgUpload
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=bjqimg"];
}
+ (NSString *)goodsCategoryIndex
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getcat"];
}
+ (NSString *)goodsOptionalParameters
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getstandard"];
}

+ (NSString *)goodsPropertyList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getattr"];
}
+ (NSString *)goodsStoreCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getdpcate"];
}
+ (NSString *)goodsAfterSaleInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getservice"];
}

+ (NSString *)goodsFreightFramework
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getyfmb"];
}

+ (NSString *)goodsRelease
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanisue&a=addprod"];
}
+ (NSString *)StoreManageGoodsList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=prodlist"];
}

+ (NSString *)StoreManageLivingBodyList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanisue&a=prodlist"];
}

+ (NSString *)StoreManageDeleteGoods
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=delprod"];
}

+ (NSString *)StoreManageDeleteLivingBody
{
    return [self appendPortWithHeaderAndFooter:@""];
}

+ (NSString *)StoreManageChangeOnsale
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=xjprod"];
}
+ (NSString *)StoreManageLivingBodyChangeOnSale
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanisue&a=putaway"];
}
+ (NSString *)StoreManageBatchManagement
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=batchprod"];
}
+  (NSString *)StoreManageLivingBodyBatchManagement
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=batchprod"];
}
+ (NSString *)StoreManageEditGoodsInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getprod"];
}

+ (NSString *)StoreManageEditLivingBodyInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanisue&a=getprod"];
}

+(NSString *)StoreManageOrderList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=ddlist"];
}
+ (NSString *)StoreManageGetStoreInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=getdpinfo"];
}
+ (NSString *)StoreManageEditLogo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=edituserpic"];
}
+ (NSString *)StoreManageEditStoreInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=editdpinfo"];
}
+ (NSString *)StoreManageEditAddress
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=editdpdz"];
}
/**
 帮助中心-常见问题分类
 */
+ (NSString *)StoreManageHelpCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=helpcat"];
}
/**
 帮助中心-常见问题分类—常见问题列表
 */
+ (NSString *)StoreManageHelpList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpfb&a=helplist"];
}

+ (NSString *)StoreMessageCategoryList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=shopCate"];
}
+ (NSString *)ShopMessageList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=shopInfo"];
}
+ (NSString *)DelaySentOrRecived
{
    return [self appendPortWithHeaderAndFooter:@"m=Czorder&a=editorderstatus"];
}
+ (NSString *)LBCerCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=getCert"];
}

+ (NSString *)LBPetCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=getCate"];
}
+ (NSString *)LBImageUpload
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=addimg"];
}
+ (NSString *)LBInfoSubmit
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=approve"];
}

+ (NSString *)LBApproveStatus
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=checkApprove"];
}

+ (NSString *)LBShopType
{
    return [self appendPortWithHeaderAndFooter:@"m=Czanimal&a=checkShop"];
}

+ (NSString *)ShopDisplayIndex
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dpindex"];
}
+ (NSString *)ShopDisplayInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dpinfo"];
}
+ (NSString *)ShopDisplayGoodsList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dplist"];
}
+ (NSString *)ShopDisplayLatestShare
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dpbask"];
}

+ (NSString *)ShopDisplayCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dpfl"];
}
+ (NSString *)ShopDisplayCatGoodsList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dplist"];
}
+ (NSString *)ShopDisplaySearch
{
    return [self appendPortWithHeaderAndFooter:@"m=Czdpzs&a=dpsearch"];
}

+ (NSString *)ShopCollection
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=collectdp"];
}


+(NSString *)ModifyPhoneNumber
{
    return [self appendPortWithHeaderAndFooter:@"m=Czreg&a=xgtel"];
}

+ (NSString *)CollectionGoodsView
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=colprolist"];
}

+ (NSString *)CollectionShopView
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=coldplist"];
}
+ (NSString *)FQACategoryList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=faqbzcat"];
}
+ (NSString *)FeedBackSubmitCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=faqcat"];
}
+ (NSString *)FQAList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=problem"];
}
+ (NSString *)FeedBackSubmit
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=faq"];
}
+ (NSString *)FeedBackUploadImg
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=pic"];
}
+ (NSString *)FeedBackMyFQA
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=faqlist"];
}
+ (NSString *)FeedBackMyFQADetail
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=faqshow"];
}
+ (NSString *)FQASolvedStatusOption
{
    return [self appendPortWithHeaderAndFooter:@"m=Czmember&a=editok"];
}

+ (NSString *)petImageUpload
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpet&a=addimg"];
}

+ (NSString *)petTypeList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpet&a=getcate"];
}

+ (NSString *)CityList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czarea&a=getarea"];
}

+(NSString *)JSPatch
{
    return [self appendPortWithHeaderAndFooter:@"m=Czupdate&a=jsupdate"];
}
+ (NSString *)Recharge
{
    return [self appendPortWithHeaderAndFooter:@"m=Czrecharge&a=recharge"];
}

+ (NSString *)RechargeDetail
{
    return [self appendPortWithHeaderAndFooter:@"m=Czrecharge&a=rechargelist"];
}

+ (NSString *)RongCloudToken
{
    return [self appendPortWithHeaderAndFooter:@"m=Czchat&a=gettoken"];
}
+ (NSString *)RecreatRongCloudToken
{
    return [self appendPortWithHeaderAndFooter:@"m=Czchat&a=reshtoken"];
}
+ (NSString *)RongCloudUserInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czchat&a=getuserinfo"];
}

+ (NSString *)messageList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=pushlist"];
}

+ (NSString *)queryUnreadMessageWithCategory
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=pushcate"];
}
+ (NSString *)fetchNotifySystemUnread
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=pushsyslist"];
}
+ (NSString *)chatList
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=pushinteract"];
}
+ (NSString *)queryShopUnreadMessage
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpush&a=shoppushcate"];
}

+ (NSString *)queryCouponRecivied
{
    return [self appendPortWithHeaderAndFooter:@"m=Czcoupon&a=couponlist"];
}
+ (NSString *)queryUnclaimeCoupon
{
    return [self appendPortWithHeaderAndFooter:@"m=Czcoupon&a=couponreceive"];
}
+ (NSString *)drawCoupon
{
    return [self appendPortWithHeaderAndFooter:@"m=Czcoupon&a=coupondraw"];
}
+ (NSString *)activityNotify
{
    return [self appendPortWithHeaderAndFooter:@"m=Czredpacket&a=getstate"];
}

+ (NSString *)publishFindPetInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpet&a=forpet"];
}
+ (NSString *)publishSavlageInfo
{
    return [self appendPortWithHeaderAndFooter:@"m=Czpet&a=helppet"];
}
@end


















