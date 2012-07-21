//
//  IGRoomsViewController.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IGUnconferencesViewController;
@class Place;

@interface IGRoomsViewController : UITableViewController{
    NSArray *allPlaces;
    Place *selectedPlace;
    
    @private
    IGUnconferencesViewController *unconfVC;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end
