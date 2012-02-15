//
//  ProductViewController.m
//  KitchenSink
//
//  Created by Adam Kaplan on 2/15/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "ProductViewController.h"
#import <GiltApi/GiltApi.h>

@interface ProductViewController (private)
- (void)updateDisplay;
@end

@implementation ProductViewController

@synthesize product, name, brand, details, other, primaryImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateDisplay];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setProduct:(GiltProduct *)aProduct {
    product = aProduct;
    [self updateDisplay];
}

- (void)updateDisplay {
    name.text = product.name;
    brand.text = product.brand;
    details.text = product.description;
    other.text = product.fitNotes; // add others
    
    NSArray *images = [product.images largest];
    if (images.count) {
        NSURL *url = [images objectAtIndex:0];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        primaryImage.image = image;
    }
}

@end
