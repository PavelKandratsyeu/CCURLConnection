//
//  CCJsonParser.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 12/9/13.
//
//

#import <Foundation/Foundation.h>
#import "CCParser.h"

@interface CCJsonParser : NSObject <CCParser>

+ (instancetype)sharedParser;

@end
