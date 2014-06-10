//
//  CCFilePostParameter.h
//  CCURLConnection
//
//  Created by  on 5/18/12.
//
//

#import <Foundation/Foundation.h>

@interface CCFilePostParameter : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSData *data;

- (id)initWithFileName:(NSString *)fileName contentType:(NSString *)contentType data:(NSData *)data;
+ (instancetype)filePostParameterWithFileName:(NSString *)fileName contentType:(NSString *)contentType data:(NSData *)data;

@end
