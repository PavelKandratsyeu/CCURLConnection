//
//  CCURLConnection.m
//  CCURLConnection
//
//  Created by  on 5/28/12.
//
//

#import "CCURLConnection.h"
#import "CCFilePostParameter.h"
#import "Parsers/CCParsers.h"
#import "Encoders/CCEncoders.h"

@interface CCURLConnection ()

@property (nonatomic, copy) CCURLConnectionCallback callback;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, weak) NSURLConnection *connection;

- (id<CCParser>)parser;
- (id)parsedResponse;

@end

@implementation CCURLConnection

static NSUInteger _maxFileSize;
static NSDictionary *_parsers;
static NSDictionary *_methods;
static NSArray *_queryEncoders;
static NSArray *_bodyEncoders;

+ (void)initialize
{
    if (self == [CCURLConnection class]) {
        _parsers = @{@"application/json": [CCJsonParser sharedParser],
                     @"text/plain": [CCTextParser sharedParser],
                     @"text/html": [CCTextParser sharedParser],
                     @"application/pdf": [CCBasicParser sharedParser],
                     @"image/png": [CCBasicParser sharedParser]};
        _methods = @{@(CCURLRequestMethodGet): @"GET",
                     @(CCURLRequestMethodDelete): @"DELETE",
                     @(CCURLRequestMethodPost): @"POST",
                     @(CCURLRequestMethodPut): @"PUT",
                     @(CCURLRequestMethodPatch): @"PATCH",
                     @(CCURLRequestMethodUpdate): @"UPDATE"};
        _queryEncoders = @[[CCDefaultQueryEncoder sharedEncoder], [CCAspNetQueryEncoder sharedEncoder], [CCDefaultQueryEncoder sharedEncoder]];
        _bodyEncoders = @[@[[CCDefaultBodyEncoder sharedEncoder], [CCAspNetBodyEncoder sharedEncoder], [CCJsonBodyEncoder sharedEncoder]],
                          @[[CCDefaultMultipartBodyEncoder sharedEncoder], [CCAspNetMultipartBodyEncoder sharedEncoder], [CCDefaultMultipartBodyEncoder sharedEncoder]]];
        [self setMaxFileSize:0xffffffff];
    }
}

+ (NSUInteger)maxFileSize
{
    return _maxFileSize;
}

+ (void)setMaxFileSize:(NSUInteger)maxFileSize
{
    _maxFileSize = maxFileSize;
}

- (void)startWithURL:(NSURL *)url
              method:(CCURLRequestMethod)method
          parameters:(NSDictionary *)parameters
       encodingStyle:(CCParametersEncodingStyle)encodingStyle
             headers:(NSDictionary *)headers
            callback:(CCURLConnectionCallback)callback
{
    NSError *error = nil;
    NSMutableURLRequest *request = nil;
    switch (method) {
        case CCURLRequestMethodDelete:
        case CCURLRequestMethodGet:
            if (parameters.count) {
                NSArray *params = [_queryEncoders[encodingStyle] queryParametersWithObject:parameters error:&error];
                if (!params) {
                    break;
                }
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", url.absoluteString, url.query.length ? @"&" : @"?", [params componentsJoinedByString:@"&"]]];
            }
            if (!url) {
                error = [NSError errorWithDomain:CCREQUEST_BUILDER_ERROR_DOMAIN code:CCRequestBuilderErrorInvalidAddress userInfo:nil];
                break;
            }
            request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
            break;
        case CCURLRequestMethodUpdate:
        case CCURLRequestMethodPost:
        case CCURLRequestMethodPatch:
        case CCURLRequestMethodPut: {
            if (!url) {
                error = [NSError errorWithDomain:CCREQUEST_BUILDER_ERROR_DOMAIN code:CCRequestBuilderErrorInvalidAddress userInfo:nil];
                break;
            }
            request = [NSMutableURLRequest requestWithURL:url];
            __block BOOL isMultipart = NO;
            NSMutableSet *parametersToCheck = [NSMutableSet setWithArray:parameters.allValues];
            for (id obj = parametersToCheck.anyObject; obj; [parametersToCheck removeObject:obj], obj = parametersToCheck.anyObject) {
                if ([obj respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)]) {
                    [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        [parametersToCheck addObject:obj];
                    }];
                } else if ([obj respondsToSelector:@selector(enumerateObjectsUsingBlock:)]) {
                    [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [parametersToCheck addObject:obj];
                    }];
                } else if ([obj isKindOfClass:[CCFilePostParameter class]]) {
                    isMultipart = YES;
                    break;
                }
            }
            NSData *data = [_bodyEncoders[isMultipart][encodingStyle] dataWithObject:parameters error:&error];
            if (!data) {
                break;
            }
            [request addValue:[_bodyEncoders[isMultipart][encodingStyle] contentType] forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:data];
        }
            break;
        default:
            error = [NSError errorWithDomain:CCREQUEST_BUILDER_ERROR_DOMAIN code:CCRequestBuilderErrorMethodUndefined userInfo:nil];
    }
    if (error) {
        self.connection = nil;
        if (callback) {
            callback(self, nil, error);
        }
    } else {
        [request setHTTPMethod:[_methods objectForKey:@(method)]];
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request addValue:obj forHTTPHeaderField:key];
        }];
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        self.callback = callback;
    }
}

- (id<CCParser>)parser
{
    NSString *contentType = self.response.allHeaderFields[@"Content-Type"];
    NSUInteger location = [contentType rangeOfString:@";"].location;
    if (location != NSNotFound) {
        contentType = [contentType substringToIndex:location];
    }
    return _parsers[contentType];
}

- (id)parsedResponse
{
    return [self.parser objectWithData:self.data];
}

- (void)setConnection:(NSURLConnection *)connection
{
    if (_connection) {
        [_connection cancel];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.data = nil;
        self.response = nil;
        self.callback = nil;
    }
    _connection = connection;
    if (connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)cancel
{
    self.connection = nil;
}

- (BOOL)isRunning
{
    return self.connection != nil;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = (NSHTTPURLResponse *)response;
    self.data = ([response expectedContentLength] == NSURLResponseUnknownLength ?
                 [NSMutableData data] :
                 [NSMutableData dataWithCapacity:(NSUInteger)[response expectedContentLength]]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.callback) {
        self.callback(self, self.parsedResponse, (self.response.statusCode / 100 == CCHTTPStatusTypeSuccess ?
                                                  nil :
                                                  [NSError errorWithDomain:CCURL_CONNECTION_ERROR_DOMAIN code:self.response.statusCode userInfo:nil]));
    }
    if (self.connection == connection) {
        self.connection = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.callback) {
        self.callback(self, nil, error);
    }
    if (self.connection == connection) {
        self.connection = nil;
    }
}

@end
