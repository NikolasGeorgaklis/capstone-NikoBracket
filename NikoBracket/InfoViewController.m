//
//  InfoViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/18/22.
//

#import "InfoViewController.h"
#import "InfoViewCell.h"

@interface InfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.rowHeight = 125;
    
    //Initialize UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.infoTableView insertSubview:self.refreshControl atIndex:0];

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
//            [self.infoTableView reloadData];
//
//           // Tell the refreshControl to stop spinning
//            [refreshControl endRefreshing];
//
//        }];
//
//        [task resume];
    [self.refreshControl endRefreshing];

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InfoViewCell *infoViewCell = [self.infoTableView dequeueReusableCellWithIdentifier:@"InfoViewCell"];
    
    return infoViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  15;
}

@end
