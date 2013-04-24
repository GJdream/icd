//
//  ICD10ViewController.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 21/05/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemICD10DetailViewController;

@interface ICD10ViewController : UITableViewController <UITextFieldDelegate>
{
    ItemICD10DetailViewController *itemDetailViewController;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
    IBOutlet UIButton *buttonConvert;
    IBOutlet UIButton *buttonRestart;
    IBOutlet UITextField *inputTextBox;
    IBOutlet UILabel *resultLabel;
    NSMutableArray *arrayItems;
}

@property(nonatomic, retain) IBOutlet UITextField *inputTextBox;
@property(nonatomic, retain) IBOutlet UILabel *resultLabel;
@property(nonatomic, retain) IBOutlet UIButton *buttonConvert;
@property(nonatomic, retain) IBOutlet UIButton *buttonRestart;
@property(strong, retain) NSMutableArray *arrayItems;

-(IBAction)cancelOperation:(id)sender;
-(IBAction)doneOperation:(id)sender;
-(IBAction)barButtonsState:(id)sender;
-(IBAction)restartOperation:(id)sender;
-(IBAction)convertOperation:(id)sender;
-(void)hideButtons;

@end
