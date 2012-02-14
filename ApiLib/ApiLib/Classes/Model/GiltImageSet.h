//
//  GiltImageSet.h
//  GiltApi
//
//  Created by Adam Kaplan on 1/28/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GiltImageSet;

@interface GiltImageSet : NSObject

- (id)initWithData:(NSArray *)list;
- (BOOL)isEqualToImageSet:(GiltImageSet *)imageSet;

@property (strong, nonatomic, readonly) NSArray *images;

@end
