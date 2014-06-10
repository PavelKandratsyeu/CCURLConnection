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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parser = [self new];
    });
}

+ (instancetype)sharedParser
{
    return _parser;
}

#pragma mark - CCParser

- (id)objectWithData:(NSData *)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

@end
