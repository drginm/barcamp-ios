//
//  Place.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Unconference;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSSet *unconferences_place;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addUnconferences_placeObject:(Unconference *)value;
- (void)removeUnconferences_placeObject:(Unconference *)value;
- (void)addUnconferences_place:(NSSet *)values;
- (void)removeUnconferences_place:(NSSet *)values;

@end
