//
//  SalesTableViewCell.h
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiltSale;

@interface SalesTableViewCell : UITableViewCell

@property (strong, readonly, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, readonly, nonatomic) IBOutlet UIImageView *thumbView;
@property (strong, nonatomic) GiltSale *sale;

- (void)imageReady:(NSNotification *)notification;

@end
