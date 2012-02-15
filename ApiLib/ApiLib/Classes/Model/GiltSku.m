//
//  GiltSku.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSku.h"

@implementation GiltSku

@synthesize identifier, inventoryStatus, msrpPrice, salePrice, shippingSurcharge, attributes;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiData:(NSDictionary *)dict {
    if (self = [super init]) {
        NSArray *attribute_list = [dict objectForKey:@"attributes"];
        NSMutableDictionary *new_attributes = [NSMutableDictionary new];
        [attribute_list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [new_attributes setObject:[obj valueForKey:@"value"] 
                               forKey:[obj valueForKey:@"name"]];
        }];
        attributes = [[NSDictionary alloc] initWithDictionary:new_attributes];

        identifier = [dict valueForKey:@"id"];
        inventoryStatus = [dict valueForKey:@"inventory_status"];
        shippingSurcharge = [NSNumber numberWithDouble:[[dict valueForKey:@"shipping_surcharge"] doubleValue]];
        msrpPrice = [NSNumber numberWithDouble:[[dict valueForKey:@"msrp_price"] doubleValue]];
        salePrice = [NSNumber numberWithDouble:[[dict valueForKey:@"sale_price"] doubleValue]];        
    }
    return self;
}

/**
 * This compares all fields for unit test purposes.
 * To determine if two skus are the same comparing identifiers should be sufficient.
 */
- (BOOL)isEqual:(id)object {
    BOOL match = FALSE;
    if ([object isKindOfClass:[self class]]) {
        GiltSku *other = (GiltSku *)object;
        match =    ((other.identifier == identifier)            || [other.identifier isEqualToNumber:identifier])
                && ((other.inventoryStatus == inventoryStatus)  || [other.inventoryStatus isEqualToString:inventoryStatus])
                && ((other.msrpPrice == msrpPrice)              || [other.msrpPrice isEqualToNumber:msrpPrice])
                && ((other.salePrice == salePrice)              || [other.salePrice isEqualToNumber:salePrice])
                && ((other.shippingSurcharge == shippingSurcharge) || [other.shippingSurcharge isEqualToNumber:shippingSurcharge])
                && ((other.attributes == attributes)            || [other.attributes isEqualToDictionary:attributes]);
    }
    return match;
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:
            @"id [%@], inventory status [%@], msrp [%@], price [%@], shipping surcharge [%@], attrs [%@]",
            identifier, inventoryStatus, msrpPrice, salePrice, shippingSurcharge, attributes];
}

#pragma mark -
#pragma mark Helpers

- (BOOL)isSoldOut {
    return [self.inventoryStatus isEqualToString:@"sold out"];
}

- (NSString *)color {
    return [self.attributes objectForKey:@"color"];
}

- (NSString *)size {
    return [self.attributes objectForKey:@"size"];
}

@end
