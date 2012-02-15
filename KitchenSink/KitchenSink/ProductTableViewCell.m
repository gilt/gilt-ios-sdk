//
//  ProductTableViewCell.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "GiltApi.h"
#import "ImageFetcher.h"
#import "UIImage+Scaling.h"

@implementation ProductTableViewCell

@synthesize leftImageView, leftBrandLabel, leftProductNameLabel, leftSalePriceLabel, 
            leftMsrpPriceLabel, leftProduct;
@synthesize rightImageView, rightBrandLabel, rightProductNameLabel, rightSalePriceLabel, 
            rightMsrpPriceLabel, rightProduct;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    leftBrandLabel.text = nil;
    rightBrandLabel.text = nil;

    leftImageView.image = nil;
    rightImageView.image = nil;
    
    leftProduct = nil;
    rightProduct = nil;
    
    leftProductNameLabel.text = nil;
    rightProductNameLabel.text = nil;
    
    leftSalePriceLabel.text = nil;
    rightSalePriceLabel.text = nil;
    
    leftMsrpPriceLabel.text = nil;
    rightMsrpPriceLabel.text = nil;
    
    [super prepareForReuse];
}

- (void)setLeftProduct:(GiltProduct *)product {
    leftProduct = product;
    
    leftBrandLabel.text = product.brand;
    leftProductNameLabel.text = product.name;
    if ([product.skus count]) {
        GiltSku *sku = [product.skus objectAtIndex:0];
        leftSalePriceLabel.text = [sku.salePrice stringValue];
        leftMsrpPriceLabel.text = [sku.msrpPrice stringValue];
    }
    
    self.leftImageView.image = nil;
    
    NSArray *gilt_images = [leftProduct.images largest];
    if ([gilt_images count]) {
        NSURL *url = [gilt_images objectAtIndex:0];
        if (url) {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(imageReady:) 
                                                         name:@"ImageReadyNotification"
                                                       object:[url absoluteString]];
            
            NSLog(@"Requesting Image [%@]", url);
            [ImageFetcher getImageFromURL:url 
                          preprocessBlock:^UIImage *(NSData *data) {
                              NSLog(@"Preprocessing Fresh Image [%@]", url);
                              UIImage *image = [[UIImage alloc] initWithData:data];
                              return [image aspectFillToSize:leftImageView.bounds.size];
                          }];
        }
    }
}

- (void)setRightProduct:(GiltProduct *)product {
    rightProduct = product;
    
    rightBrandLabel.text = rightProduct.brand;
    rightProductNameLabel.text = rightProduct.name;
    if ([rightProduct.skus count]) {
        GiltSku *sku = [rightProduct.skus objectAtIndex:0];
        rightSalePriceLabel.text = [sku.salePrice stringValue];
        rightMsrpPriceLabel.text = [sku.msrpPrice stringValue];
    }
    
    self.rightImageView.image = nil;
    
    NSArray *gilt_images = [rightProduct.images largest];
    if ([gilt_images count]) {
        NSURL *url = [gilt_images objectAtIndex:0];
        if (url) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(imageReady:) 
                                                     name:@"ImageReadyNotification"
                                                   object:[url absoluteString]];
        
        NSLog(@"Requesting Image [%@]", url);
        [ImageFetcher getImageFromURL:url 
                      preprocessBlock:^UIImage *(NSData *data) {
                          NSLog(@"Preprocessing Fresh Image [%@]", url);
                          UIImage *image = [[UIImage alloc] initWithData:data];
                          return [image aspectFillToSize:rightImageView.bounds.size];
                      }];
        }
    }
}

#pragma - mark Image Ready Handler

- (void)imageReady:(NSNotification *)notification {
    NSString *image_url = [[notification userInfo] objectForKey:@"sourceUrl"];
    UIImage *image = [[notification userInfo] objectForKey:@"image"];
    
    UIImageView *viewToUpdate = nil;
    NSArray *right_images = [rightProduct.images largest];
    if ([right_images count]) 
    {
        NSURL *right_url = [right_images objectAtIndex:0];
        if ([right_url isEqual:image_url]) {
            viewToUpdate = self.rightImageView;
        }
    }
    
    NSArray *left_images = [leftProduct.images largest];
    if ([left_images count]) 
    {    
        NSURL *left_url = [left_images objectAtIndex:0];
        if ([left_url isEqual:image_url]) {
            viewToUpdate = self.leftImageView;
        }
    }

    if (viewToUpdate) {
        viewToUpdate.image = image;
        [self setNeedsDisplay];
        NSLog(@"Updated image [%@]", image_url);
    }
    else {
        NSLog(@"Recieved invalid download event [%@]", image_url);
    }
}


@end
