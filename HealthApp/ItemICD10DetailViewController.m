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
#import "WebService.h"
#import <QuartzCore/QuartzCore.h>


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
                reportCodeBtn.frame = CGRectMake(cell.frame.size.width*2 - 42, cell.frame.size.height/2 - 10 , 120, cell.frame.size.height/2);
                reportCodeBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
            }
            [reportCodeBtn setTitle:@"Report bad code" forState:UIControlStateNormal];
            [reportCodeBtn addTarget:self action:@selector(reportCode) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:reportCodeBtn];
            //[reportCodeBtn release];
            [[cell textLabel] setText:[itemICD10 codeICD10]];
        }
            
        
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
        
        // load the comments
        NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils commentsICD10PlistPath]];
        NSString *actualComments = [favPlist valueForKey:itemICD10.codeICD10];
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
            [ws reportCode:itemICD10.codeICD10 type:10 comment:[alertView textFieldAtIndex:0].text];
            [ws release];
            [[alertView textFieldAtIndex:0] resignFirstResponder];
            
        }
    }
    else{
        
        NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils commentsICD10PlistPath]];
        
        //here add elements to data file and write data to file
        NSString *newComment = [alertView textFieldAtIndex:0].text;
        NSString *error = nil;
        // create NSData from dictionary
        
        NSString *actualComments = [favPlist valueForKey:itemICD10.codeICD10];
        if (!actualComments){
            NSDictionary *newDictionary = [[[NSDictionary alloc] init] autorelease];
            newDictionary = [NSDictionary dictionaryWithObjectsAndKeys: newComment, itemICD10.codeICD10, nil];
            [favPlist setObject:newComment forKey:itemICD10.codeICD10];
        }
        else{
            newComment = [NSString stringWithFormat:@"%@ - %@", actualComments, newComment];
            [favPlist setObject:newComment forKey:itemICD10.codeICD10];
        }
        
        
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:favPlist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            [plistData writeToFile:[Utils commentsICD10PlistPath] atomically:YES];
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//   
//    
//    return nil;
//    
//}

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
        commentBtn.titleLabel.font = [UIFont systemFontOfSize: 12];
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
            commentBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
            commentBtn.frame = CGRectMake(598, 5 , 120, 25);
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
        returnValue = 70.0f;
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
            else {
                if ([indexPath section] == 4){
                    returnValue = 200.0f;
                }
                else{
                    returnValue = 44.0f;
                }
                
            }
            
        }
    }

    
    return returnValue;
    
}


-(void) postOnFacebook: (id) sender{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    NSString *messageBody = [NSString stringWithFormat:@"Sharing ICD10 Code:  %@  \n Long description: %@ \n ICD9 Equivalent code: %@ ", itemICD10.codeICD10, itemICD10.longDescription, [itemICD10.equivalentICD9 valueForKey:@"Code"]];
        // Next try to post using Facebook's iOS6 integration
    [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                             initialText:messageBody
                                                   image:[UIImage imageNamed:@"icon.png"]
                                                     url:nil
                                                 handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                                                     NSString *alertMessage;
                                                     NSString *alertTitle;
                                                     if (error) {
                                                         alertTitle = @"Error";
                                                         alertMessage = [error description];
                                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                                                             message:alertMessage
                                                                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles:nil];
                                                         [alertView show];
                                                         
                                                         [alertView release];
                                                     } else if (result == FBOSIntegratedShareDialogResultSucceeded) {
                                                         alertTitle = @"Success";
                                                         alertMessage = @"Posted succesfully";
                                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                                                             message:alertMessage
                                                                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles:nil];
                                                         [alertView show];
                                                         
                                                         [alertView release];
                                                     }
                                                     
                                                     
                                                 }];
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void) sendMail: (id) sender{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"ICD Converter mail"];
        //NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        //[mailer setToRecipients:toRecipients];
        //UIImage *myImage = [UIImage imageNamed:@"icon114x114.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        
        NSString *messageBody = [NSString stringWithFormat:@" <b> ICD 10 Code: </b> %@ <br/> <b> Short description: </b> %@ <br/> <b> Long description: </b> %@ <br/>  <b> ICD9 Equivalent code:</b> %@ <br/>", itemICD10.codeICD10, itemICD10.shortDescription, itemICD10.longDescription, [itemICD10.equivalentICD9 valueForKey:@"Code"]];
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
    NSLog(@"Error: %@", [error description]);
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Email sent!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
             break;
        
        }
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
    [self isFavorite];
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
        
        // 113, status bar + tabBar + navBar
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 113) style:UITableViewStyleGrouped];

    }
    else{
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"FixedCell_iPad"
                                                 owner:self
                                               options:nil];
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 113) style:UITableViewStyleGrouped];

    }
    
   
    
    UIView* shareView = [nibViews objectAtIndex:0];
    //ipad config
    shareView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:shareView];
    
    UIButton *mailBtn = [[shareView subviews] objectAtIndex:0];
    UIButton *fbButton = [[shareView subviews] objectAtIndex:1];
    
    mailBtn.layer.cornerRadius = 5;
    mailBtn.layer.borderWidth = 1;
    mailBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    fbButton.layer.cornerRadius = 5;
    fbButton.layer.borderWidth = 1;
    fbButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    [mailBtn addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
    [fbButton addTarget:self action:@selector(postOnFacebook:) forControlEvents:UIControlEventTouchUpInside];

    
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
