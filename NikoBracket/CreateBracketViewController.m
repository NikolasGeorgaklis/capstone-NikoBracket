//
//  CreateBracketViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/26/22.
//
#import "CreateBracketViewCell.h"
#import "CreateBracketViewController.h"
#import "UIImageView+AFNetworking.h"
static NSString * const kMatchUpsEndpoint = @"https://api.sportsdata.io/v3/cbb/scores/json/Tournament/2022?key=";

@interface CreateBracketViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSMutableArray *arrayOfMatchups;
@property (weak, nonatomic) IBOutlet UITableView *createBracketTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *teams;
@property (strong, nonatomic) NSMutableArray *matchups;


@end

@implementation CreateBracketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.createBracketTableView.delegate = self;
    self.createBracketTableView.dataSource = self;
    self.createBracketTableView.rowHeight = 150;
    
    [self fetchData];
    
    //Initialize UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.createBracketTableView insertSubview:self.refreshControl atIndex:0];
}


- (void)fetchData{
    // parse teams json file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"teams" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.teams = [[NSMutableDictionary alloc] init];
    NSArray *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (int i = 0; i < temp.count; i++) {
        self.teams[temp[i][@"Key"]] = temp[i];
    }
    //pull api key from Keys.plist
    NSString *pListPath = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: pListPath];
    NSString *key = [dict objectForKey: @"API_Key"];
    
    //parse 1st round matchups from json
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"%@%@", kMatchUpsEndpoint, key];
    
    data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSMutableDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    self.matchups = [[NSMutableArray alloc] init];
    
    NSArray *allMatchups = tempDictionary[@"Games"];
    
    //isolate 1st round matchups given all matchups
    for (NSDictionary *game in allMatchups) {
        if ([game[@"Day"] containsString:@"2022-03-17"]
            || [game[@"Day"] containsString:@"2022-03-18"]){
            [self.matchups addObject:game];
        }
        
    }
    [self.refreshControl endRefreshing];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CreateBracketViewCell *createBracketViewCell = [self.createBracketTableView dequeueReusableCellWithIdentifier:@"CreateBracketViewCell"];
    
    NSDictionary *game = self.matchups[indexPath.row];
    createBracketViewCell.indexPath = indexPath.row;

    createBracketViewCell.awayTeamName.text = self.teams[game[@"AwayTeam"]][@"School"];
    NSURL *url = [NSURL URLWithString:self.teams[game[@"AwayTeam"]][@"TeamLogoUrl"]];
    [createBracketViewCell.awayTeamLogo setImageWithURL:url];
    
    createBracketViewCell.homeTeamName.text = self.teams[game[@"HomeTeam"]][@"School"];
    NSURL *url2 = [NSURL URLWithString:self.teams[game[@"HomeTeam"]][@"TeamLogoUrl"]];
    [createBracketViewCell.homeTeamLogo setImageWithURL:url2];
    
    if([game[@"HomeTeamMoneyLine"] intValue] < 0){
        createBracketViewCell.homeFavorite.text = @"FAVORITE";
        createBracketViewCell.awayFavorite.text = @"";
    }
    else{
        createBracketViewCell.homeFavorite.text = @"";
        createBracketViewCell.awayFavorite.text = @"FAVORITE";
    }
    
    return createBracketViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchups.count;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
