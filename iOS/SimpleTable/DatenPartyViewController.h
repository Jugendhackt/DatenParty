#import <UIKit/UIKit.h>

@interface DatenPartyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
- (IBAction)reload:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end
