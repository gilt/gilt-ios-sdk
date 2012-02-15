//
//  GiltSalesClient.m
//  GiltApi
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltSalesClient.h"
#import "GiltApi.h"
#import "GiltModel.h"
#import "GiltSale.h"

#define GiltSalesUrlFormat              @"https://api.gilt.com/v1/sales/%@%@.json?apikey=%@"
#define GiltSalesActiveComponent        @"active"
#define GiltSalesUpcomingComponent      @"upcoming"

@interface GiltSalesClient (private)
+ (NSArray *)salesFromJson:(NSDictionary *)sales;
@end

@implementation GiltSalesClient

+ (BOOL)fetchCurrentSalesWithCompletionBlock:(void (^)(NSArray *, NSError *))block {
    return [self fetchSalesForStore:GiltEveryStore 
                      upcomingSales:NO 
                            timeout:0 
                    completionBlock:block];
}

+ (BOOL)fetchUpcomingSalesWithCompletionBlock:(void (^)(NSArray *, NSError *))block {
    return [self fetchSalesForStore:GiltEveryStore 
                      upcomingSales:YES 
                            timeout:0 
                    completionBlock:block];
}

+ (BOOL)fetchSalesForStore:(GiltApiStores)store 
             upcomingSales:(BOOL)upcoming 
                   timeout:(NSTimeInterval)timeout
           completionBlock:(void (^)(NSArray *, NSError *))block {
    
    if (timeout <= 0.) {
        timeout = 30.;
    }
    
    NSURL *url = [GiltSalesClient urlForStore:store upcomingSales:upcoming];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                         timeoutInterval:timeout];
    
    // Wrap the return block in another block to perform post-parse operations
    void (^complete_block)(NSDictionary*,NSError*) = ^(NSDictionary *rawSalesDict, NSError *error) {
        NSArray *sales = nil;
        if (!error) {
            sales = [self salesFromJson:rawSalesDict];
        }
        block(sales, error);
    };
    
    GiltApiClientDownloadRunner *runner = [[GiltApiClientDownloadRunner alloc] initWithRequest:request 
                                                                                    completion:complete_block];
    [runner start];
    return YES;
}


// Synchonrous fetch, returning a GiltModel or nil if there was a problem.
// error will be nil on success or contain an error on failure
+ (NSArray *)fetchSynchronousForStore:(GiltApiStores)store 
                        upcomingSales:(BOOL)upcoming  
                              timeout:(NSTimeInterval)timeout 
                                error:(NSError **)error {
    if (error) {
        *error = nil;
    }
    if (timeout <= 0.) {
        timeout = 30.;
    }
    
    NSURL *url = [GiltSalesClient urlForStore:store upcomingSales:upcoming];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                         timeoutInterval:timeout];
    
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&response 
                                                     error:error];
    
    id sales_data = [[[GiltApi sharedInstance].jsonParserDelegate newParser] objectWithData:data];
    NSArray *sales_list = nil;
    if (!error) {
        if ([sales_data isKindOfClass:[NSDictionary class]]) {
            sales_list = [self salesFromJson:sales_data];
        }
        else {
            *error = [NSError errorWithDomain:@"Failed to parse Sales data from API response" 
                                         code:-1 
                                     userInfo:nil];
        }
    }
    return sales_list;
}

+ (NSArray *)salesFromJson:(NSDictionary *)sales {
    NSArray * salesList = [sales objectForKey:@"sales"];
    NSMutableArray *gilt_sales_list = [[NSMutableArray alloc] initWithCapacity:[salesList count]];
    
    [salesList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GiltSale *sale = [[GiltSale alloc] initWithApiData:(NSDictionary *)obj];
        [gilt_sales_list addObject:sale];
    }];
    
    return gilt_sales_list;
}
 
+ (NSURL *)urlForStore:(GiltApiStores)store 
         upcomingSales:(BOOL)upcoming {
    
    NSString *typeOfSales = GiltSalesActiveComponent;
    if (upcoming) {
        typeOfSales = GiltSalesUpcomingComponent;
    }
    
    NSString *url_string = [NSString stringWithFormat:GiltSalesUrlFormat, 
                            [GiltSalesClient urlComponentForStore:store],
                            typeOfSales, [GiltApi sharedInstance].apiKey];
    return [NSURL URLWithString:url_string];
}
        
@end
