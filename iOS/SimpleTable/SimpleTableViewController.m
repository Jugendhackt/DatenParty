//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
//
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
}

@synthesize tableView, headerView, reloadButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];    

    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NameData = [dict objectForKey:@"Name"];
    thumbnails = [dict objectForKey:@"AccountIcon"];
    TextData = [dict objectForKey:@"Text"];
    TimeData = [dict objectForKey:@"Time"];
    LinkData = [dict objectForKey:@"Link"];
    TrustData = [dict objectForKey:@"Trust"];
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
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NameData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
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
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"generated" ofType:@"json"];
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
    for (int i=0; i<[allKeys count]; i++) {
        NSDictionary *arrayResult = [allKeys objectAtIndex:i];
        TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"TextData"]];
        TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"TimeData"]];
        thumbnails = [thumbnails arrayByAddingObject:[arrayResult objectForKey:@"thumbnails"]];
        AccountNameData = [AccountNameData arrayByAddingObject:[arrayResult objectForKey:@"AccountNameData"]];
        NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"NameData"]];
        LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"LinkData"]];
        TrustData = [TrustData arrayByAddingObject:[arrayResult objectForKey:@"TrustData"]];
    }
    cell.cellView.layer.cornerRadius = 5;
    cell.cellView.layer.shadowOffset = CGSizeMake(0, 2);
    cell.cellView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.cellView.layer.shadowRadius = 8.0f;
    cell.cellView.layer.shadowOpacity = 0.7f;
    cell.cellView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.cellView.layer.bounds] CGPath];
    cell.NameLabel.text = [NameData objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    cell.thumbnailImageView.layer.cornerRadius = 5;
    cell.thumbnailImageView.layer.masksToBounds = YES;
    cell.TimeLabel.text = [TimeData objectAtIndex:indexPath.row];
    cell.AccountNameLabel.text = [NSString stringWithFormat:@"@%@", [AccountNameData objectAtIndex:indexPath.row]];
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
    upButton.frame = CGRectMake(166, 115, 126, 33);
    [cell.contentView addSubview:upButton];
    upButton.layer.cornerRadius = 5;
    upButton.layer.borderWidth = 2.0f;
    upButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    UIButton *downButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    downButton.tag=indexPath.row;
    [downButton addTarget:self
               action:@selector(untrustButtonDown:) forControlEvents:UIControlEventTouchDown];
    [downButton setTitle:@"Nicht vertrauen" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    downButton.frame = CGRectMake(39, 115, 126, 33);
    [cell.contentView addSubview:downButton];
    downButton.layer.cornerRadius = 5;
    downButton.layer.borderWidth = 2.0f;
    downButton.layer.borderColor = [UIColor grayColor].CGColor;

    cell.layer.cornerRadius = 10;
    
    NSLog(@"TrustString: %@", [[TrustData objectAtIndex:indexPath.row] floatValue]);
    /*if(<=0.5){
    cell.trustBar.backgroundColor = [UIColor colorWithRed:1 green:2*[[NSDecimalNumber decimalNumberWithString:[TrustData objectAtIndex:indexPath.row]]floatValue] blue:0 alpha:1];
    }*/
    return cell;
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
    NSLog(@"%@", [LinkData objectAtIndex:0]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[LinkData objectAtIndex:sender.tag]]];
}

-(void)trustButtonDown:(UIButton*)sender
{
    NSLog(@"Trust %d",sender.tag);
}

-(void)untrustButtonDown:(UIButton*)sender
{
    NSLog(@"Untrust %d",sender.tag);
}

- (IBAction)reload:(id)sender {
    [self spinLayer:reloadButton.layer duration:1 direction:SPIN_CLOCK_WISE];
    [self.tableView reloadData];
}
@end

