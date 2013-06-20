//
//  AppDelegate.m
//  HealthApp
//
//  Created by Pablo Epíscopo on 21/05/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ICD9ViewController.h"
#import "ICD10ViewController.h"
//#import "SearchViewController.h"
#import "SearchTableViewController.h"
#import "FavoritesViewController.h"
#import "Utils.h"
#import "CommentsViewController.h"

@implementation AppDelegate

@synthesize window = _window, session = _session;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

// FBSample logic
// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of FBAppCall the provided
// session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

// FBSample logic
// Whether it is in applicationWillTerminate, in applicationDidEnterBackground, or in some other part
// of your application, it is important that you close an active session when it is no longer useful
// to your application; if a session is not properly closed, a retain cycle may occur between the block
// and an object that holds a reference to the session object; close releases the handler, breaking any
// inadvertant retain cycles
- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
     [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    /* Creacion de TabBarController */
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    /* Search NavigationBar and Table */
    searchTableViewController = [[SearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navControllerSearch=[[UINavigationController alloc] initWithRootViewController:searchTableViewController];
    
    /* ICD9 NavigationBar and Table */
    icd9ViewController = [[ICD9ViewController alloc] initWithStyle:UITableViewStyleGrouped] ;
    UINavigationController *navControllerICD9=[[UINavigationController alloc] initWithRootViewController:icd9ViewController];
    [[icd9ViewController tableView] setScrollEnabled:NO];
    
    /* ICD10 NavigationBar and Table */
    icd10ViewController = [[ICD10ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navControllerICD10=[[UINavigationController alloc] initWithRootViewController:icd10ViewController];
    [[icd10ViewController tableView] setScrollEnabled:NO];
    
    favoritesViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
    [self copyPlist];
    favoritesViewController.favoritesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
    UINavigationController *navControllerFavorites = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    
    newsViewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    UINavigationController *navNewsViewController = [[UINavigationController alloc] initWithRootViewController:newsViewController];
    
    commentsViewController = [[CommentsViewController alloc] initWithNibName:@"CommentsViewController" bundle:nil];
    UINavigationController *navCommentsViewController = [[UINavigationController alloc] initWithRootViewController:commentsViewController];
    
    

    
    /* Agregar objetos al TabBar */
    [tabBarController setViewControllers:[NSArray arrayWithObjects:navControllerICD9, navControllerICD10, navControllerSearch
                                          , navControllerFavorites, navNewsViewController, navCommentsViewController, nil]];
    [navControllerSearch release];
    [self.window setRootViewController:tabBarController];
    
    [navControllerFavorites release];
    [navControllerICD9 release];
    [navControllerICD10 release];
    [tabBarController release];
    [newsViewController release];
    [commentsViewController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) copyPlist
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Favorites.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *defaultDBPath;
    if (!success){
        // The writable database does not exist, so copy the default to the appropriate location.
        defaultDBPath = [resourcePath stringByAppendingPathComponent:@"Favorites.plist"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
     
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"CommentsICD9.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success){
        defaultDBPath = [resourcePath stringByAppendingPathComponent:@"CommentsICD9.plist"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"CommentsICD10.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success){
        defaultDBPath = [resourcePath stringByAppendingPathComponent:@"CommentsICD10.plist"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    sleep(2);
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
    sleep(2);
    [FBAppCall handleDidBecomeActive];
}

@end
