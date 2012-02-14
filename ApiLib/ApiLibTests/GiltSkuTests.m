//
//  GiltSkuTests.m
//  GiltApi
//
//  Created by Louis Vera on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSkuTests.h"
#import "GiltSku.h"
#import "GiltApi.h"

@implementation GiltSkuTests

- (void)testInitWithApiData
{
    NSString * product = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * productDictionary = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:product];
    NSDictionary * sku = (NSDictionary *)[[productDictionary objectForKey:@"skus"] firstObject];
    GiltSku * model = [[GiltSku alloc] initWithApiData:sku];
        
    NSMutableDictionary *parsed_attributes = [NSMutableDictionary new];
    NSArray *attribute_list = [sku objectForKey:@"attributes"];
    [attribute_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [parsed_attributes setObject:[obj valueForKey:@"value"] 
                              forKey:[obj valueForKey:@"name"]];
    }];
    
    NSMutableDictionary *mutable_sku = [sku mutableCopy];
    [mutable_sku setObject:parsed_attributes forKey:@"attributes"];
    
    [mutable_sku enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent 
                                         usingBlock:^(id key, id obj, BOOL *stop) {
                                             [self compareKey:key 
                                                    withValue:obj 
                                                      toModel:model];
                                         }];
}

- (void)compareKey:(NSString *)key withValue:(id)value toModel:(id)model {
    NSDictionary *key_map = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"identifier", @"id",
                             @"inventoryStatus", @"inventory_status",
                             @"salePrice",   @"sale_price",
                             @"msrpPrice",   @"msrp_price",
                             @"shippingSurcharge", @"shipping_surcharge",
                             nil];
    
    NSSet *date_keys = [NSSet setWithObjects: nil];
    NSSet *url_keys = [NSSet setWithObjects: nil];
    NSSet *number_keys = [NSSet setWithObjects:
                          @"shippingSurcharge", 
                          @"salePrice", 
                          @"msrpPrice", nil];
    
    NSString *model_key = [key_map valueForKey:key];
    if (!model_key) {
        model_key = key;
    }
    
    id test_value = value;
    
    if ([date_keys containsObject:model_key]) {
        NSDateFormatter *date_formatter = [NSDateFormatter new];
        [date_formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        test_value = [date_formatter dateFromString:value];
    }
    else if ([url_keys containsObject:model_key]) {
        test_value = [NSURL URLWithString:value];
    }
    else if ([number_keys containsObject:model_key]) {
        test_value = [NSNumber numberWithDouble:[value doubleValue]];
    }
    
    STAssertEqualObjects(test_value, [model valueForKey:model_key], 
                         @"%@.%@ did not match", NSStringFromClass([model class]), model_key);
}

@end
