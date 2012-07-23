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
#import "AppDelegate.h"


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
    
    //self.title = selUnconference.name;
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

#pragma mark - notificacion
- (void)programarNotificacion
{
    
//    UILocalNotification *notificacion = [[UILocalNotification alloc] init];
//    notificacion.fireDate = selUnconference.start_time;
//    notificacion.timeZone = [NSTimeZone defaultTimeZone];
//    
//    notificacion.alertBody = selUnconference.name;
//    notificacion.alertAction = nil;
//    notificacion.soundName = UILocalNotificationDefaultSoundName;
//    //notificacion.applicationIconBadgeNumber = 1;
//    notificacion.applicationIconBadgeNumber=[[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
//    
//    NSDictionary *userDict = [NSDictionary dictionaryWithObject:selUnconference.identifier forKey:kNotificationTextKey];
//    notificacion.userInfo = userDict;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:notificacion];
    
    
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // Get the current date
    NSDate *pickerDate = selUnconference.start_time;
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
												   fromDate:pickerDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
												   fromDate:pickerDate];
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
	// Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
	[dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Notification details
    localNotif.alertBody = selUnconference.name;
	// Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
    
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];

}

- (IBAction)prepararNotificacion:(id)sender
{
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: NSLocalizedString(@"Favorita",nil)
                          message: NSLocalizedString(@"¿Desea agregar esta charla a su lista de favoritos?",nil)
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"No",nil)
                          otherButtonTitles: NSLocalizedString(@"Si",nil), nil];
    [alert show];
    
    
}

// Called when an alertview button is touched
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: 
        {       
            NSLog(@"No agregó");
        }
            break;
            
        case 1: 
        {
            [self programarNotificacion];
        }
            break;
    }
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
