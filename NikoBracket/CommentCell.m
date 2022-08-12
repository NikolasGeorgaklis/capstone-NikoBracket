//
//  CommentCell.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/11/22.
//

#import "CommentCell.h"
#import "Parse/PFImageView.h"

@interface CommentCell()

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *isLiked;
@property BOOL hasBeenLiked;
@property int likedCommentIndex;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setData{
        [self.comment.author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.displayName.text = self.comment[@"author"][@"displayName"];
            self.commentContent.text = self.comment[@"commentContent"];
            self.likeCount.text = [self.comment[@"likes"] stringValue];
            self.profilePicture.file = self.comment[@"author"][@"profilePicture"];
            [self.profilePicture loadInBackground];
            
            PFUser *user = [PFUser currentUser];
            
            UIImage *likeIcon;
            self.hasBeenLiked = NO;
            NSArray *likedComments = [[NSArray alloc] initWithArray:user[@"likedComments"]];
            for (int x = 0; x < likedComments.count; x++)
            {
                Comment *comment = likedComments[x];
                if ([comment.objectId isEqual:self.comment.objectId])
                {
                    self.likedCommentIndex = x;
                    self.hasBeenLiked = YES;
                }
            }
            if (self.hasBeenLiked)
            {
                likeIcon = [UIImage imageNamed:@"liked.png"];
            }
            else{
                likeIcon = [UIImage imageNamed:@"notLiked.png"];
            }
            likeIcon = [self resizeImage:likeIcon withSize:CGSizeMake(30, 30)];
            [self.isLiked setImage:likeIcon forState:UIControlStateNormal];
        }];
}

- (IBAction)like:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSMutableArray *likedComments = [[NSMutableArray alloc] initWithArray:user[@"likedComments"]];
    if (self.hasBeenLiked) {
        self.hasBeenLiked = NO;
        self.comment.likes = [NSNumber numberWithInt:[self.comment.likes intValue] - 1];
        [likedComments removeObjectAtIndex:self.likedCommentIndex];
    }
    else {
        self.hasBeenLiked = YES;
        self.comment.likes = [NSNumber numberWithInt:[self.comment.likes intValue] + 1];
        [likedComments addObject:self.comment];
    }
    user[@"likedComments"] = likedComments;
    [self setData];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            NSLog(@"SAVED USER");
        }
    }];
    
    [self.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error)
        {
            NSLog(@"SAVED POST");
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
