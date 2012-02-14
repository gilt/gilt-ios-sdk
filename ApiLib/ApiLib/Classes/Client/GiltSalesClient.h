//
//  GiltSalesClient.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiltApiClient.h"

@interface GiltSalesClient : GiltApiClient

+ (BOOL)fetchCurrentSalesWithCompletionBlock:(void (^)(NSArray *, NSError *))block;

+ (BOOL)fetchUpcomingSalesWithCompletionBlock:(void (^)(NSArray *, NSError *))block;

+ (BOOL)fetchSalesForStore:(GiltApiStores)store 
             upcomingSales:(BOOL)upcoming
                   timeout:(NSTimeInterval)timeout
           completionBlock:(void (^)(NSArray *, NSError *))block;

+ (NSArray *)fetchSynchronousForStore:(GiltApiStores)store 
                        upcomingSales:(BOOL)upcoming 
                              timeout:(NSTimeInterval)timeout 
                                error:(NSError **)error;

+ (NSURL *)urlForStore:(GiltApiStores)store 
             upcomingSales:(BOOL)upcoming;
@end
