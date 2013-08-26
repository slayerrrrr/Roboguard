//
//  FirstViewController.m
//  RoboGuard
//
//  Created by slayer on 8/15/13.
//  Copyright (c) 2013 slayer. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
//    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


- (void)setupViewWithContactsData
{
    // Do Something
    NSLog(@"setup success");
}

- (void)setupViewWithoutContactsData
{
    // Do Something because Contacts Access has been Denied or Error Occurred
    NSLog(@"setup failed");
}




- (void)viewDidLoad
{
    [super viewDidLoad];
     self.abContactFirstNameArray=[[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
//    [self askAccessToAddressBook];
    [self createContactGroup];
    [self copyDataFromAddressBook];
}

//-(void) askAccessToAddressBook{

//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);

//    if (ABAddressBookRequestAccessWithCompletion == NULL)
//    {
//        // iOS5 or Below
//        [self setupViewWithContactsData];
//        return;
//    }
//    else
//    {
//        // iOS6
//        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
//        {
//            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//                if(error)
//                {
//                    [self setupViewWithoutContactsData];
//                }
//                else
//                {
//                    [self setupViewWithContactsData];
//                }
//            });
//        }
//        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
//        {
//            [self setupViewWithContactsData];
//        }
//        else
//        {
//            [self setupViewWithoutContactsData];
//        }
//    }

//}

//-(void) createContactGroup:(NSString*)groupName {
-(void) createContactGroup{
    bool foundIt = NO;
    

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    
    
    CFArrayRef groups = ABAddressBookCopyArrayOfAllGroups(addressBook);
    CFIndex numGroups = CFArrayGetCount(groups);
    for(CFIndex idx=0; idx<numGroups; ++idx) {
        ABRecordRef groupItem = CFArrayGetValueAtIndex(groups, idx);
        
        CFStringRef name = (CFStringRef)ABRecordCopyValue(groupItem, kABGroupNameProperty);
        //NSLog(@"Look at group named %@", name);
        bool isMatch = [@"RoboGuard" isEqualToString:(__bridge NSString *)name];
        CFRelease(name);
        
        if(isMatch) {
//             NSLog(@"FOUND THE GROUP ALREADY!");
            NSNumber *groupNum = [NSNumber numberWithInt:ABRecordGetRecordID(groupItem)];
//            [self setObject:groupNum forKey:kGroupID];
            foundIt = YES;
            break;
        }
    }
    CFRelease(groups);
    
        if(!foundIt){
    
            ABRecordRef newGroup = ABGroupCreate();
            ABRecordSetValue(newGroup, kABGroupNameProperty,@"RoboGuard", nil);
            ABAddressBookAddRecord(addressBook, newGroup, nil);
            ABAddressBookSave(addressBook, nil);
            CFRelease(addressBook);
    
            //!!! important - save groupID for later use
            NSInteger *groupId = ABRecordGetRecordID(newGroup);
            CFRelease(newGroup);
                }
}

-(void) copyDataFromAddressBook{

    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    
    if (ABAddressBookRequestAccessWithCompletion == NULL)
    {
        // iOS5 or Below
        [self setupViewWithContactsData];
        return;
    }
    else
    {
        // iOS6
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if(error)
                {
                    [self setupViewWithoutContactsData];
                }
                else
                {
                    [self setupViewWithContactsData];
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            [self setupViewWithContactsData];
        }
        else
        {
            [self setupViewWithoutContactsData];
        }
    }
    //ask access to addressbook

    self.abContactArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef); // get address book contact array

    for(NSUInteger loop= 0 ; loop < [self.abContactArray count]; loop++)
    {
        ABRecordRef record = (__bridge ABRecordRef)[self.abContactArray objectAtIndex:loop]; // get address book record
        
        if(ABRecordGetRecordType(record) ==  kABPersonType) // this check execute if it is person group
        {


            NSMutableDictionary *dicContact=[[NSMutableDictionary alloc] init];
            NSString *str=(__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)([self.abContactArray objectAtIndex:loop]), kABPersonFirstNameProperty);

            if(str==nil){
                [dicContact setObject:@"no name availible" forKey:@"name"];
            
            }
            else{
            [dicContact setObject:str forKey:@"name"];

            }
            [self.abContactFirstNameArray addObject:dicContact];
            NSLog(@"%@",self.abContactFirstNameArray);
        }
    }
    NSLog(@"%@",self.abContactFirstNameArray);
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.abContactFirstNameArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
	
	//初始化cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier: cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"%@",self.abContactFirstNameArray);
    [self.abContactFirstNameArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    cell.textLabel.text = [[self.abContactFirstNameArray objectAtIndex:indexPath.row] objectForKey:@"name"];

    
    return cell;
}
@end
