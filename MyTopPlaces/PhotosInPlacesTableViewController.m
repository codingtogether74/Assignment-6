//
//  PhotosInPlacesTableViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosInPlacesTableViewController.h"
#import "RecentsUserDefaults.h"
#import "PhotoAnnotation.h"
#import "TopPlacesPhotoViewController.h"

@interface PhotosInPlacesTableViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) NSDictionary *photoToDisplay;
@end

@implementation PhotosInPlacesTableViewController

@synthesize mapButton;
@synthesize photoToDisplay=_photoToDisplay;
@synthesize place=_place;

- (void)awakeFromNib
{
    self.cellId = @"Photos Description";
}

#define MAX_RESULTS 50

- (NSMutableArray *)retrievePhotoList
{
    [self startSpinner];
    dispatch_queue_t photoListFetchingQueue =
    dispatch_queue_create("photo list fetching queue", NULL);
    
    dispatch_async(photoListFetchingQueue, ^{
        if (self.photos)return;
        self.photos = [[FlickrFetcher photosInPlace:self.place
                                        maxResults:MAX_RESULTS] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopSpinner];
            [self.tableView reloadData];
        });
    });
    
    dispatch_release(photoListFetchingQueue);
   
    return nil;
}

- (void)viewDidUnload
{
    [self setMapButton:nil];
    [super viewDidUnload];
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos){
        [annotations addObject:[PhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

#pragma mark - MapViewControllerDelegate

- (NSData *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    PhotoAnnotation *fpa = (PhotoAnnotation *)annotation;
       NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return data;
}

-(void)segueForAnnotation:(id <MKAnnotation>)annotation
{

    PhotoAnnotation *fpa = (PhotoAnnotation *)annotation;
    self.photoToDisplay=fpa.photo;
    //---------------------------------------------------
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[TopPlacesPhotoViewController class]])
        [vc setPhoto:self.photoToDisplay];
    else
        [self performSegueWithIdentifier:@"Show Photo" sender:self.photoToDisplay];
//-----------------------------------------------------
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.destinationViewController isKindOfClass:[TopPlacesPhotoViewController class]])
    if ([segue.identifier isEqualToString:@"Show Photo"])
    {
        if (self.view.window)
        {
           NSIndexPath *path = [self.tableView indexPathForSelectedRow];
           NSDictionary *photo = [self.photos objectAtIndex:path.row];
           [segue.destinationViewController setPhoto:photo];
           [[segue.destinationViewController navigationItem] setTitle:[[sender textLabel] text]];
           UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
           [segue.destinationViewController setPhotoTitle : cell.textLabel.text];
           [RecentsUserDefaults saveRecentsUserDefaults:photo];
        }else
        {
            [segue.destinationViewController setPhoto:self.photoToDisplay];
        }
    }
   else if ([segue.destinationViewController isKindOfClass:[MapViewController class]])
    
    {
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.annotations = [self mapAnnotations];
        mapVC.delegate = self;
        mapVC.title = self.title;
    }
    
    [super prepareForSegue:segue sender:sender];
   
}

@end
