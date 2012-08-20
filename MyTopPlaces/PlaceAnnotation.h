//
//  PlaceAnnotation.h
//  MyTopPlaces5map
//
//  Created by Tatiana Kornilova on 8/8/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic,strong) NSDictionary *place;
+ (PlaceAnnotation *)annotationForPlace:(NSDictionary *)place;

@end
