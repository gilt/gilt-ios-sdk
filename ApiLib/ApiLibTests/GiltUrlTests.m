//
//  GiltUrlTests.m
//  GiltApi
//
//  Created by Louis Vera on 2/3/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltUrlTests.h"
#import "GiltUrl.h"

@implementation GiltUrlTests

- (void)testMobileWebUrlForHomeSale
{
    NSURL * sale = [NSURL URLWithString:@"http://www.gilt.com/home/sale/test-sale"];
    NSURL * expected = [NSURL URLWithString:@"http://m.gilt.com/mobile/sale/home/test-sale"];
    STAssertEqualObjects([GiltUrl mobileWebUrlFromUrl:sale], expected, @"url for a home sale was not changed correctly for mobile web");
}

- (void)testMobileWebUrlForHomeProduct
{
    NSURL * product = [NSURL URLWithString:@"http://www.gilt.com/home/sale/test-sale/test-product"];
    NSURL * expected = [NSURL URLWithString:@"http://m.gilt.com/mobile/sale/home/test-sale/test-product"];
    STAssertEqualObjects([GiltUrl mobileWebUrlFromUrl:product], expected, @"url for a home product was not changed correctly for mobile web");
}

- (void)testMobileWebUrlWithTrailingSlash
{
    NSURL * product = [NSURL URLWithString:@"http://www.gilt.com/home/sale/test-sale/test-product/"];
    NSURL * expected = [NSURL URLWithString:@"http://m.gilt.com/mobile/sale/home/test-sale/test-product"];
    STAssertEqualObjects([GiltUrl mobileWebUrlFromUrl:product], expected, @"mobile web url should work with a trailing slash");
}

- (void)testMobileWebUrlForWomenSale
{
    NSURL * sale = [NSURL URLWithString:@"http://www.gilt.com/sale/women/test-sale"];
    NSURL * expected = [NSURL URLWithString:@"http://m.gilt.com/mobile/sale/women/test-sale"];
    STAssertEqualObjects([GiltUrl mobileWebUrlFromUrl:sale], expected, @"url for a women's sale was changed incorrectly for mobile web");
}

- (void)testMobileWebUrlForWomenProduct
{
    NSURL * product = [NSURL URLWithString:@"http://www.gilt.com/sale/women/test-sale/test-product"];
    NSURL * expected = [NSURL URLWithString:@"http://m.gilt.com/mobile/sale/women/test-sale/test-product"];
    STAssertEqualObjects([GiltUrl mobileWebUrlFromUrl:product], expected, @"url for a women's product was changed incorrectly for mobile web");
}

- (void)testUrlWithApiKey
{
    NSURL * url = [GiltUrl urlWithApiKeyFrom:@"http://www.gilt.com/sale/women/test-sale/test-product"];
    NSString * query = [url query];
    STAssertFalse([query rangeOfString:@"apikey="].location == NSNotFound, @"Url did not contain an apikey value");
}

@end
