//
//  NSString+Calculate.m
//  DDCategory
//
//  Created by SuperDanny on 15/4/8.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "NSString+Calculate.h"

@implementation NSString (Calculate)
- (NSString *)stringByAdding:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc]initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc]initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberByAdding:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
}

- (NSString *)stringBySubtracting:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberBySubtracting:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
}

- (NSString *)stringByMultiplyingBy:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingBy:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
}

- (NSString *)stringByDividingBy:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    if ([[bString ridTail] isEqualToString:@"0"]) {
        NSLog(@"除数为0");
        return @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberByDividingBy:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
    return [NSString stringWithFormat:@"%@", c];
}

- (BOOL)isBig:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return NO;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return YES;
    } else {//相等
        return NO;
    }
}

- (NSComparisonResult)ob_compare:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    return [a compare:b];
}

- (NSString *)ridTail {
    NSString *string = self;
    if (![string containsString:@"."]) {
        return string;
    }
    if ([string hasSuffix:@"0"]) {
        string = [string substringToIndex:string.length - 1];
        string = [string ridTail];
    } else if ([string hasSuffix:@"."]) {
        string = [string substringToIndex:string.length - 1];
        return string;
    } else {
        return string;
    }
    return string;
}

+ (NSString *)formatterNumber:(NSNumber *)number {
    return [self formatterNumber:number fractionDigits:2];
}

+ (NSString *)formatterNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMinimumIntegerDigits:1];
    
    return [numberFormatter stringFromNumber:number];
}

@end
