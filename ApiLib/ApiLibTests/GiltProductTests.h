//
//  GiltProductTests.h
//  GiltApi
//
//  Created by Louis Vera on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>

@interface GiltProductTests : SenTestCase

- (void)compareKey:(NSString *)key withValue:(id)value toModel:(id)model;

@end
