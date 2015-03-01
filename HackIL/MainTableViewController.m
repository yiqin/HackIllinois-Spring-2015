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
#import "PostingView.h"
#import <Parse/Parse.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface MainTableViewController ()

@property(nonatomic, strong) NSArray *objects;
@property(nonatomic, strong) NSMutableSet *clickedCollection;

@property(nonatomic, strong) NSIndexPath *clickingIndexPath;

@property(nonatomic, strong) PostingView *postingView;
@property(nonatomic) CGFloat aminationHeight;

@property (nonatomic, strong) CameraSessionView *cameraView;

@end

@implementation MainTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.objects = [[NSArray alloc] init];
        self.clickedCollection = [[NSMutableSet alloc] init];
        self.clickingIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;

        self.postingView = [[PostingView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight-64)];
        
        
        self.aminationHeight = screenHeight-64;
    }
    return self;
}

- (void)viewDidLoad {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
    
    [self.navigationController setValue:[[YALNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    
    
    self.title = @"Discover";
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
    
    [self.navigationController.view addSubview:self.postingView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePost) name:@"savePost" object:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)reloadThisTableView {
    [self.refreshControl endRefreshing];
    
    self.clickedCollection = [[NSMutableSet alloc] init];
    self.objects = [[NSArray alloc] initWithArray:[FeedsDataManager sharedInstance].objects];

    NSLog(@"%f", self.tableView.contentOffset.y);
    
    [self.tableView setContentOffset:CGPointMake(0, [ToPostTableViewCell cellHeight]) animated:NO];
    [self.tableView reloadData];
    
    [SVProgressHUD dismiss];
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

- (void)setNavigationDiscover {
    self.title = @"Discover";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressedAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(pressedMenuButton:)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)setNavigationPost {
    self.title = @"Post";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pressedCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pressedCameraButton:)];
    
    self.navigationItem.rightBarButtonItem = cameraButton;
}

- (void)pressedAddButton:(UIBarButtonItem *)sender {
    [self setNavigationPost];
    [self showPostingView];
}

- (void)pressedMenuButton:(UIBarButtonItem *)sender {
    
}

- (void)pressedCancelButton:(UIBarButtonItem *)sender {
    [self setNavigationDiscover];
    [self hidePostingView];
}

- (void)pressedCameraButton:(UIBarButtonItem *)sender {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    _cameraView = [[CameraSessionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [_cameraView setTopBarColor:[UIColor clearColor]];
    [_cameraView hideFlashButton];
    [_cameraView hideCameraToogleButton];
    [_cameraView hideDismissButton];
    
    _cameraView.delegate = self;
    [self.navigationController.view addSubview:_cameraView];
    
}

-(void)didCaptureImage:(UIImage *)image {
    //Use the image that is received
    [self.cameraView removeFromSuperview];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    // photoImageView.contentMode = UIViewContentModeBottom;
    photoImageView.image = image;
    // [self.postingView insertSubview:photoImageView atIndex:0];
    
    self.postingView.photoImageView.image = image;
    
    
}

- (void)showPostingView {
    
    [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:.8 initialSpringVelocity:0.1 options:0 animations:^{
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        self.postingView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hidePostingView {
    
    [self.postingView endEditing:YES];
    
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        self.postingView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight-64);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)savePost {
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSArray *ranColors = @[@"http://files.parsetfss.com/80bf5d55-10a8-400f-8ee6-56ba5df99927/tfss-0014881a-7a69-4ad9-aaa6-35bec49cf18c-helen.jpg",@"http://files.parsetfss.com/80bf5d55-10a8-400f-8ee6-56ba5df99927/tfss-239bad1b-f898-48ef-a20c-334fcb92fd4c-jocelyn.jpg",@"http://files.parsetfss.com/80bf5d55-10a8-400f-8ee6-56ba5df99927/tfss-eb54585c-51d7-4304-8b12-20c01dac3ae9-yiqin.jpg"];
    NSArray *strings = @[@"Helen",@"Jocelyn",@"Yi"];
    int size = (int)[ranColors count];
    int rand =(int) arc4random_uniform(size);
    NSString *tempString  = [ranColors objectAtIndex:2];
    NSString *userString = [strings objectAtIndex:2];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = [AFImageResponseSerializer serializer];
    [operationManager GET:tempString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        PFObject *post = [[PFObject alloc] initWithClassName:@"Feed"];
        post[@"name"] = self.postingView.tf.text;
        
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[VoiceLocationManager sharedInstance].latitude longitude:[VoiceLocationManager sharedInstance].longitude];
        post[@"geopoint"] = point;
        
        
        post[@"releasedAt"] = [NSDate date];
        
        if (self.postingView.photoImageView.image) {
            NSData *imageData2 = UIImagePNGRepresentation(self.postingView.photoImageView.image);
            PFFile *imageFile2 = [PFFile fileWithName:@"image.png" data:imageData2];
            post[@"image"] = imageFile2;
        }
        
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            PFObject *going = [[PFObject alloc] initWithClassName:@"Going"];
            going[@"feed"] = post;
            going[@"user"] = [PFUser currentUser];
            going[@"user_name"] = userString;
            NSData *imageData1 = UIImagePNGRepresentation(responseObject);
            PFFile *imageFile1 = [PFFile fileWithName:@"user_profile.png" data:imageData1];
            going[@"user_profileImage"] = imageFile1;
            
            [going saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [self hidePostingView];
                
            }];
            
        }];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.objects == 0) {
        return 0;
    }
    else {
        return self.objects.count+1;
    }
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
        cell.textField.delegate = self;
        
        return cell;
    }
    else {
        NSString *CellIdentifier = @"FeedCell";
        FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Feed *feed = [self.objects objectAtIndex:indexPath.row-1];
        BOOL isClicked = [self.clickedCollection containsObject:feed];
        if (feed) {
            [cell setContentValue:feed withCheckingCliked:isClicked];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [[FeedsDataManager sharedInstance] startLoadingDataFromParseTwo:textField.text completionClosure:^(BOOL success) {
        if (success) {
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadThisTableView) userInfo:nil repeats:NO];
        }
    }];
    
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
