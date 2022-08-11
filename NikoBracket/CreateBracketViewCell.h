//
//  CreateBracketViewCell.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/26/22.
//


#import "CreateBracketViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateBracketViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *teamSelect;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamName;
@property (weak, nonatomic) IBOutlet UIButton *awayFavoriteIcon;
@property (weak, nonatomic) IBOutlet UIButton *homeFavoriteIcon;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamName;
@property long indexPath;
@property (strong, nonatomic) CreateBracketViewController *createBracketView;
@property long section;

@end

NS_ASSUME_NONNULL_END
