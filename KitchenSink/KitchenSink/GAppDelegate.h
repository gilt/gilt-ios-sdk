//
//  GAppDelegate.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAppDelegate : UIResponder <UIApplicationDelegate> {
    @private
    NSMutableDictionary *productCache;
}

@property (strong) NSMutableDictionary *productCache;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSOperationQueue *downloadQueue;

@end
