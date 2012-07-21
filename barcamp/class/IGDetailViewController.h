//
//  IGDetailViewController.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/21/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Unconference;

@interface IGDetailViewController : UIViewController <UIScrollViewDelegate>

@property (strong) Unconference *selUnconference;

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLB;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLB;
@property (weak, nonatomic) IBOutlet UILabel *speakersLB;
@property (weak, nonatomic) IBOutlet UILabel *keywordsLB;

@property (weak, nonatomic) IBOutlet UIScrollView *detailsScroller;
@property (weak, nonatomic) IBOutlet UIPageControl *detailsPager;

- (IBAction)changePage;
- (IBAction) sendTwit:(id)sender;
- (IBAction)addToFav:(id)sender;

@end
