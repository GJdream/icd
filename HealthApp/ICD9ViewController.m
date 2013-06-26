//
//  ICD9ViewController.m
//  HealthApp
//
//  Created by Pablo Epíscopo on 21/05/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import "ICD9ViewController.h"
#import "ItemICD9DetailViewController.h"
#import "WebService.h"
#import "ItemICD9.h"

@interface ICD9ViewController ()

@end

@implementation ICD9ViewController

@synthesize inputTextBox, resultLabel, arrayItems, buttonConvert, buttonRestart, tableResults, arrayICD10;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [[self navigationItem] setTitle:@"Converter"];
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"ICD9"];
    
    UIImage *image = [UIImage imageNamed:@"tabbar-icd9.png"];
    [tbi setImage:image];
    
    return self;
}

- (IBAction)doneOperation:(id)sender
{
    [inputTextBox resignFirstResponder];
    [self hideButtons]; 
    [self donePress];
}

- (void) donePress
{
    [self hideButtons];
    [inputTextBox resignFirstResponder];
    if (![inputTextBox.text isEqualToString:@""]) {
        [inputTextBox setPlaceholder: @""];
        [resultLabel setText:@"Convert and see results here"];
        [resultLabel setTextColor:[UIColor grayColor]];
        [resultLabel setHighlightedTextColor:[UIColor grayColor]];
        [resultLabel setFont:[UIFont systemFontOfSize:17]];
        
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell setAccessoryType: UITableViewCellAccessoryNone];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    }else{
        [inputTextBox setPlaceholder: @"Please introduce ICD9 code"];
        [resultLabel setText:@" "];
    }
}

-(IBAction)cancelOperation:(id)sender
{
    [inputTextBox resignFirstResponder];
    if((![inputTextBox.placeholder isEqualToString:@""])){
        [inputTextBox setPlaceholder: @"Please introduce ICD9 code"];
        [inputTextBox setText:@""];
        [resultLabel setText:@" "];
    }
    if([inputTextBox.text isEqualToString:@""]){
        [inputTextBox setPlaceholder: @"Please introduce ICD9 code"];
    }
    [self hideButtons];
}

- (void) hideButtons
{
    [[self navigationItem] setRightBarButtonItem:nil animated:YES];
    [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
}

- (IBAction)barButtonsState:(id)sender
{   
    [[self navigationItem] setRightBarButtonItem:doneButton animated:YES];
    [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES];
}

-(IBAction)restartOperation:(id)sender
{   
    [self hideButtons];
    [inputTextBox resignFirstResponder];
    
    [inputTextBox setText:@""];
    [resultLabel setText:@" "];
    [inputTextBox setPlaceholder: @"Please introduce ICD9 code"];
    [resultLabel setTextColor:[UIColor grayColor]];
    [resultLabel setHighlightedTextColor:[UIColor grayColor]];
    [resultLabel setFont:[UIFont systemFontOfSize:17]];
    
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell setAccessoryType: UITableViewCellAccessoryNone];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
}

-(IBAction)convertOperation:(id)sender 
{    
    [self hideButtons];
    [inputTextBox resignFirstResponder];
        
    if ([[inputTextBox text] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something is missing!" message:@"Please introduce a code first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
     
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        @try {
            arrayItems = nil;
            
            WebService *ws = [[WebService alloc] init];
            arrayItems = [ws getICD9ByCode: [inputTextBox text]];
            
            if ([[[arrayItems objectAtIndex:0] codeICD9] isEqualToString:@"-1"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System is updating" message:@"Please try again later..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            } else {
                    [cell setAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
                    [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
               
                
                if([[arrayItems objectAtIndex:0] arrayICD10] == nil)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"It seems you've entered a wrong ICD9 code. Nothing found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    if([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone){
                        self.arrayICD10 = [[arrayItems objectAtIndex:0] arrayICD10];
                        [self.tableResults reloadData];
                    }
                    
                }
                
//                if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//                {
                    [resultLabel setText:[NSString stringWithFormat:@"%i Codes Found", [[[arrayItems objectAtIndex:0] arrayICD10] count]]];
                    [resultLabel setFont:[UIFont boldSystemFontOfSize:17]];
                    [resultLabel setTextColor:[UIColor blackColor]];
                    [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
                    [cell addSubview:resultLabel];
               // }
                
            }
        
        } @catch (NSException *exception) {
                //[cell setAccessoryType: UITableViewCellAccessoryNone];
                //[cell setSelectionStyle: UITableViewCellSelectionStyleNone];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"It seems you've entered a wrong ICD9 code. Nothing found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                //[resultLabel setText:@"Nothing found!"];
                //[resultLabel setFont:[UIFont boldSystemFontOfSize:17]];
                //[resultLabel setTextColor:[UIColor colorWithRed:206.0f/255.0f green:70.0f/255.0f blue:59.0f/255.0f alpha:1.0f]];
        }
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableResults)
        return indexPath;
    else
        return indexPath;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != self.tableResults)
        return 1;
    else
        return self.arrayICD10.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (tableView != self.tableResults)
    {
        if ([indexPath section] == 0) {
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                inputTextBox = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 11.0f, 270.0f, 30.0f)];
            } else {
                inputTextBox = [[UITextField alloc] initWithFrame:CGRectMake(57.0f, 11.0f, 640.0f, 30.0f)];
            }
            
            [inputTextBox setDelegate: self];
            [inputTextBox setAdjustsFontSizeToFitWidth: YES];
            [inputTextBox setTextColor: [UIColor blackColor]];
            [inputTextBox setBackgroundColor: [UIColor clearColor]];
            [inputTextBox setPlaceholder: @"Please introduce ICD9 code"];
            [inputTextBox setText: @""];
            [inputTextBox setKeyboardType: UIKeyboardTypeNamePhonePad];
            [inputTextBox setReturnKeyType: UIReturnKeyDone];
            [inputTextBox setAutocorrectionType: UITextAutocorrectionTypeNo];
            [inputTextBox setAutocapitalizationType: UITextAutocapitalizationTypeNone];
            [inputTextBox setTextAlignment: UITextAlignmentLeft];
            [inputTextBox setTag: 0];
            [inputTextBox setClearButtonMode: UITextFieldViewModeNever];
            [inputTextBox setEnabled: YES];
            [inputTextBox addTarget:self action:@selector(barButtonsState:) forControlEvents:UIControlEventEditingDidBegin];
            
            [cell addSubview:inputTextBox];
            
        }
        
        if([indexPath section] == 1) {
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 7.0f, 270.0f, 30.0f)];
            } else {
                resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 7.0f, 270.0f, 30.0f)];
            }
            
            [resultLabel setAdjustsFontSizeToFitWidth:YES];
            [resultLabel setTextColor:[UIColor grayColor]];
            [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
            [resultLabel setBackgroundColor:[UIColor clearColor]];
            [resultLabel setText:@" "];
            [resultLabel setTextAlignment:UITextAlignmentLeft];
            [resultLabel setTag:0];
            [resultLabel setEnabled:YES];
            
            [cell addSubview:resultLabel];
            
        }
        
        if([indexPath section] == 2)
        {
            buttonConvert = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
            [buttonConvert setTitle:@"Convert to ICD10" forState:UIControlStateNormal];
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [buttonConvert setFrame: CGRectMake(cell.frame.size.width/4, 22.0f, cell.frame.size.width/2, 40.0f)];
            } else {
                [buttonConvert setFrame: CGRectMake(300.0f, 22.0f, cell.frame.size.width/2, 40.0f)];
            }
            
            [buttonConvert setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [buttonConvert addTarget:self action:@selector(convertOperation:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
            [backgroundView setBackgroundColor: [UIColor clearColor]];
            
            [cell setBackgroundView: backgroundView];
            [cell addSubview:buttonConvert];
            
        }
        
        if([indexPath section] == 3)
        {
            buttonRestart = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
            [buttonRestart setTitle:@"Reset" forState:UIControlStateNormal];
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [buttonRestart setFrame: CGRectMake(cell.frame.size.width/4, 3.0f, cell.frame.size.width/2, 40.0f)];
            } else {
                [buttonRestart setFrame: CGRectMake(300.0f, 3.0f, cell.frame.size.width/2, 40.0f)];
            }
            
            [buttonRestart setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [buttonRestart addTarget:self action:@selector(restartOperation:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
            [backgroundView setBackgroundColor: [UIColor clearColor]];
            
            [cell setBackgroundView:backgroundView];
            [cell addSubview:buttonRestart];
            
        }

    }
    else
    {
        NSDictionary *icd10info = [arrayICD10 objectAtIndex:indexPath.row];
        UILabel *code = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 20)];
        [code setTextColor:[UIColor blackColor]];
        [code setBackgroundColor:[UIColor clearColor]];
        [code setFont:[UIFont boldSystemFontOfSize:17]];
        code.text = [icd10info objectForKey:@"Code"];
        [cell.contentView addSubview:code];

        UILabel *shortDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, tableResults.frame.size.width - 70, 20)];
        [shortDescription setTextColor:[UIColor blackColor]];
        [shortDescription setFont:[UIFont systemFontOfSize:15]];
        [shortDescription setBackgroundColor:[UIColor clearColor]];
        shortDescription.text = [NSString stringWithFormat:@"%@%@", @"Short description: ", [icd10info objectForKey:@"ShortDescription"]];
        [cell.contentView addSubview:shortDescription];
        
        UITextView *longDescription=[[UITextView alloc] initWithFrame:CGRectMake(10, 70, self.tableResults.contentSize.width - 110, 50)];
        [longDescription setFont: [UIFont systemFontOfSize:15.0f]] ;
        [longDescription setText: [NSString stringWithFormat:@"%@%@", @"Long description: ",[icd10info objectForKey:@"LongDescription"]]];
        [longDescription setTextColor: [UIColor blackColor]];
        [longDescription setEditable: NO];
        [longDescription setScrollEnabled:NO];
        [longDescription setBackgroundColor:[UIColor clearColor]];
        [[cell contentView] addSubview:longDescription];
        

    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView != self.tableResults)
        return 4;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView != self.tableResults)
        return [[NSArray arrayWithObjects:@"ICD9",@"ICD10",@"", @"", nil] objectAtIndex:section];
    else
        return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if ([indexPath section] == 2) {
        height = 60.0f;
    } else {
        height = 44.0f;
    }
    
    return height;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableResults)
    {
        //if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        //{
            if ([indexPath section] == 1 && [indexPath row] == 0) {
                if ([[resultLabel text] isEqualToString:@"Convert and see results here" ] || [[resultLabel text] isEqualToString:@" " ] || [[resultLabel text] isEqualToString:@"Nothing found!"]) {
                } else {
                    [self hideButtons];
                    [inputTextBox resignFirstResponder];
                    
                    if(!itemDetailViewController)
                    {
                        itemDetailViewController = [[ItemICD9DetailViewController alloc] init];
                    }
                    
                    [itemDetailViewController setItemICD9:[arrayItems objectAtIndex:0]];
                    [[self navigationController] pushViewController:itemDetailViewController animated:YES];
                }
            }
        //}
        
    }else{
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![inputTextBox.text isEqualToString:@""]) {
        [inputTextBox setPlaceholder: @""];
        [resultLabel setText:@"Convert and see results here"];
        [resultLabel setTextColor:[UIColor grayColor]];
        [resultLabel setHighlightedTextColor:[UIColor grayColor]];
        [resultLabel setFont:[UIFont systemFontOfSize:17]];
        
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell setAccessoryType: UITableViewCellAccessoryNone];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    }else{
        [inputTextBox setPlaceholder: @"Please introduce ICD9 code"];
        [resultLabel setText:@" "];
    }

    [self hideButtons];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    cancelButton=[[UIBarButtonItem alloc]
                  initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered
                  target:self action:@selector(cancelOperation:)]; 
    
    doneButton=[[UIBarButtonItem alloc]
                initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                target:self action:@selector(doneOperation:)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30.0, 0.0, self.view.frame.size.width -60.0f, 430.0f) style:UITableViewStyleGrouped];
    self.tableResults = tableView;
    

    self.tableResults.dataSource = self;
    self.tableResults.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    cancelButton = nil;
    doneButton = nil;
    self.inputTextBox = nil;
    self.resultLabel = nil;
    self.tableResults = nil;
    self.arrayICD10 = nil;
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
