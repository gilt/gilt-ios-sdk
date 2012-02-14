//
//  GiltUrl.h
//  GiltApi
//
//  Created by Louis Vera on 2/2/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiltUrl : NSObject

+ (NSURL *) mobileWebUrlFromUrl:(NSURL *)webUrl;
+ (NSURL *) urlWithApiKeyFrom:(NSString *)url;

@end
