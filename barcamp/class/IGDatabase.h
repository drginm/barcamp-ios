//
//  IGDatabase.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Place;
@class Unconference;
@interface IGDatabase : NSObject

+(IGDatabase *)sharedDatabase;

-(NSArray *)getModelAsArray:(NSString *) model;
-(id)getObjectFromModel:(NSString *)model WithId:(NSNumber *)identifier;

#pragma mark - Places
-(void)updateLocalPlaces:(NSArray *)params;

#pragma mark - Unconferences
-(void)updateLocalUnconferences:(NSArray *)unconferences;
- (NSArray *)getUnconfForPlace:(Place *) place;
- (Unconference *)getNextUnconferenceForPlace:(Place *) place;
@end
