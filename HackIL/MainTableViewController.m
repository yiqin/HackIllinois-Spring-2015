//
//  MainTableViewController.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "MainTableViewController.h"
#import "FeedTableViewCell.h"
#import "ToPostTableViewCell.h"
#import <HackIL-Swift.h>
#import "AFNetworking.h"
#import "NSMutableSet+UniqueObject.h"
#import "YALNavigationBar.h"

@interface MainTableViewController ()

@property(nonatomic, strong) NSArray *objects;
@property(nonatomic, strong) NSMutableSet *clickedCollection;

@property(nonatomic, strong) NSIndexPath *clickingIndexPath;

@end

@implementation MainTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.objects = [[NSArray alloc] init];
        self.clickedCollection = [[NSMutableSet alloc] init];
        self.clickingIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
    
    [self.navigationController setValue:[[YALNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    
    // [self.tableView setContentOffset:CGPointMake(0, [ToPostTableViewCell cellHeight]) animated:YES];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressedAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(pressedMenuButton:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    [[FeedsDataManager sharedInstance] startLoadingDataFromParse:0 completionClosure:^(BOOL success) {
        if (success) {
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadThisTableView) userInfo:nil repeats:NO];
            // [self reloadThisTableView];
        }
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)reloadThisTableView {
    [self.refreshControl endRefreshing];
    
    self.clickedCollection = [[NSMutableSet alloc] init];
    self.objects = [[NSArray alloc] initWithArray:[FeedsDataManager sharedInstance].objects];

    NSLog(@"%f", self.tableView.contentOffset.y);
    
    [self.tableView setContentOffset:CGPointMake(0, [ToPostTableViewCell cellHeight]) animated:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(id)sender {
    [[FeedsDataManager sharedInstance] startLoadingDataFromParse:0 completionClosure:^(BOOL success) {
        if (success) {
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadThisTableView) userInfo:nil repeats:NO];
        }
    }];
}

- (void)pressedAddButton:(UIBarButtonItem *)sender {
    
    
    
}

- (void)pressedMenuButton:(UIBarButtonItem *)sender {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [ToPostTableViewCell cellHeight];
    }
    else {
        Feed *feed = [self.objects objectAtIndex:indexPath.row-1];
        BOOL isClicked = [self.clickedCollection containsObject:feed];
        return [FeedTableViewCell cellHeight:isClicked];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *CellIdentifier = @"ToPostCell";
        ToPostTableViewCell *cell = (ToPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ToPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else {
        NSString *CellIdentifier = @"FeedCell";
        FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Feed *feed = [self.objects objectAtIndex:indexPath.row-1];
        if (feed) {
            [cell setContentValue:feed];
        }
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        
        
    }
    else {
        self.clickingIndexPath = indexPath;
        
        Feed *feed = [self.objects objectAtIndex:indexPath.row-1];
        [self.clickedCollection addOrDeleteUniqueObject:feed];
        
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
