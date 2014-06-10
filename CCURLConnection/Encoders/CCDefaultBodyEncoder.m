//
//  CCDefaultBodyEncoder.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import "CCDefaultBodyEncoder.h"
#import "CCDefaultQueryEncoder.h"

@implementation CCDefaultBodyEncoder

static CCDefaultBodyEncoder *_encoder;

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
    NSArray *parameters = [[CCDefaultQueryEncoder sharedEncoder] queryParametersWithObject:object error:error];
    return (parameters ? [[parameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding] : nil);
}

- (NSString *)contentType
{
    return @"application/x-www-form-urlencoded";
}

@end
