//
//  GiltSku.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiltModel.h"

@interface GiltSku : NSObject <GiltModel>

#pragma mark -
#pragma mark Standard Properties

// Unique Identifier
@property (strong, nonatomic, readonly) NSNumber *identifier;

// Inventory Status ("sold out", "for sale",  or "reserved")
@property (strong, nonatomic, readonly) NSString *inventoryStatus;

// Manufacturer's Suggested Retail Price ("full price")
@property (strong, nonatomic, readonly) NSNumber *msrpPrice;

// Gilt's Price ("sale price")
@property (strong, nonatomic, readonly) NSNumber *salePrice;

#pragma mark -
#pragma mark Optional Properties

// Optional: If set, this item is excluded from the normal Gilt
//      shipping rate and uses the specified rate instead.
//
//      If this item is purchased alone, the surchase replaces the 
//      standard shipping fee. If this product is purchased with other 
//      products, the surcharge is added to the total order shipping fee.
@property (strong, nonatomic, readonly) NSNumber *shippingSurcharge;

// Optional: A string representing the color(s) of this item
//  Please note, this is for descriptive purposes only. The prodvided
//  color string could be in the format "red" or "blue/brown/purple".
// Optional: Size of the item ("XL", "M", "42", "9M")
@property (strong, nonatomic, readonly) NSDictionary *attributes;

#pragma mark -
#pragma mark Helpers

- (BOOL)isSoldOut;
- (NSString *)color;
- (NSString *)size;

@end
