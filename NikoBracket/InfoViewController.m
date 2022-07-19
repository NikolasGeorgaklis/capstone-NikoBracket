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


@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.rowHeight = 125;
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
    InfoViewCell *infoViewCell = [self.infoTableView dequeueReusableCellWithIdentifier:@"InfoViewCell"];
    
    return infoViewCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  15;
}

@end
