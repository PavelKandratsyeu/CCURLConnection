//
//  CCBodyEncoder.h
//  CCURLConnection
//
//  Created by Kondratyev, Pavel on 3/19/14.
//
//

#import <Foundation/Foundation.h>

@protocol CCBodyEncoder <NSObject>

- (NSData *)dataWithObject:(id)object error:(NSError **)error;
- (NSString *)contentType;

@end
