//
//  CCURLConnection.h
//  CCURLConnection
//
//  Created by  on 5/28/12.
//
//

#import <UIKit/UIKit.h>

#define CCURL_CONNECTION_ERROR_DOMAIN @"CCURL_CONNECTION_ERROR_DOMAIN"

typedef enum {
    CCHTTPStatusTypeInformational   = 1,
    CCHTTPStatusTypeSuccess         = 2,
    CCHTTPStatusTypeRedirection     = 3,
    CCHTTPStatusTypeClientError     = 4,
    CCHTTPStatusTypeServerError     = 5
} CCHTTPStatusType;

typedef enum {
    CCHTTPStatusCodeContinue                            = 100,
    CCHTTPStatusCodeSwitchingProtocols                  = 101,
    CCHTTPStatusCodeProcesing                           = 102,
    
    CCHTTPStatusCodeOk                                  = 200,
    CCHTTPStatusCodeCreated                             = 201,
    CCHTTPStatusCodeAccepted                            = 202,
    CCHTTPStatusCodeNonAuthoritativeInformation         = 203,
    CCHTTPStatusCodeNoContent                           = 204,
    CCHTTPStatusCodeResetContent                        = 205,
    CCHTTPStatusCodePartialContent                      = 206,
    CCHTTPStatusCodeMultyStatus                         = 207,
    CCHTTPStatusCodeAlreadyReported                     = 208,
    CCHTTPStatusCodeIMUsed                              = 226,
    
    CCHTTPStatusCodeMultipleChoises                     = 300,
    CCHTTPStatusCodeMovedPermanently                    = 301,
    CCHTTPStatusCodeFound                               = 302,
    CCHTTPStatusCodeSeeOther                            = 303,
    CCHTTPStatusCodeNotModified                         = 304,
    CCHTTPStatusCodeUseProxy                            = 305,
    CCHTTPStatusCodeSwitchProxy                         = 306,
    CCHTTPStatusCodeTemporaryRedirect                   = 307,
    CCHTTPStatusCodePermanentRedirect                   = 308,
    
    CCHTTPStatusCodeBadRequest                          = 400,
    CCHTTPStatusCodeUnauthorized                        = 401,
    CCHTTPStatusCodePaymentRequired                     = 402,
    CCHTTPStatusCodeForbidden                           = 403,
    CCHTTPStatusCodeNotFound                            = 404,
    CCHTTPStatusCodeMethodNotAllowed                    = 405,
    CCHTTPStatusCodeNotAcceptable                       = 406,
    CCHTTPStatusCodeProxyAuthenticationRequired         = 407,
    CCHTTPStatusCodeRequestTimeout                      = 408,
    CCHTTPStatusCodeConflict                            = 409,
    CCHTTPStatusCodeGone                                = 410,
    CCHTTPStatusCodeLengthRequired                      = 411,
    CCHTTPStatusCodePreconditionFailed                  = 412,
    CCHTTPStatusCodeRequestEntityTooLarge               = 413,
    CCHTTPStatusCodeRequestURITooLong                   = 414,
    CCHTTPStatusCodeUnsupportedMediaType                = 415,
    CCHTTPStatusCodeRequestedLengthNotSatisfiable       = 416,
    CCHTTPStatusCodeExpectationFailed                   = 417,
    CCHTTPStatusCodeIAmATeapot                          = 418,
    CCHTTPStatusCodeAuthenticationTimeout               = 419,
    CCHTTPStatusCodeMethodFailure                       = 420,
    CCHTTPStatusCodeEnhanceYourCalm                     = 420,
    CCHTTPStatusCodeUnprocessableEntity                 = 422,
    CCHTTPStatusCodeLocked                              = 423,
    CCHTTPStatusCodeFailedDependency                    = 424,
    CCHTTPStatusCodeUpgradeRequired                     = 426,
    CCHTTPStatusCodePreconditionRequired                = 428,
    CCHTTPStatusCodeTooManyRequests                     = 429,
    CCHTTPStatusCodeRequestHeaderFieldsTooLarge         = 431,
    CCHTTPStatusCodeLoginTimeout                        = 440,
    CCHTTPStatusCodeNoResponse                          = 444,
    CCHTTPStatusCodeRetryWith                           = 449,
    CCHTTPStatusCodeBlockedByWindowsParentalControls    = 450,
    CCHTTPStatusCodeUnavailableForLegalReasons          = 451,
    CCHTTPStatusCodeRedirect                            = 451,
    CCHTTPStatusCodeRequestHeaderTooLarge               = 494,
    CCHTTPStatusCodeCertError                           = 495,
    CCHTTPStatusCodeNoCert                              = 496,
    CCHTTPStatusCodeHTTPToHTTPS                         = 497,
    CCHTTPStatusCodeTokenExpiredOrInvalid               = 498,
    CCHTTPStatusCodeClientClosedRequest                 = 499,
    CCHTTPStatusCodeTokenRequired                       = 499,
    
    CCHTTPStatusCodeInternalServerError                 = 500,
    CCHTTPStatusCodeNotImplemented                      = 501,
    CCHTTPStatusCodeBadGateway                          = 502,
    CCHTTPStatusCodeServiceUnavailable                  = 503,
    CCHTTPStatusCodeGatewayTimeout                      = 504,
    CCHTTPStatusCodeHTTPVersionNotSupported             = 505,
    CCHTTPStatusCodeVariantAlsoNegotiates               = 506,
    CCHTTPStatusCodeInsufficientStorage                 = 507,
    CCHTTPStatusCodeLoopDetected                        = 508,
    CCHTTPStatusCodeBandwidthLimitExceeded              = 509,
    CCHTTPStatusCodeNotExtended                         = 510,
    CCHTTPStatusCodeNetworkAuthenticationRequired       = 511,
    CCHTTPStatusCodeOriginError                         = 520,
    CCHTTPStatusCodeWebServerIsDown                     = 521,
    CCHTTPStatusCodeConnectionTimedOut                  = 522,
    CCHTTPStatusCodeProxyDeclinedRequest                = 523,
    CCHTTPStatusCodeATimeoutOccured                     = 524,
    CCHTTPStatusCodeNetworkReadTimeoutError             = 598,
    CCHTTPStatusCodeNetworkConnectTimeoutError          = 599
} CCHTTPStatusCode;

#define CCREQUEST_BUILDER_ERROR_DOMAIN @"CCREQUEST_BUILDER_ERROR_DOMAIN"

typedef enum {
    CCRequestBuilderErrorTooLargeFile = 1,
    CCRequestBuilderErrorInvalidAddress,
    CCRequestBuilderErrorInvalidParameter,
    CCRequestBuilderErrorMethodUndefined
} CCRequestBuilderError;

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

+ (NSUInteger)maxFileSize;
+ (void)setMaxFileSize:(NSUInteger)maxFileSize;

@end
