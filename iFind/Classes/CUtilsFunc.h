//
//  CUtilsFunc.h
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUtilsFunc : NSObject

+(BOOL)iPad;
+(BOOL)iPhone;
+(BOOL)iPhone5;
+(int)versionOfIOS;
+(BOOL)isReachable;
+(NSString *)macAddressOfWIFI;

+(NSString *)convertCFUUIDIntoString:(CFUUIDRef)uuid;
+(NSData *)BinaryValueFromHexString:(NSString *)str;
+(NSString *)HexStringFromBinaryValue:(NSData *)data;
+(int)HexConvertIntoInt:(NSString*)tmpid;
+(NSString *)ToHex:(int)tmpid;
@end
