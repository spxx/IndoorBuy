//
//  AESEncrypt.m
//  AESEcryptDemo
//
//  Created by Leo Tang on 14/12/17.
//  Copyright (c) 2014年 Leo Tang. All rights reserved.
//

#import "TYEncrypt.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/**************AES密钥***************/
#define gkey @"1234567890123456"
#define gIv @""
/**************DES密钥***************/
#define DES_KEY @"12345678"

@implementation TYEncrypt

#pragma mark - MD5

+ (NSString *)stringEncryptUsingMD5:(NSString *)string subrange:(NSRange)range {
    
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned)strlen(cStr), result); // This is the md5 call
    NSString *md5String = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    
    return [md5String substringWithRange:range];
}

#pragma mark - DES加密

+ (NSString *)encryptUseDES:(NSString *)clearText
{
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSASCIIStringEncoding];
    NSUInteger dataLength = [textData length];
    
    size_t dataOutAvailable = (dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    size_t dataOutMoved = 0;
    
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [DES_KEY UTF8String];
    const void *iv = (const void *) [DES_KEY UTF8String];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          vkey, kCCBlockSizeDES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          (void*)dataOut, dataOutAvailable,
                                          &dataOutMoved);
    
    if (cryptStatus == kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:(const void *)dataOut  length:(NSUInteger)dataOutMoved];
        ciphertext = [self stringWithHexBytes2:data];
        
    }
    
    return ciphertext;
}

+ (NSString *)decryptUseDES:(NSString *)plainText
{
    NSString *cleartext = nil;
    NSData *textData = [self parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    
    size_t dataOutAvailable = (dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    size_t dataOutMoved = 0;
    
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [DES_KEY UTF8String];
    const void *iv = (const void *) [DES_KEY UTF8String];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          vkey, kCCBlockSizeDES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          (void*)dataOut, dataOutAvailable,
                                          &dataOutMoved);
    
    if (cryptStatus == kCCSuccess)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSData *data = [NSData dataWithBytes:(const void *)dataOut  length:(NSUInteger)dataOutMoved];
        cleartext = [[NSString alloc] initWithData:data encoding:enc];
    }
    
    return cleartext;
}

+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}

+ (NSData*)parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

#pragma mark - AES加密（128，cbc，nopadding）

+ (NSString *)AES128Encrypt:(NSString *)plainText
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    NSInteger diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    NSInteger newSize = 0;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000 | kCCOptionECBMode,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64 stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}
#pragma mark -- key 
+ (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    NSInteger diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    NSInteger newSize = 0;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000 | kCCOptionECBMode,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64 stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}

+ (NSString *)AES128Decrypt:(NSString *)encryptText
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000 | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

@end
