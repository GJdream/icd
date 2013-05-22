//
//  ItemICDetailViewController.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 14/06/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@class ItemICD9;

@interface ItemICD9DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    ItemICD9 *itemICD9;
    NSString* actualCode;
    bool isFavorite;
    UITableView* tableView;
}

@property(nonatomic, assign) ItemICD9 *itemICD9;

@end
