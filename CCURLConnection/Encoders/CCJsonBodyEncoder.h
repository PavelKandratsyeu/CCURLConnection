//
//  CCJsonBodyEncoder.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import <Foundation/Foundation.h>
#import "CCBodyEncoder.h"

@interface CCJsonBodyEncoder : NSObject <CCBodyEncoder>

+ (instancetype)sharedEncoder;

@end
