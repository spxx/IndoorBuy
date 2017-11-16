//
//  Define.h
//  WJDJ
//
//  Created by LiuP on 15/6/10.
//  Copyright (c) 2015年 shc. All rights reserved.
//

#ifndef WJDJ_Define_h
#define WJDJ_Define_h


#endif

#import "Reachability.h" // 检测网络类
#import "BaseRequset.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "UIImage+View.h"
#import "UIView+Layout.h"
#import "JCUserContext.h"
#import "NSDictionary+HandelNull.h"
#import "UIView+Appearance.h"
#import "MJRefresh.h"
#import "GTMBase64.h"
#import "UIColor+HexTransform.h"
#import "TYTools.h"
#import "RootTabBarVC.h"
#import "JCDBCacheManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Manage.h"

#import "FMDBTools.h" //数据缓存工具
#import "ShareTools.h"//分享工具
#import "QBImagePicker.h"//图片选择类

#import "LoginViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>

static inline UIFont *fontForSize(NSUInteger size) {
    return [UIFont systemFontOfSize:size];
}

static inline UIFont *fontBoldForSize(NSUInteger size) {
    return [UIFont boldSystemFontOfSize:size];
}

static inline
id ObjectOrEmptyString(id obj)
{
    BOOL flag = YES;
    
    if (obj == nil) {
        flag = NO;
    } else if (obj == [NSNull null]) {
        flag = NO;
    }
    
    return flag ? obj : @"";
}
//数据库名称
#define DB_NAME @"default_cache"

// 详细打印
#ifdef DEBUG
#define NSLog(__FORMAT__, ...) NSLog((@"From:%s --- Line: %d\n " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#else
#define NSLog(__FORMAT__, ...)

#endif

// 基础地址
/**
 *  帮麦网的接口地址
 */
//测试
#define INDOORBUY_BASE_URL  @"http://bmapi.cncoral.com"
#define INDOORBUY_SHARE_URL @"http://bmmic.cncoral.com"
#define INDOORBUY_WKWEB     @"bmmic.cncoral.com"


//正式
//#define INDOORBUY_BASE_URL    @"http://indoorbuyapi.indoorbuy.com"
//#define INDOORBUY_SHARE_URL   @"http://m.indoorbuy.com"
//#define INDOORBUY_WKWEB     @"m.indoorbuy.com"
#define INDOORBUY_INVI(member_id) [NSString stringWithFormat:@"%@/invite/index/inviter/member_id/%@", INDOORBUY_SHARE_URL, member_id];
// 服务订单上传图片
#define SERVICE_IMAGE_URL      [NSString stringWithFormat:@"%@/Api2/Interface/serviceimage.html", INDOORBUY_BASE_URL]
//@"http://indoorbuyapi.indoorbuy.com/Api/Interface/serviceimage.html"


#define INDOORBUY_URL_API2  [NSString stringWithFormat:@"%@%@", INDOORBUY_BASE_URL, @"/Api2/Interface/indoorbuy.html"]
// 上传头像地址
#define INDOORBUY_UPLOAD_URL [NSString stringWithFormat:@"%@%@", INDOORBUY_BASE_URL, @"/Api2/Interface/imageupload.html"]

/**
 *  分销的接口地址【仅限于会员激活时的检查分销商下的卡号是否为必填】
 */
//测试
#define DP_BASE_URL @"http://drp.cncoral.com"
//正式
//#define DP_BASE_URL @"http://drp.indoorbuy.com"
#define DR_URL  [NSString stringWithFormat:@"%@%@", DP_BASE_URL, @"/Api/User/isWriteNumber.html"]

//#define BMW_BASE_IMAGE_URL  @"http://bmpic.cncoral.com/"
#define BMW_BASE_IMAGE_URL  @"http://pic.indoorbuy.com/"
#define IMAGE_URL(url)      [NSString stringWithFormat:@"%@%@",BMW_BASE_IMAGE_URL, url]
/******* 分销的接口地址【仅限于会员激活时的检查分销商下的卡号是否为必填】*****/


// 客服热线
#define SERVICE_URL @"http://chat16.live800.com/live800/chatClient/chatbox.jsp?companyID=600129&configID=122963&jid=6439855724"
/**
 * 支付回调
 */
#define ALIPAY(way) [NSString stringWithFormat:@"%@%@%@", INDOORBUY_BASE_URL, @"/Api2/Paynotfil/",way]


/**
 *一网通支付地址
 */
//测试
#define YiwangtongURL    @"http://61.144.248.29:801/netpayment/BaseHttp.dll?MB_EUserPay"
#define YiwangtongyuePay @"http://120.27.96.69/Api2/Pwdpay/rechargeNotify.html"
#define YiwangtongPay    @"http://120.27.96.69/Api2/Pwdpay/notify.html"

#define YiwangtongNo @"000275"

//正式
//#define YiwangtongURL @"https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MB_EUserPay"
//#define YiwangtongNo @"024906"
//开店回调
#define YiwangtongStoreURL [NSString stringWithFormat:@"%@%@", INDOORBUY_BASE_URL, @"/Api2/BmvipNotify/notify.html"]
//商品支付回调
//#define YiwangtongPay [NSString stringWithFormat:@"%@%@", INDOORBUY_BASE_URL, @"/Api2/Pwdpay/notify.html"]
//余额充值回调
//#define YiwangtongyuePay [NSString stringWithFormat:@"%@%@", INDOORBUY_BASE_URL, @"/Api2/Pwdpay/rechargeNotify.html"]
//签约回调
#define YiwangtongSign [NSString stringWithFormat:@"%@%@", INDOORBUY_BASE_URL, @"/Api2/Pwdpay/argnotify.html"]
// CMBPublicKey 测试: ZXDp2xXtqKStAXkYPTg/8vTw0YZkEzOOxW5uUQ95M0P9oMybxbTxZiDh/qlelCTYy8S+y/8XEdr/4fxuBtj+FxAg5ND970foOAJouADNUexrg3x72J/T9+S3t0+o2J2nBnbELxwKWeAWgGRPJAgL5TK+iZAv4r9+M85Yd2Spc4XWjAYolSAHqE5uecwSliVwSzu5GOVyUFhCv7l/v3O8U4tmMg0+LHUdt/95Qyf9HnlB/42G7ySBdTcj87Ry0XvFIUJmVIjFvj/OZrQXkQX+D/89ZlFJuV42jevz0MVXhKE7tXc0TrnEi+nSXqBvk4Ryuj1ZiIOry6UEL68i4Kgnag==
// CMBPublicKey 正式: HwhR4Kwd9L4DCBzaWf9fYSh+ozaEHk7uLbnyO+mnvWTgpZQDmhhZQYcs4ntRARzA4D6S+4swUOqEIOZGdljNa0vBaUuX/9Dlv/WCw+3bYrt1WviUuXrNjq6zHr2YvVMRxGtzXyXC7edschM4bYbvz6V9UDLtj1KZ4CkvrOPOWm5ddqt5NvHN1X33vuNY1q+4u9NO+fenlBmp2b8mzrCH9rDRjF9mhCd8InCS+69kwsvVDlL51iuiu8N7DxcodTbP9FWlp7J9ItXhkZCE2IiCSBtanFEXTipdl3OnHRTn6uUBAZUwbpz0lzSlr4Jh2rfWT9qrmmQXcJ/DS3DUG/4+UQ==
/************ 分享 **************/
#define BMW_APPSTORE    @"https://itunes.apple.com/cn/app/bang-mai-sheng-huo/id1065728592?mt=8"
#define BMW_TITLE       @"帮麦网--享受生活之上的生活"
#define BMW_DESC        @"汇集全球精品的购物APP，100%海外正品，国内保税仓急速发货。"
// 新规则分享地址
#define SHARE_DESCRIPTION   @"跨境进口、正品保证"
// 分享的style
#define SHARE_NOTIFICATION  @"shareSuccess"
#define GOODS               @"goods"
#define CLASS               @"class"
#define BAG                 @"bag"
#define SHOP                @"shop"
#define PLAT                @"plat"
#define SHAREURL_MEMBER(style, member_id, ID) [NSString stringWithFormat:@"%@/DrpShare/index/style/%@/member_id/%@/id/%@", INDOORBUY_SHARE_URL,style, member_id, ID]
#define SHAREURL_DRP(style, drpcode, ID) [NSString stringWithFormat:@"%@/DrpShare/index/style/%@/drpcode/%@/id/%@", INDOORBUY_SHARE_URL,style, drpcode, ID]
//邀请有礼
#define INVI_MEMBER(member_id) [NSString stringWithFormat:@"%@/invite/index/inviter/%@.html", INDOORBUY_SHARE_URL, member_id]

/******************通用************************/
#define IMAGEWITHNAME(imageName) [UIImage imageNamed:imageName]
#define IMAGE_WithHttp(url) [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]

// 系统版本
#define IOS8 [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0

// 获取屏幕尺寸
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

// 便利构造一个nsstring对象
#define NSSTRING_WITH_OBJECT(object) [NSString stringWithFormat:@"%@", object]

#define NSSTRING_NSInterger(object) [NSString stringWithFormat:@"%ld", object]

#define NSNumber(object) [NSNumber numberWithInteger:object]

// 判断是否为NSNULL对象
#define isNSNULL(object) [object isKindOfClass:[NSNull class]]

// 弱引用
#define WEAK_SELF typeof(self) __weak weakSelf = self


// 取得程序根控制器
#define ROOTVIEWCONTROLLER  (RootTabBarVC *)[[[[UIApplication sharedApplication] delegate] window] rootViewController]

#define MB_HUD [ROOTVIEWCONTROLLER HUD]
/**************MB***************/
// MB活动指示
#define MB_HUD [ROOTVIEWCONTROLLER HUD]
// 便利显示信息
#define SHOW_MSG(message) [MBProgressHUD show:message toView:[ROOTVIEWCONTROLLER view]]
#define SHOW_SUCCESS_MSG(message) [MBProgressHUD showSuccess:message toView:[ROOTVIEWCONTROLLER view]]
#define SHOW_EEROR_MSG(message) [MBProgressHUD showError:message toView:[ROOTVIEWCONTROLLER view]]
/**************MB***************/

/**************程序基础色调***************/
#define COLOR_TABBARTEXTCOLOR_S           [UIColor colorWithHex:0xfd5487] // tabbaritem 文字色选中  // 0xf84e37
#define COLOR_TABBARTEXTCOLOR_N           [UIColor colorWithHex:0x7f7f7f] // tabbaritem 文字色未选中
#define COLOR_TABBARTINTCOLOR             [UIColor colorWithHex:0xefefef] // tabbar 主题色
#define COLOR_BACKGRONDCOLOR              [UIColor colorWithHex:0xf1f1ed] // 背景色
#define COLOR_NAVIGATIONBAR_BARTINT       [UIColor colorWithHex:0xfd5487] // 导航栏背景色  // 0xd83d38
#define COLOR_NAVIGATIONBARTEXTCOLOR      [UIColor colorWithHex:0xffffff] // 导航栏标题色
#define COLOR_NAVIGATIONBAR_ITEM          [UIColor colorWithHex:0xffffff] // 导航栏item的颜色
/**************程序基础色调***************/

/**************Font***************/
#define FONT_HEITI_TC(fontSize) [UIFont fontWithName:@"Heiti TC" size:fontSize]   // 黑体
#define FONT_HEITI_SC(fontSize) [UIFont fontWithName:@"Heiti SC" size:fontSize]  // 黑体简体
#define FONT_ARIAL_BOLD(fontSize)   [UIFont fontWithName:@"Arial-Bold" size:fontSize]
#define FONT_ARIAL(fontSize)   [UIFont fontWithName:@"Arial" size:fontSize]

#define FONT_K_T(fontSize) [UIFont fontWithName:@"Helvetica Neue" size:fontSize]   // 黑体

/**************Font***************/

/**************各设备屏幕宽度***************/
#define IPHONE4S_SCREEN_HEIGHT 480
#define IPHONE5S_SCREEN_HEIGHT 568
#define IPHONE6_SCREEN_HEIGHT  667
#define IPHONE6P_SCREEN_HEIGHT 736
/**************各设备屏幕宽度***************/

/**************适配***************/
//适配
#define M_WIDTHVC 320.0
#define M_HEIGHTVC 568.0
//缩放比例
#define W_ABCW [UIScreen mainScreen].bounds.size.width/M_WIDTHVC
#define W_ABCH [UIScreen mainScreen].bounds.size.height/M_HEIGHTVC
/**************适配***************/

/**************获取沙盒目录***************/
#define HOME_PATH           NSHomeDirectory()       // 程序根目录
#define DOCUMENT_PATH       NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject // DocumentPath
#define LIBRARY_PATH        NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject  // LibraryPath
#define LIBRARY_CACHE_PATH  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject   // LibraryCachePath
#define TEMP_PATH           NSTemporaryDirectory()  // tempPath
/**************获取沙盒目录***************/

/************三方类**************/
#define SHARE_SDK    @"ebd2d199d4e"
#define Sina_Key    @"1456392709"
#define SIna_Secret    @"5b11281c4db5b470e52e9440d319dc8f"
#define WX_Key    @"wx4c01b99eecb06088"
#define WX_Secret @"5c9cdd9fdacddbf36d9920f387a57881"
#define QQ_APPID    @"SNmZgFd9U9H3ajGB"
#define QQ_APPKEY @"1105205129"
/************三方类**************/

/**************其他***************/


// 返回字段
#define RETURN_CODE    @"vYlbqOBmNnn6fpajA6ojlg=="
#define RETURN_DATA    @"5CIOENdbs+3JkcQzAYdFow=="
#define RETURN_MESSAGE @"1Bh5WypBhYEpHt0dskqzUg=="
/**************其他***************/
