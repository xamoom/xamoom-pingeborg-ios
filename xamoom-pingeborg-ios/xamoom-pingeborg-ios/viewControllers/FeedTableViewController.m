//
//  FeedTableViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 30/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "FeedTableViewController.h"

int const kPageSize = 7;

@interface FeedTableViewController ()

@property NSMutableArray *itemsToDisplay;
@property NSMutableDictionary *imagesToDisplay;
@property NSString *contentListCursor;
@property bool hasMore;
@property bool isApiCallingBlocked;
@property UIButton *dropDownButton;
@property UIBarButtonItem *qrButtonItem;
@property UIImage *placeholderImage;
@property JGProgressHUD *hud;

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_filled"]];
  
  //setting up tableView
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  //set NavigationController delegate
  //NavigationViewController* navController = (NavigationViewController*) self.parentViewController.parentViewController;
  //navController.delegate = self;
  
  //navbarDropdown => title
  UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,(self.view.frame.size.width/1.5),32)];
  self.dropDownButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,(self.view.frame.size.width/1.5),32)];
  //[dropDownButton addTarget:navController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
  [self.dropDownButton setTitle:@"pingeborg Kärnten" forState:UIControlStateNormal];
  [self.dropDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((iv.frame.size.width/2) - 3.5, iv.frame.size.height-3.5, 7, 3.5)];
  UIImage *angleDownImage = [UIImage imageNamed:@"angleDown"];
  [imageView setImage:angleDownImage];
  
  [iv addSubview:self.dropDownButton];
  //[iv addSubview:imageView];
  self.parentViewController.navigationItem.titleView = iv;
  
  //setting up refresh control
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.backgroundColor = [Globals sharedObject].pingeborgLinkColor;
  self.refreshControl.tintColor = [UIColor whiteColor];
  [self.refreshControl addTarget:self
                          action:@selector(pullToRefresh)
                forControlEvents:UIControlEventValueChanged];
  
  //pingeborg system changing notifcation observer
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pingeborgSystemChanged)
                                               name:@"PingeborgSystemChanged"
                                             object:nil];
  
  //init variables
  self.placeholderImage = [UIImage imageNamed:@"placeholder"];
  self.itemsToDisplay = [[NSMutableArray alloc] init];
  self.imagesToDisplay = [[NSMutableDictionary alloc] init];
  
  //loading hud in view
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  [self.hud showInView:self.view];
  
  //api call
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:kPageSize withCursor:@"null" withTags:@[@"artists"]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
  //load artists, if there are none
  if (self.itemsToDisplay.count <= 0) {
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:kPageSize withCursor:@"null" withTags:@[@"artists"]];
  }
}

-(void)viewDidDisappear:(BOOL)animated {
}

#pragma mark - XMMEnduserApi delegates

-(void)didLoadContentList:(XMMResponseContentList *)result {
  self.contentListCursor = result.cursor;
  
  //check if first startup
  if ([Globals isFirstStart]) {
    [self firstStartup:result];
  }
  
  //save if there are more items available over api
  if ([result.hasMore isEqualToString:@"True"])
    self.hasMore = YES;
  else
    self.hasMore = NO;
  
  for (XMMResponseContent *contentItem in result.items) {
    //load images
    if ([contentItem.imagePublicUrl containsString:@".gif"]) {
      //off mainthread gifimage loading
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                               (unsigned long)NULL), ^(void) {
        UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:contentItem.imagePublicUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
          [self.imagesToDisplay setValue:gifImage forKey:contentItem.contentId];
          [self.tableView reloadData];
        });
      });
    } else if ([contentItem.imagePublicUrl containsString:@".svg"]) {
      //off mainthread svg loading
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                               (unsigned long)NULL), ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:contentItem.imagePublicUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
          NSArray *paths = NSSearchPathForDirectoriesInDomains
          (NSDocumentDirectory, NSUserDomainMask, YES);
          NSString *documentsDirectory = paths[0];
          NSString *fileName = [NSString stringWithFormat:@"%@/svgimage.svg", documentsDirectory];
          [imageData writeToFile:fileName atomically:YES];
          
          //read svg mapmarker
          NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
          SVGKImage *svgImage = [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:
                                                            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
          
          [self.imagesToDisplay setValue:svgImage forKey:contentItem.contentId];
          [self.tableView reloadData];
        });
      });
      
    } else if(contentItem.imagePublicUrl != nil) {
      [self downloadImageWithURL:contentItem.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        [self.imagesToDisplay setValue:image forKey:contentItem.contentId];
        [self.tableView reloadData];
      }];
    } else {
      [self.imagesToDisplay setValue:self.placeholderImage forKey:contentItem.contentId];
    }
    
    //add contentItem
    [self.itemsToDisplay addObject:contentItem];
  }
  
  [self.hud dismiss];
  self.isApiCallingBlocked = NO;
  [self reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *simpleTableIdentifier = @"FeedItemCell";
  
  FeedItemCell *cell = (FeedItemCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  if (cell == nil)
  {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
    cell = nib[0];
  }
  
  [cell.loadingIndicator startAnimating];
  
  //set defaults to images
  cell.feedItemImage.image = nil;
  cell.loadingIndicator.hidden = NO;
  
  //save for out of range
  if (indexPath.row >= [self.itemsToDisplay count]) {
    return cell;
  }
  XMMResponseContent *contentItem = (self.itemsToDisplay)[indexPath.row];
  
  //set title
  cell.feedItemTitle.text = contentItem.title;
  
  //set image & grayscale if needed
  if((self.imagesToDisplay)[contentItem.contentId] != nil) {
    UIImage *image = (self.imagesToDisplay)[contentItem.contentId];
    float imageRatio = image.size.width / image.size.height;
    [cell.imageHeightConstraint setConstant:(self.view.frame.size.width / imageRatio)];
    
    if ([(self.imagesToDisplay)[contentItem.contentId] isKindOfClass:[SVGKImage class]]) {
      SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:(self.imagesToDisplay)[contentItem.contentId]];
      [svgImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width / imageRatio))];
      [cell.feedItemImage addSubview:svgImageView];
    } else if (![[Globals savedArtits] containsString:contentItem.contentId]) {
      cell.feedItemImage.image = [self convertImageToGrayScale:image];
      cell.feedItemOverlayImage.backgroundColor = [UIColor whiteColor];
    } else {
      cell.feedItemImage.image = image;
      cell.feedItemOverlayImage.backgroundColor = [UIColor clearColor];
    }
    
    [cell.loadingIndicator stopAnimating];
  }
  
  //overlay image for the first cell "discoverable"
  if (contentItem == self.itemsToDisplay.firstObject) {
    if (![[Globals savedArtits] containsString:contentItem.contentId]) {
      cell.feedItemOverlayImage.image = [UIImage imageNamed:@"discoverable"];
    }
  } else {
    cell.feedItemOverlayImage.image = nil;
  }
  
  //load more contents
  if (indexPath.row == [self.itemsToDisplay count] - 1) {
    [self loadMoreContent];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
  XMMResponseContent *data = (XMMResponseContent*)(self.itemsToDisplay)[indexPath.row];
  artistDetailViewController.contentId = data.contentId;
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

#pragma mark Table view reload

- (void)pullToRefresh {
  if(!self.isApiCallingBlocked) {
    
    //delete all items in arrays
    self.itemsToDisplay = [[NSMutableArray alloc] init];
    self.imagesToDisplay = [[NSMutableDictionary alloc] init];
    
    //api call
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:5 withCursor:@"null" withTags:@[@"artists"]];
    
    self.isApiCallingBlocked = YES;
  }
}

- (void)reloadData
{
  // Reload table data
  [self.tableView reloadData];
  
  // End the refreshing
  if (self.refreshControl) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, hh:mm"];
    NSString *title = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [self.refreshControl endRefreshing];
  }
}

# pragma mark - Custom Methods

-(void)firstStartup:(XMMResponseContentList *)result {
  //add artist 2-4 to discovered list
  int counter = 1;
  while (counter <= 3) {
    XMMResponseContent *contentItem = result.items[counter];
    [Globals addDiscoveredArtist:contentItem.contentId];
    counter++;
  }
}

- (void)loadMoreContent {
  if (self.hasMore && !self.isApiCallingBlocked) {
    self.isApiCallingBlocked = YES;
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:kPageSize withCursor:self.contentListCursor withTags:@[@"artists"]];
  }
}

#pragma mark - Image Methods

- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error )
                           {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                           } else{
                             completionBlock(NO,nil);
                           }
                         }];
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
  // Create image rectangle with current image width/height
  CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
  
  // Grayscale color space
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  
  // Create bitmap content with current image size and grayscale colorspace
  CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
  
  // Draw image into current context, with specified rectangle
  // using previously defined context (with grayscale colorspace)
  CGContextDrawImage(context, imageRect, [image CGImage]);
  
  // Create bitmap image info from pixel data in current context
  CGImageRef imageRef = CGBitmapContextCreateImage(context);
  
  // Create a new UIImage object
  UIImage *newImage = [UIImage imageWithCGImage:imageRef];
  
  // Release colorspace, context and bitmap information
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  CFRelease(imageRef);
  
  // Return the new grayscale image
  return newImage;
}

#pragma mark - NavbarDropdown Delegation

- (void)didChangeSystem {
  NSInteger location = [[NSUserDefaults standardUserDefaults] integerForKey:@"location"];
  
  if ([self.parentViewController.navigationItem.titleView.subviews[0] isKindOfClass:[UIButton class]]) {
    UIButton *button = self.parentViewController.navigationItem.titleView.subviews[0];
    
    switch (location) {
      case 0:
        [button setTitle:@"pingeborg Klagenfurt" forState:UIControlStateNormal];
        break;
      case 1:
        [button setTitle:@"pingeborg Salzburg" forState:UIControlStateNormal];
        break;
      case 2:
        [button setTitle:@"pingeborg Villach" forState:UIControlStateNormal];
        break;
      case 3:
        [button setTitle:@"pingeborg Vorarlberg" forState:UIControlStateNormal];
        break;
      default:
        break;
    }
  }
}

- (void)pingeborgSystemChanged {
  NSString *systemName;
  if ([[Globals sharedObject].globalSystemId isEqualToString:@"6588702901927936"]) {
    systemName = @"pingeborg Kärnten";
  }
  else if ([[Globals sharedObject].globalSystemId isEqualToString:@"Salzburg"]) {
    systemName = @"pingeborg Salzburg";
  }
  else {
    systemName = @"pingeborg Vorarlberg";
  }
  
  [self.dropDownButton setTitle:systemName forState:UIControlStateNormal];
  
  [self pullToRefresh];
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 }
 }
 */

@end
