//
//  ProductTableViewCell.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "ProductTableViewCell.h"
#import <GiltApi/GiltApi.h>
#import "GAppDelegate.h"
#import "ImageFetcher.h"
#import "UIImage+Scaling.h"

typedef enum {
    ProductSideLeft = 1,
    ProductSideRight
} ProductSide;

@interface ProductTableViewCell (private)
- (void)fetchProduct:(NSURL *)url side:(ProductSide)side;
- (void)imageReadyMainThread:(NSNotification *)notification;
@end

@implementation ProductTableViewCell

@synthesize leftImageView, leftBrandLabel, leftProductNameLabel, leftSalePriceLabel, 
            leftMsrpPriceLabel, leftProduct, leftProductKey;
@synthesize rightImageView, rightBrandLabel, rightProductNameLabel, rightSalePriceLabel, 
            rightMsrpPriceLabel, rightProduct, rightProductKey;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    leftProductKey = nil;
    rightProductKey = nil;
    
    [super prepareForReuse];
}

- (void)setLeftProductKey:(id)key {
    GAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    GiltProduct *product = [delegate.productCache objectForKey:key];
    if (product) {
        self.leftProduct = product;
        NSLog(@"+++ Cache hit for product [%@]", key);
    }
    else {
        [self fetchProduct:key side:ProductSideLeft];
        NSLog(@"--- Cache miss for product [%@]", key);
    }
}

- (void)setRightProductKey:(id)key {
    GAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    GiltProduct *product = [delegate.productCache objectForKey:key];
    if (product) {
        self.rightProduct = product;
        NSLog(@"+++ Cache hit for product [%@]", key);
    }
    else {
        [self fetchProduct:key side:ProductSideRight];
        NSLog(@"--- Cache miss for product [%@]", key);
    }    
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
            
            [ImageFetcher getImageFromURL:url 
                          preprocessBlock:^UIImage *(NSData *data) {
                              NSLog(@"Preprocessing Fresh Image [%@]", url);
                              UIImage *image = [[UIImage alloc] initWithData:data];
                              return [image aspectFillToSize:leftImageView.bounds.size];
                          }];
        }
    }
    [self setNeedsDisplay];
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
        
        [ImageFetcher getImageFromURL:url 
                      preprocessBlock:^UIImage *(NSData *data) {
                          NSLog(@"Preprocessing Fresh Image [%@]", url);
                          UIImage *image = [[UIImage alloc] initWithData:data];
                          return [image aspectFillToSize:rightImageView.bounds.size];
                      }];
        }
    }
    [self setNeedsDisplay];
}

- (void)fetchProduct:(NSURL *)url side:(ProductSide)side {
    [GiltProductClient fetchProduct:url
                         completion:
     ^(GiltProduct *product, NSError *error) {
         if (!error) {
             GAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
             [delegate.productCache setObject:product forKey:url];
             
             SEL selector;
             if (side == ProductSideLeft) {
                 selector = @selector(setLeftProduct:);
             }
             else {
                 selector = @selector(setRightProduct:);
             }
             [self performSelectorOnMainThread:selector withObject:product waitUntilDone:NO];
         }
         else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                             message:[error localizedDescription]
                                                            delegate:nil 
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}

#pragma - mark Image Ready Handler

- (void)imageReady:(NSNotification *)notification {
    [self performSelectorOnMainThread:@selector(imageReadyMainThread:) withObject:notification waitUntilDone:NO];
}

- (void)imageReadyMainThread:(NSNotification *)notification {
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
    }
    else {
        NSLog(@"Recieved invalid download event [%@]", image_url);
    }
}


@end
