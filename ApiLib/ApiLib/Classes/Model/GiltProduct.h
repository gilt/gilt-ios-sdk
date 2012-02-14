//
//  GiltProduct.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiltModel.h"
#import "GiltImageCollection.h"

@interface GiltProduct : NSObject <GiltModel>

#pragma mark -
#pragma mark Standard Properties

// Title for this product
@property (strong, nonatomic, readonly) NSString    *name;

// URL of the product data
@property (strong, nonatomic, readonly) NSURL       *details;

// Unique indentifier of product
@property (strong, nonatomic, readonly) NSString    *identifier;

// The brand that is selling this product
@property (strong, nonatomic, readonly) NSString    *brand;

// A list of GiltSku's for this product
@property (strong, nonatomic, readonly) NSArray     *skus;

#pragma mark -
#pragma mark Optional Properties

// Optional: Product page on gilt.com
@property (strong, nonatomic, readonly) NSURL       *url;

// Optional: Images of this product
@property (strong, nonatomic, readonly) GiltImageCollection *images;

// Optional list of attributes specific to this product. May contain:
//  description - additional editorial, details
//  fit_notes - editorial note on how 'true to size' the product is
//  material - describes the types and relative quantity of materials in this product
//              (such as "80% Rayon, 20% Cotton")
//  care_instructions - product care information (such as "Dry Clean Only")
//  origin - country of manufacture
@property (strong, nonatomic, readonly) NSDictionary *attributes;

#pragma mark -
#pragma mark Helpers

- (NSString *)productDescription;
- (NSString *)fitNotes;
- (NSString *)material;
- (NSString *)careInstructions;
- (NSString *)origin;

- (NSURL *)mobileWebUrl;

@end
