//
//  Unconference.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Unconference : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * schedule;
@property (nonatomic, retain) NSNumber * schedule_id;
@property (nonatomic, retain) NSString * speakers;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) Place *place;

@end
