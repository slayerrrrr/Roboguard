//
//  FirstViewController.h
//  RoboGuard
//
//  Created by slayer on 8/15/13.
//  Copyright (c) 2013 slayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

NSMutableArray *abContactArray;
NSMutableArray *abContactFirstNameArray;


@interface FirstViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>{

// IBOutlet UINavigationController *navigationController;

    __weak IBOutlet UIBarButtonItem *addContactButton;
    __weak IBOutlet UINavigationBar *navigationBar;
}


@property (nonatomic, retain) NSMutableArray *abContactArray;
@property (nonatomic, retain) NSMutableArray *abContactFirstNameArray;
@property (weak,nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak,nonatomic) IBOutlet UIBarButtonItem* addContactButton;


-(void)createContactGroup;
-(void)copyDataFromAddressBook;
-(IBAction)addContactButtonPressed:(id)sender;
//-(void)addPersonToGroup;
@end
