//
//  SearchTableViewController.m
//  Converter
//
//  Created by Pablo Epíscopo on 19/07/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ItemICD10DetailViewController.h"
#import "ItemICD9DetailViewController.h"
#import "ItemICD9.h"
#import "ItemICD10.h"
#import "WebService.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

@synthesize searchBar, arrayItems, activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [[self navigationItem] setTitle:@"Search"];
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Search"];
    
    UIImage *image = [UIImage imageNamed:@"tabbar-search.png"];
    [tbi setImage:image];
    
    return self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    int rowCount;
    
    if(isFiltered) {
        
        if (section == 0) {
            if ([[arrayItems objectAtIndex:0] objectAtIndex:0] == [NSNull null]) {
                rowCount = 1;
            } else {
                rowCount = [[arrayItems objectAtIndex:0] count];
            }
        } else {
            if ([[arrayItems objectAtIndex:1] objectAtIndex:0] == [NSNull null]) {
                rowCount = 1;
            } else {
                rowCount = [[arrayItems objectAtIndex:1] count];
            }
        }
        
    } else {
        rowCount = 0;
    }
    return rowCount;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isFiltered)
        return 2;
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSArray arrayWithObjects:@"ICD9 Codes", @"ICD10 Codes", nil] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (isFiltered) {
        
        if ([indexPath section] == 0) {
            
            ItemICD9 *itemICD9;
            
            if ([[arrayItems objectAtIndex:0] objectAtIndex:0] == [NSNull null]) {
                
                UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 270.0f, 30.0f)];
                [resultLabel setAdjustsFontSizeToFitWidth:NO];
                [resultLabel setTextColor:[UIColor blackColor]];
                [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel setBackgroundColor:[UIColor clearColor]];
                [resultLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
                [resultLabel setText:@"No matches"];                 
                [resultLabel setTextAlignment:UITextAlignmentLeft];
                [resultLabel setTag:0];
                [resultLabel setEnabled:YES];
                
                [cell addSubview:resultLabel];
                
                
                [cell setAccessoryType: UITableViewCellAccessoryNone];
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];

            } else {
                
                itemICD9 = [[arrayItems objectAtIndex:0] objectAtIndex:[indexPath row]];
                
                UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 270.0f, 30.0f)];
                [resultLabel setAdjustsFontSizeToFitWidth:NO];
                [resultLabel setTextColor:[UIColor blackColor]];
                [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel setBackgroundColor:[UIColor clearColor]];
                [resultLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
                
                if (itemICD9.shortDescription == nil) {
                    [resultLabel setText:@"No available information"];
                } else {
                    [resultLabel setText:[itemICD9 shortDescription]];
                }
                
                [resultLabel setTextAlignment:UITextAlignmentLeft];
                [resultLabel setTag:0];
                [resultLabel setEnabled:YES];
                
                [cell addSubview:resultLabel];
                
                
                UILabel *resultLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 270.0f, 30.0f)];
                [resultLabel2 setAdjustsFontSizeToFitWidth:NO];
                [resultLabel2 setTextColor:[UIColor darkGrayColor]];
                [resultLabel2 setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel2 setBackgroundColor:[UIColor clearColor]];
                [resultLabel2 setFont:[UIFont boldSystemFontOfSize:15.0]];
                
                if (itemICD9.codeICD9 == nil) {
                    [resultLabel2 setText:@"No available information"];
                } else {
                    [resultLabel2 setText:[NSString stringWithFormat:@"ICD9: %@", [itemICD9 codeICD9]]];        
                }
                
                [resultLabel2 setTextAlignment:UITextAlignmentLeft];
                [resultLabel2 setTag:0];
                [resultLabel2 setEnabled:YES];
                
                [cell addSubview:resultLabel2];
                
                
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
            }
            
        } else {
            
            ItemICD10 *itemICD10;
            
            if ([[arrayItems objectAtIndex:1] objectAtIndex:0] == [NSNull null]) {
                
                UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 270.0f, 30.0f)];
                [resultLabel setAdjustsFontSizeToFitWidth:NO];
                [resultLabel setTextColor:[UIColor blackColor]];
                [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel setBackgroundColor:[UIColor clearColor]];
                [resultLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
                [resultLabel setText:@"No matches"];                 
                [resultLabel setTextAlignment:UITextAlignmentLeft];
                [resultLabel setTag:0];
                [resultLabel setEnabled:YES];
                
                [cell addSubview:resultLabel];
                
                
                [cell setAccessoryType: UITableViewCellAccessoryNone];
                [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                
            } else {
                
                itemICD10 = [[arrayItems objectAtIndex:1] objectAtIndex:[indexPath row]];
                
                UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 270.0f, 30.0f)];
                [resultLabel setAdjustsFontSizeToFitWidth:NO];
                [resultLabel setTextColor:[UIColor blackColor]];
                [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel setBackgroundColor:[UIColor clearColor]];
                [resultLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
                
                if (itemICD10.shortDescription == nil) {
                    [resultLabel setText:@"No available information"];
                } else {
                    [resultLabel setText:[itemICD10 shortDescription]];
                }
                
                [resultLabel setTextAlignment:UITextAlignmentLeft];
                [resultLabel setTag:0];
                [resultLabel setEnabled:YES];
                
                [cell addSubview:resultLabel];
                
                
                UILabel *resultLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 270.0f, 30.0f)];
                [resultLabel2 setAdjustsFontSizeToFitWidth:NO];
                [resultLabel2 setTextColor:[UIColor darkGrayColor]];
                [resultLabel2 setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel2 setBackgroundColor:[UIColor clearColor]];
                [resultLabel2 setFont:[UIFont boldSystemFontOfSize:15.0]];
                
                if (itemICD10.codeICD10 == nil) {
                    [resultLabel2 setText:@"No available information"];
                } else {
                    [resultLabel2 setText:[NSString stringWithFormat:@"ICD10: %@", [itemICD10 codeICD10]]];
                }
                
                [resultLabel2 setTextAlignment:UITextAlignmentLeft];
                [resultLabel2 setTag:0];
                [resultLabel2 setEnabled:YES];
                
                [cell addSubview:resultLabel2];
                
                
                UILabel *resultLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 53.0f, 270.0f, 30.0f)];
                [resultLabel3 setAdjustsFontSizeToFitWidth:NO];
                [resultLabel3 setTextColor:[UIColor darkGrayColor]];
                [resultLabel3 setHighlightedTextColor:[UIColor whiteColor]];
                [resultLabel3 setBackgroundColor:[UIColor clearColor]];
                [resultLabel3 setFont:[UIFont boldSystemFontOfSize:15.0]];
                
                if (itemICD10.equivalentICD9 == nil) {
                    [resultLabel3 setText:@""];
                } else {
                    [resultLabel3 setText:[NSString stringWithFormat:@"Equivalent ICD9: %@", [itemICD10 equivalentICD9]]];
                }
                
                [resultLabel3 setTextAlignment:UITextAlignmentLeft];
                [resultLabel3 setTag:0];
                [resultLabel3 setEnabled:YES];
                
                [cell addSubview:resultLabel3];
                
                
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
            }
            
        }
        
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        
        if ([[arrayItems objectAtIndex:0] objectAtIndex:0] != [NSNull null]) {
            
            if (!item9DetailViewController) {
                item9DetailViewController = [[ItemICD9DetailViewController alloc] init];
            }
            
            ItemICD9 *itemwithoutarrayoficd10 = [[arrayItems objectAtIndex:0] objectAtIndex:[indexPath row]];
            
            WebService *ws = [[WebService alloc] init];
            NSArray *icd9arr =  [ws getICD9ByCode: itemwithoutarrayoficd10.codeICD9];
            [item9DetailViewController setItemICD9:[icd9arr objectAtIndex:0]];
            [[self navigationController] pushViewController:item9DetailViewController animated:YES];
        }
        
    } else {
        
        if ([[arrayItems objectAtIndex:1] objectAtIndex:0] != [NSNull null]) {
            
            if (!item10DetailViewController) {
                item10DetailViewController = [[ItemICD10DetailViewController alloc] init];
            }
            
            ItemICD10 *itemicd10withouticd9 = [[arrayItems objectAtIndex:1] objectAtIndex:[indexPath row]];
            WebService *ws = [[WebService alloc] init];
            NSArray *icd10arr =  [ws getICD10ByCode: itemicd10withouticd9.codeICD10];
            [item10DetailViewController setItemICD10: [icd10arr objectAtIndex:0]];
            [[self navigationController] pushViewController:item10DetailViewController animated:YES];                    
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        
        if ([[arrayItems objectAtIndex:0] objectAtIndex:0] == [NSNull null]) {
            return 44.0f;
        } else {
            return 70.0f;
        }

    } else {
        
        if ([[arrayItems objectAtIndex:1] objectAtIndex:0] == [NSNull null]) {
            return 44.0f;
        } else {
            return 95.0f;
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{ 
  
    if (text.length == 0) {
        isFiltered = NO;
        arrayItems = nil;
    }
    
    [[self tableView] reloadData];

}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [searchBar setAutocorrectionType: UITextAutocorrectionTypeNo];
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setPlaceholder: @"Search by word association"];
    [searchBar sizeToFit];
    [searchBar setDelegate:(id)self];
    [searchBar setKeyboardType: UIKeyboardTypeNamePhonePad];
    
//    [searchBar setScopeButtonTitles: [NSArray arrayWithObjects: @"ICD9 Codes", @"ICD10 Codes", @"All Codes", nil]];
//    [searchBar setShowsScopeBar: YES];
            
    for (UIView *subview in [searchBar subviews]) {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subview setDelegate:self];
        }
    }
    
    [[self navigationItem] setTitleView: searchBar];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //self.activityIndicator.frame = CGRectMake(self.view.center.x, self.view.center.y, 180, 180);
    self.activityIndicator.hidesWhenStopped = YES;
    
    
    [self.navigationController.view addSubview:self.activityIndicator];
    [self.navigationController.view bringSubviewToFront:self.activityIndicator];
    self.activityIndicator.center = self.view.center;    
}

- (IBAction) searchBarAction:(id)sender
{
    
    
    arrayItems = nil;
    [[self tableView] reloadData];
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    
    [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:nil waitUntilDone:FALSE];
}

-(void) startActivityIndicator
{
    [self.navigationController.view bringSubviewToFront:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

-(void) finishSearch
{
    [self.activityIndicator stopAnimating];
    [[self tableView] reloadData];
}

-(void) performSearch: (NSString *) text{
    if (text.length == 0) {
        
        isFiltered = NO;
        arrayItems = nil;
        
    } else {
        
        isFiltered = YES;
        arrayItems = [[NSMutableArray alloc] init];
        
        WebService *ws = [[WebService alloc] init];
        arrayItems = [ws searchItems:text columnMax:0 andCodeType:0];
        if (arrayItems == nil)
            isFiltered = NO;
        
    }
    [self performSelectorOnMainThread:@selector(finishSearch) withObject:nil waitUntilDone:true];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSelectorOnMainThread:@selector(startActivityIndicator) withObject:nil waitUntilDone:true];
    
    
    [self performSelectorInBackground:@selector(performSearch:) withObject:[textField text] ];
    
    [textField resignFirstResponder];

    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end