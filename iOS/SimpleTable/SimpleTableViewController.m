//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleTableCell.h"

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
    
}

@synthesize tableView;

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
    AccountNameData = [dict objectForKey:@"Account"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)refreshTable {
    //!!!
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
    return 165;
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
    
    return cell;
}

-(void)trustButtonDown:(UIButton*)sender
{
    NSLog(@"Trust %d",sender.tag);
}

-(void)untrustButtonDown:(UIButton*)sender
{
    NSLog(@"Untrust %d",sender.tag);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSLog(@"didSelectRowAtIndexPath");
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:[name objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [messageAlert show];
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willSelectRowAtIndexPath");
    if (indexPath.row == 0) {
        return nil;
    }
    
    return indexPath;
}

@end

