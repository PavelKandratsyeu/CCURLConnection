//
//  CCDefaultQueryEncoder.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import <Foundation/Foundation.h>
#import "CCQueryEncoder.h"

@interface CCDefaultQueryEncoder : NSObject <CCQueryEncoder>

+ (instancetype)sharedEncoder;

@end
