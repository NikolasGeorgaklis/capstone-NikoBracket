//
//  CommentsViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/12/22.
//

#import "CommentsViewController.h"
#import "CommentCell.h"
#import "Comment.h"
#import "Parse/Parse.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
- (IBAction)postComment:(id)sender;


@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 75;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getComments) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self getComments];
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.comment = self.comments[indexPath.row];;
    [cell setData];
    return cell;
}

- (void)getComments{
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"comment"];
    [query orderByDescending:@"likes"];
    self.comments = [[NSMutableArray alloc] init];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *comment in objects) {
            PFUser *user = comment[@"user"];
            if ([user.objectId isEqual:self.user.objectId]) {
                [self.comments addObject:comment];
            }
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (IBAction)postComment:(id)sender {
    [Comment postCommentWithText:self.commentTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    } andUser:self.user];
    self.commentTextField.text = @"";
}


- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
