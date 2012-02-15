//
//  ImageFetcher.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "ImageFetcher.h"
#import "GAppDelegate.h"
#import "NSString+MD5.h"

@implementation ImageFetcher

+ (void)getImageFromURL:(NSURL *)imageUrl preprocessBlock:(UIImage *(^)(NSData *))block {
    // Check cache
    NSString *filename = [[imageUrl absoluteString] MD5];
    NSError *error = nil;
    NSFileManager *file_manager = [[NSFileManager alloc] init];
    NSURL *cache_dir = [file_manager URLForDirectory:NSCachesDirectory 
                                            inDomain:NSUserDomainMask 
                                   appropriateForURL:nil 
                                              create:YES 
                                               error:&error];    
    NSURL __block *path = [cache_dir URLByAppendingPathComponent:filename];

    NSData *image_data = [NSData dataWithContentsOfURL:path];
    if (image_data) {
        NSLog(@"+++ Cache hit for image [%@]", [imageUrl absoluteURL]);
        UIImage *image = [UIImage imageWithData:image_data];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              image,    @"image",
                              imageUrl, @"sourceUrl", 
                              nil];
        [self performSelectorOnMainThread:@selector(sendImageCompleteNotification:) 
                               withObject:info 
                            waitUntilDone:NO];
    }
    else {
        NSLog(@"--- Cache miss for image [%@]", [imageUrl absoluteURL]);
        
        // Pull remote image
        NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl
                                                 cachePolicy:NSURLCacheStorageAllowed 
                                             timeoutInterval:10.0];
        GAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

        [NSURLConnection sendAsynchronousRequest:request 
                                           queue:delegate.downloadQueue 
                               completionHandler:^(NSURLResponse *request, NSData *data, NSError *error) {
                                   if (error) {
                                       NSLog(@"Error downloading image: %@", error);
                                   }
                                   else {
                                       @try {
                                           NSLog(@"Resource downloaded [%@]", [imageUrl absoluteURL]);
                                           UIImage *image = block(data); // custom preprocess
                                           [UIImagePNGRepresentation(image) writeToURL:path atomically:YES];
                                           
                                           NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 image,     @"image",
                                                                 imageUrl,  @"sourceUrl", 
                                                                 nil];
                                           [self performSelectorOnMainThread:@selector(sendImageCompleteNotification:) 
                                                                  withObject:info 
                                                               waitUntilDone:NO];
                                       }
                                       @catch (NSException *exception) {
                                           NSLog(@"Exception while downloading image:\n%@", 
                                                 [exception callStackSymbols]);
                                       }
                                   }
                               }];
    }
}

+ (void)sendImageCompleteNotification:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageReadyNotification" 
                                                        object:[[info valueForKey:@"sourceUrl"] absoluteString]
                                                      userInfo:info];
}

@end
