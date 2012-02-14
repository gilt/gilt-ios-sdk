//
//  GiltImageCollectionTest.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/30/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltImageCollectionTest.h"
#import "GiltImageCollection.h"
#import "GiltApi.h"

@implementation GiltImageCollectionTest

- (void)testInitWithApiData
{
    NSString * productJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:nil];
    NSDictionary * product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:productJson];
    NSDictionary * imageDictionary = [product objectForKey:@"image_urls"];
    
    GiltImageCollection *images = [[GiltImageCollection alloc]
                                   initWithApiData:imageDictionary];
    
    for (NSArray * imageArray in [imageDictionary allValues]) {
        if ([imageArray count] > 0) {
            NSDictionary * first = [imageArray objectAtIndex:0];
            NSNumber * width = [first objectForKey:@"width"];
            NSNumber * height = [first objectForKey:@"height"];
            NSValue * size = [NSValue valueWithCGSize:CGSizeMake([width floatValue], [height floatValue])];
            NSMutableArray * imageUrls = [NSMutableArray arrayWithCapacity:[imageArray count]];
            for (NSDictionary * image in imageArray) {
                [imageUrls addObject:[NSURL URLWithString:[image objectForKey:@"url"]]];
            }
            NSArray * imagesForSize = [images forSize:[size CGSizeValue]];
            STAssertEqualObjects(imagesForSize, imageUrls, @"Parsing image collection failed");
        }
    }
}

- (void)testSmallest
{
    NSString * productJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:nil];
    NSDictionary * product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:productJson];
    NSDictionary * imageDictionary = [product objectForKey:@"image_urls"];
    
    GiltImageCollection *images = [[GiltImageCollection alloc]
                                   initWithApiData:imageDictionary];
    
    NSArray * expected = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://cdn1.gilt.com/images/1/100x100.jpg"], [NSURL URLWithString:@"http://cdn1.gilt.com/images/2/100x100.jpg"], nil];
    
    STAssertEqualObjects(expected, [images smallest], @"Failed to find the smallest image");
}

- (void)testLargest
{
    NSString * productJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:nil];
    NSDictionary * product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:productJson];
    NSDictionary * imageDictionary = [product objectForKey:@"image_urls"];
    
    GiltImageCollection *images = [[GiltImageCollection alloc]
                                   initWithApiData:imageDictionary];
    
    NSArray * expected = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://cdn1.gilt.com/images/1/300x300.jpg"], [NSURL URLWithString:@"http://cdn1.gilt.com/images/2/300x300.jpg"], nil];
    
    STAssertEqualObjects(expected, [images largest], @"Failed to find the largest image");
}

- (void)testLargerThan
{
    NSString * productJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:nil];
    NSDictionary * product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:productJson];
    NSDictionary * imageDictionary = [product objectForKey:@"image_urls"];
    
    GiltImageCollection *images = [[GiltImageCollection alloc]
                                   initWithApiData:imageDictionary];
    
    NSArray * expected = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://cdn1.gilt.com/images/1/91x121.jpg"], [NSURL URLWithString:@"http://cdn1.gilt.com/images/2/91x121.jpg"], nil];
    
    STAssertEqualObjects(expected, [images largerThan:CGSizeMake(100, 100)], @"Failed to find a larger image than 100x100");
    STAssertNil([images largerThan:CGSizeMake(300, 300)], @"Should return nil for a size greater than the largest avaialable");
}

- (void)testSmallerThan
{
    NSString * productJson = [NSString stringWithContentsOfFile:@"ApiLibTests/Data/product.json" 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:nil];
    NSDictionary * product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithString:productJson];
    NSDictionary * imageDictionary = [product objectForKey:@"image_urls"];
    
    GiltImageCollection *images = [[GiltImageCollection alloc]
                                   initWithApiData:imageDictionary];
    
    NSArray * expected = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://cdn1.gilt.com/images/1/100x100.jpg"], [NSURL URLWithString:@"http://cdn1.gilt.com/images/2/100x100.jpg"], nil];
    
    STAssertEqualObjects(expected, [images smallerThan:CGSizeMake(91, 121)], @"Failed to find a smaller image than 100x100");
    STAssertNil([images smallerThan:CGSizeMake(100, 100)], @"Should return nil for a size smaller than the smallest avaialable");
}

@end
