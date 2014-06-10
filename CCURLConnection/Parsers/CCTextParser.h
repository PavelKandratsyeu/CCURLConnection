//
//  CCTextParser.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import <Foundation/Foundation.h>
#import "CCParser.h"

@interface CCTextParser : NSObject <CCParser>

+ (instancetype)sharedParser;

@end
