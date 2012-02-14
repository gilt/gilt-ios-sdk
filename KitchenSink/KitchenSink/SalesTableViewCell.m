//
//  SalesTableViewCell.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/27/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "SalesTableViewCell.h"
#import <CoreImage/CoreImage.h>
#import "ImageFetcher.h"
#import "GAppDelegate.h"
#import "GiltApi.h"
#import "NSString+MD5.h"
#import "UIImage+Scaling.h"

@implementation SalesTableViewCell

@synthesize titleLabel, thumbView, sale;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.sale = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super prepareForReuse];
}

- (void)setSale:(GiltSale *)aSale {
    sale = aSale;
    self.titleLabel.text = sale.name;
    self.thumbView.image = nil;
    
    NSArray * sale_images = [sale.images largerThan:thumbView.bounds.size];
    if ([sale_images count]) {
        NSURL *image_url = [sale_images objectAtIndex:0];
        if (image_url) {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(imageReady:) 
                                                         name:@"ImageReadyNotification"
                                                       object:[image_url absoluteString]];
            
            NSLog(@"Requesting Image [%@]", image_url);
            [ImageFetcher getImageFromURL:image_url 
                          preprocessBlock:^UIImage *(NSData *data) {
                              NSLog(@"Preprocessing Fresh Image [%@]", image_url);
                              UIImage *image = [[UIImage alloc] initWithData:data];
                              
                              return [image aspectFillToSize:thumbView.bounds.size];
                          }];
        }
    }
}

- (void)imageReady:(NSNotification *)notification {
    NSString *image_url = [[notification userInfo] objectForKey:@"sourceUrl"];
    UIImage *image = [[notification userInfo] objectForKey:@"image"];
    NSArray * sale_images = [sale.images largerThan:thumbView.bounds.size];
    
    if ([sale_images count]) {
        NSURL *expected_image_url = [sale_images objectAtIndex:0];
        if ([expected_image_url isEqual:image_url]) {
            self.thumbView.image = image;
            [self setNeedsDisplay];
            NSLog(@"Updated image [%@]", image_url);
        }
        else {
            NSLog(@"Receieved invalid download event  [%@]", image_url);
        }
    }
    else {
        NSLog(@"Receieved unexpected download event  [%@]", image_url);
    }
}

@end
