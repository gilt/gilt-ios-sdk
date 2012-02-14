//
//  GMasterViewController.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "SalesViewController.h"

#import "GiltApi.h"
#import "ProductsViewController.h"
#import "SalesTableViewCell.h"

@implementation SalesViewController

@synthesize loadingView;

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
    //self.detailViewController = (GDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //self.detailViewController = (GDetailViewController *)[[self.splitViewController    
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
    
    if (!sales) {
        [self.tableView addSubview:loadingView];
        NSLog(@"%@", loadingView);
        
        [GiltSalesClient fetchSalesForStore:GiltEveryStore 
                              upcomingSales:NO 
                                    timeout:30.0 
                            completionBlock:^(NSArray *salesList, NSError *error) {
                                if (!error) {
                                    //filter out sales with 0 products
                                    NSPredicate * filter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
                                        BOOL valid = NO;
                                        GiltSale * sale = (GiltSale *)evaluatedObject;
                                        if (sale.products && [sale.products count] > 0) {
                                            valid = YES;
                                        }
                                        return valid;
                                    }];
                                    sales = [salesList filteredArrayUsingPredicate:filter];
                                    NSLog(@"Sales %@", sales);
                                    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                                                     withObject:nil 
                                                                  waitUntilDone:YES];
                                    [loadingView removeFromSuperview];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SalesTableViewCell *cell = sender;
    ProductsViewController *products_controller = segue.destinationViewController;
    products_controller.sale = cell.sale;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = [sales count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse_identifier = @"SaleCell";
    
    SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_identifier];
    if (indexPath.row < [sales count]) {
        cell.sale = [sales objectAtIndex:indexPath.row];
    }
    
    return cell;
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
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [sales count]) {
        //GiltSale *selected_sale = [sales objectAtIndex:indexPath.row];
        
        //[self.navigationController pushViewController:productsTableViewController animated:YES];
        //[self.navigationController performSegueWithIdentifier:@"PushProductsTable" sender:self];
    }
}

@end
