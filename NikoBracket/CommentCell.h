//
//  CommentCell.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/11/22.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) Comment *comment;
- (void)setData;

@end

NS_ASSUME_NONNULL_END
