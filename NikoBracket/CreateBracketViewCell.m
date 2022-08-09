//
//  CreateBracketViewCell.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/26/22.
//

#import "CreateBracketViewCell.h"
#import "CreateBracketViewController.h"


@implementation CreateBracketViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}
- (IBAction)teamSelectAction:(id)sender {
    [self.createBracketView changePick:self.indexPath inSection:self.section inCell:self];
}




@end
