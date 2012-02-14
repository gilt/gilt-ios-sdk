//
//  GiltDefaultJsonParser.m
//  GiltApi
//
//  Created by Louis Vera on 2/1/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GiltDefaultJsonParser.h"

#pragma mark - [Private] GiltSbJsonWrapper

@interface GiltSbJsonWrapper : GiltDefaultJsonParser {
@private
    BOOL canObjectWithData;
    BOOL canObjectWithString;
    id sbJsonParser;
}

@end

@implementation GiltSbJsonWrapper

- (id)initWithParser:(id)parser
{
    if (self = [super init]) {
        sbJsonParser = parser;
        canObjectWithData = [sbJsonParser respondsToSelector:@selector(objectWithData:)];
        canObjectWithString = [sbJsonParser respondsToSelector:@selector(objectWithString:)];
    }
    return self;
}

- (id)objectWithData:(NSData*)data
{
    id parsedData = nil;
    if (canObjectWithData) {
        parsedData = [sbJsonParser objectWithData:data];
    }
    return parsedData;
}

- (id)objectWithString:(NSString *)repr
{
    id parsedData = nil;
    if (canObjectWithString) {
        parsedData = [sbJsonParser objectWithString:repr];
    }
    return parsedData;
}

@end

#pragma mark - [Private] GiltNSJsonWrapper

@interface GiltNSJsonWrapper : GiltDefaultJsonParser
@end

@implementation GiltNSJsonWrapper

- (id)objectWithData:(NSData*)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (id)objectWithString:(NSString *)repr
{
    //This only gets used in the unit tests anyway
    NSData * data = [repr dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

@end

#pragma mark - GiltDefaultJsonParser

@interface GiltDefaultJsonParser (private)
@end

@implementation GiltDefaultJsonParser

+ (id<GiltJsonParserDelegate>)newParser
{
    id<GiltJsonParserDelegate> parser = nil;

    Class sbJsonParserClass = NSClassFromString(@"SBJsonParser");
    
    if(NSClassFromString(@"NSJSONSerialization")) {
        parser = [[GiltNSJsonWrapper alloc] init];
    }
    else if (sbJsonParserClass) {
        id sbJsonParser = [[sbJsonParserClass alloc] init];
        parser = [[GiltSbJsonWrapper alloc] initWithParser:sbJsonParser];
    }
    
    if (!parser) {
        NSLog(@"No suitable default JSON parser found. Tried NSJSONSerialization and SBJsonParser.");
    }
    
    // Neither of these parsers should be shared between multiple lines of execution
    // Retain it in current context, globally if you really know what you're doing
    return parser;
}

#pragma Interface Requirements, This is an abstract factory class.

- (id)objectWithData:(NSData*)data
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)objectWithString:(NSString *)repr
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
