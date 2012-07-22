//
//  IGRoomsViewController.m
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import "IGRoomsViewController.h"
#import "IGUnconferencesViewController.h"
#import "ODRefreshControl.h"
#import "IGDatabase.h"
#import "Place.h"
#import "Unconference.h"

@interface IGRoomsViewController ()

@end

@implementation IGRoomsViewController

@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)updatePlaces:(NSNotification *) notification{
    if([[notification name] isEqualToString:@"updatePlaces"]){
        allPlaces = [[IGDatabase sharedDatabase] getModelAsArray:@"Place"];
        [[self tableView] reloadData];
        [HUD hide:YES];
//        [self.view setNeedsDisplay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaces:) 
                                                 name:@"updatePlaces"
                                               object:nil];

    self.navigationItem.title = @"Salas";
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Actualizando";
	HUD.minSize = CGSizeMake(135.f, 135.f);
    
    [HUD show:YES];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    allPlaces = [[IGDatabase sharedDatabase] getModelAsArray:@"Place"];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self.tableView reloadData];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tbView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"roomsCell";
    UITableViewCell *cell = [tbView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [(Place *)[allPlaces objectAtIndex:indexPath.row] name];
    
    Place *current = (Place *)[allPlaces objectAtIndex:indexPath.row];

	UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
	nameLabel.text = [current name];
    
    Unconference *next = [[IGDatabase sharedDatabase] getNextUnconferenceForPlace:current];
    
	UILabel *desconferenciaLabel = (UILabel *)[cell viewWithTag:101];
	desconferenciaLabel.text =next.name;
    
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"unconferenceSegue"]){
        unconfVC = [segue destinationViewController];
        [unconfVC setSelPlace:selectedPlace];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
//    if(unconfVC == nil){
//        unconfVC = [IGUnconferencesViewController alloc] init
//    }
    
    selectedPlace = [allPlaces objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"unconferenceSegue" sender:self];
    /*
     
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
