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

-(NSArray *)getArrayOfModel:(NSString *) model Predicate:(NSPredicate *) predicate SortDescriptors:(NSArray *) sortDescriptors{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:model inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

-(id)getObjectFromModel:(NSString *)model WithId:(NSNumber *)identifier{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:model inManagedObjectContext:context];
    [request setEntity:description];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [placeDict objectForKey:@"id"]];
        [request setPredicate:predicate];
        
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if([results count] == 0){
            Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
            
            place.identifier = [placeDict numberForKey:@"id"];
            place.name = [placeDict stringForKey:@"nombre"];
            place.desc = [placeDict stringForKey:@"descripcion"];
            place.image = [placeDict stringForKey:@"imagen"];
            
                        
//            [context save:&error];
            [self updateLocalUnconferences:[placeDict objectForKey:@"Conferencias"] forPlace:place];
        } else {
            Place *place = (Place *)[results lastObject];

            place.name = [placeDict stringForKey:@"nombre"];
            place.desc = [placeDict stringForKey:@"descripcion"];
            place.image = [placeDict stringForKey:@"imagen"];
            [self updateLocalUnconferences:[placeDict objectForKey:@"Conferencias"] forPlace:place];
            
            
        }
        
        
        [context save:&error];
        
        
    }
    
//    NSDictionary *places = [NSDictionary dictionaryWithObject:allPlaces forKey:PLACES_KEY];
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"updatePlaces" 
     object:self userInfo:nil];
    
}

#pragma mark - Unconferences


-(void)updateLocalUnconferences:(NSArray *)unconferences forPlace:(Place *)place{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"HH:mm a"];
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Unconference" inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    
    for (NSDictionary *unconferenceDict in unconferences) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [unconferenceDict objectForKey:@"id"]];
        [request setPredicate:predicate];
        
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if([results count] == 0){
            Unconference *unconference = [NSEntityDescription insertNewObjectForEntityForName:@"Unconference" inManagedObjectContext:context];
            
            unconference.identifier = [unconferenceDict numberForKey:@"id"];
            unconference.name = [unconferenceDict stringForKey:@"nombre"];
            unconference.desc = [unconferenceDict stringForKey:@"resumen"];
            unconference.keywords = [unconferenceDict stringForKey:@"palabrasClave"];

            unconference.speakers = [unconferenceDict stringForKey:@"expositores"];
            
            NSDictionary *horario = [unconferenceDict objectForKey: @"horario"];
            unconference.start_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaInicio"]];
            unconference.end_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaFin"]];
            
            
            unconference.schedule = [NSString stringWithFormat:@"%@ - %@", [hourFormatter stringFromDate:unconference.start_time], [hourFormatter stringFromDate:unconference.end_time]];
//            unconference.schedule_id = [unconferenceDict numberForKey:@"ScheduleId"];
            
            
            
//            Place *place = [self getObjectFromModel:@"Place" WithId:[unconferenceDict objectForKey:@"Place"]];
            
            if (place != nil) {
                unconference.place = place;
            }
            
//            [context save:&error];
        
        } else {
            Unconference *unconference = (Unconference *)[results objectAtIndex:0];
            
            unconference.identifier = [unconferenceDict numberForKey:@"id"];
            unconference.name = [unconferenceDict stringForKey:@"nombre"];
            unconference.desc = [unconferenceDict stringForKey:@"resumen"];
            unconference.keywords = [unconferenceDict stringForKey:@"palabrasClave"];
            //            unconference.schedule = [unconferenceDict stringForKey:@"horario"];
            //            unconference.schedule_id = [unconferenceDict numberForKey:@"ScheduleId"];
            unconference.speakers = [unconferenceDict stringForKey:@"expositores"];
            
            NSDictionary *horario = [unconferenceDict objectForKey: @"horario"];
            unconference.start_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaInicio"]];
            unconference.end_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaFin"]];
            
            unconference.schedule = [NSString stringWithFormat:@"%@ - %@", [hourFormatter stringFromDate:unconference.start_time], [hourFormatter stringFromDate:unconference.end_time]];
            
//            Place *place = [self getObjectFromModel:@"Place" WithId:[unconferenceDict objectForKey:@"Place"]];
            
            if (place != nil) {
                unconference.place = place;
            }
//            [context save:&error];
    
        }
    }
    
    
//    NSMutableArray *unconferenceArray = [[self getModelAsArray:@"Unconference"] mutableCopy];
//    if([unconferences count] < [unconferenceArray count]){
//        for (Unconference *current in unconferenceArray) {
//            BOOL shouldDelete = YES;
//            
//            for (NSDictionary *currentDict in unconferences) {
//                if (current.identifier) {
//                    shouldDelete = NO;
//                    break;
//                }
//            }
//            
//            if (shouldDelete) {
//                [context deleteObject:current];
//            }
//        }
//    }

}



-(void)updateLocalUnconferences:(NSArray *)unconferences{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    
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
            
            unconference.identifier = [unconferenceDict numberForKey:@"id"];
            unconference.name = [unconferenceDict stringForKey:@"nombre"];
            unconference.desc = [unconferenceDict stringForKey:@"resumen"];
            unconference.keywords = [unconferenceDict stringForKey:@"palabrasClave"];
//            unconference.schedule = [unconferenceDict stringForKey:@"horario"];
//            unconference.schedule_id = [unconferenceDict numberForKey:@"ScheduleId"];
            unconference.speakers = [unconferenceDict stringForKey:@"expositores"];
            
            NSDictionary *horario = [unconferenceDict objectForKey: @"horario"];
            unconference.start_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaInicio"]];
            unconference.end_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaFin"]];
            
            
            Place *place = [self getObjectFromModel:@"Place" WithId:[unconferenceDict objectForKey:@"Place"]];
            
            if (place != nil) {
                unconference.place = place;
            }
                        
            
            [context save:&error];
        } else {
            Unconference *unconference = (Unconference *)[results objectAtIndex:0];
            
            unconference.identifier = [unconferenceDict numberForKey:@"id"];
            unconference.name = [unconferenceDict stringForKey:@"nombre"];
            unconference.desc = [unconferenceDict stringForKey:@"resumen"];
            unconference.keywords = [unconferenceDict stringForKey:@"palabrasClave"];
            //            unconference.schedule = [unconferenceDict stringForKey:@"horario"];
            //            unconference.schedule_id = [unconferenceDict numberForKey:@"ScheduleId"];
            unconference.speakers = [unconferenceDict stringForKey:@"expositores"];
            
            NSDictionary *horario = [unconferenceDict objectForKey: @"horario"];
            unconference.start_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaInicio"]];
            unconference.end_time = [dateFormatter dateFromString:[horario stringForKey:@"fechaFin"]];
            
            Place *place = [self getObjectFromModel:@"Place" WithId:[unconferenceDict objectForKey:@"Place"]];
            
            if (place != nil) {
                unconference.place = place;
            }
            
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY place == %@", place];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"schedule_id"     
                                        ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    
    NSArray *unconfs = [self getArrayOfModel:@"Unconference" Predicate:predicate SortDescriptors:descriptors];
    return unconfs;
}

- (Unconference *)getNextUnconferenceForPlace:(Place *) place{

    NSDate *now = [NSDate date];
    Unconference *nextUnconf;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY place == %@ AND start_time >= %@", place, now];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"schedule_id"     
                                        ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    
    NSArray *unconfsForPlace = [self getArrayOfModel:@"Unconference" Predicate:predicate SortDescriptors:descriptors];
    
    if (unconfsForPlace && [unconfsForPlace count] > 0) {
        nextUnconf = (Unconference *)[unconfsForPlace objectAtIndex:0];
    }
    return nextUnconf;
}

@end
