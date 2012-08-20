//
//  PopoverVacationsTableViewController.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@class PopoverVacationsTableViewController;

@protocol PopoverVacationsTableViewControllerDelegate <NSObject> // added <NSObject> after lecture

@optional
-(void)PopoverVacationsTableViewController :(PopoverVacationsTableViewController *)sender
choseVacation:(NSString *)vacation;

@end

@interface PopoverVacationsTableViewController : UITableViewController
@property (nonatomic,strong) NSArray *vacations;
@property (nonatomic) BOOL unvisit;
@property (nonatomic,weak) id <PopoverVacationsTableViewControllerDelegate> delegate;
@end
