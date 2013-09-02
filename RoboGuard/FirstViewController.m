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
//@synthesize
//navigationController =



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
    self.navigationItem.title=@"allowed contact";
     self.abContactFirstNameArray=[[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.

    self.navigationBar.topItem.title=@"allowed callers";


    [self copyDataFromAddressBook];
}



-(void) copyDataFromAddressBook{

    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        bool foundIt = NO;
    
    
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
            NSString *str1= (__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)([self.abContactArray objectAtIndex:loop]), kABPersonLastNameProperty);
            NSString *str2= (__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)([self.abContactArray objectAtIndex:loop]), kABPersonFirstNameProperty);
            

            if(str1==nil){
                str1 = @"";
            }
            if(str2==nil){
                str2 = @"";
            }
            NSString *str= [NSString stringWithFormat:@"%@ %@", str2,str1];
            [dicContact setObject:str forKey:@"name"];
            if(str1!=nil){

             [dicContact setObject:str1 forKey:@"lastname"];
            }
            if(str2!=nil){
                
                [dicContact setObject:str2 forKey:@"firstname"];
                
            }
            
                
                [self.abContactFirstNameArray addObject:dicContact];
//                NSLog(@"%@",self.abContactFirstNameArray);

            if([str isEqualToString:@" "]){
                [dicContact setObject:@"no name availible" forKey:@"name"];
            }

        }
        CFArrayRef groups = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
        CFIndex numGroups = CFArrayGetCount(groups);
        for(CFIndex idx=0; idx<numGroups; ++idx) {
            ABRecordRef groupItem = CFArrayGetValueAtIndex(groups, idx);
            
            CFStringRef name = (CFStringRef)ABRecordCopyValue(groupItem, kABGroupNameProperty);
            //NSLog(@"Look at group named %@", name);
            bool isMatch = [@"RoboGuardTest" isEqualToString:(__bridge NSString *)name];
            CFRelease(name);
            
            if(isMatch) {
                ABGroupAddMember(groupItem, record, nil); // add the person to the group
                //
                ABAddressBookSave(addressBookRef, nil);
                
                foundIt = YES;
                break;
            }

        }
        CFRelease(groups);
        
        if(!foundIt){
            
            ABRecordRef newGroup = ABGroupCreate();
            ABRecordSetValue(newGroup, kABGroupNameProperty,@"RoboGuardTest", nil);
            ABAddressBookAddRecord(addressBookRef, newGroup, nil);
            ABAddressBookSave(addressBookRef, nil);
            CFRelease(addressBookRef);

            
            CFRelease(newGroup);
        }
        
    }
//    NSLog(@"%@",self.abContactFirstNameArray);
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.abContactFirstNameArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
    
    cell.accessoryType = UITableViewCellAccessoryNone;
//    NSLog(@"%@",self.abContactFirstNameArray);
    [self.abContactFirstNameArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES]]];
    
    
    cell.textLabel.text = [[self.abContactFirstNameArray objectAtIndex:indexPath.row] objectForKey:@"name"];

    
    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//NSString *title =@"是否";
//    return title;
//}


-(IBAction)addContactButtonPressed:(id)sender{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];

}


@end
