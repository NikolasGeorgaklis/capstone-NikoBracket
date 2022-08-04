//
//  HomeViewCell.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *correctOverTotal;
@property (weak, nonatomic) IBOutlet UIImageView *selectedChampionLogo;
@property PFUser *user;
-(void)setUserInfo;

@end

NS_ASSUME_NONNULL_END
