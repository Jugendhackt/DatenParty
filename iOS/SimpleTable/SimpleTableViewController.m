//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1
#import "SimpleTableViewController.h"
#import "SimpleTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface SimpleTableViewController ()

@end
UIRefreshControl * refreshControl;
@implementation SimpleTableViewController
{
    NSArray *NameData;
    NSArray *thumbnails;
    NSArray *TimeData;
    NSArray *AccountNameData;
    NSArray *TextData;
    NSArray *LinkData;
    NSArray *TrustData;
    NSArray *TweetidData;
}
NSTimer *updateTimer;
bool makeEmpty=NO;
@synthesize tableView, headerView, reloadButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //updateTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadAction) userInfo:nil repeats:YES];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];    

    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NameData = [dict objectForKey:@"Name"];
    thumbnails = [dict objectForKey:@"AccountIcon"];
    TimeData = [dict objectForKey:@"Time"];
    LinkData = [dict objectForKey:@"Link"];
    TrustData = [dict objectForKey:@"Trust"];
    TextData = [dict objectForKey:@"Text"];
    TweetidData = [dict objectForKey:@"Tweetid"];
    AccountNameData = [dict objectForKey:@"Account"];
    headerView.layer.shadowOffset = CGSizeMake(0, 2);
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowRadius = 8.0f;
    headerView.layer.shadowOpacity = 0.7f;
    headerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:headerView.layer.bounds] CGPath];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)refreshTable {
    makeEmpty = YES;
    [self.tableView reloadData];
    makeEmpty = NO;
    [refreshControl endRefreshing];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(makeEmpty){
        return 4;
    }else{
        return [NameData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";

    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"tweet" ofType:@"json"];
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
    for (int i=0; i<[allKeys count]; i++) {
        NSDictionary *arrayResult = [allKeys objectAtIndex:i];
        TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"date"]];
        thumbnails = [thumbnails arrayByAddingObject:[arrayResult objectForKey:@"profilimage"]];
        NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"profilname"]];
        LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"link"]];
        TrustData = [TrustData arrayByAddingObject:[arrayResult objectForKey:@"trust"]];
        TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"tweet"]];
        TweetidData = [TweetidData arrayByAddingObject:[arrayResult objectForKey:@"tweetid"]];
    }
    cell.cellView.layer.cornerRadius = 5;
    cell.cellView.layer.shadowOffset = CGSizeMake(0, 2);
    cell.cellView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.cellView.layer.shadowRadius = 5.0f;
    cell.cellView.layer.shadowOpacity = 0.7f;
    cell.cellView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.cellView.layer.bounds] CGPath];
    cell.NameLabel.text = [NameData objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [thumbnails objectAtIndex:indexPath.row]]]]];
    cell.thumbnailImageView.layer.cornerRadius = 5;
    cell.thumbnailImageView.layer.masksToBounds = YES;
    cell.TimeLabel.text = [TimeData objectAtIndex:indexPath.row];
    cell.TextLabel.text = [TextData objectAtIndex:indexPath.row];
    
    UIButton *linkButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    linkButton.tag=indexPath.row;
    [linkButton addTarget:self
                 action:@selector(linkDown:) forControlEvents:UIControlEventTouchDown];
    linkButton.frame = CGRectMake(17, 16, 287, 140);
    [cell.contentView addSubview:linkButton];
    
    UIButton *upButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    upButton.tag=indexPath.row;
    [upButton addTarget:self
                   action:@selector(trustButtonDown:) forControlEvents:UIControlEventTouchDown];
    [upButton setTitle:@"Vertrauen" forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1] forState:UIControlStateNormal];
    upButton.frame = CGRectMake(30, 110, 126, 33);
    [cell.contentView addSubview:upButton];
    /*upButton.layer.cornerRadius = 5;
    upButton.layer.borderWidth = 2.0f;
    upButton.layer.borderColor = [UIColor grayColor].CGColor;*/
    
    UIButton *downButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    downButton.tag=indexPath.row;
    [downButton addTarget:self
               action:@selector(untrustButtonDown:) forControlEvents:UIControlEventTouchDown];
    [downButton setTitle:@"Nicht vertrauen" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    downButton.frame = CGRectMake(170, 110, 126, 33);
    [cell.contentView addSubview:downButton];
    /*downButton.layer.cornerRadius = 5;
    downButton.layer.borderWidth = 2.0f;
    downButton.layer.borderColor = [UIColor grayColor].CGColor;*/

    cell.layer.cornerRadius = 10;
    cell.trustBar.layer.cornerRadius = 2;
    if(indexPath.row!=0){
    float trust = [[TrustData objectAtIndex:indexPath.row] floatValue];
        NSLog(@"%d %f", indexPath.row, trust);
        if(trust<=0.5){
            cell.trustBar.backgroundColor = [UIColor colorWithRed:1 green:2*trust blue:0 alpha:1];
        }else{
            cell.trustBar.backgroundColor = [UIColor colorWithRed:2*(1-trust) green:1 blue:0 alpha:1];
        }
    }
    return cell;
    [self.tableView reloadData];
}

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction
{
    CABasicAnimation* rotationAnimation;
    
    // Rotate about the z axis
    rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * direction];
    
    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;
    
    // Set the pacing of the animation
    rotationAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)linkDown:(UIButton*)sender
{
    NSLog(@"Link %d",sender.tag);
    NSLog(@"%@", [LinkData objectAtIndex:sender.tag]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[LinkData objectAtIndex:sender.tag]]];
}

-(void)trustButtonDown:(UIButton*)sender
{
    NSLog(@"URL %@",[NSString stringWithFormat:@"http://maschini.de/datenparty/up/%@", [TweetidData objectAtIndex:sender.tag]]);
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"/datenparty/up/%@", [TweetidData objectAtIndex:sender.tag]]];
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
}

-(void)untrustButtonDown:(UIButton*)sender
{
    NSLog(@"URL %@",[NSString stringWithFormat:@"http://maschini.de/datenparty/down/%@", [TweetidData objectAtIndex:sender.tag]]);
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"/datenparty/down/%@", [TweetidData objectAtIndex:sender.tag]]];
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
}

- (IBAction)reload:(id)sender {
    [self spinLayer:reloadButton.layer duration:1 direction:SPIN_CLOCK_WISE];
    [self reloadAction];
}

-(void)reloadAction{
    [self.tableView setContentOffset:CGPointZero animated:YES];
    makeEmpty = YES;
    [self.tableView reloadData];
    makeEmpty = NO;
}
@end

