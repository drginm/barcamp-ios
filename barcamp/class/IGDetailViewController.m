//
//  IGDetailViewController.m
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/21/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import "IGDetailViewController.h"
#import "Unconference.h"
#import "Place.h"
#import "UILabel+ESAdjustableLabel.h"


@interface IGDetailViewController ()

@end

@implementation IGDetailViewController
@synthesize titleLB;
@synthesize scheduleLB;
@synthesize descriptionLB;
@synthesize speakersLB;
@synthesize keywordsLB;
@synthesize detailsScroller;
@synthesize detailsPager;
@synthesize selUnconference;
@synthesize container;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTitleLB:nil];
    [self setScheduleLB:nil];
    [self setDescriptionLB:nil];
    [self setSpeakersLB:nil];
    [self setKeywordsLB:nil];
    [self setContainer:nil];
    [self setDetailsScroller:nil];
    [self setDetailsPager:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = selUnconference.name;
    self.titleLB.text = selUnconference.name;
    self.scheduleLB.text = selUnconference.schedule;
    self.descriptionLB.text = selUnconference.desc;
    [self.descriptionLB adjustLabelToMaximumSize:self.descriptionLB.bounds.size minimumFontSize:12];
    self.speakersLB.text = selUnconference.speakers;
    [self.speakersLB adjustLabelToMaximumSize:self.speakersLB.bounds.size minimumFontSize:12];
    self.keywordsLB.text = selUnconference.keywords;
    [self.keywordsLB adjustLabelToMaximumSize:self.keywordsLB.bounds.size minimumFontSize:12];
    
    self.detailsScroller.delegate = self;
    [self.detailsScroller setPagingEnabled:YES];
    
    self.detailsScroller.contentSize = CGSizeMake(self.detailsScroller.bounds.size.width * 3, self.detailsScroller.bounds.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Share
-(IBAction) sendTwit:(id)sender{
    if ([TWTweetComposeViewController canSendTweet])
    {
        
        NSString *articleUrl = BARCAMP_URL;
        
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet addURL:[NSURL URLWithString:articleUrl]];
        
        [tweetSheet setInitialText: [NSString stringWithFormat:@"Interesante charla: %@ en %@",selUnconference.name, BARCAMP_TWITTER]];
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)addToFav:(id)sender {
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.detailsScroller.frame.size.width;
    float fractionalPage = self.detailsScroller.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.detailsPager.currentPage = page; 
}


#pragma mark - pager
- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.detailsScroller.frame.size.width * self.detailsPager.currentPage;
    frame.origin.y = 0;
    frame.size = self.detailsScroller.frame.size;
    [self.detailsScroller scrollRectToVisible:frame animated:YES];

}

@end
