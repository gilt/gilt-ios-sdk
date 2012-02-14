//
//  GiltImageCollection.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/28/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltImageCollection.h"

@interface GiltImageCollection (private)

- (NSComparisonResult)compare:(NSValue *)value1 with:(NSValue *)value2;
- (NSArray *)sortedKeys;
- (NSUInteger) findFirstLargerThan:(CGSize)size;
- (NSDictionary *)urlsBySize;

@end

@implementation GiltImageCollection (private)

- (NSComparisonResult)compare:(NSValue *)value1 with:(NSValue *)value2 {
    NSComparisonResult result = NSOrderedSame;
    CGSize size1 = [value1 CGSizeValue];
    CGSize size2 = [value2 CGSizeValue];
    CGFloat area1 = size1.width * size1.height;
    CGFloat area2 = size2.width * size2.height;
    if (area1 > area2) {
        result = NSOrderedDescending;
    } else if (area1 < area2) {
        result = NSOrderedAscending;
    }
    return result;
}

- (NSArray *)sortedKeys {
    if(!sortedKeys) {
        sortedKeys = [[urlsBySize allKeys] sortedArrayUsingComparator:
                      ^(id obj1, id obj2) {
                          return [self compare:obj1 with:obj2];
                      }];
    }
    return sortedKeys;
}

- (NSUInteger) findFirstLargerThan:(CGSize)size {
    NSValue * test = [NSValue valueWithCGSize:size];
    NSUInteger index = [[self sortedKeys] indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            NSValue * value = (NSValue *) obj;
                            return (BOOL)([self compare:value with:test] == NSOrderedDescending);
                        }];
    return index;
}

- (NSDictionary *)urlsBySize {
    return urlsBySize;
}

@end

@implementation GiltImageCollection

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiData:(NSDictionary *)dict {
    if (self = [super init]) {
        NSMutableDictionary * urlArraysBySize = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
        NSMutableArray * urls = nil;
        for (NSArray * images in [dict allValues]) {
            int count = [images count];
            if(count > 0) {
                NSNumber * width = [[images objectAtIndex:0]objectForKey:@"width"];
                NSNumber * height = [[images objectAtIndex:0]objectForKey:@"height"];
                NSValue * size = [NSValue valueWithCGSize:CGSizeMake([width floatValue], [height floatValue])];
                urls = [NSMutableArray arrayWithCapacity:count];
                for (NSDictionary * image in images) {
                    [urls addObject:[NSURL URLWithString:[image objectForKey:@"url"]]];
                }
                [urlArraysBySize setObject:urls forKey:size];
            }
        }
        urlsBySize = urlArraysBySize;
    }
    return self;
}

- (NSArray *)sizes {
    return [self sortedKeys];
}

- (NSArray *)largest {
    NSArray * largest = nil;
    NSArray * keys = [self sortedKeys];
    NSUInteger count = [keys count];
    if(count > 0) {
        NSValue * largestKey = [keys objectAtIndex:count - 1];
        largest = [urlsBySize objectForKey:largestKey];
    }
    return largest;
}

- (NSArray *)smallest {
    NSArray * smallest = nil;
    NSArray * keys = [self sortedKeys];
    NSUInteger count = [keys count];
    if(count > 0) {
        NSValue * smallestKey = [keys objectAtIndex:0];
        smallest = [urlsBySize objectForKey:smallestKey];
    }
    return smallest;
}

- (NSArray *)forSize:(CGSize)size {
    NSValue * key = [NSValue valueWithCGSize:size];
    return [urlsBySize objectForKey:key];
}

- (NSArray *)largerThan:(CGSize)size {
    NSArray * images = nil;
    NSUInteger largerIndex = [self findFirstLargerThan:size];
    if(largerIndex != NSNotFound){
        NSValue * largerKey = [[self sortedKeys] objectAtIndex:largerIndex];
        images = [urlsBySize objectForKey:largerKey];
    }
    return images;
}

- (NSArray *)smallerThan:(CGSize)size {
    NSArray * images = nil;
    NSUInteger largerIndex = [self findFirstLargerThan:size];
    NSUInteger startIndex = [[self sortedKeys] count] - 1;
    if(largerIndex != NSNotFound && largerIndex > 0){
        //one less than the a larger image is smaller or equal
        startIndex = largerIndex - 1;
    }
    
    NSValue * test = [NSValue valueWithCGSize:size];
    NSValue * smallerKey = nil;
    for(int i = startIndex; i >= 0 && !images; i--) {
        smallerKey = [[self sortedKeys] objectAtIndex:i];
        if([self compare:smallerKey with:test] == NSOrderedAscending) {
            images = [urlsBySize objectForKey:smallerKey];
        }
    }
    
    return images;
}

- (BOOL)isEqual:(id)object {
    BOOL match = FALSE;
    if ([object isKindOfClass:[self class]]) {
        GiltImageCollection *other = (GiltImageCollection *)object;
        match = [[other urlsBySize] isEqual:[self urlsBySize]];
    }
    return match;
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:
            @"urls [%@]", urlsBySize];
}

@end
