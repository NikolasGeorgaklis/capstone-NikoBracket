//
//  HomeViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/13/22.
//

#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "HomeViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic)NSArray *accountsArray;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PFUser *user;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];

    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 100;
    [self getAccounts];
        
    //Initialize UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView insertSubview:self.refreshControl atIndex:0];
    
}

-(void)getAccounts{
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"correctPicks"];
    
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *accounts, NSError *error) {
        if (accounts != nil) {
            // do something with the array of object returned by the call
            self.accountsArray = accounts;
            [self.homeTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeViewCell *cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeViewCell"];
    
    cell.user = self.accountsArray[indexPath.row];
    [cell setUserInfo];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountsArray.count;
}

@end
