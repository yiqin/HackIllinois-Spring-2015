//
//  MainTableViewController.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "MainTableViewController.h"
#import "FeedTableViewCell.h"
#import <HackIL-Swift.h>
#import "AFNetworking.h"
#import "NSMutableSet+UniqueObject.h"

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
        // self.clickingIndexPath = [[NSIndexPath alloc] init];
        self.clickingIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[FeedsDataManager sharedInstance] startLoadingDataFromParse:0 completionClosure:^(BOOL success) {
        if (success) {
            [self reloadThisTableView];
        }
    }];
}

- (void)reloadThisTableView {
    self.clickedCollection = [[NSMutableSet alloc] init];
    self.objects = [[NSArray alloc] initWithArray:[FeedsDataManager sharedInstance].objects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Feed *feed = [self.objects objectAtIndex:indexPath.row];
    
    BOOL isClicked = [self.clickedCollection containsObject:feed];
    
    // NSLog(@"%f", [FeedTableViewCell cellHeight:isClicked]);
    return [FeedTableViewCell cellHeight:isClicked];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"FeedCell";
    FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Feed *feed = [self.objects objectAtIndex:indexPath.row];
    if (feed) {
        [cell setContentValue:feed];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.clickingIndexPath = indexPath;
    
    Feed *feed = [self.objects objectAtIndex:indexPath.row];
    if ([self.clickedCollection containsObject:feed]) {
        [self.clickedCollection removeObject:feed];
    }
    else {
        [self.clickedCollection addObject:feed];
    }
    
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:self.clickingIndexPath, nil];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
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
