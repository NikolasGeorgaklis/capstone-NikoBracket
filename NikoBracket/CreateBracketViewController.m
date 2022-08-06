//
//  CreateBracketViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/26/22.
//
#import "CreateBracketViewCell.h"
#import "CreateBracketViewController.h"
#import "Parse/Parse.h"
#import "UIImageView+AFNetworking.h"
static NSString * const kMatchUpsEndpoint = @"https://api.sportsdata.io/v3/cbb/scores/json/Tournament/2022?key=";
static const NSInteger kRound1 = 0;
static const NSInteger kRound2 = 1;
static const NSInteger kRound3 = 2;
static const NSInteger kRound4 = 3;
static const NSInteger kSemiFinal = 4;
static const NSInteger kFinal = 5;

@interface CreateBracketViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PFUser *user;
@property(strong, nonatomic) NSMutableArray *arrayOfMatchups;
@property (weak, nonatomic) IBOutlet UITableView *createBracketTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *teams;
@property (strong, nonatomic) NSMutableArray *matchups;
@property (strong, nonatomic) NSMutableArray *westMatchups;
@property (strong, nonatomic) NSMutableArray *eastMatchups;
@property (strong, nonatomic) NSMutableArray *midwestMatchups;
@property (strong, nonatomic) NSMutableArray *southMatchups;
@property (strong, nonatomic) NSMutableArray *westPicks;
@property (strong, nonatomic) NSMutableArray *southPicks;
@property (strong, nonatomic) NSMutableArray *eastPicks;
@property (strong, nonatomic) NSMutableArray *midwestPicks;
@property (strong, nonatomic) NSMutableArray *finalsPicks;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roundControl;
@property int round;
- (IBAction)roundControlAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lockBracket;


@end

@implementation CreateBracketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.round = self.roundControl.selectedSegmentIndex;
    
    self.lockBracket.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    self.createBracketTableView.delegate = self;
    self.createBracketTableView.dataSource = self;
    self.createBracketTableView.rowHeight = 150;
    
    [self.createBracketTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    [self fetchData];
    
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.roundControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
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
    
    //read tournament JSON file into tempdictionary
    data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSMutableDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //create arrays for all first round matchups, also seperate each matchup into regions
    self.matchups = [[NSMutableArray alloc] init];
    self.westMatchups = [[NSMutableArray alloc] init];
    self.eastMatchups = [[NSMutableArray alloc] init];
    self.midwestMatchups = [[NSMutableArray alloc] init];
    self.southMatchups = [[NSMutableArray alloc] init];

    //put all games info into allMatchups
    NSArray *allMatchups = tempDictionary[@"Games"];
    
    //initialize arrays for first round teams in each region
    NSMutableArray *round1west = [[NSMutableArray alloc] init];
    NSMutableArray *round1south = [[NSMutableArray alloc] init];
    NSMutableArray *round1east = [[NSMutableArray alloc] init];
    NSMutableArray *round1midwest = [[NSMutableArray alloc] init];
    
    //initialize arrays to contain teams from all regions for all rounds
    self.westPicks = [[NSMutableArray alloc] init];
    self.southPicks = [[NSMutableArray alloc] init];
    self.eastPicks = [[NSMutableArray alloc] init];
    self.midwestPicks = [[NSMutableArray alloc] init];

    //isolate 1st round matchups given all matchups

    for (int i = 0; i < allMatchups.count; i++) {
        NSDictionary *game = allMatchups[i];
        //hardcoded 2022 1st round dates because "round" key returns incorrect data in free API version
        if ([game[@"Day"] containsString:@"2022-03-17"] || [game[@"Day"] containsString:@"2022-03-18"]){
            [self.matchups addObject:game];
            
            if ([game[@"Bracket"] isEqual:@"West"]) {
                [self.westMatchups addObject:game];

                NSString *team1 = game[@"AwayTeam"];
                NSString *team2 = game[@"HomeTeam"];
                NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:team1, team2, @"0", nil];
                [round1west addObject:matchup];
            }
            else if ([game[@"Bracket"] isEqual:@"South"]) {
                [self.southMatchups addObject:game];

                NSString *team1 = game[@"AwayTeam"];
                NSString *team2 = game[@"HomeTeam"];
                NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:team1, team2, @"0", nil];
                [round1south addObject:matchup];
            }
            else if ([game[@"Bracket"] isEqual:@"East"]) {
                [self.eastMatchups addObject:game];

                NSString *team1 = game[@"AwayTeam"];
                NSString *team2 = game[@"HomeTeam"];
                NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:team1, team2, @"0", nil];
                [round1east addObject:matchup];
            }
            else if ([game[@"Bracket"] isEqual:@"Midwest"]) {
                [self.midwestMatchups addObject:game];

                NSString *team1 = game[@"AwayTeam"];
                NSString *team2 = game[@"HomeTeam"];
                NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:team1, team2, @"0", nil];
                [round1midwest addObject:matchup];
            }
        }
    }
    
    [self.westPicks addObject:round1west];
    [self.southPicks addObject:round1south];
    [self.eastPicks addObject:round1east];
    [self.midwestPicks addObject:round1midwest];
    
    [self initializeUserBracket:self.westPicks];
    [self initializeUserBracket:self.southPicks];
    [self initializeUserBracket:self.eastPicks];
    [self initializeUserBracket:self.midwestPicks];
        
    //finals bracket is different from other brackets, must be set up after regional brackets
    self.finalsPicks = [[NSMutableArray alloc] init];
    [self initializeUserFinalsBracket:self.finalsPicks];
    
    self.user[@"westPicks"] = self.westPicks;
    self.user[@"southPicks"] = self.southPicks;
    self.user[@"eastPicks"] = self.eastPicks;
    self.user[@"midwestPicks"] = self.midwestPicks;
    self.user[@"finalsPicks"] = self.finalsPicks;

    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    [self.refreshControl endRefreshing];
    }];
}


- (void) changePick:(int) index inSection:(int) section inCell:(CreateBracketViewCell *) cell{
    
    switch (section) {
        case 0:
            if (self.roundControl.selectedSegmentIndex < 4) {
                [self.westPicks[self.roundControl.selectedSegmentIndex][index] replaceObjectAtIndex:2 withObject:(cell.teamSelect.selectedSegmentIndex ? @"1" : @"0")];
                self.user[@"westPicks"] = self.westPicks;
            }
            else{
                [self.finalsPicks[self.roundControl.selectedSegmentIndex - 4][index] replaceObjectAtIndex:2 withObject:(cell.teamSelect.selectedSegmentIndex ? @"1" : @"0")];
                self.user[@"finalsPicks"] = self.finalsPicks;
            }
            break;
        case 1:
            [self.southPicks[self.roundControl.selectedSegmentIndex][index] replaceObjectAtIndex:2 withObject:(cell.teamSelect.selectedSegmentIndex ? @"1" : @"0")];
            self.user[@"southPicks"] = self.southPicks;
            
            break;
        case 2:
            [self.eastPicks[self.roundControl.selectedSegmentIndex][index] replaceObjectAtIndex:2 withObject:(cell.teamSelect.selectedSegmentIndex ? @"1" : @"0")];
            self.user[@"eastPicks"] = self.eastPicks;
            
            break;
        case 3:
            [self.midwestPicks[self.roundControl.selectedSegmentIndex][index] replaceObjectAtIndex:2 withObject:(cell.teamSelect.selectedSegmentIndex ? @"1" : @"0")];
            self.user[@"midwestPicks"] = self.midwestPicks;
            
            break;
        default:
            break;
    }
    
    [self.user saveInBackground];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CreateBracketViewCell *createBracketViewCell = [self.createBracketTableView dequeueReusableCellWithIdentifier:@"CreateBracketViewCell"];
    
    NSMutableArray *currentWestMatchups = [[NSMutableArray alloc] init];
    NSMutableArray *currentSouthMatchups = [[NSMutableArray alloc] init];
    NSMutableArray *currentEastMatchups = [[NSMutableArray alloc] init];
    NSMutableArray *currentMidwestMatchups = [[NSMutableArray alloc] init];
    NSMutableArray *semisMatchups = [[NSMutableArray alloc] init];
    NSMutableArray *championship = [[NSMutableArray alloc] init];


    switch (self.roundControl.selectedSegmentIndex) {
        case kRound1:
            currentWestMatchups = self.westMatchups;
            currentSouthMatchups = self.southMatchups;
            currentEastMatchups = self.eastMatchups;
            currentMidwestMatchups = self.midwestMatchups;
            break;
        case kRound2:
            currentWestMatchups = self.westPicks[1];
            currentSouthMatchups = self.southPicks[1];
            currentEastMatchups = self.eastPicks[1];
            currentMidwestMatchups = self.midwestPicks[1];
            break;
        case kRound3:
            currentWestMatchups = self.westPicks[2];
            currentSouthMatchups = self.southPicks[2];
            currentEastMatchups = self.eastPicks[2];
            currentMidwestMatchups = self.midwestPicks[2];
            break;
        case kRound4:
            currentWestMatchups = self.westPicks[3];
            currentSouthMatchups = self.southPicks[3];
            currentEastMatchups = self.eastPicks[3];
            currentMidwestMatchups = self.midwestPicks[3];
            break;
        case kSemiFinal:
            semisMatchups = self.finalsPicks[0];
            break;
        case kFinal:
            championship = self.finalsPicks[1];
            break;
        default:
            break;
    }
    
    if (indexPath.section == 0) {
        if (self.roundControl.selectedSegmentIndex < 4) {
            [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:currentWestMatchups];
        }
        else if (self.roundControl.selectedSegmentIndex == 4){
            [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:semisMatchups];
        }
        else{
            [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:championship];
        }
    }
    else if (indexPath.section == 1) {
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:currentSouthMatchups];
    }
    else if (indexPath.section == 2) {
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:currentEastMatchups];
    }
    else if (indexPath.section == 3){
        [self setBracketCells:createBracketViewCell atIndex:indexPath withArray:currentMidwestMatchups];
    }
    
    return createBracketViewCell;
}

- (void)setBracketCells:(CreateBracketViewCell *)cell atIndex:(NSIndexPath *) indexPath withArray:(NSMutableArray *) arr{
    cell.indexPath = indexPath.row;
    cell.section = indexPath.section;
    cell.createBracketView = self;
    
    
    if (self.roundControl.selectedSegmentIndex == 0) {
        NSDictionary *game = arr[indexPath.row];
        
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
    else{
        cell.awayTeamName.text = self.teams[arr[indexPath.row][0]][@"School"];
        NSURL *url = [NSURL URLWithString:self.teams[arr[indexPath.row][0]][@"TeamLogoUrl"]];
        [cell.awayTeamLogo setImageWithURL:url];
        
        cell.homeTeamName.text = self.teams[arr[indexPath.row][1]][@"School"];
        NSURL *url2 = [NSURL URLWithString:self.teams[arr[indexPath.row][1]][@"TeamLogoUrl"]];
        [cell.homeTeamLogo setImageWithURL:url2];
        
        //no odds for theoretical matchups so no favorites
        cell.awayFavorite.text = @"";
        cell.homeFavorite.text = @"";
    }
        

}

- (IBAction)roundSelectAction:(id)sender {
    self.round = self.roundControl.selectedSegmentIndex;
    
    self.lockBracket.hidden = self.roundControl.selectedSegmentIndex == 5 ?  NO : YES;
    
    [self initializeUserBracket:self.westPicks];
    [self initializeUserBracket:self.southPicks];
    [self initializeUserBracket:self.eastPicks];
    [self initializeUserBracket:self.midwestPicks];
    [self initializeUserFinalsBracket:self.finalsPicks];

    
    self.user[@"westPicks"] = self.westPicks;
    self.user[@"southPicks"] = self.southPicks;
    self.user[@"eastPicks"] = self.eastPicks;
    self.user[@"midwestPicks"] = self.midwestPicks;
    self.user[@"finalsPicks"] = self.finalsPicks;
    
    [self.user saveInBackground];
    [self.createBracketTableView reloadData];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    switch (self.roundControl.selectedSegmentIndex) {
        case kRound1:
            return 8;
            break;
        case kRound2:
            return 4;
            break;
        case kRound3:
            return 2;
            break;
        case kRound4:
            return 1;
            break;
        case kSemiFinal:
            return 2;
            break;
        case kFinal:
            return 1;
            break;
    }
    
    if (section == 0) {
        return self.westMatchups.count;
    }
    else if (section == 1) {
        return self.southMatchups.count;
    }
    else if (section == 2) {
        return self.eastMatchups.count;
    }
    else if (section == 3){
        return self.midwestMatchups.count;
    }
    else {
        return self.finalsPicks.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.round < 4){
        return 4;
    }
    else{
        return 1;
    }
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
    
    if (self.roundControl.selectedSegmentIndex > 3) {
        header.textLabel.text = @"";
    }
    
    header.textLabel.font = [header.textLabel.font fontWithSize:30];
    
    return header;
}

- (NSMutableArray *) initializeUserBracket:(NSMutableArray *) matchups {
    NSMutableArray *round1 = matchups[0];
    NSMutableArray *round2 = [[NSMutableArray alloc] init];
    NSMutableArray *round3 = [[NSMutableArray alloc] init];
    NSMutableArray *round4 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < round1.count - 1; i+=2) {
        //each "game" object contains 3 elements: two 3-5 letter abbreviations, one for the home team, one for the away team, and the third element is a 0 or 1 indicating the user’s choice for who they believe will win the game
        NSArray *game = round1[i];
        NSArray *game2 = round1[i+1];

        NSString *winner1 = game[[game[2] intValue]];
        NSString *winner2 = game2[[game2[2] intValue]];
        if (matchups.count == 1) {
            NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, @"0", nil];
            [round2 addObject:matchup];
        }
        else{
            NSString *choice = matchups[1][i/2][2];
            NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, choice, nil];
            [round2 addObject:matchup];
        }
       
    }
    for (int i = 0; i < round2.count - 1; i+=2) {
        NSArray *game = round2[i];
        NSArray *game2 = round2[i+1];

        NSString *winner1 = game[[game[2] intValue]];
        NSString *winner2 = game2[[game2[2] intValue]];
        if (matchups.count == 1) {
            NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, @"0", nil];
            [round3 addObject:matchup];
        }
        else{
            NSString *choice = matchups[2][i/2][2];
            NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, choice, nil];
            [round3 addObject:matchup];
        }
    }
    for (int i = 0; i < round3.count - 1; i+=2) {
        NSArray *game = round3[i];
        NSArray *game2 = round3[i+1];

        NSString *winner1 = game[[game[2] intValue]];
        NSString *winner2 = game2[[game2[2] intValue]];
        if (matchups.count == 1) {
            NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, @"0", nil];
            [round4 addObject:matchup];
        }
        else{
            NSString *choice = matchups[3][i/2][2];
            NSMutableArray *matchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, choice, nil];
            [round4 addObject:matchup];
        }
    }
    
    switch (matchups.count) {
        case 0:
            [matchups addObject:round2];
            [matchups addObject:round3];
            [matchups addObject:round4];
            break;
        case 1:
            matchups[1] = round2;
            [matchups addObject:round3];
            [matchups addObject:round4];
            break;
        case 2:
            matchups[1] = round2;
            matchups[2] = round3;
            [matchups addObject:round4];
            break;
        default:
            matchups[1] = round2;
            matchups[2] = round3;
            matchups[3] = round4;
            break;
    }
    
    return matchups;
}

- (NSMutableArray *) initializeUserFinalsBracket:(NSMutableArray *) finalsMatchups {
    NSMutableArray *final_4 = [[NSMutableArray alloc] init];
    NSMutableArray *championship = [[NSMutableArray alloc] init];
    
    //East vs West in final 4
    NSArray *game = self.westPicks[3][0];
    NSArray *game2 = self.eastPicks[3][0];
    
    NSString *winner1 = game[[game[2] intValue]];
    NSString *winner2 = game2[[game2[2] intValue]];
    
    if (finalsMatchups.count == 0) {
        NSMutableArray *EvWmatchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, @"0", nil];
        [final_4 addObject:EvWmatchup];
    }
    else{
        NSMutableArray *EvWmatchup = [[NSMutableArray alloc] initWithObjects:winner1, winner2, finalsMatchups[0][0][2], nil];
        [final_4 addObject:EvWmatchup];
    }
    
    //South vs Midwest in final 4
    NSArray *game3 = self.southPicks[3][0];
    NSArray *game4 = self.midwestPicks[3][0];
    
    NSString *winner3 = game3[[game3[2] intValue]];
    NSString *winner4 = game4[[game4[2] intValue]];
    
    if (finalsMatchups.count == 0) {
        NSMutableArray *SvMmatchup = [[NSMutableArray alloc] initWithObjects:winner3, winner4, @"0", nil];
        [final_4 addObject:SvMmatchup];
    }
    else{
        NSMutableArray *SvMmatchup = [[NSMutableArray alloc] initWithObjects:winner3, winner4, finalsMatchups[0][1][2], nil];
        [final_4 addObject:SvMmatchup];
    }
    
    //add final4 to finals matchups
    if (finalsMatchups.count > 0) {
        finalsMatchups[0] = final_4;
    }
    else {
        [finalsMatchups addObject:final_4];
    }
    
    //championship
    NSArray *semisGame1 = final_4[0];
    NSArray *semisGame2 = final_4[1];
    
    NSString *finalist1 = semisGame1[[semisGame1[2] intValue]];
    NSString *finalist2 = semisGame2[[semisGame2[2] intValue]];
    
    if (finalsMatchups.count == 1) {
        NSMutableArray *finalMatchup = [[NSMutableArray alloc] initWithObjects:finalist1, finalist2, @"0", nil];
        [championship addObject:finalMatchup];
    }
    else{
        NSMutableArray *finalMatchup = [[NSMutableArray alloc] initWithObjects:finalist1, finalist2, finalsMatchups[1][0][2], nil];
        [championship addObject:finalMatchup];
    }
    
    //add championship to finals matchups
    if (finalsMatchups.count == 2) {
        finalsMatchups[1] = championship;
    }
    else {
        [finalsMatchups addObject:championship];
    }

    return finalsMatchups;
}

- (IBAction)didTapLockBracket:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                 message:@"Are you sure you want to lock your bracket? You will not be able to make changes after pressing OK"
                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
     {}];
    [alert addAction:cancel];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
     {
        // How many pieces to generate
            int confettiCount = 200;
            
            // What colors should the pieces be?
            NSArray *confettiColors = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]];
            
            
            // Everything else that you can configure
            int screenWidth = self.view.frame.size.width;
            int screenHeight = self.view.frame.size.height;
            int randomStartPoint;
            int randomStartConfettiLength;
            int randomEndConfettiLength;
            int randomEndPoint;
            int randomDelayTime;
            int randomFallTime;
            int randomRotation;
            
            for (int i = 0; i < confettiCount; i++){
                randomStartPoint = arc4random_uniform(screenWidth);
                randomEndPoint = arc4random_uniform(screenWidth);
                randomDelayTime = arc4random_uniform(100);
                randomFallTime = arc4random_uniform(3);
                randomRotation = arc4random_uniform(360);
                randomStartConfettiLength = arc4random_uniform(15);
                randomEndConfettiLength = arc4random_uniform(15);
                NSUInteger randomColor = arc4random() % [confettiColors count];
                
                UIView *confetti=[[UIView alloc]initWithFrame:CGRectMake(randomStartPoint, -10, randomStartConfettiLength, 8)];
                [confetti setBackgroundColor:confettiColors[randomColor]];
                confetti.alpha = .4;
                [self.view addSubview:confetti];
                
                [UIView animateWithDuration:randomFallTime+5 delay:randomDelayTime*.1 options:UIViewAnimationOptionRepeat animations:^{
                        [confetti setFrame:CGRectMake(randomEndPoint, screenHeight+30, randomEndConfettiLength, 8)];
                        confetti.transform = CGAffineTransformMakeRotation(randomRotation);
                } completion:nil];
            }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                     message:@"You have created your March Madness Bracket."
                                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {
            [self.navigationController popViewControllerAnimated:YES];
            self.tabBarController.tabBar.hidden = NO;

        }];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

@end
