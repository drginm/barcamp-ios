//
//  IGBackend.h
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGBackend : NSObject

+(IGBackend *)sharedBackend;


- (void)updatePlaces;
- (void)updateUnconferences;
- (void)updateTwitts;
@end
