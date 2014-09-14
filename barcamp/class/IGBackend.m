//
//  IGBackend.m
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import "IGBackend.h"
#import "IGDatabase.h"
#import "DictionaryHelper.h"

@implementation IGBackend

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

+(IGBackend *) sharedBackend{
    static IGBackend *shared = nil;
    if(!shared){
        shared = [[super allocWithZone:nil] init];
    }
    
    return shared;
}

+(id)allocWithZone:(NSZone *)zone{
    return [self sharedBackend];
}

#pragma mark - Places
- (void)updatePlaces{
    
    __block NSString *jsonResult = nil;
    
    dispatch_queue_t cola = dispatch_queue_create("services", NULL);
    dispatch_async(cola, ^{
        NSString *url = [NSString stringWithFormat:@"%@", API_PLACES];        
        jsonResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSError *error;
            NSData *dataJson = [jsonResult dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *allPlaces;
            if(dataJson){
                allPlaces = [NSJSONSerialization JSONObjectWithData: dataJson options: NSJSONReadingMutableContainers error:&error];
            }

            [[IGDatabase sharedDatabase] updateLocalPlaces:allPlaces];
             
//            NSDictionary *places = [NSDictionary dictionaryWithObject:allPlaces forKey:PLACES_KEY];
//            
//            [[NSNotificationCenter defaultCenter] 
//             postNotificationName:@"updatePlaces" 
//             object:self userInfo:places];
            

            
        });
    });
    
    dispatch_release(cola);
}


#pragma mark - Unconferences
- (void)updateUnconferences{
    
    __block NSString *jsonResult = nil;
    
    dispatch_queue_t cola = dispatch_queue_create("services", NULL);
    dispatch_async(cola, ^{
        NSString *url = [NSString stringWithFormat:@"%@", API_UNCONFERENCE];        
        jsonResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSError *error;
            NSData *dataJson = [jsonResult dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *allUncf;
            if(dataJson){
                allUncf = [NSJSONSerialization JSONObjectWithData: dataJson options: NSJSONReadingMutableContainers error:&error];
            }
            
            [[IGDatabase sharedDatabase] updateLocalUnconferences:allUncf];
            
//            NSDictionary *places = [NSDictionary dictionaryWithObject:allUncf forKey:UNCONFERENCES_KEY];
            
            
        });
    });
    
    dispatch_release(cola);
}

@end
