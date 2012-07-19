//
//  IGDatabase.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGDatabase : NSObject

+(IGDatabase *)sharedDatabase;

-(NSArray *)getModelAsArray:(NSString *) model;
-(id)getObjectFromModel:(NSString *)model WithId:(NSNumber *)identifier;
-(void)updateLocalPlaces:(NSArray *)params;
-(void)updateLocalUnconferences:(NSArray *)unconferences;
@end
