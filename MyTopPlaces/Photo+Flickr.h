//
//  Photo+Flickr.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/14/12.
//
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoFromFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Photo *)exisitingPhotoWithID:(NSString *)photoID
         inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)removePhoto:(Photo *)photo;
+ (void)removePhotoWithID:(NSString *)photoID
   inManagedObjectContext:(NSManagedObjectContext *)context;

@end
