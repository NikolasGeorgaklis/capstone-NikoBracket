//
//  HomeViewCell.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/18/22.
//

#import "HomeViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Parse/PFImageView.h"
#import "Parse.h"

@implementation HomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setUserInfo {
    PFFileObject *file = self.user[@"profilePicture"];
    NSURL *url = [NSURL URLWithString:file.url];
    if (file) {
        [self.profilePicture setImageWithURL:url];
    }
    self.displayName.text = [NSString stringWithFormat:@"%@", self.user[@"displayName"]];
    self.rank.text = [NSString stringWithFormat:@"Rank: %@", [self.user[@"rank"] stringValue]];
    self.correctOverTotal.text = self.user[@"ratio"];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
