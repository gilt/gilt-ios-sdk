//
//  GiltSalesClientTests.m
//  GiltApi
//
//  Created by Adam Kaplan on 2/10/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltProductsClientTests.h"
#import "GiltApi.h"
#import "GiltProduct.h"
#import "GiltProductClient.h"

#import <UIKit/UIKit.h>
//#import "application_headers" as required

@implementation GiltProductsClientTests

// Test synchronous product client
- (void)testASyncProductsClient {
    [GiltApi sharedInstance].apiKey = @"NOTHING";
    NSBundle *test_bundle = [NSBundle bundleForClass:[self class]];

    // Control object
    NSURL *product_plist_url = [test_bundle URLForResource:@"product" withExtension:@"plist"];
    NSDictionary *product_dict = [NSDictionary dictionaryWithContentsOfURL:product_plist_url];
    GiltProduct *control_product = [[GiltProduct alloc] initWithApiData:product_dict];
    
    // Test object
    NSURL *product_json_url = [test_bundle URLForResource:@"product" withExtension:@"json"];
    [GiltProductClient fetchProduct:product_json_url 
                         completion:^(GiltProduct *test_product, NSError *error) {
                             STAssertTrue([control_product isEqual:test_product], 
                                          @"Async fetch product did not match test:\n[%@]\ncontrol\n[%@]\n", 
                                          test_product, control_product);
                         }];
}

// Test synchronous product client
- (void)testSyncProductsClient {
    [GiltApi sharedInstance].apiKey = @"NOTHING";
    NSBundle *test_bundle = [NSBundle bundleForClass:[self class]];
    
    // Control object
    NSURL *product_plist_url = [test_bundle URLForResource:@"product" withExtension:@"plist"];
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


@end
