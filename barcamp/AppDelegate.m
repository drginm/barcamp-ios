//
//  AppDelegate.m
//  barcamp
//
//  Created by Jhon Jaiver López Calderón on 7/19/12.
//  Copyright (c) 2012 IGApps. All rights reserved.
//

#import "AppDelegate.h"
#import "IGBackend.h"
#import "IGDatabase.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

NSString *kNotificationTextKey = @"kNotificationTextKey";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
//    [[IGBackend sharedBackend] updateUnconferences];
    
    
    NSString* barcampVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"barcampVersion"];
    
    if (!barcampVersion || ![barcampVersion isEqualToString:@"2.0"]) {
        [self clearStore];
    }
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:appVersionString forKey:@"barcampVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[IGBackend sharedBackend] updatePlaces];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor darkGrayColor],
                       UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor],
                       UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]} forState:UIControlStateSelected];
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: textTitleOptions
                                                forState: UIControlStateNormal];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IGBarcampModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IGBarcampModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

-(void)clearStore{
    [[IGDatabase sharedDatabase] deleteAllObjects:@"Unconference"];
    [[IGDatabase sharedDatabase] deleteAllObjects:@"Place"];
    
    //    NSError * error;
//    // retrieve the store URL
////    NSURL * storeURL = [[__managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[__managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IGBarcampModel.sqlite"];
//    // lock the current context
//    [__managedObjectContext lock];
//    [__managedObjectContext reset];//to drop pending changes
//    //delete the store from the current managedObjectContext
//    if ([[__managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[__managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
//    {
//        // remove the file containing the data
//        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
//        //recreate the store like in the  appDelegate method
//        [[__managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
//    }
//    [__managedObjectContext unlock];
//    //that's it !
}




#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
