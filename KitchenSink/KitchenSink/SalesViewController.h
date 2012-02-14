//
//  GMasterViewController.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesViewController : UITableViewController {
    NSArray *sales;
}

@property (strong, nonatomic, readonly) IBOutlet UIView *loadingView;

@end
