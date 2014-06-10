//
//  CCFilePostParameter.m
//  CCURLConnection
//
//  Created by  on 5/18/12.
//
//

#import "CCFilePostParameter.h"

@implementation CCFilePostParameter

- (id)initWithFileName:(NSString *)fileName contentType:(NSString *)contentType data:(NSData *)data
{
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.contentType = contentType;
        self.data = data;
    }
    return self;
}

+ (instancetype)filePostParameterWithFileName:(NSString *)fileName contentType:(NSString *)contentType data:(NSData *)data
{
    return [[self alloc] initWithFileName:fileName contentType:contentType data:data];
}

@end
