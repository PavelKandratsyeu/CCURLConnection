//
//  CCMultipartParser.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 8/19/14.
//
//

#import <Foundation/Foundation.h>
#import "CCParser.h"

@interface CCMultipartParser : NSObject <CCParser>

+ (instancetype)sharedParser;

@end
