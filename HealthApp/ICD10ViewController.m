//
//  ICD10ViewController.m
//  HealthApp
//
//  Created by Pablo Epíscopo on 21/05/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import "ICD10ViewController.h"
#import "ItemICD10DetailViewController.h"
#import "WebService.h"
#import "ItemICD10.h"

@interface ICD10ViewController ()

@end

@implementation ICD10ViewController

@synthesize inputTextBox, resultLabel, arrayItems, buttonConvert, buttonRestart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [[self navigationItem] setTitle:@"Converter"];
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"ICD10"];
    
    UIImage *image = [UIImage imageNamed:@"tabbar-icd10.png"];
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
    
    [resultLabel setText:@"Waiting for results..."];
    [resultLabel setTextColor:[UIColor grayColor]];
    [resultLabel setHighlightedTextColor:[UIColor grayColor]];
    [resultLabel setFont:[UIFont systemFontOfSize:17]];
    
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell setAccessoryType: UITableViewCellAccessoryNone];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
}

-(IBAction)cancelOperation:(id)sender
{
    [inputTextBox resignFirstResponder];
    [inputTextBox setText:@""];
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
    [resultLabel setText:@"Waiting for results..."];
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
        [alert release];
    } else {
        
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        @try {
            [arrayItems release];
            arrayItems = nil;
            
            WebService *ws = [[WebService alloc] init];
            arrayItems = [ws getICD10ByCode: [inputTextBox text]];
            
            if ([[[arrayItems objectAtIndex:0] codeICD10] isEqualToString:@"-1"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System is updating" message:@"Please try again later..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            } else {
                
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
                
                NSLog(@"%@", [[arrayItems objectAtIndex:0] equivalentICD9]);
                
                if([[arrayItems objectAtIndex:0] equivalentICD9] == nil)
                    [resultLabel setText: @"Equivalent Code Not Found"];
                else
                {
                    NSString *labelText = [NSString stringWithFormat:@"%@%@%@", [[ [arrayItems objectAtIndex:0] equivalentICD9] objectForKey:@"Code"], @" - ", [[ [arrayItems objectAtIndex:0] equivalentICD9] objectForKey:@"ShortDescription"]];
                    
                    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        [resultLabel setText:[[ [arrayItems objectAtIndex:0] equivalentICD9] objectForKey:@"Code"]];
                    }
                    else
                    {
                        [resultLabel setText: labelText];
                    }
                    
                }
                    
                
                [resultLabel setFont:[UIFont boldSystemFontOfSize:17]];
                [resultLabel setTextColor:[UIColor blackColor]];
                [resultLabel setHighlightedTextColor:[UIColor whiteColor]];
                [cell addSubview:resultLabel];
            }
            
        } @catch (NSException *exception) {
            [cell setAccessoryType: UITableViewCellAccessoryNone];
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            
            [resultLabel setText:@"Nothing found!"];
            [resultLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [resultLabel setTextColor:[UIColor colorWithRed:206.0f/255.0f green:70.0f/255.0f blue:59.0f/255.0f alpha:1.0f]];
        }
    }
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
        [inputTextBox setPlaceholder: @"Please introduce ICD10 code"];
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
        
        [inputTextBox release];
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
        [resultLabel setText:@"Waiting for results..."];        
        [resultLabel setTextAlignment:UITextAlignmentLeft];
        [resultLabel setTag:0];
        [resultLabel setEnabled:YES];
        
        [cell addSubview:resultLabel];
        
        [resultLabel release];
    } 
    
    if([indexPath section] == 2)
    {
        buttonConvert = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [buttonConvert setTitle:@"Convert to ICD9" forState:UIControlStateNormal];

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
        [backgroundView release];
        [cell addSubview:buttonConvert];
        
        [buttonConvert release];
    }
    
    if([indexPath section] == 3)
    {
        buttonRestart = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [buttonRestart setTitle:@"Restart" forState:UIControlStateNormal];

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
        [backgroundView release];
        [cell addSubview:buttonRestart];
        
        [buttonRestart release];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSArray arrayWithObjects:@"ICD10",@"ICD9",@"", @"", nil] objectAtIndex:section];
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
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        if ([[resultLabel text] isEqualToString:@"Waiting for results..." ] || [[resultLabel text] isEqualToString:@"Nothing found!"]) {
        } else {
            [self hideButtons];
            [inputTextBox resignFirstResponder];
            
            if(!itemDetailViewController)
            {
                itemDetailViewController = [[ItemICD10DetailViewController alloc] init];
            }
            
            [itemDetailViewController setItemICD10: [arrayItems objectAtIndex:0]];
            [[self navigationController] pushViewController:itemDetailViewController animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [cancelButton release];
    [doneButton release];
    [inputTextBox release];
    [resultLabel release];
    
    cancelButton = nil;
    doneButton = nil;
    inputTextBox = nil;
    resultLabel = nil;
}

- (void)dealloc
{
    [cancelButton release];
    [doneButton release];
    [inputTextBox release];
    [resultLabel release];    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
