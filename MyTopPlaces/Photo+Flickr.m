//
//  Photo+Flickr.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/14/12.
//
//

#import "Photo+Flickr.h"
#import "Place+Create.h"
#import "Tag+Create.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)
+ (Photo *)photoFromFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",
                         [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1 || error)) {
        NSLog(@"Error in photoFromFlickrInfo: %@ %@", matches, error);
    } else if ([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo
                                              format:FlickrPhotoFormatLarge]
                          absoluteString];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.place = [Place placeFromFlickrInfo:flickrInfo
                          inManagedObjectContext:context];
        photo.tags = [Tag tagsFromFlickrInfo:flickrInfo
                      inManagedObjectContext:context];
    } else {
        photo = [matches lastObject];
    }
    return photo;
}

+ (Photo *)exisitingPhotoWithID:(NSString *)photoID
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", photoID];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1 || error)) {
        NSLog(@"Error in exisitingPhotoForID: %@ %@", matches, error);
    } else if ([matches count] == 0) {
        photo = nil;
    } else {
        photo = [matches lastObject];
    }
    return photo;
}

+ (void)removePhoto:(Photo *)photo
{
    NSManagedObjectContext *context = photo.managedObjectContext;
    // tags and place could be put in prepareForDeletion
    for (Tag *tag in photo.tags) {
        if ([tag.photos count] == 1) [context deleteObject:tag];
        else tag.count = [NSNumber numberWithInt:[tag.photos count] - 1];
    }
    if ([photo.place.photos count] == 1) [context deleteObject:photo.place];
    [context deleteObject:photo];
}

+ (void)removePhotoWithID:(NSString *)photoID
   inManagedObjectContext:(NSManagedObjectContext *)context
{
    [Photo removePhoto:[Photo exisitingPhotoWithID:photoID inManagedObjectContext:context]];
}

@end
