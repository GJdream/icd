//
//  ItemICDDetailViewController.m
//  HealthApp
//
//  Created by Pablo Epíscopo on 14/06/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import "ItemICD10DetailViewController.h"
#import "ItemICD10.h"
#import "Utils.h"

@interface ItemICD10DetailViewController ()

@end

@implementation ItemICD10DetailViewController

@synthesize itemICD10;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [[self navigationItem] setTitle:@""];
    
   
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void) setFavourite{
    
 
    NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
    
    //here add elements to data file and write data to file
    NSDictionary *newDictionary = [[[NSDictionary alloc] init] autorelease];
    newDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"ICD10",actualCode, nil];
    
    NSString *error = nil;
    // create NSData from dictionary
    
    
    [[favPlist valueForKey:@"Favorites"] addObject:newDictionary];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:favPlist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:[Utils favoritesPlistPath] atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        [error release];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoriteAdded" object:self];
    self.navigationItem.rightBarButtonItem = nil;
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if ([indexPath section] == 0) {
        
        if (itemICD10.codeICD10 == nil) 
            [[cell textLabel] setText:@"Code Not Available"];
        else
            [[cell textLabel] setText:[itemICD10 codeICD10]];
        
    }
    
    if ([indexPath section] == 1) {
        
        if (itemICD10.equivalentICD9 == nil)
            [[cell textLabel] setText:@"Equivalent Code Not Found"];
        else
        {
            NSDictionary *icd9Dic = itemICD10.equivalentICD9;
            actualCode = itemICD10.codeICD10;
            [self performSelectorInBackground:@selector(isFavorite) withObject:nil];
            
            NSString *content = [NSString stringWithFormat:@"%@%@%@", [icd9Dic objectForKey:@"Code"], @" - ", [icd9Dic objectForKey:@"ShortDescription"]];
            
            CGSize stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                    constrainedToSize:CGSizeMake(300.0f, 9999.0f)
                                        lineBreakMode:UILineBreakModeWordWrap];
            
            UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5.0f, 4.0f, 290.0f, stringSize.height + 10.0f)];
            [textV setFont: [UIFont systemFontOfSize:14.0f]] ;
            [textV setText: content];
            [textV setTextColor: [UIColor blackColor]];
            [textV setEditable: NO];
            [textV setScrollEnabled:NO];
            [textV setBackgroundColor:[UIColor clearColor]];
            [[cell contentView] addSubview:textV];
            [textV release];
        }
            
        
    }
    
    if([indexPath section] == 2) {
       
        NSString *content = [itemICD10 shortDescription];
        
        if(itemICD10.shortDescription == nil)
            content = @"No Available Information";
        
        CGSize stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                constrainedToSize:CGSizeMake(320.0f, 9999.0f)
                                    lineBreakMode:UILineBreakModeWordWrap];
        
        UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5.0f, 4.0f, 290.0f, stringSize.height + 10.0f)];
        [textV setFont: [UIFont systemFontOfSize:16.0f]] ;
        [textV setText: content];
        [textV setTextColor: [UIColor blackColor]];
        [textV setEditable: NO];
        [textV setScrollEnabled:NO];
        [textV setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:textV];
        [textV release];
    } 
    
    if([indexPath section] == 3) {
        
        NSString *content = [itemICD10 longDescription];
        
        if(itemICD10.longDescription == nil)
            content = @"No Available Information";
        
        CGSize stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                constrainedToSize:CGSizeMake(320.0f, 9999.0f)
                                    lineBreakMode:UILineBreakModeWordWrap];
        
        UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5.0f, 4.0f, 290.0f, stringSize.height + 10.0f)];
        [textV setFont: [UIFont systemFontOfSize:16.0f]] ;
        [textV setText: content];
        [textV setTextColor: [UIColor blackColor]];
        [textV setEditable: NO];
        [textV setScrollEnabled:NO];
        [textV setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:textV];
        [textV release];
    }
    
    if ([indexPath section] == 4){ //Personal Comments section
        
        
        
        
        
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   
    
    return nil;
    
}

-(void) isFavorite{
    
    if (isFavorite) return;
    
    if (![Utils isFavorite:actualCode]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add code as favorite" style:UIBarButtonSystemItemAction target:self action:@selector(setFavourite)];
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
        isFavorite = true;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSArray arrayWithObjects:@"ICD10 Code", @"ICD9 Code", @"Short Description", @"Long Description", @"Personal Comments", nil] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {  
    
    int returnValue;
    CGSize stringSize;
    if ([indexPath section] == 1) {
        returnValue =70.0f;
    }
    else
    {
        if ([indexPath section] == 2) {

            NSString *content;
            if(itemICD10.shortDescription == nil)
            {
                content = @"No Available Information";
            } else {
                content = [itemICD10 shortDescription];
            }
            
             stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                              constrainedToSize:CGSizeMake(320.0f, 9999.0f)
                                  lineBreakMode:UILineBreakModeWordWrap];
            if(stringSize.height > 20.0f)
            {
                returnValue = stringSize.height + 25.0f;
            } else {
                returnValue = 44.0f;
            }

            
        }
        else
        {
            if([indexPath section] == 3) {
            
                NSString *content;
                if(itemICD10.longDescription == nil)
                {
                    content = @"No Available Information";
                }
                else
                {
                    content = [itemICD10 longDescription];
                }

                stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                 constrainedToSize:CGSizeMake(320.0f, 9999.0f)
                                     lineBreakMode:UILineBreakModeWordWrap];
                
                if(stringSize.height > 20.0f)
                {
                    returnValue = stringSize.height + 25.0f;
                } else
                {
                    returnValue = 44.0f;
                }
            
            }
            else
            {
                returnValue = 44.0f;
            }
        }
    }

    
    return returnValue;
    
} 

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
        
}

- (void)viewDidLoad
{  
    [super viewDidLoad];
    
    NSArray *nibViews;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"FixedCell_iPhone"
                                                 owner:self
                                               options:nil];
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];

    }
    else{
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"FixedCell_iPad"
                                                 owner:self
                                               options:nil];
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];

    }
    UIView* shareView = [nibViews objectAtIndex:0];
    //ipad config
    shareView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:shareView];
    
    [shareView release];
    //ipad
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
