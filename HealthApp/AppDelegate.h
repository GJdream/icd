//
//  AppDelegate.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 21/05/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@class SearchTableViewController, ICD9ViewController, ICD10ViewController, FavoritesViewController, NewsViewController, CommentsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SearchTableViewController *searchTableViewController;
    ICD9ViewController *icd9ViewController;
    ICD10ViewController *icd10ViewController;
    FavoritesViewController *favoritesViewController;
    NewsViewController *newsViewController;
    CommentsViewController *commentsViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;

@end
