//
//  CCJsonBodyEncoder.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import "CCJsonBodyEncoder.h"

@implementation CCJsonBodyEncoder

static CCJsonBodyEncoder *_encoder;

+ (void)initialize
{
    if (self == [CCJsonBodyEncoder class]) {
        _encoder = [self new];
    }
}

+ (instancetype)sharedEncoder
{
    return _encoder;
}

#pragma mark - BodyEncoder

- (NSData *)dataWithObject:(id)object error:(NSError **)error
{
    return (object ? [NSJSONSerialization dataWithJSONObject:object options:0 error:error] : nil);
}

- (NSString *)contentType
{
    return @"application/json";
}

@end
