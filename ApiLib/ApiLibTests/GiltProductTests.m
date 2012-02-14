//
//  GiltProductTests.m
//  GiltApi
//
//  Created by Louis Vera on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltProductTests.h"
#import "GiltProduct.h"
#import "GiltSku.h"
#import "GiltImageCollection.h"
#import "GiltApi.h"
#import "GiltUrl.h"

@implementation GiltProductTests

- (void)testInitWithApiData
{
    NSString * productJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                encoding:NSUTF8StringEncoding 
                                                   error:nil];
    NSDictionary * product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:productJson];
    GiltProduct * model = [[GiltProduct alloc] initWithApiData:product];
    
    // Need to mock the SKU list
    NSArray *sku_json_list = [product objectForKey:@"skus"];
    NSMutableArray *skus = [[NSMutableArray alloc] initWithCapacity:[sku_json_list count]];
    for(NSDictionary *sku in sku_json_list) {
        [skus addObject:[[GiltSku alloc] initWithApiData:sku]];
    }
    
    GiltImageCollection *images = [[GiltImageCollection alloc]
                               initWithApiData:[product objectForKey:@"image_urls"]];
    
    NSMutableDictionary *mutable_product = [product mutableCopy];
    [mutable_product setObject:skus forKey:@"skus"];
    [mutable_product setObject:images forKey:@"image_urls"];
    
    [mutable_product enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent 
                                             usingBlock:^(id key, id obj, BOOL *stop) {
                                                 [self compareKey:key 
                                                        withValue:obj 
                                                          toModel:model];
                                             }];
}

- (void)compareKey:(NSString *)key withValue:(id)value toModel:(id)model {
    NSDictionary *key_map = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"url",         @"sale_url",
                             @"attributes",  @"content",
                             @"images",      @"image_urls",
                             @"details",     @"product",
                             @"identifier",  @"id",
                             nil];
    
    NSSet *date_keys    = [NSSet setWithObjects:@"endDate", @"startDate", nil];
    NSSet *url_keys     = [NSSet setWithObjects:@"url", nil];
    NSSet *api_url_keys = [NSSet setWithObjects:@"details", nil];
    
    NSString *model_key = [key_map valueForKey:key];
    if (!model_key) {
        model_key = key;
    }
    
    id test_value = value;
    
    if ([date_keys containsObject:model_key]) {
        NSDateFormatter *date_formatter = [NSDateFormatter new];
        [date_formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        test_value = [date_formatter dateFromString:value];
    } else if ([url_keys containsObject:model_key]) {
        test_value = [NSURL URLWithString:value];
    } else if ([api_url_keys containsObject:model_key]) {
        test_value = [GiltUrl urlWithApiKeyFrom:value];
    }
    
    STAssertEqualObjects(test_value, [model valueForKey:model_key], 
                         @"%@.%@ did not match", NSStringFromClass([model class]), model_key);
}

@end
