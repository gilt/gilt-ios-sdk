//
//  MultiSkuProductTableViewCell.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MultiSkuProductTableViewCell.h"
#import "GiltApi.h"
#import "ImageFetcher.h"
#import "UIImage+Scaling.h"

@implementation MultiSkuProductTableViewCell

@synthesize primaryImageView, topLeftImageView, bottomLeftImageView, 
            topRightImageView, bottomRightImageView, brandLabel, 
            productNameLabel, salePriceLabel, msrpPriceLabel, product;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        downloadMap = [NSMutableDictionary new];
    }
    return self;
}

- (void)awakeFromNib {
    downloadMap = [NSMutableDictionary new];
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProduct:nil];
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(GiltProduct *)aProduct {
    [downloadMap removeAllObjects];
    product = aProduct;
    
    brandLabel.text = product.brand;
    productNameLabel.text = product.name;
    
    GiltSku *sku = [product.skus objectAtIndex:0];
    salePriceLabel.text = [sku.salePrice stringValue];
    msrpPriceLabel.text = [sku.msrpPrice stringValue];
    
    primaryImageView.image = nil;
    topLeftImageView.image = nil;
    topRightImageView.image = nil;
    bottomLeftImageView.image = nil;
    bottomRightImageView.image = nil;
    
    NSArray *images = [product.images largest];
    if ([images count] > 0) {
        NSURL *url = [images objectAtIndex:0];
        if (url) {
            [downloadMap setObject:self.primaryImageView 
                            forKey:url];
        }
    }
    else if ([images count] > 1) {
        NSURL *url = [images objectAtIndex:1];
        if (url) {
            [downloadMap setObject:self.topLeftImageView 
                            forKey:url];
        }
    }
    else if ([images count] > 2) {
        NSURL *url = [images objectAtIndex:2];
        if (url) {
            [downloadMap setObject:self.topRightImageView 
                            forKey:url];
        }
    }
    else if ([images count] > 3) {
        NSURL *url = [images objectAtIndex:3];
        if (url) {
            [downloadMap setObject:self.bottomLeftImageView 
                            forKey:url];
        }
    }
    else if ([images count] > 4) {
        NSURL *url = [images objectAtIndex:4];
        if (url) {
            [downloadMap setObject:self.bottomRightImageView 
                            forKey:url];
        }
    }
    
    [downloadMap enumerateKeysAndObjectsUsingBlock:^(NSString *url_string, UIImageView *anImageView, BOOL *stop) {
        NSURL *image_url = [NSURL URLWithString:url_string];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(imageReady:) 
                                                     name:@"ImageReadyNotification"
                                                   object:[image_url absoluteString]];
        
        NSLog(@"Requesting Image [%@]", url_string);
        [ImageFetcher getImageFromURL:image_url 
                      preprocessBlock:^UIImage *(NSData *data) {
                          NSLog(@"Preprocessing Fresh Image [%@]", url_string);
                          UIImage *image = [[UIImage alloc] initWithData:data];
                          
                          return [image aspectFillToSize:anImageView.bounds.size];
                      }];
    }];
}

- (void)imageReady:(NSNotification *)notification {
    NSString *image_url = [[[notification userInfo] objectForKey:@"sourceUrl"] absoluteString];
    UIImage *image = [[notification userInfo] objectForKey:@"image"];
    
    UIImageView *view_to_update = [downloadMap objectForKey:image_url];
    if (view_to_update) {
        view_to_update.image = image;
        [self setNeedsDisplay];
    }
    else {
        NSLog(@"Recieved unexpected download event [%@]", image_url);
    }
}

@end
