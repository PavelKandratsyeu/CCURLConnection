//
//  CCJsonParser.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 12/9/13.
//
//

#import "CCJsonParser.h"

@implementation CCJsonParser

static CCJsonParser *_parser;

+ (void)initialize
{
    if (self == [CCJsonParser class]) {
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
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

@end
