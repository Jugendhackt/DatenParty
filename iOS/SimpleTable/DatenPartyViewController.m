#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1
#import "DatenPartyViewController.h"
#import "DatenPartyCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface DatenPartyViewController ()

@end
UIRefreshControl * refreshControl;
@implementation DatenPartyViewController
{
    NSArray *NameData;
    NSArray *thumbnails;
    NSArray *TimeData;
    NSArray *TextData;
    NSArray *LinkData;
    NSArray *YesData;
    NSArray *NoData;
    NSArray *TweetidData;
}
UIAlertController *networkAlert;
NSTimer *updateTimer;
NSTimer *networkTimer;
bool makeEmpty=NO;
bool upBool=NO;
bool downBool=NO;
int cellColorChange;
int reload = 0;
int cellHeight = 200;
int noArray[999999];
int yesArray[999999];
int a = 0;
NSData* jsonData;
@synthesize tableView, headerView, reloadButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadAction) userInfo:nil repeats:NO];
        
        refreshControl = [[UIRefreshControl alloc]init];
        [self.tableView addSubview:refreshControl];
        [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tweets" ofType:@"plist"];
        
        // Load the file content and read the data into arrays
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NameData = [dict objectForKey:@"author"];
        thumbnails = [dict objectForKey:@"author"];
        TimeData = [dict objectForKey:@"date"];
        LinkData = [dict objectForKey:@"link"];
        YesData = [dict objectForKey:@"yes"];
        NoData = [dict objectForKey:@"no"];
        TextData = [dict objectForKey:@"article"];
        TweetidData = [dict objectForKey:@"id"];
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
            NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
            if(jsonString==NULL){
                networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable." preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:networkAlert animated:YES completion:nil];
                networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
                //NSString *jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
            }
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
            for (int i=0; i<[allKeys count]; i++) {
                NSDictionary *arrayResult = [allKeys objectAtIndex:i];
                NameData = [dict objectForKey:@"author"];
                thumbnails = [dict objectForKey:@"author"];
                TimeData = [dict objectForKey:@"date"];
                LinkData = [dict objectForKey:@"link"];
                YesData = [dict objectForKey:@"yes"];
                NoData = [dict objectForKey:@"no"];
                TextData = [dict objectForKey:@"article"];
                TweetidData = [dict objectForKey:@"id"];
            }
        });
    }else{
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadAction) userInfo:nil repeats:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
            for (int i=0; i<[allKeys count]; i++) {
                NSDictionary *arrayResult = [allKeys objectAtIndex:i];
                TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"date"]];
                thumbnails = [thumbnails arrayByAddingObject:[arrayResult objectForKey:@"author"]];
                NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"author"]];
                LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"link"]];
                TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"article"]];
                TweetidData = [TweetidData arrayByAddingObject:[arrayResult objectForKey:@"id"]];
                YesData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"yes"]];
                NoData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"no"]];
                yesArray[a] = [[arrayResult objectForKey:@"yes"] floatValue];
                noArray[a] = [[arrayResult objectForKey:@"no"] floatValue];
                a++;
            }
        });
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)networkTimer{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkAlert dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)refreshTable {
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
        if(jsonString==NULL){
            networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:networkAlert animated:YES completion:nil];
            networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
        }
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        makeEmpty = YES;
        [self.tableView reloadData];
        makeEmpty = NO;
        [self.tableView endUpdates];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSError *error;
        NSError *jsonError;
        NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"JSON: %@", jsonString);
        if(jsonString==NULL){
            networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:networkAlert animated:YES completion:nil];
            networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
            jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
        }
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Data 1");
        id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    if(makeEmpty){
        return [allKeys count];
    }else{
        return [NameData count];
    }
    }else{
        NSString *jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        return 0;
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
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        static NSString *DatenPartyIdentifier = @"DatenPartyCell";
        
        DatenPartyCell *cell = (DatenPartyCell *)[tableView dequeueReusableCellWithIdentifier:DatenPartyIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DatenPartyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSLog(@"Data 2");
        float length = ceil(([[TextData objectAtIndex:indexPath.row] length]/37.0f));
        if(length>=8){
            length = 8;
        }
        cell.NameLabel.text = [NameData objectAtIndex:indexPath.row];
        cell.thumbnailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [NameData objectAtIndex:indexPath.row]]];
        cell.thumbnailImageView.layer.cornerRadius = 5;
        cell.thumbnailImageView.layer.masksToBounds = YES;
        cell.TimeLabel.text = [TimeData objectAtIndex:indexPath.row];
        cell.TextLabel.text = [TextData objectAtIndex:indexPath.row];
        cell.TextLabel.frame = CGRectMake(60, 37, cell.TextLabel.frame.size.width, (length+1)*13.5);
        cell.cellView.frame = CGRectMake(cell.cellView.frame.origin.x, cell.cellView.frame.origin.y, cell.cellView.frame.size.width, (length+8)*13.5);
        cell.cellView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.cellView.layer.bounds] CGPath];
        cell.cellView.layer.cornerRadius = 5;
        cell.cellView.layer.shadowOffset = CGSizeMake(0, 2);
        cell.cellView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.cellView.layer.shadowRadius = 5.0f;
        cell.cellView.layer.shadowOpacity = 0.7f;
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, (length+13)*13.5);
        
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
        float trust = (float)yesArray[indexPath.row]/(float)(yesArray[indexPath.row]+noArray[indexPath.row]);
        NSLog(@"%f", trust);
        if(trust<=0.5){
            cell.trustBar.backgroundColor = [UIColor colorWithRed:1 green:2*trust blue:0 alpha:1];
        }else{
            cell.trustBar.backgroundColor = [UIColor colorWithRed:2*(1-trust) green:1 blue:0 alpha:1];
        }
        reload = 1;
        cellHeight=cell.TextLabel.frame.size.height+120;
        sleep(0.1);
        return cell;
        [self.tableView reloadData];
    }

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
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001/up?%@", [TweetidData objectAtIndex:sender.tag]]];
        NSError *error;
        NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
        makeEmpty = YES;
        [self.tableView reloadData];
        makeEmpty = NO;
    }
}

-(void)untrustButtonDown:(UIButton*)sender
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001/down?%@", [TweetidData objectAtIndex:sender.tag]]];
        NSError *error;
        NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
        makeEmpty = YES;
        [self.tableView reloadData];
        makeEmpty = NO;
    }
}

- (IBAction)reload:(id)sender {
    [self spinLayer:reloadButton.layer duration:1 direction:SPIN_CLOCK_WISE];
    [self reloadAction];
}

-(void)reloadAction{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
        if(jsonString==NULL){
            networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:networkAlert animated:YES completion:nil];
            networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\"}]"];
        }
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
        for (int i=0; i<[allKeys count]; i++) {
            NSDictionary *arrayResult = [allKeys objectAtIndex:i];
            TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"date"]];
            thumbnails = [thumbnails arrayByAddingObject:[arrayResult objectForKey:@"author"]];
            NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"author"]];
            LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"link"]];
            TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"article"]];
            YesData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"yes"]];
            NoData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"no"]];
            TweetidData = [TweetidData arrayByAddingObject:[arrayResult objectForKey:@"id"]];
            yesArray[a] = [[arrayResult objectForKey:@"yes"] floatValue];
            noArray[a] = [[arrayResult objectForKey:@"no"] floatValue];
            a++;
        }
        [self.tableView setContentOffset:CGPointZero animated:YES];
        makeEmpty = YES;
        [self.tableView reloadData];
        makeEmpty = NO;
        [self.tableView endUpdates];
    }
}

-(float)roundUp:(float)input{
    float z=1.0f;
    while(input>=13.333*z){
        z++;
    }
    return 13.333*z;
}
@end

