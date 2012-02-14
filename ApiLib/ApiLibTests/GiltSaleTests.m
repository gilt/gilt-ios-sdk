//
//  GiltSaleTests.m
//  GiltApi
//
//  Created by Louis Vera on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSaleTests.h"
#import "GiltSale.h"
#import "GiltImageCollection.h"
#import "GiltApi.h"
#import "GiltUrl.h"

@implementation GiltSaleTests

- (void)testInitWithApiData {    
    NSString *salesJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/sales.json" 
                                                     encoding:NSUTF8StringEncoding 
                                                        error:nil];
    NSDictionary *sales = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:salesJson];
    NSDictionary * firstSale = [[sales objectForKey:@"sales"] objectAtIndex:0];
    GiltSale *model = [[GiltSale alloc] initWithApiData:firstSale];
    
    NSMutableDictionary *testSale = [firstSale mutableCopy];
    GiltImageCollection *images = [[GiltImageCollection alloc] 
                               initWithApiData:[firstSale objectForKey:@"image_urls"]];
    [testSale setObject:images forKey:@"image_urls"];
    
    NSArray * products = [firstSale objectForKey:@"products"];
    NSMutableArray * productUrls = [NSMutableArray arrayWithCapacity:[products count]];
    for(NSString * url in products) {
        [productUrls addObject:[GiltUrl urlWithApiKeyFrom:url]];
    }
    [testSale setObject:productUrls forKey:@"products"];
    
    [testSale enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent 
                                             usingBlock:^(id key, id obj, BOOL *stop) {
                                                 [self compareKey:key 
                                                        withValue:obj 
                                                          toModel:model];
                                             }];
}

- (void)compareKey:(NSString *)key withValue:(id)value toModel:(id)model {
    NSDictionary *key_map = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"url",             @"sale_url",
                            @"details",         @"sale",
                            @"identifier",      @"sale_key",
                            @"startDate",       @"begins",
                            @"endDate",         @"ends",
                            @"images",          @"image_urls",
                            @"saleDescription", @"description",
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
                         @"%@.%@ did not match", NSStringFromClass([model class]), key);
}

@end
