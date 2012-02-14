//
//  GiltImageCollection.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/28/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GiltModel.h"

@interface GiltImageCollection : NSObject <GiltModel> {
    @private
    NSDictionary *urlsBySize;
    NSArray *sortedKeys;
}

#pragma mark -
#pragma mark Helper Methods

//Each of these methods returns an NSArray of NSURLs

// The sizes of images available
// Array contains NSValue with CGSize
- (NSArray *)sizes;

// The largest images
- (NSArray *)largest;

// The smallest images
- (NSArray *)smallest;

// Images for a given size if available
- (NSArray *)forSize:(CGSize)size;

// Images less than the given size
- (NSArray *)smallerThan:(CGSize)size;

// Images larger than the given size
- (NSArray *)largerThan:(CGSize)size;

@end
