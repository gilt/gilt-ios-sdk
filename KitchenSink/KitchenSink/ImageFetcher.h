//
//  ImageFetcher.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFetcher : NSObject

+ (void)getImageFromURL:(NSURL *)imageUrl preprocessBlock:(UIImage *(^)(NSData *))block;
+ (void)sendImageCompleteNotification:(NSDictionary *)info;

@end
