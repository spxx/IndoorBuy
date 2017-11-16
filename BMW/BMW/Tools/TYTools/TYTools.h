//
//  TYTools.h
//  工具类
//
//  Created by Leo Tang on 14-10-10.
//  Copyright (c) 2014年 Leo Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PayNotifyURLIsDefault,                  // 普通订单
    PayNotifyURLIsVIPApply,                //vip申请
    PayNotifyURLIsVIPBinding,             //vip绑卡
    PayNotifyURLIsBalanceRecgarge,       //余额充值
    PayNotifyURLOpenStore,              //我要开店
    
} PayNotifyURLType;

@interface TYTools : NSObject
/**
 * 转成 Json 字符串
 */
+ (NSString *)dataJsonWithDic:(id)paramObj;

/**
 *  金额千进制格式化
 *
 *  @param obj 金额对象，字符串或number
 *
 *  @return 格式化后的金额
 */
+ (NSString *)amountFormatter:(id)obj;
/**
 *判断是否为URl
 */

+(BOOL)isUrl:(NSString *)sender;

#pragma mark - 时间相关

/**
 *  计算年月日
 *
 *  @param date 计算的日期
 *
 *  @return 日期组成
 */
+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;
+ (NSDateComponents *)dateComponentsFromDateString:(NSString *)dateString;

/**
 *  计算时间差
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return 时间差
 */
+ (NSDateComponents *)calculateTimeDifferenceWithStartDateString:(NSString *)startString endDateString:(NSString *)endString;
+ (NSDateComponents *)calculateTimeDifferenceWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDateComponents *)calculateAgeWithDate:(NSDate *)date;
+ (NSDateComponents *)calculateAgeWithDateString:(NSString *)string;

+ (NSString *)dateStringFormatter:(NSString *)string;
/**
 *是否为今天
 *是否为同一天
 */
+ (BOOL)isToday:(NSDate *)date;
+ (BOOL)isSameDayWith:(NSDate *)date AndOtherDate:(NSDate *)otherDate;

/**
 *  弹出警告框
 *
 *  @param title   警告框标题
 *  @param message 警告内容
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  弹出自定视图
 *
 *  @param alertView  自定义视图
 *  @param parentView 需要展示的父视图
 *  @param alpha      背景alpha值
 */
+ (void)alertView:(UIView *)alertView onView:(UIView *)parentView backgroundAlpha:(double)alpha;



#pragma mark -- 支付
/**
 *  支付
 *
 *  @param goodsDic      信息字典
 *  @param isAlipay      是否为支付宝
 *  @param NotifyURLType 支付的商品类型
 */
+(void)paymentWithGoodsDetail:(NSDictionary *)goodsDic isAlipay:(BOOL)isAlipay NotifyURLType:(PayNotifyURLType)NotifyURLType;
//+(void)paymentWithGoodsDetail:(NSDictionary *)goodsDic withType:(NSString *)type isVIPRenew:(BOOL)isVIPRenew isApplyNotifyURL:(BOOL)isApplyNotifyURL;

#pragma mark - JSON
/**
 *  处理JSON字符串，返回JSON对象
 *
 *  @param data 包含JSON字符串的NSData对象
 *
 *  @return JSON对象
 */

+ (id)JSONObjectWithString:(NSString *)string;

+ (id)JSONObjectWithData:(NSData *)data;

/**
 *  转译含'/'的json字符串
 *
 *  @param jsonString 含'/'的json字符串
 *
 *  @return 正常json字符串
 */
+ (NSString *)JSONDataStringTranslation:(NSString*)JSONString;

/**
 *  将字典结构的NSData数据转化为字典  // 待验证
 *
 *  @param data 字典结构的NSData
 *
 *  @return 转化后的字典
 */
+ (NSDictionary *)DictionaryWithContentsOfData:(NSData *)data;


#pragma mark - 文件管理
/**
 *  向文件追加数据
 *
 *  @param DataStr  追加的数据
 *  @param fileName 文件名字
 *  @param filePath 文件路径
 */
+ (void)AddDataStr:(NSString *)DataStr ToFile:(NSString *)fileName filePath:(NSString *)filePath;
/**
 *  在某路径创建一个文件
 *
 *  @param filePath   文件路径
 *  @param fileName   文件名字 text.txt
 *  @param dataStr    文件内容
 *  @param attributes
 *
 *  @return 是否创建成功
 */
+ (BOOL)CreatFileAtPath:(NSString *)filePath
               fileName:(NSString *)fileName
                dataStr:(NSString *)dataStr
             attributes:(NSDictionary *)attributes;
/**
 *  删除文件
 *
 *  @param filePath 文件路径
 *  @param fileName 文件名
 *
 *  @return 成功与否
 */
+ (BOOL)DeleteFileAtPath:(NSString *)filePath fileName:(NSString *)fileName;
/**
 *  通过fileManager读取文件
 *
 *  @param filePath 文件路径
 *  @param fileName 文件名
 *
 *  @return 返回读取数据
 */
+ (NSData *)ReadFileByFileManagerWithFilePath:(NSString *)filePath fileName:(NSString *)fileName;
/**
 *  通过NSData读取文件
 *
 *  @param filePath 文件路径
 *  @param fileName 文件名
 *
 *  @return 返回读取后的字符串
 */
+ (NSData *)ReadFileByNSDataWithFilePath:(NSString *)filePath fileName:(NSString *)fileName;
/**
 *  通过NSString读取文件
 *
 *  @param filePath 文件路径
 *  @param fileName 文件名
 *
 *  @return 返回读取数据
 */
+ (NSString *)ReadFileByNSStringWithFilePath:(NSString *)filePath fileName:(NSString *)fileName;

#pragma mark - 图像处理
/**
 *  按宽度比例改变大小
 *
 *  @param image 原始图片
 *  @param defineWidth  宽度
 *
 *  @return 改变后的图片
 */
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 *  改变图片尺寸
 *
 *  @param image 原始图片
 *  @param size  改变的大小
 *
 *  @return 改变后的图片
 */
+ (UIImage*)originalImage:(UIImage *)image scaleToSize:(CGSize)size;

/**
 *  图片压缩
 *
 *  @param image    原始图片
 *  @param compress 压缩比例 (0...1)
 *
 *  @return 压缩后图片
 */
+ (NSData *)originalImage:(UIImage *)image compress:(CGFloat)compress;

#pragma mark - 加密算法

/**
 *  DES加密
 *
 *  @param clearText 需要加密的字符串
 *
 *  @return 加密字符串
 */
+ (NSString *)encryptUseDES:(NSString *)clearText;

/**
 *  DES解密
 *
 *  @param plainText 需要解密的字符串
 *
 *  @return 解密字符串
 */
+ (NSString *)decryptUseDES:(NSString *)plainText;

/**
 *  AES加密 128, CBC, NOPADDING
 *
 *  @param plainText 需要加密的字符串
 *
 *  @return 加密字符串
 */
+ (NSString *)AES128Encrypt:(NSString *)plainText;

/**
 *  AES解密 128, CBC, NOPADDING
 *
 *  @param encryptText 需要解密的字符串
 *
 *  @return 解密字符串
 */
+ (NSString *)AES128Decrypt:(NSString *)encryptText;

/**
 *  MD5加密
 *
 *  @param string 需要加密的字符串
 *  @param range  截取部分
 *
 *  @return 加密字符串
 */
+ (NSString *)stringEncryptUsingMD5:(NSString *)string subrange:(NSRange)range;


#pragma mark - 动态分配文字所占空间

/**
 *  动态分配UILabel的高度
 *
 *  @param string   显示的字符串
 *  @param size     分配的最大区域
 *  @param fontSize 字体大小
 *
 *  @return 空间大小
 */

+ (CGRect)boundingString:(NSString *)string size:(CGSize)size fontSize:(NSInteger)fontSize;

/**
 *  动态分配UILabel的区域
 *
 *  @param string   显示的字符串
 *  @param size     分配的最大区域
 *  @param fontName 字体名字
 *  @param fontSize 字体大小
 *
 *  @return 空间大小
 */

+ (CGRect)boundingString:(NSString *)string size:(CGSize)size fontName:(NSString *)fontName fontSize:(NSInteger)fontSize;

/**
 *  动态分配UILabel的区域
 *
 *  @param string     要显示的文本
 *  @param size       分配的最大区域
 *  @param attributes 文本属性
 *
 *  @return 空间大小
 */
+ (CGRect)boundingString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attributes;

#pragma mark - 本地正则验证 Email、电话号码、身份证

/**
 *  验证密码合法
 *
 *  @param passWord 密码字符串
 *
 *  @return 验证结果
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**
 *  验证是否合法邮箱
 *
 *  @param email 邮箱字符串
 *
 *  @return 验证结果
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  验证是否合法电话号码
 *
 *  @param mobileNum 电话号码字符串
 *
 *  @return 验证结果
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  验证是否合法身份证
 *
 *  @param sPaperId 身份证字符串
 *
 *  @return 验证结果
 */
+ (BOOL)isIdCard:(NSString *)sPaperId;

@end

#pragma mark - 获取类的属性列表、方法列表

@interface NSObject (PropertyListing)

/**
 *  获取类的属性列表
 *
 *  @return 属性列表
 */
- (NSDictionary *)properties_aps;

/**
 *  打印对象所有方法
 */
- (void)printMothList;


#pragma mark -- UILabel, UITextField 根据屏幕大小改变字体 --
/**
 * 屏幕是适配时黑体简体的字体大小
 * 针对  UILabel
 */
+(void)HeiTi_SC_FontSizeOfLabel:(UILabel *)label;


/**
 * 屏幕是适配时黑体繁体的字体大小
 * 针对  UILabel
 */
+(void)HeiTi_TC_FontSizeOfLabel:(UILabel *)label;


/**
 * 屏幕是适配时黑体简体的字体大小
 * 针对  UITextField
 */
+(void)HeiTi_SC_FontSizeOfTextField:(UITextField *)textField;


/**
 * 屏幕是适配时黑体繁体的字体大小
 * 针对  UITextField
 */
+(void)HeiTi_TC_FontSizeOfTextField:(UITextField *)textField;



/**
 * 屏幕是适配时Arial-Bold的字体大小
 * 针对  UILabel
 */
+(void)Arial_Bold_FontSizeOfLabel:(UILabel *)label;

#pragma mark -- 时间戳转换成时间 --
/**
 *  时间戳转换成时间
 *
 *  @param timestamp 时间戳
 *
 *  @return 时间字符串
 */
+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp;
@end

