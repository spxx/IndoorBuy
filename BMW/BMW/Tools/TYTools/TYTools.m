//
//  TYTools.m
//
//
//  Created by Leo Tang on 14-10-10.
//  Copyright (c) 2014年 Leo Tang. All rights reserved.
//

#import "TYTools.h"
#import "TYEncrypt.h"
#import "TYVerify.h"
#import <objc/runtime.h>
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "payRequsestHandler.h"
#import "WXApi.h"
#import "WXUtil.h"

// DES加密密钥
static NSString *key = @"app16810";

@implementation TYTools
#pragma mark -- 字典转字符串
/**
 * 转成 Json 参数
 */
+ (NSString *)dataJsonWithDic:(id)paramObj
{
    NSData * data = [NSJSONSerialization dataWithJSONObject:paramObj options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *paramStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return paramStr;
    
}

+(BOOL)isUrl:(NSString *)sender{
    return ([sender rangeOfString:@"http://"].location != NSNotFound ||
            [sender rangeOfString:@"https://"].location != NSNotFound ||
            [sender rangeOfString:@"HTTP://"].location != NSNotFound ||
            [sender rangeOfString:@"HTTPS://"].location != NSNotFound);

}
/**
 *  支付
 *
 *  @param goodsDic      信息字典
 *  @param isAlipay      是否为支付宝
 *  @param NotifyURLType 支付的商品类型
 */
+(void)paymentWithGoodsDetail:(NSDictionary *)goodsDic isAlipay:(BOOL)isAlipay NotifyURLType:(PayNotifyURLType)NotifyURLType {
    if (isAlipay) {
        //支付宝
        NSString *partner = @"2088121127392840";
        NSString *seller = @"2088121127392840";
        NSString *privateKey = @"MIICXQIBAAKBgQCe6jD93gTVQMUXoUR58afe0mfloEkjLnoo/mCD6qX9xuwgJeDWrhopmtonJ3IMXlK8q6qUwpQBYCEw44eiLhfRWekV7eGC4H59FQNC7rXTnhhTQ/JQQf8vJ51MomtFhuTIk6qSmzSHR81WoV5/H+4JleJrTgIS++GrBsXP7gAqdwIDAQABAoGAT0i2QqJXNPIIox5xZImdYD0HWvgaJTRV/EfVbVtPj4qEWhGr2E+qe+FnP6udafBRRRI8m9VsNDd6t8J88/wdIyte7aaC+QAVTwi/pkhaGontr0BaZ+tAp3uHlKEd9u5H3vy9WTlRWCk/iDE9YEFC6eI0fCWMhaqNEFl/G3lZDLkCQQDQ5BI72QOLZgKCZYVezflen9hT7u5QJN2NZrz/nOx8yK2nVSaNMWLHWO4vFiZF7mBejhnpr4YYGkxrfo40IjxDAkEAwsDX1tOpABi2d7l035VGqYrex1F+uoB4S06qsGq1rQDbRc5hOKurBeMI7cGzLNNETR2qX5yZiKVb8K22nctPvQJBAJtvelnqK4cIywk4fbuDzPEqRBCAk/gy1mEnd69El3xq3zzKUbtyaiwn8mQ7OROEQ1VYq9OFdmRs/TxnmW0VpH0CQQCdHIGDV0FxSH57W2vDq2NUBynt1frMbjOdXRsqMwvZQ2WhjPq1gxf3Kc7cL3ViZhUluRbnByh9KhlfsmQuLARpAkB+8jjYzBJo3wJ2SbfdbUiex5W0J2+4V/X4QKm5vpl+ttdSfM8iw00i90bNYIFUmw9LIxLRtAZKAIWJny8dutvq";
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order *order = [[Order alloc] init];
        order.partner = partner;
        order.sellerID = seller;
        order.outTradeNO = goodsDic[@"pay_sn"];     //订单ID
        
//        [NSString stringWithFormat:@"%@",goodsDic[@"cs_commo"][@"name"]];
//        order.productDescription = @"测试组合商品名字";
//        [NSString stringWithFormat:@"%@等商品",goodsDic[@"cs_commo"][@"description"]];
        switch (NotifyURLType) {
            case PayNotifyURLIsDefault:{
                //普通订单
                order.totalFee = [NSString stringWithFormat:@"%.2f",[goodsDic[@"order_amount"] floatValue]];
                order.subject = [NSString stringWithFormat:@"商品购买_%@",goodsDic[@"order_sn"]];
                order.notifyURL = ALIPAY(@"alipay");
//                @"http://indoorbuyapi.indoorbuy.com/Api/Paynotfil/alipay"; //回调URL
            }
                break;
            case PayNotifyURLIsVIPApply:{
                //vip申请
                order.outTradeNO = goodsDic[@"order_sn"];
                order.totalFee = @"200.00";
                order.subject = [NSString stringWithFormat:@"帮麦麦咖会员年费_%@",goodsDic[@"order_sn"]];
                order.notifyURL = ALIPAY(@"bmactive.html");
//                @"http://indoorbuyapi.indoorbuy.com/Api/Paynotfil/bmactive.html";  //申请的回调【正式】
//                order.notifyURL = @"http://bmapi.cncoral.com/Api/Paynotfil/bmactive.html";  //申请的回调【测试】
            }
                break;
            case PayNotifyURLIsVIPBinding:{
                //vip绑定
                order.outTradeNO = goodsDic[@"order_sn"];
                order.totalFee = [NSString stringWithFormat:@"%.2f",[goodsDic[@"price"] floatValue]];
                order.subject = [NSString stringWithFormat:@"帮麦麦咖会员年费_%@",goodsDic[@"order_sn"]];
                order.notifyURL = ALIPAY(@"active");
//                @"http://indoorbuyapi.indoorbuy.com/Api/Paynotfil/active"; //绑卡的回调URL【正式】
//                order.notifyURL =  @"http://bmapi.cncoral.com/Api/Paynotfil/active";//【测试用】
            }
                break;
            case PayNotifyURLIsBalanceRecgarge:{
                //余额充值
                order.outTradeNO = goodsDic[@"order_sn"];
                order.totalFee = [NSString stringWithFormat:@"%.2f",[goodsDic[@"price"] floatValue]];
                order.subject = [NSString stringWithFormat:@"余额充值_%@",goodsDic[@"order_sn"]];
                order.notifyURL = ALIPAY(@"recharge.html");
//                @"http://indoorbuyapi.indoorbuy.com/Api/paynotfil/recharge.html"; //回调URL
            }
                break;
            case PayNotifyURLOpenStore:{
                order.outTradeNO = goodsDic[@"order_sn"];
                order.totalFee = [NSString stringWithFormat:@"%.2f",[goodsDic[@"price"] floatValue]];
                order.subject = [NSString stringWithFormat:@"成为麦咖_%@",goodsDic[@"order_sn"]];
                order.notifyURL = ALIPAY(@"bmactive");
//                @"http://indoorbuyapi.indoorbuy.com/Api/paynotfil/recharge.html"; //回调URL
            }
                break;
            default:
                break;
        }
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showURL = @"ms.alipay.com";
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"BMW";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        NSLog(@"orderSpec = %@",orderSpec);
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            NSArray *array = [[UIApplication sharedApplication] windows];
            UIWindow* win=[array objectAtIndex:0];
            [win setHidden:NO];
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //回调走AppDelegate里面
            }];
        }
    }else{
        //微支付
        NSString    *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str	= [WXUtil md5:time_stamp];
        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
        //        package       = [NSString stringWithFormat:@"Sign=%@",package];
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: @"wx4c01b99eecb06088"        forKey:@"appid"];
        [signParams setObject: nonce_str    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: @"1325994601"        forKey:@"partnerid"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        [signParams setObject: goodsDic[@"prepay_id"]     forKey:@"prepayid"];
        NSString * sign = [TYTools createMd5Sign:signParams];
        
        //设置支付参数
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = @"wx4c01b99eecb06088";
        req.partnerId           = @"1325994601";
        req.prepayId            = [goodsDic objectForKey:@"prepay_id"];
        req.nonceStr            = nonce_str;
        req.timeStamp           = time_stamp.intValue;
        req.package             = @"Sign=WXPay";
        req.sign                = sign;
        if ([WXApi sendReq:req]) {
            NSLog(@"成功发起支付");
        }else {
            NSLog(@"发起支付失败");
        }
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
}
//创建package签名
+(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段 spKey 秘钥
    [contentString appendFormat:@"key=%@", @"ca5c1cc605219355b503779852617186"];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    //    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}
#pragma mark - 文件管理
+ (void)AddDataStr:(NSString *)DataStr ToFile:(NSString *)fileName filePath:(NSString *)filePath
{
    NSString *sourcePath = [filePath stringByAppendingPathComponent:fileName];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sourcePath];
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    NSString *str = DataStr;       // 追加的数据
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData]; //追加写入数据
    [fileHandle closeFile];
}

+ (BOOL)CreatFileAtPath:(NSString *)filePath fileName:(NSString *)fileName dataStr:(NSString *)dataStr attributes:(NSDictionary *)attributes
{
    NSString * sourcePath = [filePath stringByAppendingPathComponent:fileName];
    NSFileManager * fileManeger = [NSFileManager defaultManager];
    NSData * fileData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    return [fileManeger createFileAtPath:sourcePath contents:fileData attributes:attributes];
}

+ (BOOL)DeleteFileAtPath:(NSString *)filePath fileName:(NSString *)fileName
{
    NSString * sourcePath = [filePath stringByAppendingPathComponent:fileName];
    NSFileManager * fileManeger = [NSFileManager defaultManager];
    NSError * error;
    BOOL result = [fileManeger removeItemAtPath:sourcePath error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return result;
}

+ (NSData *)ReadFileByFileManagerWithFilePath:(NSString *)filePath fileName:(NSString *)fileName
{
    NSString * sourcePath = [filePath stringByAppendingPathComponent:fileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSData * data = [fileManager contentsAtPath:sourcePath];
    return data;
}

+ (NSData *)ReadFileByNSDataWithFilePath:(NSString *)filePath fileName:(NSString *)fileName
{
    NSString * sourcePath = [filePath stringByAppendingPathComponent:fileName];
    NSData * data = [NSData dataWithContentsOfFile:sourcePath];
    return data;
}

+ (NSString *)ReadFileByNSStringWithFilePath:(NSString *)filePath fileName:(NSString *)fileName
{
    NSString * sourcePath = [filePath stringByAppendingPathComponent:fileName];
    NSError * error;
    NSString * content = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        content = @"读取失败";
    }
    return content;
}
#pragma mark -- 图片处理

//指定宽度按比例缩放
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)originalImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

+ (NSData *)originalImage:(UIImage *)image compress:(CGFloat)compress
{
    //得到图片的data
    // 压缩图片
    NSData *imageData = nil;
    CGFloat compression = compress;
    do {
        imageData = UIImageJPEGRepresentation(image, compression);
        compression -= 0.1;
    } while (imageData.length / 1024.0 > 300);
    return imageData;
}

#pragma mark -- 弹框信息
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    
    // 初始化警告框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    // 显示警告框
    [alertView show];
    
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager createFileAtPath:@"" contents:nil attributes:nil];
}

#pragma mark -- 带底层的视图弹出
+ (void)alertView:(UIView *)alertView onView:(UIView *)parentView backgroundAlpha:(double)alpha {
    
    // 弹出视图底层
    UIView *bottomView = [[UIView alloc] initWithFrame:parentView.bounds];
    bottomView.backgroundColor = [UIColor clearColor];
    [parentView addSubview:bottomView];
    
    // 黑色遮罩层
    UIView *backgroundView = [[UIView alloc] initWithFrame:bottomView.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = alpha;
    [bottomView addSubview:backgroundView];
    
    
    [alertView align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(bottomView.viewWidth/2, bottomView.viewHeight)];
    [bottomView addSubview:alertView];
    
    
}

#pragma mark - 千进制金额

+ (NSString *)amountFormatter:(id)obj {
    
    // 转化为可变字符串对象
    NSMutableString *amountString = [NSMutableString stringWithFormat:@"%@", obj];
    // 判断有无小数点
    int i = 2;
    if ([amountString rangeOfString:@"."].location != NSNotFound) {
        i += 3;
    }
    // 添加千位进制符
    for (; i < amountString.length - 1; i += 3) {
        [amountString insertString:@"," atIndex:amountString.length - i - 1];
        i++;
    }
    // 首字符删0
    while ([amountString characterAtIndex:0] == '0' || [amountString characterAtIndex:0] == ',') {
        [amountString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    // 小数点前加0
    if ([amountString characterAtIndex:0] == '.') {
        [amountString insertString:@"0" atIndex:0];
    }
    return amountString;
}

#pragma mark - 时间相关

+ (NSDateComponents *)dateComponentsFromDateString:(NSString *)dateString {
    
    dateString = [self dateStringFormatter:dateString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; //设定日期时区
    
    return [self dateComponentsFromDate:[dateFormatter dateFromString:dateString]];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 日期对比项
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    return [calendar components:unitFlags fromDate:date];
}

+ (NSDateComponents *)calculateTimeDifferenceWithStartDateString:(NSString *)startString endDateString:(NSString *)endString {
    
    startString = [self dateStringFormatter:startString];
    endString = [self dateStringFormatter:endString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [self calculateTimeDifferenceWithStartDate:[dateFormatter dateFromString:startString] endDate:[dateFormatter dateFromString:endString]];
}

+ (NSDateComponents *)calculateTimeDifferenceWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 日期对比项
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    return [calendar components:unitFlags fromDate:startDate toDate:endDate options:NSCalendarMatchStrictly];
}

+ (NSDateComponents *)calculateAgeWithDate:(NSDate *)date {
    
    return [self calculateTimeDifferenceWithStartDate:date endDate:[NSDate date]];
}

+ (NSDateComponents *)calculateAgeWithDateString:(NSString *)dateString {
    
    dateString = [self dateStringFormatter:dateString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; //设定日期时区
    
    return [self calculateAgeWithDate:[dateFormatter dateFromString:dateString]];
}

/**
 *  日期字符串格式化方法
 *
 *  @param dateString 日期字符串
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)dateStringFormatter:(NSString *)dateString {
    
    // 去日期字符串的符号
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 时间字符串长度超出，截取14位
    if ([dateString length] > 14) {
        dateString = [dateString substringToIndex:13];
    }
    
    // 时间字符串长度不够，补0
    while ([dateString length] < 14) {
        dateString = [dateString stringByAppendingString:@"0"];
    }
    
    return dateString;
}

+ (BOOL)isToday:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isSameDayWith:(NSDate *)date AndOtherDate:(NSDate *)otherDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:otherDate];
    NSDate *othersDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:othersDate]) {
        return YES;
    }
    else
    {
        return NO;
    }
}



#pragma mark - 计算文本大小

+ (CGRect)boundingString:(NSString *)string size:(CGSize)size fontSize:(NSInteger)fontSize
{
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    return [string boundingRectWithSize:size options:options attributes:attributes context:nil];
}

+ (CGRect)boundingString:(NSString *)string size:(CGSize)size fontName:(NSString *)fontName fontSize:(NSInteger)fontSize {
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:fontName size:fontSize]};
    
    return [string boundingRectWithSize:size options:options attributes:attributes context:nil];
}

+ (CGRect)boundingString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attributes {
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    return [string boundingRectWithSize:size options:options attributes:attributes context:nil];
}

#pragma mark - JSON

+ (id)JSONObjectWithString:(NSString *)string {
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self JSONObjectWithData:jsonData];
}

+ (id)JSONObjectWithData:(NSData *)data {
    
    if ([data length] == 0) {
        return nil;
    }
    
    //JSON字符串转JSON对象
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:&error];
    if (error) {
        NSLog(@"Json analytic did failed with error message '%@'.",
              [error localizedDescription]);
        return nil;
    }
    
    return object;
}

+ (NSString *)JSONDataStringTranslation:(NSString*)JSONString {
    
    JSONString = [JSONString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    JSONString = [JSONString stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
    JSONString = [JSONString stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
    
    return JSONString;
}

/**
 *  待验证
 *
 */
+ (NSDictionary *)DictionaryWithContentsOfData:(NSData *)data {
    CFPropertyListRef list = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data, kCFPropertyListImmutable, NULL);
    if(list == nil) return nil;
    if ([(__bridge id)list isKindOfClass:[NSDictionary class]]) {
        return (__bridge NSDictionary *)list;
    }
    else {
        CFRelease(list);
        return nil;
    }
}

#pragma mark - 本地正则验证 密码、Email、电话号码、身份证

//密码
+ (BOOL)validatePassword:(NSString *)passWord
{
    return [TYVerify validatePassword:passWord];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    return [TYVerify isValidateEmail:email];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    return [TYVerify isMobileNumber:mobileNum];
}

+ (BOOL)isIdCard:(NSString *)sPaperId
{
    return [TYVerify isIdCard:sPaperId];
}

#pragma mark - 加密

// MD5
+ (NSString *)stringEncryptUsingMD5:(NSString *)string subrange:(NSRange)range {
    
    return [TYEncrypt stringEncryptUsingMD5:string subrange:range];
}

// DES
+ (NSString *)encryptUseDES:(NSString *)clearText
{
    return [TYEncrypt encryptUseDES:clearText];
}

+ (NSString *)decryptUseDES:(NSString *)plainText
{
    return [TYEncrypt decryptUseDES:plainText];
}

// AES
+ (NSString *)AES128Encrypt:(NSString *)plainText {
    
    return [TYEncrypt AES128Encrypt:plainText];
}

+ (NSString *)AES128Decrypt:(NSString *)encryptText {
    
    return [TYEncrypt AES128Decrypt:encryptText];
}

@end

@implementation NSObject (PropertyListing)

/* 获取对象的所有属性 */
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

/* 获取对象的所有方法 */
-(void)printMothList
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
//        Method temp_f = mothList_f[i];
        //        IMP imp_f = method_getImplementation(temp_f);
        //        SEL name_f = method_getName(temp_f);
//        const char* name_s =sel_getName(method_getName(temp_f));
//        int arguments = method_getNumberOfArguments(temp_f);
//        const char* encoding =method_getTypeEncoding(temp_f);
//        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
//              arguments,
//              [NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

#pragma mark -- UILabel, UITextField 根据屏幕大小改变字体 --
+(void)HeiTi_SC_FontSizeOfLabel:(UILabel *)label
{
    if (SCREEN_HEIGHT == IPHONE4S_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_SC(label.font.pointSize - 1);
    }
    if (SCREEN_HEIGHT == IPHONE5S_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_SC(label.font.pointSize );
    }
    
    if (SCREEN_HEIGHT == IPHONE6_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_SC(label.font.pointSize +1);
    }
    
    if (SCREEN_HEIGHT == IPHONE6P_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_SC(label.font.pointSize + 2);
    }
    
    
}
+(void)HeiTi_TC_FontSizeOfLabel:(UILabel *)label
{
    if (SCREEN_HEIGHT == IPHONE4S_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_TC(label.font.pointSize - 1);
    }
    if (SCREEN_HEIGHT == IPHONE5S_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_TC(label.font.pointSize );
    }
    
    if (SCREEN_HEIGHT == IPHONE6_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_TC(label.font.pointSize +1);
    }
    
    if (SCREEN_HEIGHT == IPHONE6P_SCREEN_HEIGHT) {
        label.font = FONT_HEITI_TC(label.font.pointSize + 2);
    }
    
    
}

+(void)HeiTi_SC_FontSizeOfTextField:(UITextField *)textField
{
    if (SCREEN_HEIGHT == IPHONE4S_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_SC(textField.font.pointSize - 1);
    }
    if (SCREEN_HEIGHT == IPHONE5S_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_SC(textField.font.pointSize );
    }
    
    if (SCREEN_HEIGHT == IPHONE6_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_SC(textField.font.pointSize+1);
    }
    
    if (SCREEN_HEIGHT == IPHONE6P_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_SC(textField.font.pointSize + 2);
    }
    
}

+(void)HeiTi_TC_FontSizeOfTextField:(UITextField *)textField
{
    
    if (SCREEN_HEIGHT == IPHONE4S_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_TC(textField.font.pointSize - 1);
    }
    if (SCREEN_HEIGHT == IPHONE5S_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_TC(textField.font.pointSize );
    }
    
    if (SCREEN_HEIGHT == IPHONE6_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_TC(textField.font.pointSize +1 );
    }
    
    if (SCREEN_HEIGHT == IPHONE6P_SCREEN_HEIGHT) {
        textField.font = FONT_HEITI_TC(textField.font.pointSize + 2);
    }
    
    
}


+(void)Arial_Bold_FontSizeOfLabel:(UILabel *)label
{
    
    if (SCREEN_HEIGHT == IPHONE4S_SCREEN_HEIGHT) {
        label.font = FONT_ARIAL_BOLD(label.font.pointSize - 1);
    }
    if (SCREEN_HEIGHT == IPHONE5S_SCREEN_HEIGHT) {
        label.font = FONT_ARIAL_BOLD(label.font.pointSize );
    }
    
    if (SCREEN_HEIGHT == IPHONE6_SCREEN_HEIGHT) {
        label.font = FONT_ARIAL_BOLD(label.font.pointSize +1);
    }
    
    if (SCREEN_HEIGHT == IPHONE6P_SCREEN_HEIGHT) {
        label.font = FONT_ARIAL_BOLD(label.font.pointSize + 2);
    }
    
    
}

#pragma mark -- 时间戳转换 --
+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp
{
    NSString *publishString = timestamp;
    double publishLong = [timestamp doubleValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    publishDate = [publishDate  dateByAddingTimeInterval: interval];
    
    publishString = [formatter stringFromDate:publishDate];
    
    return publishString;
}

@end

