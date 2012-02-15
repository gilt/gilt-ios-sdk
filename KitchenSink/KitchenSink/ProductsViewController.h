//
//  GDetailViewController.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiltSale;

@interface ProductsViewController : UITableViewController {
@private
}

@property (strong, nonatomic) GiltSale *sale;

@end
