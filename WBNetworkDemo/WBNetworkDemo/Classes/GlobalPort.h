//
//  GlobalPort.h
//  AngelPlanets
//
//  Created by KongLT on 15/12/30.
//  Copyright © 2015年 SheChongKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 首页广告图片
 */
#define ImgPrefix @"http://www.cz10000.com/basic"
/**
 百科图片
 */
#define ImgPrefixNoBasic @"http://www.cz10000.com"
/**
 个人中心头像
 */
#define DPImgPrefix @"http://www.cz10000.com/index"
/**
 店铺图片
 */
#define DianPuImgPreFix @"http://www.cz10000.com/dianpu"

/**
 商铺图片前缀
 */
#define SPImgPrefix @"http://www.cz10000.com/dianpu"

@interface GlobalPort : NSObject

//拼接接口

+ (NSString *)appendPortWithHeaderAndFooter:(NSString *)footer;
/**
 上传设备号
 */
+ (NSString *)uploadDeviceTocken;
/**
 检查App版本
 */
+ (NSString *)ExamineVersion;
#pragma mark- 首页
/**
 *首页横幅广告
 *参数：catid
 *描述：catid为1代表轮播图，catid为2、3、4、5、6依次代表其他广告位
 */
+ (NSString *)IndexAdvantagePort;

/**
 首页产品分类
 参数：无
 描述：返回一级产品分类
 */
+(NSString *)IndexProductCategory;
/**
 首页产品广告
 参数：不传则返回全部按序返回 单个获取则传对应参数
 描述：参数 1 2 3 4 分别对应热门推荐 最新产品 顽主必选 限时抢购
 */
+ (NSString *)IndexProductAdvantage;
/**
 首页推荐产品
参数：无
 描述：返回首页推荐产品
 */
+ (NSString *)IndexProductRecommend;

/**
 分类页左侧标题
 */
+ (NSString *)classifySliderTitles;

/**
 分类页热门推荐
 */
+ (NSString *)classifyHotGoods;
/**
 分类左侧标题对应内容
 */
+ (NSString *)classifyTitleDetail;
/**
 分类页广告位接口
 */
+ (NSString *)classifyAdvert;


#pragma mark- 商城

/**
 商品图文详情
 */
+ (NSString *)mallGoodsDetailHtmlPage;
/**
 店铺推荐商品
 */
+ (NSString *)mallStoreRecommendGoods;
/**
 商品收藏操作，option传1为查询  option传2为操作，后台自动取反，前台读取结果即可
 */
+ (NSString *)mallQueryGoodsCollection;

/**
 获取catid对应的商品列表数据
 */
+ (NSString *)mallGoodsListWithCategoryId;

/**
 商品搜索结果，catid 1表示搜索商品，2表示搜索店铺    keywords为搜索关键词
 */
+ (NSString *)mallGoodsListSearched;
/**
 店铺搜索
 */
+ (NSString *)mallShopListSearched;
/**
 加入购物车
 */
+ (NSString *)mallAddGoodsToShopCart;

/**
 是否同意活体交易协议
 */
+ (NSString *)isLivingBodyAgreementAgreed;
/**
 立即购买
 */
+ (NSString *)mallPayNow;
+ (NSString *)mallPayNowNew;
/**
 商品基本信息
 */
+ (NSString *)mallGoodsDetailBaseInfo;
/**
 店铺信息
 */
+ (NSString *)mallGoodsDetailStoreInfo;

/**
 产品参数
 */
+ (NSString *)mallGoodsDetailProperty;

/**
 评价列表
 */
+ (NSString *)mallGoodsCommentList;

/**
 获取商品的认证资质（针对活体）
 */
+ (NSString *)mallGoodsApproveInfo;

/**
 获取所以一级分类和对应二级分类
 */
+ (NSString *)mallCategoryList;
#pragma mark- 百科

/**
 百科标题数据
 */
+(NSString *)baikeTitlesData;

/**
 百科分页数据
 */
+(NSString *)baikePageData;
/**
 百科推荐分类列表
 */
+ (NSString *)baikeRecommendList;
/**
 百科搜索
 */
+ (NSString *)baikeSearch;

/**
 百科评论接口
 */
+ (NSString *)baikeComment;
/**

 -------------------------------------------------------------->
 */
#pragma mark- 商家入驻
/**
 验证用户开店情况
 参数: userid
 */
+(NSString *)verifyUserStoreApply;

/**
 商户入驻
 参数：太多，看文档
 */
+(NSString *)storeApply;

+(NSString *)storeApplyUploadPic;

/**
 -------------------------------------------------------------->
 */
#pragma mark- 购物车


/**
 查询购物车商品数量
 */
+ (NSString *)shopcartNumber;

/**
 查询购物车
 参数：userid
 */
+(NSString *)shopCartQuery;

/**
 删除购物车中的商品
 参数：购物车id：g_id
 */
+(NSString *)deleteGoodsFromShopCart;

/**
 修改购物车中的产品参数和数量
 */
+(NSString*)reviseGoodsInfo;

/**
 获取地址列表
 dz_mrdz传任意非0值获取默认地址，dz_mrdz不传值获取所有地址
 */
+(NSString *)AddressList;

+(NSString *)addressEdit;
/**
 删除地址
 */
+(NSString *)addressDelete;



/**
 购物车推荐商品
 */
+ (NSString *)shopCartRecommendGoods;
/**
 -------------------------------------------------------------->
 */
#pragma mark- 登录注册

/**
 登录
 */
+ (NSString *)loginSignIn;
/**
 注册
 */
+ (NSString *)loginRegister;


/**
 快速登录
 */
+ (NSString *)fastLoginAPI;


/**
 注册接口 0114
 */
+ (NSString *)fastRegistAPI;

/**
 短信接口

 @return <#return value description#>
 */
+ (NSString *)getVerifyCodeAPI;

/**
 注销
 */
+ (NSString *)signOut;
/**
 注册设备   将当前设备和用户绑定
 */
+ (NSString *)registDevice;
/**
 获取手机验证码
 */
+ (NSString *)loginReturnPinCode;
/**
 修改密码
 */
+ (NSString *)loginModifyPassword;

/**
 修改个人信息
 */
+ (NSString *)loginModifyCustomInfo;

/**
 加载个人信息
 */
+ (NSString *)loginLoadUserInfo;

/**
 查询第三方账号是否已被绑定或注册
 */
+ (NSString *)queryAuthBindingStatus;
/**
 使用第三方平台的信息注册新用户
 */
+ (NSString *)createUserWithAuthInfo;
/**
 将第三方平台账户和平台账户绑定
 */
+ (NSString *)bindingUserWithAuthInfo;

/**
 使用第三方平台注册注册新用户（绑定手机号）
 */
+ (NSString *)createUserWithAuthInfoAndPhoneNumber;
/**
 绑定手机号
 */
+ (NSString *)bindingTelNumber;

/**
 -------------------------------------------------------------->
 */
#pragma mark- 订单

/**
 结算接口
 */
+ (NSString *)clearingSelectedGoods;
/**
 提交订单(从购物车进入)
 */
+ (NSString *)submitOrderFromShopCart;
/**
 新提交订单接口(计算运费模板)
 */
+ (NSString *)submitOrderFromShopCartNew;
/**
 提交订单(从商品详情页立即购买进入)
 */
+ (NSString *)submitOrderFromGoodsDetail;
/**
 新提交订单接口（计算运费模板，从商品详情进入）
 */
+ (NSString *)submitOrderFromGoodsDetailNew;
/**
 支付宝支付
 */
+ (NSString *)payByAlipay;

/**
 支付回调接口
 */
+ (NSString *)payReturnUrl;
/**
 微信支付接口
 */
+ (NSString *)payByWXPay;
/**
 查询订单  根据参数返回不同状态的订单
 */
+ (NSString *)orderQueryOrder;
/**
 取消未支付订单
 */
+ (NSString *)orderCancelUnpay;

/**
 结算未支付订单
 */
+ (NSString *)orderClearingUnoay;
/**
 订单详情页收货地址接口
 */
+ (NSString *)orderDetailAddress;

/**
 修改订单状态
 */
+ (NSString *)modifyOrderStatus;

/**
 退款图片上传修改接口
 */
+ (NSString *)drawBackUploadImage;

/**
 退款接口
 */
+ (NSString *)drawBackSubmit;

/**
 订单评价图片上传接口
 */
+ (NSString *)appraiseImgUpload;
/**
 提交订单评价
 */
+ (NSString *)appraiseSubmit;
/**
 修改订单价格
 */
+ (NSString *)modiftOrderPrice;
/**
 驳回退款申请
 */
+ (NSString *)auditDrawBack;
/**
 关闭订单
 */
+ (NSString *)closeOrder;
/**
 获取快递列表
 */
+ (NSString *)EMSList;
/**
 提交申诉
 */
+ (NSString *)appealSubmit;

/**
 查询物流信息
 */
+ (NSString *)queryEmsInfo;
/**
 退款售后详情
 */
+ (NSString *)drawBackDetial;

/**
 -------------------------------------------------------------->
 */
#pragma mark- 商品发布接口
/**
 店铺首页信息
 */
+ (NSString *)StoreManageIndexInfo;

/**
 商品发布图片上传接口
 */
+ (NSString *)goodsReleaseImgUpload;

/**
 商品发布轮播图片上传接口
 */
+ (NSString *)goodsReleaseBannerImgUpload;
/**
 编辑器图片上传接口
 */
+ (NSString *)goodsDetailEditorImgUpload;

/**
 获取各级分类索引 
 */
+ (NSString *)goodsCategoryIndex;
/**
 获取该分类下可选规格
 */
+ (NSString *)goodsOptionalParameters;
/**
 获取该分类下产品的属性参数
 */
+ (NSString *)goodsPropertyList;
/**
 获取店铺分类
 */
+ (NSString *)goodsStoreCategory;
/**
 获取售后保障信息
 */
+ (NSString *)goodsAfterSaleInfo;
/**
 获取运费模板列表
 */
+ (NSString *)goodsFreightFramework;

/**
 发布商品接口
 */
+ (NSString *)goodsRelease;
#pragma  mark-  店铺管理接口
/**
 店铺管理 宝贝管理列表
 */
+ (NSString *)StoreManageGoodsList;

/**
 店铺管理  活体商品管理列表
 */
+ (NSString *)StoreManageLivingBodyList;

/**
 店铺管理 删除宝贝
 */
+ (NSString *)StoreManageDeleteGoods;

/**
 店铺管理  改变宝贝销售状态（上架/下架）
 */
+ (NSString *)StoreManageChangeOnsale;
/**
 店铺管理  改变活体的销售状态
 */
+ (NSString *)StoreManageLivingBodyChangeOnSale;
/**
 店铺批量管理  批量上架/下架/删除商品
 */
+ (NSString *)StoreManageBatchManagement;
/**
 店铺活体商品批量管理
 */
+ (NSString *)StoreManageLivingBodyBatchManagement;
/**
 编辑宝贝时获取宝贝信息
 */
+ (NSString *)StoreManageEditGoodsInfo;
/**
 编辑活体商品时获取信息
 */
+ (NSString *)StoreManageEditLivingBodyInfo;

/**
 获取商家管理订单列表
 */
+ (NSString *)StoreManageOrderList;

/**
 获取店铺信息
 */
+ (NSString *)StoreManageGetStoreInfo;

/**
 修改店铺Logo
 */
+ (NSString *)StoreManageEditLogo;

/**
 修改店铺信息(店铺名称和店铺简介)
 */
+ (NSString *)StoreManageEditStoreInfo;
/**
 修改店铺地址（收货地址和发货地址）
 */
+ (NSString *)StoreManageEditAddress;

/**
 帮助中心-常见问题分类
 */
+ (NSString *)StoreManageHelpCategory;
/**
 帮助中心-常见问题分类—常见问题列表
 */
+ (NSString *)StoreManageHelpList;

/**
 商家消息分类列表
 */
+ (NSString *)StoreMessageCategoryList;
/**
 某个分类下的消息列表
 */
+ (NSString *)ShopMessageList;

/**
 延长收货  type参数 1延长发货 2延长收货
 */
+ (NSString *)DelaySentOrRecived;

#pragma mark- 活体认证接口

/**
 活体证书分类
 */
+ (NSString *)LBCerCategory;

/**
 活体认证宠物种类
 */
+ (NSString *)LBPetCategory;
/**
 活体认证图片上传接口
 */
+ (NSString *)LBImageUpload;

/**
 活体认证信息提交
 */
+ (NSString *)LBInfoSubmit;
/*
 * 检查是否提交过活体认证信息
 * 2017-03-07
 * ?m=Czanimal&a=checkApprove
 * @param shopid int 店铺id
 * @return result int 1 资料不完善 3 shopid为空 4 无认证信息 5 待审核 6 审核通过 7 审核驳回
 */
+ (NSString *)LBApproveStatus;
/**
 获取店铺类型  企业/个人
 */
+ (NSString *)LBShopType;


#pragma mark- 商家店铺展示
/**
 店铺首页接口
 */
+ (NSString *)ShopDisplayIndex;
/**
 店铺信息接口
 */
+ (NSString *)ShopDisplayInfo;
/**
 店铺商品列表（全部/最新）
 */
+ (NSString *)ShopDisplayGoodsList;
/**
 店铺最新晒单
 */
+ (NSString *)ShopDisplayLatestShare;
/**
 店铺宝贝分类
 */
+ (NSString *)ShopDisplayCategory;
/**
 获取店铺分类下的商品列表
 */
+ (NSString *)ShopDisplayCatGoodsList;
/**
 店铺内搜索接口
 */
+ (NSString *)ShopDisplaySearch;
/**
 店铺收藏接口 option传1为查询  传2为操作
 */
+ (NSString *)ShopCollection;
#pragma 个人中心
/**
 修改手机号
 */
+ (NSString *)ModifyPhoneNumber;
/**
 商品收藏展示
 */
+ (NSString *)CollectionGoodsView;
/**
 店铺收藏展示
 */
+ (NSString *)CollectionShopView;
/**
 常见问题分类列表
 */
+ (NSString *)FQACategoryList;
/**
 提交反馈分类列表
 */
+ (NSString *)FeedBackSubmitCategory;
/**
 常见问题列表
 */
+ (NSString *)FQAList;
/**
 提交反馈
 */
+ (NSString *)FeedBackSubmit;
/**
 提交反馈-上传图片
 */
+ (NSString *)FeedBackUploadImg;
/**
 我的反馈
 */
+ (NSString *)FeedBackMyFQA;
/**
 我的反馈详情
 */
+ (NSString *)FeedBackMyFQADetail;

/**
 更改反馈解决状态
 */
+ (NSString *)FQASolvedStatusOption;

#pragma 其他
/**
 宠物救助、寻宠相关图片上传地址
 */
+ (NSString *)petImageUpload;
/**
 获取宠物种类
 */
+ (NSString *)petTypeList;
/**
 获取地区数据
 */
+ (NSString *)CityList;

/**
 从服务器加载JS更新文件
 */
+ (NSString *)JSPatch;

/**
 充值接口
 */
+ (NSString *)Recharge;
/**
 充值明细
 */
+ (NSString *)RechargeDetail;

/**
 获取初始化融云SDK的Token

 @return 注册融云用的Token
 */
+ (NSString *)RongCloudToken;

+ (NSString *)RecreatRongCloudToken; 

/**
 返回融云需要的头像id等信息

 @return 返回融云需要的头像id等信息
 */
+ (NSString *)RongCloudUserInfo;

#pragma mark- 消息中心
/**
 获取分类下消息列表
 */
+ (NSString *)messageList;
/**
 查询分类下是否有未读消息
 */
+ (NSString *)queryUnreadMessageWithCategory;
/**
 获取未读取的系统消息
 */
+ (NSString *)fetchNotifySystemUnread;

/**
 获取聊天列表
 */
+ (NSString *)chatList;
/**
 查询商家时候有未读消息
 */
+ (NSString *)queryShopUnreadMessage;

#pragma mark- 优惠券相关接口
/**
 查询已领取优惠券 参数type为优惠券类型 1店铺优惠券 2平台优惠券
 */
+ (NSString *)queryCouponRecivied;

/**
 查询可领取的优惠券
 */
+ (NSString *)queryUnclaimeCoupon;
/**
 领取优惠券
 */
+ (NSString *)drawCoupon;

/**
 获取活动弹窗通知
 */
+ (NSString *)activityNotify;

#pragma  mark- 发现
/**
 发布寻宠信息
 */
+ (NSString *)publishFindPetInfo;
/**
 发布宠物救助信息
 */
+ (NSString *)publishSavlageInfo;
@end






















