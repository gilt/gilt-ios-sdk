//
//  ProductTableViewCell.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiltProduct;

@interface ProductTableViewCell : UITableViewCell

@property (strong, nonatomic, retain) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic, retain) IBOutlet UILabel *leftBrandLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *leftProductNameLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *leftSalePriceLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *leftMsrpPriceLabel;
@property (strong, nonatomic, retain) GiltProduct *leftProduct;
@property (strong, nonatomic, retain) id leftProductKey;

@property (strong, nonatomic, retain) IBOutlet UIImageView *rightImageView;
@property (strong, nonatomic, retain) IBOutlet UILabel *rightBrandLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *rightProductNameLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *rightSalePriceLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *rightMsrpPriceLabel;
@property (strong, nonatomic, retain) GiltProduct *rightProduct;
@property (strong, nonatomic, retain) id rightProductKey;

@end
