//
//  CCAspNetBodyEncoder.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import <Foundation/Foundation.h>
#import "CCBodyEncoder.h"

@interface CCAspNetBodyEncoder : NSObject <CCBodyEncoder>

+ (instancetype)sharedEncoder;

@end
