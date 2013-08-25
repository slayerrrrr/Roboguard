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

@interface FirstViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) NSMutableArray *abContactArray;
@property (nonatomic, retain) NSMutableArray *abContactFirstNameArray;



-(void)createContactGroup;
-(void)copyDataFromAddressBook;
@end
