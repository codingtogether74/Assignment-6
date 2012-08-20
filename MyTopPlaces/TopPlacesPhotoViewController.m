//
//  TopPlacesPhotoViewController.m
//   MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/28/12.
//

#import "TopPlacesPhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentsUserDefaults.h"
#import "FlickrPhotoCache.h"
#import "VacationHelper.h"
#import "PopoverVacationsTableViewController.h"

#define PHOTO_TITLE_KEY  @"title"
#define PHOTO_ID_KEY @"id"
#define TOO_MANY_PHOTOS 20

@interface TopPlacesPhotoViewController() <UIScrollViewDelegate,
                                           PopoverVacationsTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSString *photoTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *visitButton;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSArray *vacations;

@end

@implementation TopPlacesPhotoViewController
 
@synthesize photoScrollView = _photoScrollView;
@synthesize photoImageView = _photoImageView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photoTitle = _photoTitle;
@synthesize spinner = _spinner;
@synthesize visitButton = _visitButton;
@synthesize popoverController;
@synthesize vacations = _vacations;

@synthesize photo = _photo;

- (void)displayVisitButtonForPhotoID:(NSString *)photoID {
    VacationHelper *vh = [VacationHelper sharedVacation:nil];
    [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
        [self checkVisitButton];
        if ([Photo exisitingPhotoWithID:photoID
                 inManagedObjectContext:vh.database.managedObjectContext]) {
            self.visitButton.title = @"Unvisit";
        } else {
            self.visitButton.title = @"Visit";
        }
    }];
    
}

-(void)checkVisitButton
{
    if (self.splitViewController) {       //  iPad
        //-------------------------
        BOOL isVisitButton=NO;
        // iPad
        NSMutableArray * items = [[self.toolbar items] mutableCopy];
        for (int i = 0; i < items.count; i++) {
            UIBarButtonItem * b = [items objectAtIndex:i];
            if (b.style == UIBarButtonItemStyleBordered) {
                isVisitButton = YES;
            }
        }
        if (!isVisitButton){
            [items addObject:self.visitButton];
            [self.toolbar setItems:items];
        }
    } else {                             //  iPhone
        self.navigationItem.rightBarButtonItem = self.visitButton;
    }
}

- (void)hideVisitButton {
    if (self.splitViewController) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        [toolbarItems removeObject:self.visitButton];
        self.toolbar.items = toolbarItems;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (UIBarButtonItem *)visitButton
{
    if (!_visitButton) {
        _visitButton = [[UIBarButtonItem alloc] initWithTitle:@"Visit" style:UIBarButtonItemStyleBordered target:self action:@selector(visitButtonPressed:)];
    }
    return _visitButton;
}

- (IBAction)visitButtonPressed:(id)sender
{
    VacationHelper *vh = [VacationHelper sharedVacation:nil];
//-----------------
if ([self.photo objectForKey:@"imageURL"]){
    if (self.splitViewController){
// photo comes from database
        self.photoImageView.alpha = 0.3;
            [self hideVisitButton];
    } else {
            [self.navigationController popViewControllerAnimated:YES];
           }
    [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
    [Photo removePhotoWithID:[self.photo objectForKey:FLICKR_PHOTO_ID]
           inManagedObjectContext:vh.database.managedObjectContext];
    [vh.database saveToURL:vh.database.fileURL
                 forSaveOperation:UIDocumentSaveForOverwriting
                 completionHandler:NULL];
    }];
}
//-----------------
      if ([self.visitButton.title isEqualToString:@"Visit"]) {
//----- instatiate from Storyboard destination ViewController---------
            UIStoryboard*storyboard=self.storyboard;
            PopoverVacationsTableViewController *pvtvc =[storyboard
                                                         instantiateViewControllerWithIdentifier:@"ListOfVacations"];
            if (self.splitViewController) {         // iPad
                self.visitButton.enabled = NO;
//----------allocate popover-------------------------------------------
                UIPopoverController* popover = [[UIPopoverController alloc]
                                                initWithContentViewController:pvtvc];


                self.popoverController = popover;
//----------size of popover-------------------------------------------
                [ self.popoverController setPopoverContentSize:CGSizeMake(200, 200)];
//----------set vacations and delegate-------------------------------------------
                [pvtvc setVacations:self.vacations];
                [pvtvc setDelegate:self];
//----------present vacations with popover-------------------------------------------
                [self.popoverController presentPopoverFromBarButtonItem:sender
                                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                                               animated:YES];
            } else {                  //iPhone
                [self.navigationController pushViewController:pvtvc animated:YES];
            }
        } else {
          self.visitButton.title = @"Visit";
            [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
                [Photo removePhotoWithID:[self.photo objectForKey:FLICKR_PHOTO_ID]
                  inManagedObjectContext:vh.database.managedObjectContext];
            }];
        }
        [vh.database saveToURL:vh.database.fileURL
              forSaveOperation:UIDocumentSaveForOverwriting
             completionHandler:NULL];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Visit Vacations"]) {
        // this if statement added after lecture to prevent multiple popovers
        // appearing if the user keeps touching the Favorites button over and over
        // simply remove the last one we put up each time we segue to a new one
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = popoverSegue.popoverController; // might want to be popover's delegate and self.popoverController = nil on dismiss?
        }
        [segue.destinationViewController setVacations:self.vacations];
        [segue.destinationViewController setDelegate:self];
    }
}

-(void)PopoverVacationsTableViewController :(PopoverVacationsTableViewController *)sender
                              choseVacation:(NSString *)vacation;
{
    VacationHelper *vh = [VacationHelper sharedVacation:vacation];
    [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
        [Photo photoFromFlickrInfo:self.photo
            inManagedObjectContext:vh.database.managedObjectContext];
        [self.navigationController popViewControllerAnimated:YES];
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        self.visitButton.title = @"Unvisit";
        self.visitButton.enabled = YES;

        [vh.database saveToURL:vh.database.fileURL
              forSaveOperation:UIDocumentSaveForOverwriting
             completionHandler:NULL];
    }];
}
- (void)synchronizeViewWithImage:(UIImage *) image
{
	self.photoImageView.image = image ;       //  [UIImage imageWithData:imageData];
    self.photoImageView.alpha = 1;
	self.title = [self.photo objectForKey:PHOTO_TITLE_KEY];
	
	// Reset the zoom scale back to 1
	self.photoScrollView.zoomScale = 1;
    
    self.photoScrollView.maximumZoomScale = 10.0;
    self.photoScrollView.minimumZoomScale = 0.1;
    
	self.photoScrollView.contentSize = self.photoImageView.image.size;
	self.photoImageView.frame =
	CGRectMake(0, 0, self.photoImageView.image.size.width, self.photoImageView.image.size.height);
	
}
#pragma mark - Scroll View Delegate

// set the image that needs to be scrolled by the scrollview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

- (void)setPhotoTitle:(NSString *)photoTitle
{
    if ([photoTitle isEqualToString:@""])
        _photoTitle = @"no photo description";
    else
        _photoTitle = photoTitle;
//----------------------------------
    BOOL changed;
    if (self.toolbar) {
        // iPad
        NSMutableArray * items = [[self.toolbar items] mutableCopy];
        for (int i = 0; i < items.count; i++) {
            UIBarButtonItem * b = [items objectAtIndex:i];
            if (b.style == UIBarButtonItemStylePlain) {
                [b setTitle:photoTitle];
                changed = YES;
            }
        }
        if (changed) [self.toolbar setItems:items];
    }
    else {
        // iPhone
        self.title = photoTitle;
    }
//----------------------------------
/*    if (self.toolbar) {
    // title for the iPad
            NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
            UIBarButtonItem *titleButton = [toolbarItems objectAtIndex:[toolbarItems count]-3];
            titleButton.title = _photoTitle;
    } else {
    // title for the iPhone
            self.title = _photoTitle;
    }
*/ 
}
   
- (void)fillView
{
    CGFloat hScale = self.photoScrollView.bounds.size.height/self.photoImageView.bounds.size.height;
    CGFloat wScale = self.photoScrollView.bounds.size.width/self.photoImageView.bounds.size.width;
    [self.photoScrollView setZoomScale:MAX(wScale, hScale) animated:YES];
    [self.photoImageView setNeedsDisplay];
}


- (void)loadPhoto
{
    if (self.photo) {
        [self.spinner startAnimating];
        dispatch_queue_t dispatchQueue = dispatch_queue_create("q_photo", NULL);
        
        // Load the image using the queue
        dispatch_async(dispatchQueue, ^{ 

//-------------- check cache ----------------------------------------------------------------------------
        NSURL *photoUrl;
        NSString *urlString;
        NSData *photoData;
            
       FlickrPhotoCache *flickrPhotoCache = [[FlickrPhotoCache alloc]init];
        [flickrPhotoCache retrievePhotoCache];
            
        if ([flickrPhotoCache isInCache:self.photo])
        {
                urlString = [flickrPhotoCache readImageFromCache:self.photo];//photo is in cache
                photoData = [NSData dataWithContentsOfFile:urlString];
//                NSLog(@"load image from cache: %@",urlString);
        }
        else
        {
            if ([self.photo objectForKey:@"imageURL"])
            {
                // photo comes from database
                photoUrl = [NSURL URLWithString:[self.photo objectForKey:@"imageURL"]];
                
            }else
            {
                photoUrl = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]; //photo is not in cache
            }
            
            photoData = [NSData dataWithContentsOfURL:photoUrl];
        }
            //NSLog(@"downloaded from url: %@",url);
            UIImage *image = [UIImage imageWithData:photoData];
//            NSLog(@"image id to cache is %@",[self.photo objectForKey:FLICKR_PHOTO_ID]);
            [flickrPhotoCache writeImageToCache:image forPhoto:self.photo fromUrl:photoUrl]; //update photo cache
//------------------------------------------------------------------------------------------
            // Use the main queue to store the photo in NSUserDefaults and to display
            dispatch_async(dispatch_get_main_queue(), ^{

        if (photoData) {
            NSString *photoID = [self.photo objectForKey:PHOTO_ID_KEY];
			// Only store and display if another photo hasn't been selected
			if ([photoID isEqualToString:[self.photo objectForKey:PHOTO_ID_KEY]]) {
                [RecentsUserDefaults saveRecentsUserDefaults:self.photo];
				[self synchronizeViewWithImage:image];
				[self fillView]; // Sets the zoom level to fill screen
				[self.spinner stopAnimating];
			}
            // Assignment 4 - task 7
            self.photoTitle = [self.photo valueForKey:FLICKR_PHOTO_TITLE];
            [self displayVisitButtonForPhotoID:photoID];
        } else {
            self.photoTitle = @"no photo retrieved";
        }
            });
                
        });
        dispatch_release(dispatchQueue);
    } else {
        self.photoTitle = @"no photo selected";

    }
}

//  This one was added for the iPad splitview
//  It needs displaying the image again if the photo is changed
- (void)setPhoto:(NSDictionary *)photo {
    if (photo != _photo) {
        _photo = photo;
        if (!_photo) return;
        self.vacations = [VacationHelper getVacations];
        // Model chaned, so update our View (the table)
      if (self.photoImageView.window)  [self loadPhoto];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoScrollView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
	if (self.photo) [self loadPhoto];
	
}

- (void)viewWillLayoutSubviews {
    
	// Zoom the image to fill up the view
	if (self.photoImageView.image) [self fillView];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    [self setToolbar:nil];
    [self setPhotoScrollView:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

#pragma mark - Split View Controller

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) {
            [toolbarItems removeObject:_splitViewBarButtonItem];
        }
        if (splitViewBarButtonItem) {
            [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        }
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

@end
