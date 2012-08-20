//
//  PhotoTableViewController.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 8/03/12.
//
//
#import <UIKit/UIKit.h>

#import "FlickrFetcher.h"
#import "TopPlacesPhotoViewController.h"

@interface PhotoTableViewController : UITableViewController

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSDictionary *place;
@property (nonatomic,strong) NSString *cellId;
@property (nonatomic, strong) UIBarButtonItem *rButton;

- (void)startSpinner;
- (void)stopSpinner;

@end
