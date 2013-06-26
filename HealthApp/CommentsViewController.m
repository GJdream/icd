//
//  CommentsViewController.m
//  Converter
//
//  Created by TopTierlabs on 5/8/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import "CommentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebService.h"

@implementation CommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [[self navigationItem] setTitle:@"Feedback"];
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Feedback"];
    
    UIImage *image = [UIImage imageNamed:@"comments.png"];
    [tbi setImage:image];
    
    return self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }
    else if (section == 1){
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0){
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            return 100.0f;
        }else{
            return 200.0f;
        }
        
    }
    else if ([indexPath section] == 1){
        return 50.0f;
    }
    return 10.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor grayColor]];
    

    
    if (indexPath.section == 0){ //Comment
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            comment = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 300, 100)];
        }
        else{
            
            comment = [[UITextView alloc] initWithFrame:CGRectMake(45, 0, 680, 200)];
        }
            
        comment.layer.cornerRadius = 5;
        comment.layer.borderWidth = 2.0f;
        comment.layer.borderColor = [[UIColor grayColor] CGColor];
        comment.text = @"Please put your comment here...";
        comment.textColor = [UIColor grayColor];
        comment.delegate = self;
        [cell addSubview:comment];

    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            customNumberOfStars = [[[DLStarRatingControl alloc] initWithFrame:CGRectMake(35, 7, 250, 60) andStars:5 isFractional:NO] retain];
        }
        else{
            customNumberOfStars = [[[DLStarRatingControl alloc] initWithFrame:CGRectMake(240, -5, 300, 80) andStars:5 isFractional:NO] retain];
        }
        
        customNumberOfStars.delegate = self;
        customNumberOfStars.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //	customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        customNumberOfStars.rating = 3;
        [cell addSubview:customNumberOfStars];
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, 200, 30)];
            ratingLabel.font = [UIFont systemFontOfSize: 20];
            ratingLabel.backgroundColor = [UIColor clearColor];
            ratingLabel.textColor = [UIColor whiteColor];
        }
        else{
            ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 5, 220, 30)];
            ratingLabel.font = [UIFont systemFontOfSize: 25];
            ratingLabel.backgroundColor = [UIColor clearColor];
            ratingLabel.textColor = [UIColor whiteColor];
        }
        ratingLabel.text = @"3 star rating";
        starNum=3;
        [cell addSubview:ratingLabel];
    }
     
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSArray arrayWithObjects:@"Leave your comment",  @"Rate our app!", nil] objectAtIndex:section];
}


-(void)dismissKeyboard {
    [comment resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom Number of Stars
    // Custom Number of Stars
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
	    UIBarButtonItem *submit = [[UIBarButtonItem alloc]
                initWithTitle:@"Submit comment" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(submit)];
    
    [[self navigationItem] setRightBarButtonItem:submit animated:YES];
    
	[self.view addSubview:customNumberOfStars];

    

    // Do any additional setup after loading the view from its nib.
}

- (void) submit{
    
    if (!([comment.text isEqualToString:@""] || [comment.text isEqualToString:@"Please put your comment here..."])){
        WebService *ws = [[WebService alloc] init];
        [ws ratingApp:comment.text rating:starNum];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comment sent!" message:@"Thank you for rating our app!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The comment is missing!" message:@"Please introduce a comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        comment.layer.cornerRadius = 5;
        comment.layer.borderWidth = 2.0f;
        comment.layer.borderColor = [[UIColor grayColor] CGColor];
        comment.text = @"Please put your comment here...";
        comment.textColor = [UIColor grayColor];
    }
   
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)newRating:(DLStarRatingControl *)control :(float)rating {
    starNum=rating;
	ratingLabel.text = [NSString stringWithFormat:@"%0.f star rating",rating];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    comment.textColor = [UIColor blackColor];
    if([comment.text isEqualToString:@"Please put your comment here..."]){
        comment.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([comment.text isEqualToString:@""]){
        comment.layer.cornerRadius = 5;
        comment.layer.borderWidth = 2.0f;
        comment.layer.borderColor = [[UIColor grayColor] CGColor];
        comment.text = @"Please put your comment here...";
        comment.textColor = [UIColor grayColor];
    }
}



@end
