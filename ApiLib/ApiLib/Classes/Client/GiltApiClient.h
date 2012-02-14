//
//  GiltApiClient.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiltModel.h"

typedef enum {
    // All Stores
    GiltEveryStore = 0,
    // Specfic Stores
    GiltMensStore,
    GiltWomensStore,
    GiltKidsStore,
    GiltHomeStore,
    // No Specific Store
    GiltUnspecifiedStore = INT_MIN,
    // Future Specific Stores
    GiltTasteStore = GiltUnspecifiedStore,
    GiltCityStore = GiltUnspecifiedStore,
    GiltJetsetterStore = GiltUnspecifiedStore,
} GiltApiStores;

@interface GiltApiClient : NSObject

+ (NSString *)urlComponentForStore:(GiltApiStores)store;

@end

#pragma mark -
#pragma mark

@interface GiltApiClientDownloadRunner : NSThread {
@private
    BOOL complete;
    NSMutableData *data;
    NSURLRequest * request;
    void (^completionBlock)(id, NSError *);
}

- (id)initWithRequest:(NSURLRequest *)request completion:(void (^)(id, NSError *))block;

#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

// Note: once iOS 4 is deprecated, we can just adopt the proper protocol.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)gotData;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
