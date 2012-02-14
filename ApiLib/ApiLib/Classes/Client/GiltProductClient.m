//
//  GiltProductClient.m
//  GiltApi
//
//  Created by Adam Kaplan on 2/10/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltProductClient.h"
#import "GiltApi.h"
#import "GiltProduct.h"

@interface GiltProductClient (private)
+ (GiltProduct *)productFromJson:(NSDictionary *)productData;
@end

@implementation GiltProductClient

+ (BOOL)fetchProduct:(NSURL *)productUrl completion:(void (^)(GiltProduct *, NSError *))block {
    return [self fetchProduct:productUrl timeout:0 completion:block];
}

+ (BOOL)fetchProduct:(NSURL *)productUrl 
             timeout:(NSTimeInterval)timeout
          completion:(void (^)(GiltProduct *, NSError *))block 
{
    if (timeout <= 0.) {
        timeout = 30.;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:productUrl 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                         timeoutInterval:timeout];
    
    // Start the downloader, calling back to 'block()' them done
    void (^completion)(id,NSError*) = ^(id productInfo, NSError *error) {
        GiltProduct *product = nil;
        if (!error && [productInfo isKindOfClass:[NSDictionary class]]) {
            product = [self productFromJson:productInfo];
            if (!product) {
                error = [NSError errorWithDomain:@"Failed to parse a product from API response" 
                                            code:-1 
                                        userInfo:nil];
            }
        }
        block(product, error);
    };
    
    GiltApiClientDownloadRunner *runner = [[GiltApiClientDownloadRunner alloc] initWithRequest:request 
                                                                                    completion:completion];
    [runner start];
    return YES;
}

// Synchonrous fetch
+ (GiltProduct *)fetchSynchronousProduct:(NSURL *)productUrl 
                                 timeout:(NSTimeInterval)timeout 
                                   error:(NSError **)error {
    *error = nil;
    if (timeout <= 0.) {
        timeout = 30.0;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:productUrl 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                         timeoutInterval:timeout];
    NSLog(@"%@   %@", productUrl, request);
    
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&response 
                                                     error:error];
    
    NSDictionary *raw_product = (NSDictionary *)[[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithData:data];
    return [self productFromJson:raw_product];
}

#pragma mark - Private Methods

+ (GiltProduct *)productFromJson:(NSDictionary *)productData {
    return [[GiltProduct alloc] initWithApiData:productData];
}

@end
