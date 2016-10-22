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
bool upBool=NO;
bool downBool=NO;
int cellColorChange;
int reload = 0;
int cellHeight = 200;
NSData* jsonData;
@synthesize tableView, headerView, reloadButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadAction) userInfo:nil repeats:NO];
    
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
    makeEmpty = YES;
    [self.tableView reloadData];
    makeEmpty = NO;
    [refreshControl endRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://raw.githubusercontent.com/Jugendhackt/DatenParty/master/Sortierung/tweets.json"]] encoding:NSUTF8StringEncoding error:&error];
    jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)refreshTable {
    [refreshControl endRefreshing];
    makeEmpty = YES;
    [self.tableView reloadData];
    makeEmpty = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://raw.githubusercontent.com/Jugendhackt/DatenParty/master/Sortierung/tweets.json"]] encoding:NSUTF8StringEncoding error:&error];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    NSLog(@"Data 1");
    id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    if(makeEmpty){
        return [allKeys count];
    }else{
        return [NameData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateHeightForConfiguredSizingCell:indexPath];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(NSIndexPath *)indexPath {
    return cellHeight;
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

    NSError *jsonError;
    NSLog(@"Data 2");
    id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
    for (int i=0; i<[allKeys count]; i++) {
        NSDictionary *arrayResult = [allKeys objectAtIndex:i];
        TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"date"]];
        thumbnails = [thumbnails arrayByAddingObject:[arrayResult objectForKey:@"profilimage"]];
        NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"profilname"]];
        LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"tweetlink"]];
        TrustData = [TrustData arrayByAddingObject:[arrayResult objectForKey:@"trustlevel"]];
        TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"tweet"]];
        TweetidData = [TweetidData arrayByAddingObject:[arrayResult objectForKey:@"tweetid"]];
    }

    cell.NameLabel.text = [NameData objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [thumbnails objectAtIndex:indexPath.row]]]]];
    cell.thumbnailImageView.layer.cornerRadius = 5;
    cell.thumbnailImageView.layer.masksToBounds = YES;
    cell.TimeLabel.text = [TimeData objectAtIndex:indexPath.row];
    cell.TextLabel.text = [TextData objectAtIndex:indexPath.row];
    cell.TextLabel.frame = CGRectMake(60, 37, cell.TextLabel.frame.size.width, (ceil([[TextData objectAtIndex:indexPath.row] length]/37.0f))*13.5);
    cell.cellView.frame = CGRectMake(cell.cellView.frame.origin.x, cell.cellView.frame.origin.y, cell.cellView.frame.size.width, (ceil([[TextData objectAtIndex:indexPath.row] length]/37.0f)+7)*13.5);
    cell.cellView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.cellView.layer.bounds] CGPath];
    cell.cellView.layer.cornerRadius = 5;
    cell.cellView.layer.shadowOffset = CGSizeMake(0, 2);
    cell.cellView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.cellView.layer.shadowRadius = 5.0f;
    cell.cellView.layer.shadowOpacity = 0.7f;
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, (ceil([[TextData objectAtIndex:indexPath.row] length]/37.0f)+12)*13.5);
    
    cell.trustButton.tag = indexPath.row;
    [cell.trustButton addTarget:self
                 action:@selector(trustButtonDown:)
       forControlEvents:UIControlEventTouchUpInside];
    
    cell.untrustButton.tag = indexPath.row;
    [cell.untrustButton addTarget:self
                         action:@selector(untrustButtonDown:)
               forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *linkButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    linkButton.tag=indexPath.row;
    [linkButton addTarget:self
                 action:@selector(linkDown:) forControlEvents:UIControlEventTouchUpInside];
    linkButton.frame = CGRectMake(30, 40, 265, cell.TextLabel.frame.size.height+20);
    [cell.contentView addSubview:linkButton];

    cell.layer.cornerRadius = 10;
    cell.trustBar.layer.cornerRadius = 2;
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [cell.trustBar.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if(upBool==NO&&downBool==NO){
    float trust = [[TrustData objectAtIndex:indexPath.row] floatValue];
        NSLog(@"%d %f", indexPath.row, trust);
        if(trust<=0.5){
            cell.trustBar.backgroundColor = [UIColor colorWithRed:1 green:2*trust blue:0 alpha:1];
        }else{
            cell.trustBar.backgroundColor = [UIColor colorWithRed:2*(1-trust) green:1 blue:0 alpha:1];
        }
    }else if(upBool==YES&&red>=0&&red<=1&&cellColorChange==indexPath.row){
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [cell.trustBar.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        red=red-0.1;
        cell.trustBar.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        upBool=NO;

    }else if(downBool==YES&&red>=0&&red<=1&&cellColorChange==indexPath.row){
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [cell.trustBar.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        red=red+0.1;
        cell.trustBar.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        downBool=NO;
        //NSLog(@"%f %f %f", red, ,);
    }
    reload = 1;
    cellHeight=cell.TextLabel.frame.size.height+120;
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[LinkData objectAtIndex:sender.tag]]];
}

-(void)trustButtonDown:(UIButton*)sender
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"/datenparty/up/%@", [TweetidData objectAtIndex:sender.tag]]];
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    upBool=YES;
    makeEmpty = YES;
    [self.tableView reloadData];
    makeEmpty = NO;
    cellColorChange=sender.tag;
    NSLog(@"Trust %d", sender.tag);
}

-(void)untrustButtonDown:(UIButton*)sender
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"/datenparty/down/%@", [TweetidData objectAtIndex:sender.tag]]];
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    downBool=YES;
    makeEmpty = YES;
    [self.tableView reloadData];
    makeEmpty = NO;
    cellColorChange=sender.tag;
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
    [self.tableView endUpdates];
}

-(float)roundUp:(float)input{
    float z=1.0f;
    while(input>=13.333*z){
        z++;
    }
    return 13.333*z;
}
@end

