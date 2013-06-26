//
//  FavoritesViewController.m
//  Converter
//
//  Created by TopTierlabs on 4/25/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ItemICD10DetailViewController.h"
#import "ItemICD9DetailViewController.h"
#import "WebService.h"
#import "Utils.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController
@synthesize favoriteTableView, favoritesDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [[self navigationItem] setTitle:@"Favorites"];
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Favorites"];
    
    UIImage *image = [UIImage imageNamed:@"starWhite-xxl.png"];
    [tbi setImage:image];
    
    
    favoritesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
    favoritesArray = [favoritesDictionary valueForKey:@"Favorites"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddFavouriteNotification) name:@"FavoriteAdded" object:nil];
    
    return self;
}

- (void) receiveAddFavouriteNotification{
       
    favoritesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
    favoritesArray = [favoritesDictionary valueForKey:@"Favorites"];
    [favoriteTableView reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return favoritesArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[NSArray arrayWithObjects:@"Favorite Codes", nil] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    NSString *content;
    
    NSDictionary *ICD = [favoritesArray objectAtIndex:indexPath.row];
    NSArray *kind = [ICD allValues];
    NSArray *code = [ICD allKeys];
    if ([[kind objectAtIndex:0] isEqualToString:@"ICD9"]){
        cell.tag = 9;
        content = [NSString stringWithFormat:@"%@ %@", @"ICD9 Code:", [code objectAtIndex:0]];
        cell.textLabel.tag = [code objectAtIndex:0];
    }
    else if ([[kind objectAtIndex:0] isEqualToString:@"ICD10"]){
        cell.tag = 10;
        content = [NSString stringWithFormat:@"%@ %@", @"ICD10 Code:", [code objectAtIndex:0]];
        cell.textLabel.tag = [code objectAtIndex:0];
    }
    
        
    cell.textLabel.text = content;
//    CGSize stringSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
//                            constrainedToSize:CGSizeMake(320.0f, 9999.0f)
//                                lineBreakMode:UILineBreakModeWordWrap];
//    
//    UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5.0f, 4.0f, 290.0f, stringSize.height + 10.0f)];
//    [textV setFont: [UIFont systemFontOfSize:14.0f]] ;
//    [textV setText: content];
//    [textV setTextColor: [UIColor blackColor]];
//    [textV setEditable: NO];
//    [textV setScrollEnabled:NO];
//    [textV setBackgroundColor:[UIColor clearColor]];
//    [[cell contentView] addSubview:textV];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WebService *ws = [[WebService alloc] init];
    
    if (cell.tag == 9){
        arrayItems = [ws getICD9ByCode: cell.textLabel.tag];
        ItemICD9DetailViewController *detail = [[ItemICD9DetailViewController alloc] init];
        [detail setItemICD9: [arrayItems objectAtIndex:0]];
        [[self navigationController] pushViewController:detail animated:YES];
    }
    else if(cell.tag == 10){
        arrayItems = [ws getICD10ByCode: cell.textLabel.tag];
        ItemICD10DetailViewController *detail = [[ItemICD10DetailViewController alloc] init];
        [detail setItemICD10: [arrayItems objectAtIndex:0]];
        [[self navigationController] pushViewController:detail animated:YES];
    }

    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [Utils removeFavorite:cell.textLabel.tag];
        favoritesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
        favoritesArray = [favoritesDictionary valueForKey:@"Favorites"];
        [tableView reloadData];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    favoritesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
    favoritesArray = [favoritesDictionary valueForKey:@"Favorites"];
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
