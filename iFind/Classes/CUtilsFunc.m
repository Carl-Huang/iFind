//
//  CUtilsFunc.m
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CUtilsFunc.h"

@implementation CUtilsFunc
//判断是否是iPad
+(BOOL)iPad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? YES : NO;
}
//判断是否是iPhone
+(BOOL)iPhone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? YES : NO;
}
//判断是否是iPhone5
+(BOOL)iPhone5
{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO;
}
//取得ios的版本
+(int)versionOfIOS
{
    return [[UIDevice currentDevice].systemVersion intValue];
}
//判断是否网络可用
+(BOOL)isReachable
{
    return NO;
}
//取得wifi的GSSID,即Mac地址
+(NSString *)macAddressOfWIFI
{
    return nil;
}
//CFUUIDRef 转化为 NSString 
+(NSString *)convertCFUUIDIntoString:(CFUUIDRef)uuid
{
    NSAssert(uuid != NULL, @"The CFUUID is null.");
    NSString * uuidStr = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid) autorelease];
    return uuidStr;
}

+ (NSData *)BinaryValueFromHexString:(NSString *)str
{
    NSArray * array = [str componentsSeparatedByString:@" "];
    unsigned long hex;
    unsigned char ch;
    NSMutableData * data = [NSMutableData data];
    for (NSString * value in array)
    {
        sscanf(value.UTF8String, "%2lx", &hex);
        ch = hex & 0x000000ff;
        [data appendBytes:&ch length:1];
    }
    return [NSData dataWithData:data];
}

+(NSString *)HexStringFromBinaryValue:(NSData *)data
{
    unsigned char * buf = (unsigned char *) data.bytes;
    NSMutableString * str = [NSMutableString string];
    unsigned long hex;
    for (int i=0; i<data.length; i++)
    {
        hex = buf[i];
        [str appendFormat:@"%02lx ", hex & 0x000000ff];
    }
    //NSLog(@"HexStringFromBinaryValue(): %@", str);
    return [str substringToIndex:str.length - 1];
}

+(int)HexConvertIntoInt:(NSString*)tmpid
{
    int int_ch;
    unichar hex_char1 = [tmpid characterAtIndex:0]; ////两位16进制数中的第一位(高位*16)
    int int_ch1;
    if(hex_char1 >= '0'&& hex_char1 <='9')
        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
    else if(hex_char1 >= 'A'&& hex_char1 <='F')
        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
    else
        int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97

    unichar hex_char2 = [tmpid characterAtIndex:1]; ///两位16进制数中的第二位(低位)
    int int_ch2;
    if(hex_char2 >= '0'&& hex_char2 <='9')
        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
    else if(hex_char1 >= 'A'&& hex_char1 <='F')
        int_ch2 = hex_char2-55; //// A 的Ascll - 65
    else
        int_ch2 = hex_char2-87; //// a 的Ascll - 97
    
    int_ch = int_ch1+int_ch2;    
    return int_ch;
}


+(NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    NSString *str=@"";
    if([endtmp length]<4)
    {
        for (int x=[endtmp length]; x<4; x++) {
            str=[str stringByAppendingString:@"0"];
        }
        endtmp=[[NSString alloc]initWithFormat:@"%@%@",str,endtmp];
    }
    return endtmp;
}

@end
