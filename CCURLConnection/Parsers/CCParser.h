//
//  CCParser.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 6/10/14.
//
//

#import <Foundation/Foundation.h>

@protocol CCParser <NSObject>

- (id)objectWithData:(NSData *)data parameters:(NSString *)parameters;

@end
