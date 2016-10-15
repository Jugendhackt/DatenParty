//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIButton *DownButton;
@property (weak, nonatomic) IBOutlet UIButton *UpButton;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
