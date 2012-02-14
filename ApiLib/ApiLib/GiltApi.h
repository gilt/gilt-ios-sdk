//
//  ApiLib.h
//  ApiLib
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiltJsonParserDelegate.h"
#import "GiltImageCollection.h"
#import "GiltModel.h"
#import "GiltProduct.h"
#import "GiltSale.h"
#import "GiltSalesClient.h"
#import "GiltSku.h"
#import "GiltProductClient.h"

@interface GiltApi : NSObject

+ (GiltApi *)sharedInstance;

// Your assigned Gilt API token, issues at https://dev.gilt.com/
@property (strong) NSString *apiKey;

// A object that vends JSON parsers
// @see GiltJsonParserDelegate
@property (strong) Class<GiltJsonParserDelegate> jsonParserDelegate;

@end
