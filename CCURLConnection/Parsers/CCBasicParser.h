//
//  CCBasicParser.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 6/10/14.
//
//

#import <Foundation/Foundation.h>
#import "CCParser.h"

@interface CCBasicParser : NSObject <CCParser>

+ (instancetype)sharedParser;

@end
