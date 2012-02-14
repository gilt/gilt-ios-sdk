//
//  GiltSale.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSale.h"
#import "GiltUrl.h"

@implementation GiltSale

@synthesize name, details, identifier, store, url, images, startDate, endDate, saleDescription, products;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiData:(NSDictionary *)dict {
    if (self = [super init]) {
        name =              [dict objectForKey:@"name"];
        details =           [GiltUrl urlWithApiKeyFrom:[dict objectForKey:@"sale"]];
        identifier =        [dict objectForKey:@"sale_key"];
        store =             [dict objectForKey:@"store"];
        url =               [NSURL URLWithString:[dict objectForKey:@"sale_url"]];
        images =            [[GiltImageCollection alloc] initWithApiData:[dict objectForKey:@"image_urls"]];
        saleDescription =   [dict objectForKey:@"description"];
        
        NSDateFormatter *date_formatter = [NSDateFormatter new];
        [date_formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        startDate =     [date_formatter dateFromString:[dict objectForKey:@"begins"]];
        endDate =       [date_formatter dateFromString:[dict objectForKey:@"ends"]];
        
        NSArray *productStrings = (NSArray *)[dict objectForKey:@"products"];
        NSMutableArray *productUrls = [NSMutableArray arrayWithCapacity:[productStrings count]];
        [productStrings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSURL *productUrl = [GiltUrl urlWithApiKeyFrom:(NSString *)obj];
            [productUrls addObject:productUrl];
        }];
        products = productUrls;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    BOOL equals = NO;
    if ([object isKindOfClass:[self class]]) {
        GiltSale *other = object;
        equals = ((name == other.name)                  || [name isEqualToString:other.name])
        && ((details    == other.details)               || [details isEqual:other.details])
        && ((identifier == other.identifier)            || [identifier isEqualToString:other.identifier])
        && ((store      == other.store)                 || [store isEqualToString:other.store])
        && ((url        == other.url)                   || [url isEqual:other.url])
        && ((images     == other.images)                || [images isEqual:other.images])
        && ((saleDescription == other.saleDescription)  || [saleDescription isEqualToString:other.saleDescription])
        && ((startDate  == other.startDate)             || [startDate isEqualToDate:other.startDate])
        && ((endDate    == other.endDate)               || [endDate isEqualToDate:other.endDate])
        && ((products   == other.products)              || [products isEqualToArray:other.products]);
    }
    return equals;
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:
            @"name [%@], id [%@], url [%@], store [%@], details [%@], images [%@], start date [%@], end date [%@], desc [%@], products [%@]",
            name, identifier, url, store, details, images, startDate, endDate, saleDescription, products];
}

#pragma mark -
#pragma mark Helpers

- (NSURL *)mobileWebUrl {
    return [GiltUrl mobileWebUrlFromUrl:[self url]];
}

@end
