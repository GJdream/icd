//
//  NewsViewController.m
//  Converter
//
//  Created by TopTierlabs on 4/30/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import "NewsViewController.h"
#import "WebService.h"

#define ITEMS_IN_SECTION 2

@interface NewsViewController()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [[self navigationItem] setTitle:@"News"];
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"News"];
    
    UIImage *image = [UIImage imageNamed:@"news-icon.png"];
    [tbi setImage:image];
    
    
        
    return self;
}

- (void) loadNews{
    WebService *ws = [[WebService alloc] init];
    news = [[ws getNews] retain];
    [ws release];
    newsTable.delegate = self;
    newsTable.dataSource = self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return news.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"]
                autorelease];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setBackgroundColor:[UIColor grayColor]];
    NSString *completeString = [news objectAtIndex: indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\r%@", [completeString substringToIndex:7], [completeString substringFromIndex:7]];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.frame = cell.frame;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
