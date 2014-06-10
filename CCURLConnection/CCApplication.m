//
//  CCApplication.m
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 4/25/14.
//
//

#import "CCApplication.h"

@implementation CCApplication

static unsigned int _networkActivityCounter = 0;

- (void)setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible
{
    if (networkActivityIndicatorVisible) {
        if (++_networkActivityCounter == 1) {
            [super setNetworkActivityIndicatorVisible:networkActivityIndicatorVisible];
        }
    } else {
        if (--_networkActivityCounter == 0) {
            [super setNetworkActivityIndicatorVisible:networkActivityIndicatorVisible];
        }
    }
}

@end
