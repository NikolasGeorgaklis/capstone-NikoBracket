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


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 150;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeViewCell *homeViewCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeViewCell"];
    
    return homeViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  5;
}

@end
