//
//  NewsViewController.h
//  Converter
//
//  Created by TopTierlabs on 4/30/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *newsTable;
    NSMutableArray *news;
}



@end
