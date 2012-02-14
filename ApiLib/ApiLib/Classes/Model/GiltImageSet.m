//
//  GiltImageSet.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/28/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiltImageSet.h"
#import "GiltImage.h"

@implementation GiltImageSet

@synthesize images;

- (id)initWithData:(NSArray *)list {
    if (self = [super init]) {
        NSMutableDictionary __block *grouped_images = [NSMutableDictionary new];
        
        // Group the differently sized image URL strings by their common base images
        [list enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            NSString *key = [str stringByDeletingLastPathComponent];

            NSMutableArray *image_sizes_list = [grouped_images objectForKey:key];
            if (!image_sizes_list) {
                image_sizes_list = [NSMutableArray new];
                [grouped_images setObject:image_sizes_list forKey:key];
            }
            [image_sizes_list addObject:str];
        }];
        
        // Create GiltImages for each base image set with the list of image sizes available
        NSMutableArray *new_images = [[NSMutableArray alloc] initWithCapacity:[grouped_images count]];
        [grouped_images enumerateKeysAndObjectsUsingBlock:
         ^(NSString *key, NSArray *image_path_list, BOOL *stop) {
             GiltImage *image = [GiltImage new];
             [new_images addObject:image];
             
             [image_path_list enumerateObjectsWithOptions:NSEnumerationConcurrent 
                                               usingBlock:
              ^(NSString *path, NSUInteger idx, BOOL *stop) {
                  NSString *size_spec = [[path lastPathComponent] stringByDeletingPathExtension];
                  NSArray *size_components = [size_spec componentsSeparatedByString:@"x"];
                  if ([size_components count] > 1) {
                      CGSize size = CGSizeMake([[size_components objectAtIndex:0] doubleValue],
                                               [[size_components objectAtIndex:1] doubleValue]);
                      [image addImagePath:path withSize:size];
                  }
                  else {
                      [image addImagePath:path withSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                  }
              }];
         }];
        
        // Done.
        images = [NSArray arrayWithArray:new_images];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    BOOL equals = NO;
    if ([object isKindOfClass:[self class]]) {
        equals = [self isEqualToImageSet:object];
    }
    return equals;
}

- (BOOL)isEqualToImageSet:(GiltImageSet *)imageSet {
    return [images isEqualToArray:imageSet.images];
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" %@", images];
}

@end
