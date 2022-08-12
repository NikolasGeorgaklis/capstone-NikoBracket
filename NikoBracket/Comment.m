//
//  Comment.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/11/22.
//

#import "Comment.h"

@implementation Comment

@dynamic commentContent;
@dynamic likes;
@dynamic user;
@dynamic author;

+ (void)postCommentWithText:(NSString *)commentContent withCompletion:(PFBooleanResultBlock)completion andUser:(PFUser *)user{
    
    Comment *newComment = [Comment new];
    newComment.user = user;
    newComment.author = [PFUser currentUser];
    newComment.commentContent = commentContent;
    newComment.likes = @(0);
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSMutableArray *comments = [[NSMutableArray alloc] initWithArray:newComment.user[@"comments"]];
        [comments addObject:newComment];
        newComment.user[@"comments"] = comments;
        [newComment.user saveInBackground];
    }];
    
}

+ (nonnull NSString* ) parseClassName{
    return @"comment";
}

@end
