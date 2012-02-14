//
//  GiltJsonParserDelegateTests.m
//  GiltApi
//
//  Created by Louis Vera on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltJsonParserDelegateTests.h"
#import "GiltApi.h"

/**
 * A simple test for json parser compatibility
 */
@implementation GiltJsonParserDelegateTests

/**
 * Test whether a json parser gives us what we expect for a fake sales response 
 */
- (void)testParseSales
{
    NSString * sale = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/sales.json" 
                                                encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * saleDictionary = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:sale];
    NSDictionary * expected = [[NSDictionary alloc] initWithContentsOfFile:@"ApiLibTests/Data/sales.plist"];
    STAssertEqualObjects(saleDictionary, expected, @"Parsing sales failed");
}

/**
 * Test whether a json parser gives us what we expect for a fake product response 
 */
- (void)testParseProduct
{
    NSString * product = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * productDictionary = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:product];
    NSDictionary * expected = [[NSDictionary alloc] initWithContentsOfFile:@"ApiLibTests/Data/product.plist"];
    STAssertEqualObjects(productDictionary, expected, @"Parsing product failed");
}

@end
