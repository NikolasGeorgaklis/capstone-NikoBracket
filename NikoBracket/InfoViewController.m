//
//  InfoViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/18/22.
//

#import "InfoViewController.h"
#import "InfoViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface InfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSMutableArray *arrayOfMatchups;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *teams;
@property (strong, nonatomic) NSMutableArray *matchups;


@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.rowHeight = 125;
    
    [self fetchData];
    
    //Initialize UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.infoTableView insertSubview:self.refreshControl atIndex:0];
    
    
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
    
    //parse 1st round matchups from json
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://api.sportsdata.io/v3/cbb/scores/json/Tournament/2022?key=003d3b7e4d724cbeb785ca7d4aded519"];
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
    InfoViewCell *infoViewCell = [self.infoTableView dequeueReusableCellWithIdentifier:@"InfoViewCell"];
    
    NSDictionary *game = self.matchups[indexPath.row];
    
    infoViewCell.AwaySchoolName.text = self.teams[game[@"AwayTeam"]][@"School"];
    infoViewCell.awayMoneyline.text = [game[@"AwayTeamMoneyLine"] stringValue];
    NSURL *url = [NSURL URLWithString:self.teams[game[@"AwayTeam"]][@"TeamLogoUrl"]];
    [infoViewCell.awayTeamLogo setImageWithURL:url];
    
    infoViewCell.homeSchoolName.text = self.teams[game[@"HomeTeam"]][@"School"];
    infoViewCell.homeMoneyline.text = [game[@"HomeTeamMoneyLine"] stringValue];
    NSURL *url2 = [NSURL URLWithString:self.teams[game[@"HomeTeam"]][@"TeamLogoUrl"]];
    [infoViewCell.homeTeamLogo setImageWithURL:url2];
    
    if([game[@"HomeTeamMoneyLine"] intValue] < 0){
        infoViewCell.homeFavorite.text = @"FAVORITE";
        infoViewCell.awayFavorite.text = @"";
    }
    else{
        infoViewCell.homeFavorite.text = @"";
        infoViewCell.awayFavorite.text = @"FAVORITE";
    }
    
    return infoViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchups.count;
}


@end
