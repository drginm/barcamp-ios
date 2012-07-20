//
//  IGUnconferencesViewController.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface IGUnconferencesViewController : UITableViewController{
    NSArray *allUnconfs;
}

@property (strong) Place *selPlace;

@end
