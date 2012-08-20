//
//  VacationPhotosTableViewController.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import "VacationPhotosTableViewController.h"
#import "VacationHelper.h"
#import "Photo.h"
#import "FlickrFetcher.h"

@interface VacationPhotosTableViewController ()

@end

@implementation VacationPhotosTableViewController

@synthesize vacation = _vacation;
@synthesize place = _place;
@synthesize tag = _tag;

- (void)setPlace:(Place *)place
{
    if (_place == place) return;
    _place = place;
    if (!_place) return;
    self.title = place.name;
    self.tag = nil;
}

- (void)setTag:(Tag *)tag
{
    if (_tag == tag) return;
    _tag = tag;
    if (!_tag) return;
    self.title = tag.name;
    self.place = nil;
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES
                                                              selector:
                                @selector(localizedCaseInsensitiveCompare:)]];
    NSManagedObjectContext *context;
    if (self.place) {
        request.predicate = [NSPredicate predicateWithFormat:@"place.name = %@", self.place.name];
        context = self.place.managedObjectContext;
    }
    if (self.tag) {
        request.predicate = [NSPredicate predicateWithFormat:@"%@ in tags", self.tag];
        context = self.tag.managedObjectContext;
    }
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:context
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}


#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        // create a photo dictionary object to segue to PhotoViewController
        NSDictionary *photoDict = [NSDictionary dictionaryWithObjectsAndKeys:photo.unique,FLICKR_PHOTO_ID,photo.imageURL,@"imageURL", photo.title,FLICKR_PHOTO_TITLE,nil];
        [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photoDict];
        [segue.destinationViewController performSelector:@selector(setPhotoTitle:) withObject:photo.title];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [VacationHelper openVacation:self.vacation usingBlock:^(BOOL success) {
        [self setupFetchedResultsController];
    }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title ;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc respondsToSelector:@selector(setPhoto:)]) {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        // create a photo dictionary object to segue to PhotoViewController
        NSDictionary *photoDict = [NSDictionary dictionaryWithObjectsAndKeys:photo.unique,FLICKR_PHOTO_ID,photo.imageURL,@"imageURL", photo.title, @"title",nil];
        [vc performSelector:@selector(setPhoto:) withObject:photoDict];
        [vc performSelector:@selector(setPhotoTitle:) withObject:photo.title];
    }
}

@end
