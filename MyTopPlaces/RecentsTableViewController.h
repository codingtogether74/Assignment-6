//
//  RecentsTableViewController.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "MapViewController.h"

@interface RecentsTableViewController : PhotoTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;

@end
