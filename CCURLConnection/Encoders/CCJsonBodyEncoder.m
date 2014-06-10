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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _encoder = [self new];
    });
}

+ (instancetype)sharedEncoder
{
    return _encoder;
}

#pragma mark - BodyEncoder

- (NSData *)dataWithObject:(id)object error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}

- (NSString *)contentType
{
    return @"application/json";
}

@end
