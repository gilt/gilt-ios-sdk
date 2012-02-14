//
//  GiltProduct.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltProduct.h"
#import "GiltSku.h"
#import "GiltUrl.h"

@implementation GiltProduct

@synthesize name, details, identifier, brand, skus, url, images, attributes;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiData:(NSDictionary *)dict {
    if (self = [super init]) {
        name        = [dict objectForKey:@"name"];
        details     = [GiltUrl urlWithApiKeyFrom:[dict objectForKey:@"product"]];
        identifier  = [dict objectForKey:@"id"];
        brand       = [dict objectForKey:@"brand"];
        url         = [NSURL URLWithString:[dict objectForKey:@"url"]];
        attributes  = [dict objectForKey:@"content"];
        
        images      = [[GiltImageCollection alloc] 
                       initWithApiData:[dict objectForKey:@"image_urls"]];
        
        NSArray *sku_list = [dict objectForKey:@"skus"];
        NSMutableArray *mutable_skus = [[NSMutableArray alloc] initWithCapacity:[sku_list count]];
        [sku_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GiltSku *sku = [[GiltSku alloc] initWithApiData:obj];
            [mutable_skus addObject:sku];
        }];
        skus = [[NSArray alloc] initWithArray:mutable_skus];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    BOOL equals = NO;
    if ([object isKindOfClass:[self class]]) {
        GiltProduct *other = object;
        equals = ((name ==  other.name)         || [name isEqualToString:other.name])
        && ((details ==     other.details)      || [details isEqual:other.details])
        && ((identifier ==  other.identifier)   || [identifier isEqualToString:other.identifier])
        && ((brand ==       other.brand)        || [brand isEqualToString:other.brand])
        && ((url ==         other.url)          || [url isEqual:other.url])
        && ((images ==      other.images)       || [images isEqual:other.images])
        && ((attributes ==  other.attributes)   || [attributes isEqualToDictionary:other.attributes])
        && ((skus ==        other.skus)         || [skus isEqualToArray:other.skus]);
    }
    return equals;
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:
            @"name [%@], id [%@], url [%@], brand [%@], details [%@], attrs [%@], images [%@], skus [%@]",
            name, identifier, url, brand, details, attributes, images, skus];
}

#pragma mark -
#pragma mark Helpers

- (NSString *)productDescription {
    return [attributes objectForKey:@"description"];
}

- (NSString *)fitNotes {
    return [attributes objectForKey:@"fit_notes"];
}

- (NSString *)material {
    return [attributes objectForKey:@"material"];
}

- (NSString *)careInstructions {
    return [attributes objectForKey:@"care_instructions"];
}

- (NSString *)origin {
    return [attributes objectForKey:@"origin"];
}

- (NSURL *)mobileWebUrl {
    return [GiltUrl mobileWebUrlFromUrl:[self url]];
}

@end
