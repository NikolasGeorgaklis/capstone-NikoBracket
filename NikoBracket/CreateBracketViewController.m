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
@property (strong, nonatomic) NSMutableArray *westMatchups;
@property (strong, nonatomic) NSMutableArray *eastMatchups;
@property (strong, nonatomic) NSMutableArray *midwestMatchups;
@property (strong, nonatomic) NSMutableArray *southMatchups;

@end

@implementation CreateBracketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.createBracketTableView.delegate = self;
    self.createBracketTableView.dataSource = self;
    self.createBracketTableView.rowHeight = 150;
    
    [self.createBracketTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
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
    self.westMatchups = [[NSMutableArray alloc] init];
    self.eastMatchups = [[NSMutableArray alloc] init];
    self.midwestMatchups = [[NSMutableArray alloc] init];
    self.southMatchups = [[NSMutableArray alloc] init];

    NSArray *allMatchups = tempDictionary[@"Games"];
    
    //isolate 1st round matchups given all matchups
    for (NSDictionary *game in allMatchups) {
        if ([game[@"Day"] containsString:@"2022-03-17"]
            || [game[@"Day"] containsString:@"2022-03-18"]){
            [self.matchups addObject:game];
            
            if ([game[@"Bracket"] isEqual:@"West"]) {
                [self.westMatchups addObject:game];
            }
            else if ([game[@"Bracket"] isEqual:@"South"]) {
                [self.southMatchups addObject:game];
            }
            else if ([game[@"Bracket"] isEqual:@"East"]) {
                [self.eastMatchups addObject:game];
            }
            else if ([game[@"Bracket"] isEqual:@"Midwest"]) {
                [self.midwestMatchups addObject:game];
            }
        }
    }
    
    [self.refreshControl endRefreshing];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CreateBracketViewCell *createBracketViewCell = [self.createBracketTableView dequeueReusableCellWithIdentifier:@"CreateBracketViewCell"];
    
    
    if (indexPath.section == 0) {
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:self.westMatchups];
    }
    else if (indexPath.section == 1) {
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:self.southMatchups];
    }
    else if (indexPath.section == 2) {
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:self.eastMatchups];
    }
    else {
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:self.midwestMatchups];
    }

    
    return createBracketViewCell;
}

- (void)setBracketCells:(CreateBracketViewCell *)cell atIndex:(NSIndexPath *) indexPath withArray:(NSMutableArray *) arr{
    NSDictionary *game = arr[indexPath.row];
    cell.indexPath = indexPath.row;

    cell.awayTeamName.text = self.teams[game[@"AwayTeam"]][@"School"];
    NSURL *url = [NSURL URLWithString:self.teams[game[@"AwayTeam"]][@"TeamLogoUrl"]];
    [cell.awayTeamLogo setImageWithURL:url];
    
    cell.homeTeamName.text = self.teams[game[@"HomeTeam"]][@"School"];
    NSURL *url2 = [NSURL URLWithString:self.teams[game[@"HomeTeam"]][@"TeamLogoUrl"]];
    [cell.homeTeamLogo setImageWithURL:url2];
    
    if([game[@"HomeTeamMoneyLine"] intValue] < 0){
        cell.homeFavorite.text = @"FAVORITE";
        cell.awayFavorite.text = @"";
    }
    else{
        cell.homeFavorite.text = @"";
        cell.awayFavorite.text = @"FAVORITE";
    }

}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.westMatchups.count;
    }
    else if (section == 1) {
        return self.southMatchups.count;
    }
    else if (section == 2) {
        return self.eastMatchups.count;
    }
    else {
        return self.midwestMatchups.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (section == 0) {
        header.textLabel.text = @"West";
    }
    else if (section == 1) {
        header.textLabel.text = @"South";
    }
    else if (section == 2) {
        header.textLabel.text = @"East";
    }
    else {
        header.textLabel.text = @"Midwest";
    }
    
    header.textLabel.font = [header.textLabel.font fontWithSize:30];
    
    return header;
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
