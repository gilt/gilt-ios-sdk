//
//  GiltSalesClientTests.m
//  GiltApi
//
//  Created by Adam Kaplan on 2/10/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSalesClientTests.h"
#import "GiltApi.h"
#import "GiltSalesClient.h"
#import "GiltSale.h"

@implementation GiltSalesClientTests
/*
- (NSArray *)salesFromJson:(NSDictionary *)salesDict {
    NSArray *sales_list = [salesDict objectForKey:@"sales"];
    NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:[sales_list count]];
    for (NSDictionary *sale_dict in sales) {
        GiltSale *sale = [[GiltSale alloc] initWithApiData:sale_dict];
        [sales addObject:sale];
    }
    return sales;
}
 
// Test synchronous sales client
- (void)testASyncSalesClient {
    [GiltApi sharedInstance].apiKey = @"NOTHING";
    NSBundle *test_bundle = [NSBundle bundleForClass:[self class]];
    
    // Control object
    NSURL *sales_plist_url = [test_bundle URLForResource:@"sales" withExtension:@"plist"];
    NSDictionary *sales_dict = [NSDictionary dictionaryWithContentsOfURL:sales_plist_url];
    NSArray *control_array = [self salesFromJson:sales_dict];
    
    // Test object
    NSURL *sales_json_url = [test_bundle URLForResource:@"sales" withExtension:@"json"];
    [GiltSalesClient fet
    [GiltSalesClient fetchProduct:sales_json_url 
                       completion:^(GiltProduct *test_product, NSError *error) {
                           STAssertTrue([control_product isEqual:test_product], 
                                        @"Async fetch product did not match test:\n[%@]\ncontrol\n[%@]\n", 
                                        test_product, control_product);
                       }];
}

// Test synchronous sales client
- (void)testSyncSalesClient {
    [GiltApi sharedInstance].apiKey = @"NOTHING";
    NSBundle *test_bundle = [NSBundle bundleForClass:[self class]];
    
    // Control object
    NSURL *sales_plist_url = [test_bundle URLForResource:@"product" withExtension:@"plist"];
    NSDictionary *product_dict = [NSDictionary dictionaryWithContentsOfURL:product_plist_url];
    GiltProduct *control_product = [[GiltProduct alloc] initWithApiData:product_dict];
    
    // Test object
    NSURL *product_json_url = [test_bundle URLForResource:@"product" withExtension:@"json"];
    NSError *error = nil;
    GiltProduct *test_product = [GiltProductClient fetchSynchronousProduct:product_json_url timeout:5.0 error:&error];
    
    STAssertTrue([control_product isEqual:test_product], 
                 @"Synchronous fetch products did not match test:\n[%@]\ncontrol:\n[%@]\n", 
                 test_product, control_product);
}
 */

@end
