//
//  CCTextParser.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import "CCTextParser.h"

@implementation CCTextParser

static CCTextParser *_parser;

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
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
