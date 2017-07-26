//
//  NSString+Addition.m
//  DDCategory
//
//  Created by SuperDanny on 15/4/8.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonCrypto.h>
#import "sys/utsname.h"

#define IOS7     [[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@implementation NSString (Addition)
- (NSString *)MD5 {
    if(self.length == 0) {
        return nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}
- (CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
#ifdef IOS7
    CGRect newRect = [self boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil];
    return newRect.size;
#else
    CGSize newSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    return newSize;
#endif
}


#pragma mark - 将HTML特殊字符转义成正常字符
- (NSString *)stringByDecodingXMLEntities {
    
    NSUInteger myLength = [self length];
    NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return self;
    }
    // Make result string with some extra capacity.
    
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
finish:
    return result;
}

#pragma mark - 将特殊字符转义成HTML识别字符
- (NSString *)stringByXMLToESC {
    NSString *result = self;
    result = [[[[[result stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"] stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"] stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"] stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    return result;
}

#pragma mark - URLEncodedString(编码)
- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

#pragma mark - URLDecodedString(解码)
- (NSString *)URLDecodedString {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

///金额转大写
+ (NSString *)digitUppercaseWithMoney:(NSString *)money {
    if ([self filterNULLValue:money].length == 0) {
        return @"";
    }
    //首先转化成标准格式        “200.23”
    NSMutableString *tempStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    //位
    NSArray *carryArr1=@[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *carryArr2=@[@"分",@"角"];
    //数字
    NSArray *numArr=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    //小数点前的数值字符串
    NSString *firstStr=[NSString stringWithFormat:@"%@",temarr[0]];
    //小数点后的数值字符串
    NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];
    
    //是否拼接了“零”，做标记
    bool zero=NO;
    //拼接数据的可变字符串
    NSMutableString *endStr=[[NSMutableString alloc] init];
    
    //首先遍历firstStr，从最高位往个位遍历    高位----->个位
    for (int i=(int)firstStr.length;i>0;i--) {
        //取最高位数
        NSInteger MyData=[[firstStr substringWithRange:NSMakeRange(firstStr.length-i, 1)] integerValue];
        
        if ([numArr[MyData] isEqualToString:@"零"]) {
            
            if ([carryArr1[i-1] isEqualToString:@"万"]||[carryArr1[i-1] isEqualToString:@"亿"]||[carryArr1[i-1] isEqualToString:@"元"]||[carryArr1[i-1] isEqualToString:@"兆"]) {
                //去除有“零万”
                if (zero) {
                    endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:(endStr.length-1)]];
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                } else {
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }
                
                //去除有“亿万”、"兆万"的情况
                if ([carryArr1[i-1] isEqualToString:@"万"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"亿"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                }
                //去除“兆亿”
                if ([carryArr1[i-1] isEqualToString:@"亿"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }
            } else {
                if (!zero) {
                    [endStr appendString:numArr[MyData]];
                    zero=YES;
                }
            }
            
        } else {
            //拼接数字
            [endStr appendString:numArr[MyData]];
            //拼接位
            [endStr appendString:carryArr1[i-1]];
            //不为“零”
            zero=NO;
        }
    }
    
    //再遍历secondStr    角位----->分位
    if ([secondStr isEqualToString:@"00"]) {
        [endStr appendString:@"整"];
        //小数部分跟整数部分都为0时
        if (firstStr.integerValue==0) {
            [endStr insertString:@"零" atIndex:0];
        }
    } else {
        for (int i=(int)secondStr.length;i>0;i--) {
            //取最高位数
            NSInteger MyData=[[secondStr substringWithRange:NSMakeRange(secondStr.length-i, 1)] integerValue];
            
            [endStr appendString:numArr[MyData]];
            [endStr appendString:carryArr2[i-1]];
        }
        //去除只有小数部分的
        if (firstStr.integerValue==0) {
            endStr = [endStr substringFromIndex:1].mutableCopy;
        }
    }
    
    return endStr;
}

+ (NSString *)deviceVersion {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return @"Unknown";
}

#pragma mark 使用这句话的原因，是为了避免使用数据的时候出现空或者其他的，导致闪退
+ (NSString *)filterNULLValue:(NSString *)string {
    NSString *newStr = [NSString stringWithFormat:@"%@",string];
    if ([newStr isKindOfClass:[NSNull class]] ||
        newStr == nil ||
        [newStr isEqualToString:@"(null)"]||
        [newStr isEqualToString:@""] ||
        [newStr isEqualToString:@"null"] ||
        [newStr isEqualToString:@"<null>"]) {
        newStr = @"";
    }
    return newStr;
}

@end
