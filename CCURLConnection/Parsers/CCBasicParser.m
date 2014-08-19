//
//  CCBasicParser.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 6/10/14.
//
//

#import "CCBasicParser.h"

@implementation CCBasicParser

static CCBasicParser *_parser;

+ (void)initialize
{
    if (self == [CCBasicParser class]) {
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
    return data;
}

@end
