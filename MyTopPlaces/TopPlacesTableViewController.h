//
//  TopPlacesTableViewController.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface TopPlacesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshPress;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (nonatomic, strong) NSArray *topPlaces;

@end
