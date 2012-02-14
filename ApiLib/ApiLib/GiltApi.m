//
//  ApiLib.m
//  ApiLib
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltApi.h"
#import "GiltDefaultJsonParser.h"

static GiltApi *sharedApiInstance = nil;

@implementation GiltApi

@synthesize apiKey, jsonParserDelegate;

#pragma mark - Singleton Lifecycle

+ (GiltApi *)sharedInstance {
    if (!sharedApiInstance) {
        @synchronized (self) {
            if (!sharedApiInstance) {
                sharedApiInstance = [[super allocWithZone:NULL] init];
                sharedApiInstance.jsonParserDelegate = [GiltDefaultJsonParser class];
            }
        } // Excessive optimization? So what?
        
        // Attempt to pull API Key from Info.plist
        NSString *plist = @"Info.plist";
        sharedApiInstance.apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GiltApiKey"];
        if (!sharedApiInstance.apiKey) {
            // Alternatively, check GiltApi.plist. This one is friendlier for development as we
            // .gitignore the GiltApi.plist, so your keys are safe!
            NSString *plist_path = [[NSBundle mainBundle] pathForResource:@"GiltApi" ofType:@"plist"];
            if (plist_path) {
                sharedApiInstance.apiKey = [[NSDictionary dictionaryWithContentsOfFile:plist_path] 
                                            objectForKey:@"GiltApiKey"];
                plist = @"GiltApi.plist";
            }
        }
        
        if (sharedApiInstance.apiKey) {
            NSLog(@"Initialized shared Gilt client with API token from %@ [%@]", plist, sharedApiInstance.apiKey);
        }
        else {
            NSLog(@"Initialized shared Gilt client. No API token found as GiltApiKey in Info.plist or GiltApi.plist.");
        }
    }
    return sharedApiInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
