//
//  CCURLConnection.h
//  CCURLConnection
//
//  Created by  on 5/28/12.
//
//

#import <UIKit/UIKit.h>

#define CCURL_CONNECTION_ERROR_DOMAIN                 @"CCURL_CONNECTION_ERROR_DOMAIN"
#define CCURL_CONNECTION_ERROR_UNAUTHORIZED           401
#define CCURL_CONNECTION_ERROR_UNPROCESSABLE_ENTITY   422

#define CCREQUEST_BUILDER_ERROR_DOMAIN              @"CCREQUEST_BUILDER_ERROR_DOMAIN"
#define CCREQUEST_BUILDER_ERROR_TOO_LARGE_FILE      1
#define CCREQUEST_BUILDER_ERROR_INVALID_ADDRESS     2
#define CCREQUEST_BUILDER_ERROR_INVALID_PARAMETER   3
#define CCREQUEST_BUILDER_ERROR_METHOD_UNDEFINED    4

typedef enum {
    CCParametersEncodingDefault,
    CCParametersEncodingAspNet,
    CCParametersEncodingJson
} CCParametersEncodingStyle;

typedef enum {
    CCURLRequestMethodUndefined,
    CCURLRequestMethodGet,
    CCURLRequestMethodPost,
    CCURLRequestMethodDelete,
    CCURLRequestMethodUpdate,
    CCURLRequestMethodPatch,
    CCURLRequestMethodPut
} CCURLRequestMethod;

@class CCURLConnection;

typedef void (^CCURLConnectionCallback)(CCURLConnection *connection, id response, NSError *error);

@interface CCURLConnection : NSObject <NSURLConnectionDataDelegate>

- (void)startWithURL:(NSURL *)url
              method:(CCURLRequestMethod)method
          parameters:(NSDictionary *)parameters
       encodingStyle:(CCParametersEncodingStyle)encodingStyle
             headers:(NSDictionary *)headers
            callback:(CCURLConnectionCallback)callback;
- (void)cancel;
- (BOOL)isRunning;

@end
