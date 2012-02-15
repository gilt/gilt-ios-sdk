//
//  ProductsViewController.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "ProductsViewController.h"

#import <GiltApi/GiltApi.h>
#import "ProductTableViewCell.h"
#import "MultiSkuProductTableViewCell.h"
#import "ProductViewController.h"

@implementation ProductsViewController

@synthesize sale;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }*/
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (sale) {
        for(NSURL * url in sale.products) {
            [GiltProductClient fetchProduct:url
                                 completion:^(GiltProduct *product, NSError *error) {
                                     if (!error) {
                                         if(product) {
                                             [products addObject:product];
                                         }
                                         NSLog(@"Products %@", products);
                                         [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                                                          withObject:nil 
                                                                       waitUntilDone:YES];
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
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([products count]) {
        rows = ceil([products count] / 2.0);
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *single_reuse_identifier = @"ProdCell";

    UITableViewCell *return_cell = [self.tableView dequeueReusableCellWithIdentifier:single_reuse_identifier];
    NSInteger row = indexPath.row * 2;
    if (row < [products count]) {
        GiltProduct *product = [products objectAtIndex:row];
        
            ((ProductTableViewCell *)return_cell).leftProduct = product;
            
            // Left view as seperate product
            if (row + 1 < [products count]) {
                GiltProduct *right_product = [products objectAtIndex:row + 1];
                ((ProductTableViewCell *)return_cell).rightProduct = right_product;
            }
    }
    
    return return_cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [products count]) {
        
    }
}

#pragma mark - Setters

- (void)setSale:(GiltSale *)aSale {
    sale = aSale;
    self.navigationItem.title = sale.name;
    products = [NSMutableArray arrayWithCapacity:[sale.products count]];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProductViewController *product_controller = segue.destinationViewController;
    product_controller.product = ((ProductTableViewCell *)sender).rightProduct;
}

@end
