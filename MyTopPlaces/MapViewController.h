//
//  MapViewController.h
//  MyTopPlaces5
//
//  Created by Tatiana Kornilova on 8/7/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

-(NSData *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation;
- (void)segueForAnnotation:(id<MKAnnotation>)annotation;

@end

@interface MapViewController : UIViewController
@property (nonatomic,strong) NSArray *annotations; // of id <MKAnnotations  
@property (nonatomic,weak) id <MapViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeChanged;

@end
