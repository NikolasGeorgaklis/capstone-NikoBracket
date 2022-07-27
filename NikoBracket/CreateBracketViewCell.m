//
//  CreateBracketViewCell.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/26/22.
//

#import "CreateBracketViewCell.h"

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
    NSLog(self.teamSelect.selectedSegmentIndex ? @"true" : @"false");
    NSLog(@"%d", self.indexPath);
    
}


@end
