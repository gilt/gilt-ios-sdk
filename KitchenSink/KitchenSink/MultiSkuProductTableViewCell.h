//
//  MultiSkuProductTableViewCell.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiltProduct;

@interface MultiSkuProductTableViewCell : UITableViewCell {
    @private
    NSMutableDictionary *downloadMap;
}

@property (strong, nonatomic, retain) GiltProduct *product;

@property (strong, nonatomic, retain) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *salePriceLabel;
@property (strong, nonatomic, retain) IBOutlet UILabel *msrpPriceLabel;

@property (strong, nonatomic, retain) IBOutlet UIImageView *primaryImageView;
@property (strong, nonatomic, retain) IBOutlet UIImageView *topLeftImageView;
@property (strong, nonatomic, retain) IBOutlet UIImageView *bottomLeftImageView;
@property (strong, nonatomic, retain) IBOutlet UIImageView *topRightImageView;
@property (strong, nonatomic, retain) IBOutlet UIImageView *bottomRightImageView;

@end
