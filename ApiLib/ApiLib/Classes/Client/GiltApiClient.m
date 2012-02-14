//
//  GiltApiClient.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSalesClient.h"
#import "GiltApi.h"

@implementation GiltApiClient

#pragma mark -
#pragma Abstract Methods

+ (id)allocWithZone:(NSZone *)zone {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark -
#pragma Concrete Methods

+ (NSString *)urlComponentForStore:(GiltApiStores)store {
    NSString *component = nil;
    switch (store) {
        case GiltEveryStore:
            component = @"";
            break;
            
        case GiltMensStore:
            component = @"men/";
            break;

        case GiltWomensStore:
            component = @"women/";
            break;
        
        case GiltKidsStore:
            component = @"kids/";
            break;
        
        case GiltHomeStore:
            component = @"home/";
            break;
        
        //case GiltTasteStore:
        //case GiltCityStore:
        //case GiltJetsetterStore:
        case GiltUnspecifiedStore:
        default:
            @throw [NSException exceptionWithName:@"Invalid Store" 
                                           reason:[NSString stringWithFormat:@"Store '%d' is not a valid GiltApiStores", store] 
                                         userInfo:nil];
            break;
    }
    
    return component;
}

@end

#pragma mark -
#pragma mark

@interface GiltApiClientDownloadRunner (private)
- (void)downloadComplete:(NSError *)error;
@end

@implementation GiltApiClientDownloadRunner

- (id)initWithRequest:(NSURLRequest *)req completion:(void (^)(id, NSError *))block {
    if (self = [super init]) {
        completionBlock = block;
        complete = NO;
        request = req;
    }
    return self;
}

- (void)main {
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    [conn scheduleInRunLoop:theRL 
                    forMode:NSRunLoopCommonModes];
    while (!complete && [theRL runMode:NSDefaultRunLoopMode 
                           beforeDate:[NSDate distantFuture]]);
}

- (BOOL)isFinished {
    return complete;
}

- (BOOL)isExecuting {
    return ![self isFinished];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    complete = NO;
    data = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)gotData {
    [data appendData:gotData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self downloadComplete:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self downloadComplete:error];
}

- (void)downloadComplete:(NSError *)error {
    id json_object = nil;
    if (!error) {
        @try {
            json_object = [[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithData:data];
        }
        @catch (NSException *exception) {
            json_object = nil;
            error = [NSError errorWithDomain:NSCocoaErrorDomain 
                                        code:-1 
                                    userInfo:[NSDictionary dictionaryWithObject:[exception reason] 
                                                                         forKey:NSLocalizedDescriptionKey]];
        }
    }
    
    completionBlock(json_object, error);
    data = nil;
    complete = YES;
}

@end