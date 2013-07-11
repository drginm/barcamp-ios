//
//  Unconference.h
//  barcamp
//
//  Created by Jhon Lopez on 7/11/13.
//  Copyright (c) 2013 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Unconference : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * schedule;
@property (nonatomic, retain) NSNumber * schedule_id;
@property (nonatomic, retain) NSString * speakers;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSNumber * place_id;

@end
