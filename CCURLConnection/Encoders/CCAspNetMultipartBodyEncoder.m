//
//  CCAspNetMultipartBodyEncoder.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import "CCAspNetMultipartBodyEncoder.h"
#import "CCFilePostParameter.h"
#import "CCMultipartEncoderConstants.h"
#import "CCURLConnection.h"

@interface CCAspNetMultipartBodyEncoder ()

- (BOOL)encodeParameter:(NSString *)prefix object:(id)object to:(NSMutableData *)data error:(NSError **)error;

@end

@implementation CCAspNetMultipartBodyEncoder

static CCAspNetMultipartBodyEncoder *_encoder;

+ (void)initialize
{
    if (self == [CCAspNetMultipartBodyEncoder class]) {
        _encoder = [self new];
    }
}

+ (instancetype)sharedEncoder
{
    return _encoder;
}

- (BOOL)encodeParameter:(NSString *)prefix object:(id)object to:(NSMutableData *)data error:(NSError **)error
{
    __block BOOL fail = NO;
    if ([object respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)]) {
        __block NSError *err;
        [object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            *stop = fail = [self encodeParameter:(prefix.length
                                           ? [NSString stringWithFormat:@"%@.%@", prefix, key]
                                           : key) object:obj to:data error:&err];
        }];
        if (error) {
            *error = err;
        }
    } else if ([object respondsToSelector:@selector(enumerateObjectsUsingBlock:)]) {
        __block unsigned long idx = 0;
        __block NSError *err;
        [object enumerateObjectsUsingBlock:^(id obj, NSUInteger unused, BOOL *stop) {
            *stop = fail = [self encodeParameter:[NSString stringWithFormat:@"%@%%5B%lu%%5D", prefix, idx++] object:obj to:data error:&err];
        }];
        if (error) {
            *error = err;
        }
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        [data appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n\r\n", MULTIPART_BOUNDARY, prefix] dataUsingEncoding:NSUTF8StringEncoding]];
    } else if ([object isKindOfClass:[CCFilePostParameter class]]) {
        if ([object data].length > [CCURLConnection maxFileSize]) {
            if (error) {
                *error = [NSError errorWithDomain:CCREQUEST_BUILDER_ERROR_DOMAIN code:CCRequestBuilderErrorTooLargeFile userInfo:nil];
            }
            fail = YES;
        } else {
            [data appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n", MULTIPART_BOUNDARY, prefix, [object fileName], [object contentType]] dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[object data]];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    } else {
        [data appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", MULTIPART_BOUNDARY, prefix, [object description]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (!prefix) {
        [data appendData:[[NSString stringWithFormat:@"--%@--", MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return fail;
}

#pragma mark - BodyEncoder

- (NSData *)dataWithObject:(id)object error:(NSError **)error
{
    NSMutableData *result = [NSMutableData data];
    return ([self encodeParameter:nil object:object to:result error:error] ? nil : result);
}

- (NSString *)contentType
{
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTIPART_BOUNDARY];
}

@end
