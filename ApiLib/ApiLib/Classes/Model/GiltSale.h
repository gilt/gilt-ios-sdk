//
//  GiltSale.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiltModel.h"
#import "GiltImageCollection.h"

@interface GiltSale : NSObject <GiltModel>

#pragma mark -
#pragma mark Standard Properties

// Name / title of the sale
@property (strong, nonatomic, readonly) NSString    *name;

// URL of the sale data
@property (strong, nonatomic, readonly) NSURL       *details;

// Unique identifier of sale
@property (strong, nonatomic, readonly) NSString    *identifier;

// The store that is
@property (strong, nonatomic, readonly) NSString    *store;

// URL of the sale on gilt.com
@property (strong, nonatomic, readonly) NSURL       *url;

// A list of images that can be used to describe the sale
// In most cases you should use the first image
@property (strong, nonatomic, readonly) GiltImageCollection *images;

// Sale start time
@property (strong, nonatomic, readonly) NSDate      *startDate;

#pragma mark -
#pragma mark Optional Properties

// Optional: Sale end time
@property (strong, nonatomic, readonly) NSDate      *endDate;

// Optional: Sale description text
@property (strong, nonatomic, readonly) NSString    *saleDescription;

// Optional: A list of NSURL objects for product details
@property (strong, nonatomic, readonly) NSArray     *products;

#pragma mark -
#pragma mark Helpers

- (NSURL *)mobileWebUrl;

@end
