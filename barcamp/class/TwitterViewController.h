//
//  TwitterViewController.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/21/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TwitterViewController : UITableViewController<MBProgressHUDDelegate>{
    NSArray *twitterEntries;
    MBProgressHUD *HUD;
}

@end
