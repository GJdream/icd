//
//  ItemICDetailViewController.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 14/06/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemICD10;

@interface ItemICD10DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    ItemICD10 *itemICD10;
    NSString* actualCode;
    bool isFavorite;
    UITableView* tableView;
}

@property(nonatomic, assign) ItemICD10 *itemICD10;

@end
