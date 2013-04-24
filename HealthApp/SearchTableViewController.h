//
//  SearchTableViewController.h
//  Converter
//
//  Created by Pablo Epíscopo on 19/07/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemICD10DetailViewController, ItemICD9DetailViewController;

@interface SearchTableViewController : UITableViewController <UITextFieldDelegate>
{
    ItemICD9DetailViewController *item9DetailViewController;
    ItemICD10DetailViewController *item10DetailViewController;
    UISearchBar *searchBar;
    NSMutableArray *arrayItems;
    BOOL isFiltered;
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (strong, retain) NSMutableArray *arrayItems;

- (IBAction)searchBarAction:(id)sender;

@end
