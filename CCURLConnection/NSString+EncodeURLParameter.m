//
//  NSString+EncodeURLParameter.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import "NSString+EncodeURLParameter.h"

@implementation NSString (EncodeURLParameter)

- (NSString *)encodedURLParameter
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, CFSTR(":/=,!$&'()*+;[]@#?"), kCFStringEncodingUTF8));
}

@end
