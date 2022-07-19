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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 100;
    
    self.logOutButton.tintColor = [UIColor systemPinkColor];
    
    //Initialize UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"refreshing");

        // Create NSURL and NSURLRequest

//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                              delegate:nil
//                                                         delegateQueue:[NSOperationQueue mainQueue]];
//        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//           // ... Use the new data to update the data source ...
//
//           // Reload the tableView now that there is new data
//            [self.homeTableView reloadData];
//
//           // Tell the refreshControl to stop spinning
//            [refreshControl endRefreshing];
//
//        }];
//
//        [task resume];
    [self.refreshControl endRefreshing];

}

- (IBAction)didTapLogOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        NSLog(@"Logged out");
    }];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeViewCell *homeViewCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeViewCell"];
    
    return homeViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

@end
