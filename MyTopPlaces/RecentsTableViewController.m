//
//  RecentsTableViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "RecentsUserDefaults.h"
#import "PhotoAnnotation.h"
#import "TopPlacesPhotoViewController.h"

@interface  RecentsTableViewController() <MapViewControllerDelegate>
@property (nonatomic, strong) NSDictionary *photoToDisplay;
@end

@implementation RecentsTableViewController
@synthesize mapButton;
@synthesize photoToDisplay=_photoToDisplay;

- (void)awakeFromNib
{
    self.cellId = @"Photos Description";
}

- (NSArray *)retrievePhotoList
{
     self.photos = [[RecentsUserDefaults retrieveRecentsUserDefaults] mutableCopy]; 
     return self.photos;
}


- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
     [self.tableView reloadData];
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
        [self performSegueWithIdentifier:@"Show ResPhoto" sender:self.photoToDisplay];
    //-----------------------------------------------------
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show ResPhoto"])
    {
        if (self.view.window)
        {
          NSIndexPath *path = [self.tableView indexPathForSelectedRow];
          NSDictionary *photo = [self.photos objectAtIndex:path.row];
         [segue.destinationViewController setPhoto:photo];
         [[segue.destinationViewController navigationItem] setTitle:[[sender textLabel] text]];
         UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
         [segue.destinationViewController setTitle : cell.textLabel.text];
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
- (void)viewDidUnload {
    [self setMapButton:nil];
    [super viewDidUnload];
}
@end
