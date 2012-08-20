//
//  PhotoAnnotation.h
//  MyTopPlaces5
//
//  Created by Tatiana Kornilova on 8/7/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PhotoAnnotation : NSObject <MKAnnotation>
+ (PhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo; //Flickr photo dictionary
@property (nonatomic,strong) NSDictionary *photo;
@end
