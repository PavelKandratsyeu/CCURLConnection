//
//  CCAspNetBodyEncoder.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import "CCAspNetBodyEncoder.h"
#import "CCAspNetQueryEncoder.h"

@implementation CCAspNetBodyEncoder

static CCAspNetBodyEncoder *_encoder;

+ (void)initialize
{
    if (self == [CCAspNetBodyEncoder class]) {
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
    NSArray *parameters = [[CCAspNetQueryEncoder sharedEncoder] queryParametersWithObject:object error:error];
    return (parameters ? [[parameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding] : nil);
}

- (NSString *)contentType
{
    return @"application/x-www-form-urlencoded";
}

@end
