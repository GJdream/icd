//
//  ItemICDDetailViewController.m
//  HealthApp
//
//  Created by Pablo Epíscopo on 14/06/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import "ItemICD9DetailViewController.h"
#import "ItemICD9.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "WebService.h"

@interface ItemICD9DetailViewController ()

@end

@implementation ItemICD9DetailViewController

@synthesize itemICD9;

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
     newDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"ICD9",actualCode, nil];
    
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
    if(section == 3)
        if ([[itemICD9 arrayICD10] count] > 0)
            return [[itemICD9 arrayICD10] count];
        else
            return 1;

    else
        return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if ([indexPath section] == 0) {
        
        if (itemICD9.codeICD9 == nil) 
            [[cell textLabel] setText:@"Code Not Available"];
        else{
            UIButton * reportCodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            reportCodeBtn.layer.cornerRadius = 5;
            reportCodeBtn.layer.borderWidth = 1;
            reportCodeBtn.layer.borderColor = [UIColor grayColor].CGColor;
            reportCodeBtn.clipsToBounds = YES;
            [reportCodeBtn setBackgroundImage:[UIImage imageNamed:@"gradient12"] forState:UIControlStateNormal];
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                reportCodeBtn.frame = CGRectMake(cell.frame.size.width - 115, cell.frame.size.height/2 - 10 , 100, cell.frame.size.height/2);
                reportCodeBtn.titleLabel.font = [UIFont systemFontOfSize: 12];
            }
            else{
                reportCodeBtn.frame = CGRectMake(cell.frame.size.width - 20, cell.frame.size.height/2 - 10 , 100, cell.frame.size.height/2);
                reportCodeBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
            }
                
                        [reportCodeBtn setTitle:@"Report bad code" forState:UIControlStateNormal];
            [reportCodeBtn addTarget:self action:@selector(reportCode) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:reportCodeBtn];
            //[reportCodeBtn release];
            [[cell textLabel] setText:[itemICD9 codeICD9]];
        }   
            
        
    }
    
    if([indexPath section] == 1) {
        
        NSString *content = [itemICD9 shortDescription];
        
        if(itemICD9.shortDescription == nil)
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
    
    if([indexPath section] == 2) {
        
        NSString *content = [itemICD9 longDescription];
        
        if(itemICD9.longDescription == nil)
            content = @"No Available Information";
        
        CGSize stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                constrainedToSize:CGSizeMake(320.0f, 9999.0f)
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
    
    if ([indexPath section] == 3) {
        
        if ([[itemICD9 arrayICD10] count] <= 0)
            [[cell textLabel] setText:@"Equivalent Code Not Found"];
        else
        {
            actualCode = itemICD9.codeICD9;
            [self performSelectorInBackground:@selector(isFavorite) withObject:nil];
            NSString *content = [NSString stringWithFormat:@"%@%@%@", [ [[itemICD9 arrayICD10] objectAtIndex:indexPath.row] objectForKey:@"Code"],
                                 @" - ", [ [[itemICD9 arrayICD10] objectAtIndex:indexPath.row] objectForKey:@"ShortDescription"]];
            
            
            CGSize stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                    constrainedToSize:CGSizeMake(320.0f, 9999.0f)
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
            
            //NSString *code = ;
            //[[cell textLabel] setText:code];
        }
            
        
    }
    if ([indexPath section] == 4){ //Personal Comments section
        
        // load the comments
        NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils commentsICD9PlistPath]];
        NSString *actualComments = [favPlist valueForKey:itemICD9.codeICD9];
        cell.textLabel.text = actualComments;
        
    }
    
    return cell;
}

- (void) reportCode{
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Report" message:@"Please enter your comment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView.title isEqualToString:@"Report"]){
        
        if (buttonIndex == 1){
            
            WebService *ws = [[WebService alloc] init];
            [ws reportCode:itemICD9.codeICD9 type:9 comment:[alertView textFieldAtIndex:0].text];
            [ws release];
            [[alertView textFieldAtIndex:0] resignFirstResponder];
            
        }
        
    }
    else{
        
        NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils commentsICD9PlistPath]];
        
        //here add elements to data file and write data to file
        NSString *newComment = [alertView textFieldAtIndex:0].text;
        NSString *error = nil;
        // create NSData from dictionary

        NSString *actualComments = [favPlist valueForKey:itemICD9.codeICD9];
        if (!actualComments){
            NSDictionary *newDictionary = [[[NSDictionary alloc] init] autorelease];
            newDictionary = [NSDictionary dictionaryWithObjectsAndKeys: newComment, itemICD9.codeICD9, nil];
            [favPlist setObject:newComment forKey:itemICD9.codeICD9];
        }
        else{
            newComment = [NSString stringWithFormat:@"%@ - %@", actualComments, newComment];
            [favPlist setObject:newComment forKey:itemICD9.codeICD9];
        }
        
        
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:favPlist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            [plistData writeToFile:[Utils commentsICD9PlistPath] atomically:YES];
            [tableView reloadSections:[[NSIndexSet alloc]initWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            [error release];
        }
        
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        return [[NSArray arrayWithObjects:@"ICD9 Code" ,@"Short Description", @"Long Description", @"ICD10 Codes", @"Personal Comments", nil] objectAtIndex:section];

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        CGRect labelFrame = CGRectMake(20, 2, 320, 30);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.shadowColor = [UIColor colorWithWhite:1.0 alpha:1];
        label.shadowOffset = CGSizeMake(0, 1);
        label.textColor = [UIColor colorWithRed:0.265 green:0.294 blue:0.367 alpha:1.000];
        label.text = [self tableView:tableView titleForHeaderInSection:section];
        [containerView addSubview:label];
        UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        commentBtn.layer.cornerRadius = 5;
        commentBtn.layer.borderWidth = 1;
        commentBtn.layer.borderColor = [UIColor grayColor].CGColor;
        commentBtn.clipsToBounds = YES;
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"gradient12"] forState:UIControlStateNormal];
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            commentBtn.titleLabel.font = [UIFont systemFontOfSize: 12];
            commentBtn.frame = CGRectMake(205, 5 , 100, 25);
        }
        else{
            commentBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
            commentBtn.frame = CGRectMake(620, 5 , 100, 25);
        }
        [commentBtn setTitle:@"Comment code" forState:UIControlStateNormal];
        
        [commentBtn addTarget: self action: @selector(addCommentToCode)
        forControlEvents: UIControlEventTouchUpInside];
        [containerView addSubview:commentBtn];
        
        return containerView;
    }
    else{
        return nil;
    }
}

-(void) addCommentToCode
{

    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Code Comment" message:@"Please enter your comment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {  
    
    int returnValue;
    CGSize stringSize;
    
    if ([indexPath section] == 1) {

        NSString *content;
        if(itemICD9.shortDescription == nil)
        {
            content = @"No available information";
        } else {
            content = [itemICD9 shortDescription];
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

    } else if([indexPath section] == 2) {
        
        NSString *content;
        if(itemICD9.longDescription == nil)
        {
            content = @"No available information";
        } else {
            content = [itemICD9 longDescription];
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
        
    } else if([indexPath section] == 3) {
        
        returnValue = 70.0f;
        
    } else {
        returnValue = 44.0f;
    }
    
    return returnValue;
    
}

-(void) postOnFacebook:(id)sender{
    
}

-(void) sendMail:(id)sender{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"ICD Converter mail"];
        //NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        //[mailer setToRecipients:toRecipients];
        //UIImage *myImage = [UIImage imageNamed:@"icon114x114.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        NSArray* icd10Codes = [[[itemICD9.arrayICD10 objectAtIndex:0] description] componentsSeparatedByString:@";"];
        
        NSString* codes = [[icd10Codes objectAtIndex:0] substringWithRange:NSMakeRange(2, [[icd10Codes objectAtIndex:0] length])];
        
        NSString *messageBody = [NSString stringWithFormat:@" <b> ICD 9 Code: </b> %@ <br/> <b> Short description: </b> %@ <br/> <b> Long description : </b> %@ <br/>  <b> ICD10 Asociated code/s:</b> %@ <br/>", itemICD9.codeICD9, itemICD9.shortDescription, itemICD9.longDescription, codes];
        [mailer setMessageBody:messageBody isHTML:YES];
        //[mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
    
}



- (void)viewDidLoad
{  
    [super viewDidLoad];
    
    NSArray* nibViews;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"FixedCell_iPhone"
                                                          owner:self
                                                        options:nil];
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-113) style:UITableViewStyleGrouped];
    }
    else{
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"FixedCell_iPad"
                                                          owner:self
                                                        options:nil];
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-113) style:UITableViewStyleGrouped];
    }
    
    
    
    
    UIView* shareView = [nibViews objectAtIndex:0];
    //ipad config
    shareView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:shareView];
    
    
    UIButton *mailButton = [[shareView subviews] objectAtIndex:0];
    UIButton *fbButton = [[shareView subviews] objectAtIndex:1];
    
//    mailButton = (UIButton*) [self.view viewWithTag:@"998"];
//    fbButton = (UIButton*)[self.view viewWithTag:@"999"];
    [mailButton addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
    [fbButton addTarget:self action:@selector(postOnFacebook:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [shareView release];
    // Do any additional setup after loading the view from its nib.
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
