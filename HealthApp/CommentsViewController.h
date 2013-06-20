//
//  CommentsViewController.h
//  Converter
//
//  Created by TopTierlabs on 5/8/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface CommentsViewController : UIViewController <DLStarRatingDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    UILabel *ratingLabel;
    IBOutlet UITableView *table;
    UITextView *comment;
    DLStarRatingControl *customNumberOfStars;
}

@end
