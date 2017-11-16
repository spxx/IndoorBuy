//
//  BaseRequset.h
//  成长轨迹
//
//  Created by Leo Tang on 15/1/7.
//  Copyright (c) 2015年 Leo Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RequestResultSuccess, // 成功
    RequestResultFailed, // 失败
    RequestResultException, // 异常
    RequestResultEmptyData, // 无数据
    RequestResultDelegated,
} RequestResult;

typedef void(^RequestCallback)(RequestResult result, id object);

typedef void(^DownLoadCallBack)(RequestResult result, id object);

@interface BaseRequset : NSObject

/**
 *  BMW api2接口
 *
 *  @param method
 *  @param parameters
 *  @param callBack
 */
+ (void)sendPOSTRequestWithBMWApi2Method:(NSString *)method
                              parameters:(NSDictionary *)parameters
                                callBack:(RequestCallback)callBack;

/**
 *  BMW api接口
 *
 *  @param method     请求的方法
 *  @param parameters 参数
 *  @param callBack   回调函数
 */
+ (void)sendPOSTRequestWithMethod_Data:(NSString *)method parameters:(NSDictionary *)parameters callBack:(RequestCallback)callBack;
/**
 *  分销的接口
 *
 *  @param method
 *  @param parameters
 *  @param callBack
 */
+ (void)sendPOSTRequestWithDPMethod:(NSString *)method
                         parameters:(NSDictionary *)parameters
                           callBack:(RequestCallback)callBack;

/**
 *  上传图片
 *
 *  @param image    图像
 *  @param type     类型
 *  @param callBack 回调函数
 */
+(void)upLoadImageWithUrl:(NSString*)url parmas:(id)parmas withImage:(UIImage*)image RequestSuccess:(void(^)(id result))success failBlcok:(void(^)(id result))failBlcok;

+(void)upLoadImagewithGoodsImage:(NSString*)url parmas:(id)parmas withImage:(UIImage*)image RequestSuccess:(void(^)(id result))success failBlcok:(void(^)(id result))failBlcok;


/**
 * 下载文件
 */
- (void)downloadFileURL:(NSString *)aUrl
               savePath:(NSString *)aSavePath
               fileName:(NSString *)aFileName
               callBack:(DownLoadCallBack)callBack;

@end
