//
//  AESEncrypt.h
//  AESEcryptDemo
//
//  Created by Leo Tang on 14/12/17.
//  Copyright (c) 2014年 Leo Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYEncrypt : NSObject

// MD5
+ (NSString *)stringEncryptUsingMD5:(NSString *)string subrange:(NSRange)range;
// DES
+ (NSString *)encryptUseDES:(NSString *)clearText;
+ (NSString *)decryptUseDES:(NSString *)plainText;
// AES
+ (NSString *)AES128Encrypt:(NSString *)plainText;
+ (NSString *)AES128Decrypt:(NSString *)encryptText;
+ (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
@end
