//
//  GiltProductClient.h
//  GiltApi
//
//  Created by Adam Kaplan on 2/10/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltApiClient.h"

@class GiltProduct;

@interface GiltProductClient : GiltApiClient

+ (BOOL)fetchProduct:(NSURL *)productUrl completion:(void (^)(GiltProduct *, NSError *))block;

+ (BOOL)fetchProduct:(NSURL *)productUrl 
             timeout:(NSTimeInterval)timeout 
          completion:(void (^)(GiltProduct *, NSError *))block;

+ (GiltProduct *)fetchSynchronousProduct:(NSURL *)productUrl 
                                 timeout:(NSTimeInterval)timeout 
                                   error:(NSError **)error;

@end
