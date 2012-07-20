//
//  IGDatabase.m
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import "IGDatabase.h"
#import "AppDelegate.h"
#import "Place.h"
#import "Unconference.h"
#import "DictionaryHelper.h"

@implementation IGDatabase

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

+(IGDatabase *) sharedDatabase{
    static IGDatabase *shared = nil;
    if(!shared){
        shared = [[super allocWithZone:nil] init];
    }
    
    return shared;
}

+(id)allocWithZone:(NSZone *)zone{
    return [self sharedDatabase];
}

-(NSArray *)getModelAsArray:(NSString *) model{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:model inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

-(NSArray *)getArrayOfModel:(NSString *) model AndPredicate:(NSPredicate *) predicate{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:model inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    
    [request setPredicate:predicate];    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

-(id)getObjectFromModel:(NSString *)model WithId:(NSNumber *)identifier{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:model inManagedObjectContext:context];
    [request setEntity:description];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", identifier];
    [request setPredicate:predicate];
    NSError *error;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return (results && [results count] > 0)?[results objectAtIndex:0]:nil;
}

#pragma mark - Places
-(void)updateLocalPlaces:(NSArray *)places{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    
    for (NSDictionary *placeDict in places) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [placeDict objectForKey:@"Identifier"]];
        [request setPredicate:predicate];
        
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if([results count] == 0){
            Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
            
            place.identifier = [placeDict numberForKey:@"Identifier"];
            place.name = [placeDict stringForKey:@"Name"];
            place.desc = [placeDict stringForKey:@"Description"];
            place.image = [placeDict stringForKey:@"Image"];
            
                        
            [context save:&error];
        } else {
            Place *place = (Place *)[results objectAtIndex:0];

            place.name = [placeDict stringForKey:@"Name"];
            place.desc = [placeDict stringForKey:@"Description"];
            place.image = [placeDict stringForKey:@"Image"];
            
            [context save:&error];
        }
    }
    
}

#pragma mark - Unconferences
-(void)updateLocalUnconferences:(NSArray *)unconferences{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Unconference" inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    
    for (NSDictionary *unconferenceDict in unconferences) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [unconferenceDict objectForKey:@"Identifier"]];
        [request setPredicate:predicate];
        
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if([results count] == 0){
            Unconference *unconference = [NSEntityDescription insertNewObjectForEntityForName:@"Unconference" inManagedObjectContext:context];
            
            unconference.identifier = [unconferenceDict numberForKey:@"Identifier"];
            unconference.name = [unconferenceDict stringForKey:@"Name"];
            unconference.desc = [unconferenceDict stringForKey:@"Description"];
            unconference.keywords = [unconferenceDict stringForKey:@"Keywords"];
            unconference.schedule = [unconferenceDict stringForKey:@"Schedule"];
            unconference.schedule_id = [unconferenceDict numberForKey:@"ScheduleId"];
            unconference.speakers = [unconferenceDict stringForKey:@"Speakers"];
            unconference.start_time = [dateFormatter dateFromString:[unconferenceDict stringForKey:@"StartTime"]];
            unconference.end_time = [dateFormatter dateFromString:[unconferenceDict stringForKey:@"EndTime"]];
            
            [context save:&error];
        } else {
            Unconference *unconference = (Unconference *)[results objectAtIndex:0];
            
            unconference.name = [unconferenceDict stringForKey:@"Name"];
            unconference.desc = [unconferenceDict stringForKey:@"Description"];
            unconference.keywords = [unconferenceDict stringForKey:@"Keywords"];
            unconference.schedule = [unconferenceDict stringForKey:@"Schedule"];
            unconference.schedule_id = [unconferenceDict numberForKey:@"ScheduleId"];
            unconference.speakers = [unconferenceDict stringForKey:@"Speakers"];
            unconference.start_time = [dateFormatter dateFromString:[unconferenceDict stringForKey:@"StartTime"]];
            unconference.end_time = [dateFormatter dateFromString:[unconferenceDict stringForKey:@"EndTime"]];
            
            [context save:&error];
        }
    }
    
    NSMutableArray *unconferenceArray = [[self getModelAsArray:@"Unconference"] mutableCopy];
    if([unconferences count] < [unconferenceArray count]){
        for (Unconference *current in unconferenceArray) {
            BOOL shouldDelete = YES;
            
            for (NSDictionary *currentDict in unconferences) {
                if (current.identifier) {
                    shouldDelete = NO;
                    break;
                }
            }
            
            if (shouldDelete) {
                [context deleteObject:current];
            }
        }
    }
    
}

- (NSArray *)getUnconfForPlace:(Place *) place{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY place == %@", place.identifier];
    NSArray *unconfs = [self getArrayOfModel:@"Unconference" AndPredicate:predicate];
    return unconfs;
}

@end
