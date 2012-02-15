//
//  ProductViewController.h
//  KitchenSink
//
//  Created by Adam Kaplan on 2/15/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiltProduct;

@interface ProductViewController : UIViewController

@property (strong, nonatomic) IBOutlet GiltProduct *product;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *brand;
@property (strong, nonatomic) IBOutlet UITextView *details;
@property (strong, nonatomic) IBOutlet UITextView *other;
@property (strong, nonatomic) IBOutlet UIImageView *primaryImage;

@end
