//
//  BaseRequset.m
//  成长轨迹
//
//  Created by Leo Tang on 15/1/7.
//  Copyright (c) 2015年 Leo Tang. All rights reserved.
//

#import "BaseRequset.h"
#import "AFNetworking.h"



@implementation BaseRequset

/**
 *  BMW api2接口
 *
 *  @param method
 *  @param parameters
 *  @param callBack
 */
+ (void)sendPOSTRequestWithBMWApi2Method:(NSString *)method
                              parameters:(NSDictionary *)parameters
                                callBack:(RequestCallback)callBack {
    // 初始化请求
    NSString *url = INDOORBUY_URL_API2;
    NSLog(@"%@",parameters);
    // 参数格式化
    parameters = [self parameterFormatterWithMethod:method parameters:parameters];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/html", nil];
    
    manager.requestSerializer.timeoutInterval = 30;
    // 发送请求
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，返回解密对象
        if (callBack) {
            // 返回正常数据格式
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 解密
                id object = [self decryptReturnData:responseObject];
                
                switch ([object[@"code"] integerValue]) {
                    case 100:
                        callBack(RequestResultSuccess, object);
                        break;
                    case 902:
                        callBack(RequestResultEmptyData, object);
                        break;
                    case 999:
                        callBack(RequestResultException, object);
                        break;
                    default:
                        callBack(RequestResultFailed, object[@"message"]);
                        break;
                }
            }
            // 异常数据格式
            else {
                callBack(RequestResultException, responseObject);
                NSLog(@"数据异常：%@", responseObject);
            }
        } else {
            NSLog(@"Request success with responseObject - \n '%@'", [self decryptReturnData:responseObject]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 判断网络
        BOOL reachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
        if (!reachable) {
        }
        
        //        NSString * er = [[NSString alloc]initWithData:error encoding:NSUTF8StringEncoding];
        // 请求失败，返回错误信息
        if (callBack) {
            NSString * message;
            if (error.code == 3840 || error.code == -1003) {
                message = @"服务器故障，程序猿正在拼命修复！";
            }else if (error.code == -1001) {
                message = @"网络连接超时，请检查网络";
            }else if (error.code == -1009) {
                message = @"您已断开网络连接，请检查网络";
            }else {
                message = @"服务器故障，程序猿正在拼命修复！";
            }
            callBack(RequestResultFailed, message);
        } else {
            NSLog(@"Request failed with reason '%@'", [error localizedDescription]);
        }
    }];
}


+ (void)sendPOSTRequestWithMethod_Data:(NSString *)method parameters:(NSDictionary *)parameters callBack:(RequestCallback)callBack
{
    // 初始化请求
    NSString *url = INDOORBUY_URL_API2;
    // 参数格式化
    parameters = [self parameterFormatterWithMethod:method parameters:parameters];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/html", nil];
    
    manager.requestSerializer.timeoutInterval = 30;
    // 发送请求
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，返回解密对象
        if (callBack) {
            // 返回正常数据格式
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 解密
                id object = [self decryptReturnData:responseObject];
                
                switch ([object[@"code"] integerValue]) {
                    case 100:
                        callBack(RequestResultSuccess, object);
                        break;
                    case 902:
                        callBack(RequestResultEmptyData, object);
                        break;
                    case 999:
                        callBack(RequestResultException, object);
                        break;
                    default:
                        callBack(RequestResultFailed, object[@"message"]);
                        break;
                }
            }
            // 异常数据格式
            else {
                callBack(RequestResultException, responseObject);
                NSLog(@"数据异常：%@", responseObject);
            }
        } else {
            NSLog(@"Request success with responseObject - \n '%@'", [self decryptReturnData:responseObject]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 判断网络
        BOOL reachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
        if (!reachable) {
        }
        
//        NSString * er = [[NSString alloc]initWithData:error encoding:NSUTF8StringEncoding];
        // 请求失败，返回错误信息
        if (callBack) {
            NSString * message;
            if (error.code == 3840 || error.code == -1003) {
                message = @"服务器故障，程序猿正在拼命修复！";
            }else if (error.code == -1001) {
                message = @"网络连接超时，请检查网络";
            }else if (error.code == -1009) {
                message = @"您已断开网络连接，请检查网络";
            }else {
                message = @"服务器故障，程序猿正在拼命修复！";
            }
            callBack(RequestResultFailed, message);
        } else {
            NSLog(@"Request failed with reason '%@'", [error localizedDescription]);
        }
    }];
}
/**
 *  分销接口
 *
 *  @param method     
 *  @param parameters
 *  @param callBack
 */
+ (void)sendPOSTRequestWithDPMethod:(NSString *)method
                       parameters:(NSDictionary *)parameters
                         callBack:(RequestCallback)callBack {
    
    NSLog(@"parameters - %@", parameters);
    
    // 初始化请求
    NSString *url = DR_URL;
    // 参数格式化
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/html", nil];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，返回解密对象
        if (callBack) {
            // 返回正常数据格式
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 解密
                switch ([responseObject[@"status"] integerValue]) {
                    case 1:
                        callBack(RequestResultSuccess, responseObject);
                        break;
                    default:
                        callBack(RequestResultException, [NSString stringWithFormat:@"%@",responseObject[@"msg"]]);
                        break;
                }
            }
            // 异常数据格式
            else {
                callBack(RequestResultException, responseObject);
                NSLog(@"数据异常：%@", responseObject);
            }
        } else {
            NSLog(@"Request success with responseObject - \n '%@'", [self decryptReturnData:responseObject]);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 判断网络
        BOOL reachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
        if (!reachable) {
#warning ...
        }
        // 请求失败，返回错误信息
        if (callBack) {
            NSString * message;
            if (error.code == 3840 || error.code == -1003) {
                message = @"服务器故障，程序猿正在拼命修复！";
            }else if (error.code == -1001) {
                message = @"网络连接超时，请检查网络";
            }else if (error.code == -1009) {
                message = @"您已断开网络连接，请检查网络";
            }else {
                message = @"服务器故障，程序猿正在拼命修复！";
            }
            callBack(RequestResultFailed, message);
        } else {
            NSLog(@"Request failed with reason '%@'", [error localizedDescription]);
        }
    }];
}


// 上传图片
+(void)upLoadImageWithUrl:(NSString*)url parmas:(id)parmas withImage:(UIImage*)image RequestSuccess:(void(^)(id result))success failBlcok:(void(^)(id result))failBlcok
{
    
    UIImage *imageV =   [TYTools originalImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    
    NSData *imageData = [TYTools originalImage:imageV compress:0.9];
//    NSData *imageData = UIImageJPEGRepresentation(imageV, 1.0);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"apple.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        id jsonobj = [TYTools JSONObjectWithString:str];
        
        //        id object = [self decryptReturnData:jsonobj];
        success(jsonobj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString * str = [[NSString alloc]initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        NSLog(@"%@%@",str,[error localizedDescription]);
        success(error);
    }];
    
}
//上传有问题图片
+(void)upLoadImagewithGoodsImage:(NSString*)url parmas:(id)parmas withImage:(UIImage*)image RequestSuccess:(void(^)(id result))success failBlcok:(void(^)(id result))failBlcok
{
    
    UIImage *imageV =   [TYTools originalImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    
    NSData *imageData = [TYTools originalImage:imageV compress:0.9];
    //    NSData *imageData = UIImageJPEGRepresentation(imageV, 1.0);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"apple.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        id jsonobj = [TYTools JSONObjectWithString:str];
        
        //        id object = [self decryptReturnData:jsonobj];
        success(jsonobj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString * str = [[NSString alloc]initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        NSLog(@"%@%@",str,[error localizedDescription]);
    }];

}

+ (void)uploadImg:(UIImage *)image
           type:(NSNumber *)type
         callBack:(RequestCallback)callBack {
    
    [self uploadImg:image
         parameters:nil
           callBack:callBack];
    
    return;
}


+ (void)uploadImg:(UIImage *)image
       parameters:(NSDictionary *)parameters
         callBack:(RequestCallback)callBack {
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[self uploadImageURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:45];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc] initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc] initWithFormat:@"%@--", MPboundary];
    
    //得到图片的data
    // 压缩图片
    NSData *imageData = nil;
    CGFloat compression = 1.0;
    do {
        imageData = UIImageJPEGRepresentation(image, compression);
        compression -= 0.1;
    } while (imageData.length / 1024.0 > 300);
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc] init];
    //参数的集合的所有key的集合
    for (NSString *key in [parameters allKeys]) {
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
    }
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               dispatch_sync(dispatch_get_main_queue(), ^{
                                   // 请求失败，返回错误对象
                                   if (connectionError) {
                                       // 判断网络
                                       BOOL reachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
                                       if (!reachable) {
                                       }
                                       callBack(RequestResultFailed, connectionError);
                                       return;
                                   }
                                   
                                   id object = [TYTools JSONObjectWithData:data];
                                   // 请求成功，解析成功，返回json对象
                                   if (object) {
                                       if (callBack) {
                                           callBack(RequestResultSuccess, object);
                                       }
                                   }
                                   // 请求成功，解析失败，返回反馈字符串
                                   else {
                                       if (callBack) {
                                           callBack(RequestResultException, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                       }
                                   }
                               });
                           }];
    
}


/**
 *  上传图片的地址
 */
+ (NSURL *)uploadImageURL {
    
    NSURL *url = nil;
    NSString *urlString = [NSString stringWithFormat:@"%@", INDOORBUY_URL_API2];
    url = [NSURL URLWithString:urlString];
    return url;
}

/**
 *  参数格式化
 *
 *  @param parameters 参数
 *
 *  @return 格式化后的参数
 */
+ (NSDictionary *)parameterFormatterWithMethod:(NSString *)method
                                    parameters:(NSDictionary *)parameters {
    NSMutableDictionary *formatedParametters = [NSMutableDictionary dictionary];
    if (method) {
        [formatedParametters setObject:[TYTools AES128Encrypt:method] forKey:[TYTools AES128Encrypt:@"InterfaceID"]];
    }

    // 逻辑部分
    for (NSString *key in [parameters allKeys]) {
        NSString *valueString = [NSString stringWithFormat:@"%@", parameters[key]];
        [formatedParametters setObject:[TYTools AES128Encrypt:valueString] forKey:[TYTools AES128Encrypt:key]];
        /*
        if ([key isEqualToString:@"password"]) {
            [formatedParametters setObject:valueString forKey:key];
        }
        else{
            
        }
         */
        
    }
    
    return formatedParametters;
}

/**
 *  返回数据解密
 *
 *  @param id 加密数据
 *
 *  @return 解密数据
 */
+ (NSDictionary *)decryptReturnData:(id)object {
    
    NSMutableDictionary *decryptedData = [NSMutableDictionary dictionary];
    // 逻辑部分
    // 状态码
    /*
     902 未找到相关数据
     903 手机号码有误
     904 手机号码重复
     ￼905 验证码错误
     ￼906 用户或密码错误
     ￼907 用户被禁用
     ￼908
     ￼909
     ￼910
     ￼￼911
     */
    if ([object objectForKey:RETURN_CODE]) {
        [decryptedData setObject:[TYTools AES128Decrypt:[object objectForKey:RETURN_CODE]] forKey:@"code"];
    } else {
        NSLog(@"%@ - %@", @"不存在字段'code'，用空字符串代替", NSStringFromSelector(_cmd));
        [decryptedData setObject:@"" forKey:@"code"];
    }
    
    if ([object objectForKey:RETURN_DATA]) {
        
        NSString *decryptString = [TYTools AES128Decrypt:[object objectForKey:RETURN_DATA]];
        //        NSLog(@"decryptString - %@", decryptString);
        NSMutableString *jsonString = [NSMutableString stringWithString:decryptString];
        while ([jsonString characterAtIndex:[jsonString length] - 1] == '\0' && [jsonString length] > 0) {
            [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
        }
        id jsonObject = [TYTools JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        if (jsonObject) {
            [decryptedData setObject:jsonObject forKey:@"data"];
        } else {
            [decryptedData setObject:jsonString forKey:@"data"];
        }
    } else {
        NSLog(@"%@ - %@", @"不存在字段'data'，用空字符串代替", NSStringFromSelector(_cmd));
        [decryptedData setObject:@"" forKey:@"data"];
    }
    
    if ([object objectForKey:RETURN_MESSAGE]) {
        [decryptedData setObject:[TYTools AES128Decrypt:[object objectForKey:RETURN_MESSAGE]] forKey:@"message"];
    } else {
        NSLog(@"%@ - %@", @"不存在字段'message'，用空字符串代替", NSStringFromSelector(_cmd));
        [decryptedData setObject:@"" forKey:@"message"];
    }
    
    return decryptedData;
}

/**
* 下载文件
*/
- (void)downloadFileURL:(NSString *)aUrl
               savePath:(NSString *)aSavePath
               fileName:(NSString *)aFileName
               callBack:(DownLoadCallBack)callBack
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        
        callBack(RequestResultSuccess, audioData);
        
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPSessionManager *operationManger = [AFHTTPSessionManager manager];
        
        NSURLSessionDownloadTask *task = [operationManger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //下载地址
            NSLog(@"默认下载地址:%@",targetPath);
            
            //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
            NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
            return [NSURL URLWithString:filePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            //下载完成调用的方法
            NSLog(@"下载完成：");
            NSLog(@"%@--%@",response,filePath);
            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            //设置下载数据到res字典对象中并用代理返回下载数据NSData
            
            callBack(RequestResultSuccess, audioData);
        }];
        //开启任务
        [task resume];
    }
}




@end
