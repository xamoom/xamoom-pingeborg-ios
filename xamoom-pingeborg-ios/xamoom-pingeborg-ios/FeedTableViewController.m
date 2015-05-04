//
//  FeedTableViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 30/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "FeedTableViewController.h"

static int const pageSize = 7;

@interface FeedTableViewController ()

@property NSMutableArray *itemsToDisplay;
@property NSMutableDictionary *imagesToDisplay;
@property NSString *contentListCursor;
@property bool hasMore;
@property bool isApiCallingBlocked;

@end

@implementation FeedTableViewController

@synthesize itemsToDisplay;
@synthesize imagesToDisplay;

UIButton *dropDownButton;
UIBarButtonItem *qrButtonItem;
JGProgressHUD *hud;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //setting up tableView
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  //set NavigationController delegate
  NavigationViewController* navController = (NavigationViewController*) self.parentViewController.parentViewController;
  navController.delegate = self;
  
  //navbarDropdown
  UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,(self.view.frame.size.width/1.5),32)];
  dropDownButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,(self.view.frame.size.width/1.5),32)];
  //[dropDownButton addTarget:navController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
  [dropDownButton setTitle:@"pingeborg Carinthia" forState:UIControlStateNormal];
  [dropDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((iv.frame.size.width/2) - 3.5, iv.frame.size.height-3.5, 7, 3.5)];
  UIImage *angleDownImage = [UIImage imageNamed:@"angleDown"];
  [imageView setImage:angleDownImage];
  
  [iv addSubview:dropDownButton];
  //[iv addSubview:imageView];
  self.parentViewController.navigationItem.titleView = iv;
  
  //setting up refresh control
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.backgroundColor = [UIColor colorWithRed:25/255.0f green:198/255.0f blue:255/255.0f alpha:1.0f];
  self.refreshControl.tintColor = [UIColor whiteColor];
  [self.refreshControl addTarget:self
                          action:@selector(pullToRefresh)
                forControlEvents:UIControlEventValueChanged];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pingeborgSystemChanged)
                                               name:@"PingeborgSystemChanged"
                                             object:nil];
  
  itemsToDisplay = [[NSMutableArray alloc] init];
  imagesToDisplay = [[NSMutableDictionary alloc] init];
  
  hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  [hud showInView:self.view];
  
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:pageSize withCursor:@"null"];
  
  qrButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr26"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(tappedQRButton)];
  
  self.parentViewController.navigationItem.leftBarButtonItem = qrButtonItem;

  isFirstTime = YES;
  
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
  /*
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isPingeborgSystemChanged"]) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO
                   forKey:@"isPingeborgSystemChanged"];
    [userDefaults synchronize];
  }*/
  //self.parentViewController.navigationItem.leftBarButtonItem= qrButtonItem;
  
  //load artists, if there are none
  if (itemsToDisplay.count <= 0) {
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:pageSize withCursor:@"null"];
  }
}

-(void)viewDidDisappear:(BOOL)animated {
  //self.parentViewController.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - XMMEnduserApi delegates

-(void)didLoadContentList:(XMMResponseContentList *)result {
  //check if first startup
  if ([Globals isFirstStart]) {
    [self firstStartup:result];
  }
  
  NSString *savedArtists = [Globals savedArtits];
  self.contentListCursor = result.cursor;
  
  if ([result.hasMore isEqualToString:@"True"])
    self.hasMore = YES;
  else
    self.hasMore = NO;
  
  for (XMMResponseContent *contentItem in result.items) {
    
    [imagesToDisplay setValue:[UIImage imageNamed:@"placeholder"] forKey:contentItem.contentId];
    
    //gif support
    if ([contentItem.imagePublicUrl containsString:@".gif?"]) {
      UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:contentItem.imagePublicUrl]];
      
      if (![savedArtists containsString:contentItem.contentId]) {
        gifImage = [self convertImageToGrayScale:gifImage];
      }
      
      [imagesToDisplay setValue:gifImage forKey:contentItem.contentId];
      contentItem.imagePublicUrl = nil;
    }
    
    if(contentItem.imagePublicUrl != nil) {
      [self downloadImageWithURL:contentItem.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
          if (![savedArtists containsString:contentItem.contentId]) {
            image = [self convertImageToGrayScale:image];
          }
          
          [imagesToDisplay setValue:image forKey:contentItem.contentId];
          [self.tableView reloadData];
        }
      }];
    }
    
    [itemsToDisplay addObject:contentItem];
  }
  
  [hud dismiss];
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
  return [itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *simpleTableIdentifier = @"FeedItemCell";
  
  FeedItemCell *cell = (FeedItemCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  if (cell == nil)
  {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }
  cell.feedItemImage.image = [UIImage imageNamed:@"placeholder"];
  
  //load more contents
  if (indexPath.row == [self.itemsToDisplay count] - 1) {
    if (self.hasMore && !self.isApiCallingBlocked) {
      self.isApiCallingBlocked = YES;
      [[XMMEnduserApi sharedInstance] setDelegate:self];
      [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:pageSize withCursor:self.contentListCursor];
    }
    return cell;
  }
  
  //save for out of range
  if (indexPath.row >= [itemsToDisplay count]) {
    return cell;
  }
  
  XMMResponseContent *contentItem = [itemsToDisplay objectAtIndex:indexPath.row];
  
  //styling the label
  NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  style.alignment = NSTextAlignmentJustified;
  style.firstLineHeadIndent = 4.0f;
  style.tailIndent = -4.0f;
  style.lineBreakMode = NSLineBreakByTruncatingTail;
  NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:contentItem.title
                                                                 attributes:@{ NSParagraphStyleAttributeName : style}];
  //set the title
  cell.feedItemTitle.attributedText = attrText;
  [cell.loadingIndicator startAnimating];
  
  if ([imagesToDisplay objectForKey:contentItem.contentId]){
    UIImage *image = [imagesToDisplay objectForKey:contentItem.contentId];
    float imageRatio = image.size.width / image.size.height;
    [cell.imageHeightConstraint setConstant:(cell.frame.size.width / imageRatio)];
    cell.feedItemImage.image = image;
    [cell.loadingIndicator stopAnimating];
  } else {
    //[cell.imageHeightConstraint setConstant:50.0f];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
  XMMResponseContent *data = (XMMResponseContent*)[itemsToDisplay objectAtIndex:indexPath.row];
  artistDetailViewController.contentId = data.contentId;
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

#pragma mark Table view reload

- (void)pullToRefresh {
  if(!self.isApiCallingBlocked) {
    itemsToDisplay = nil;
    itemsToDisplay = [[NSMutableArray alloc] init];
    imagesToDisplay = nil;
    imagesToDisplay = [[NSMutableDictionary alloc] init];
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] contentListWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:5 withCursor:@"null"];
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
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [self.refreshControl endRefreshing];
  }
}

# pragma mark - Custom Methods

-(void)firstStartup:(XMMResponseContentList *)result {
  int counter = 1;
  while (counter <= 3) {
    XMMResponseContent *contentItem = result.items[counter];
    [Globals addDiscoveredArtist:contentItem.contentId];
    counter++;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ( [[segue identifier] isEqualToString:@"showScanResult"] ) {
    ScanResultViewController *srvc = [segue destinationViewController];
    [srvc setResult:result];
  }
}


#pragma mark - User Interaction

-(void)tappedQRButton {
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
  [[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self withAPIRequest:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"Completion with result: %@", result);
  }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
  NSLog(@"readerDidCancel");
  [self dismissViewControllerAnimated:YES completion:NULL];
}

BOOL isFirstTime;
XMMResponseGetByLocationIdentifier *result;

- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier *)apiResult {
  
  result = apiResult;
  if( isFirstTime ) {
    isFirstTime = NO;
    [Globals addDiscoveredArtist:apiResult.content.contentId];
    [self performSegueWithIdentifier:@"showScanResult" sender:self];
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
  CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
  
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
    systemName = @"pingeborg Carinthia";
  }
  else if ([[Globals sharedObject].globalSystemId isEqualToString:@"Salzburg"]) {
    systemName = @"pingeborg Salzburg";
  }
  else {
    systemName = @"pingeborg Vorarlberg";
  }
  
  [dropDownButton setTitle:systemName forState:UIControlStateNormal];
  
  [self pullToRefresh];
}

@end
