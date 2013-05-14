//
//  FavoritesViewController.h
//  Converter
//
//  Created by TopTierlabs on 4/25/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController{
    IBOutlet UITableView *favoriteTableView;
    NSDictionary *favoritesDictionary;
    NSMutableArray *favoritesArray;
    NSMutableArray *arrayItems;
}

@property(nonatomic, retain) IBOutlet UITableView *favoriteTableView;
@property(nonatomic, retain) NSDictionary *favoritesDictionary;


@end
