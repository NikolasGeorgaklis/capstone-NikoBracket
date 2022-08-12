//
//  Comment.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFUser *author;
+ (void)postCommentWithText:(NSString *)commentContent withCompletion:(PFBooleanResultBlock)completion andUser:(PFUser *) user;

@end

NS_ASSUME_NONNULL_END
