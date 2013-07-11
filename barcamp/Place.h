//
//  Place.h
//  barcamp
//
//  Created by Jhon Lopez on 7/11/13.
//  Copyright (c) 2013 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;

@end
