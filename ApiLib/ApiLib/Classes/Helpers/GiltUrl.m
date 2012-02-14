//
//  GiltUrl.m
//  GiltApi
//
//  Created by Louis Vera on 2/2/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltUrl.h"
#import "GiltApi.h"

@implementation GiltUrl

+ (NSURL *) mobileWebUrlFromUrl:(NSURL *)webUrl {
    // For some reason, home store URLs do not follow the standard path conventions.
    NSString *path = [[webUrl path] stringByReplacingOccurrencesOfString:@"/home/sale/" 
                                                              withString:@"/sale/home/" 
                                                                 options:NSCaseInsensitiveSearch | NSAnchoredSearch 
                                                                   range:NSMakeRange(0, 11)];
    
    // Append path to mobile web.
    NSString *url = [@"http://m.gilt.com/mobile" stringByAppendingString:path];
    return [NSURL URLWithString:url];
}

+ (NSURL *) urlWithApiKeyFrom:(NSString *)url {
    return [NSURL URLWithString:[url stringByAppendingFormat:@"?apikey=%@", [GiltApi sharedInstance].apiKey]];
}

@end
