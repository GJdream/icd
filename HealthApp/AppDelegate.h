//
//  AppDelegate.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 21/05/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTableViewController, ICD9ViewController, ICD10ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SearchTableViewController *searchTableViewController;
    ICD9ViewController *icd9ViewController;
    ICD10ViewController *icd10ViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
