#import <UIKit/UIKit.h>

@interface DatenPartyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIButton *DownButton;
@property (weak, nonatomic) IBOutlet UIButton *UpButton;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *trustBar;
@property (weak, nonatomic) IBOutlet UIButton *untrustButton;
@property (weak, nonatomic) IBOutlet UIButton *trustButton;

@end
