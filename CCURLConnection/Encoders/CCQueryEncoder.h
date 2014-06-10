//
//  CCQueryEncoder.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import <Foundation/Foundation.h>

@protocol CCQueryEncoder <NSObject>

- (NSArray *)queryParametersWithObject:(id)object error:(NSError **)error;

@end
