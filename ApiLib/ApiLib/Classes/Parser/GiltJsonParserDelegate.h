//
//  GiltJsonParserDelegate.h
//  GiltApi
//
//  Created by Louis Vera on 2/1/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GiltJsonParserDelegate <NSObject>

// Get a parser instance. 
//
// Please note that while you could return a singleton instance of the class
// that implements this protocol, you should only do so if your JSON parser
// is thread-safe. Otherwise a safe default implementation is simply by
// returning [self new].
//
+ (id<GiltJsonParserDelegate>)newParser;

// Support deserialization of raw JSON data
- (id)objectWithData:(NSData*)data;

// Support deserialization of a JSON string
- (id)objectWithString:(NSString *)repr;

@end
