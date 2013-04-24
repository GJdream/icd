//
//  ItemICDetailViewController.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 14/06/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemICD9;

@interface ItemICD9DetailViewController : UITableViewController
{
    ItemICD9 *itemICD9;
}

@property(nonatomic, assign) ItemICD9 *itemICD9;

@end
