//
//  InfoViewCell.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/18/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AwaySchoolName;
@property (weak, nonatomic) IBOutlet UILabel *homeSchoolName;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *awayMoneyline;
@property (weak, nonatomic) IBOutlet UILabel *homeMoneyline;
@property (weak, nonatomic) IBOutlet UIButton *HomeFavoriteIcon;
@property (weak, nonatomic) IBOutlet UIButton *AwayFavoriteIcon;

@end

NS_ASSUME_NONNULL_END
