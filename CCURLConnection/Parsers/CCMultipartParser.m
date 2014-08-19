//
//  CCMultipartParser.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 8/19/14.
//
//

#import "CCMultipartParser.h"
#import "CCFilePostParameter.h"

@implementation CCMultipartParser

static CCMultipartParser *_parser;

+ (void)initialize
{
    if (self == [CCMultipartParser class]) {
        _parser = [self new];
    }
}

+ (instancetype)sharedParser
{
    return _parser;
}

#pragma mark - CCParser

- (id)objectWithData:(NSData *)data parameters:(NSString *)parameters
{
    NSArray *params = [parameters componentsSeparatedByString:@"; "];
    NSData *boudary;
    for (NSString *param in params) {
        if ([param hasPrefix:@"boundary="]) {
            boudary = [[NSString stringWithFormat:@"--%@", [param substringFromIndex:9]] dataUsingEncoding:NSUTF8StringEncoding];
            break;
        }
    }
    if (!boudary) {
        return nil;
    }
    NSRange range = [data rangeOfData:boudary options:NSDataSearchAnchored range:NSMakeRange(0, data.length)];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableData *nextBoundary = [NSMutableData dataWithData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [nextBoundary appendData:boudary];
    NSData *valuePrefix = [@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSUInteger currentByte = range.location + range.length;
    for (range = [data rangeOfData:nextBoundary options:0 range:NSMakeRange(currentByte, data.length - currentByte)];
         range.location != NSNotFound;
         range = [data rangeOfData:nextBoundary options:0 range:NSMakeRange(currentByte, data.length - currentByte)]) {
        NSRange valuePrefixRange = [data rangeOfData:valuePrefix options:0 range:NSMakeRange(currentByte, range.location - currentByte)];
        if (range.location == NSNotFound) {
            return nil;
        }
        NSString *description = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(currentByte, valuePrefixRange.location - currentByte)] encoding:NSUTF8StringEncoding];
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^\r\nContent-Disposition: ([^;]*); name=\"([^\"]*)\"(?:; filename=\"([^\"]*)\"\r\nContent-Type: (.*))?$"
                                                                                options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *match = [regexp firstMatchInString:description options:0 range:NSMakeRange(0, description.length)];
        if (!match) {
            return nil;
        }
        [result setObject:[data subdataWithRange:NSMakeRange(valuePrefixRange.location + valuePrefixRange.length, range.location - (valuePrefixRange.location + valuePrefixRange.length))]
                   forKey:[description substringWithRange:[match rangeAtIndex:2]]];
        currentByte = range.location + range.length;
    }
    return result;
}

@end
