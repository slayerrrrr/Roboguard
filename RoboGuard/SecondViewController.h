//
//  SecondViewController.h
//  RoboGuard
//
//  Created by slayer on 8/15/13.
//  Copyright (c) 2013 slayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SecondViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;


-(IBAction)sendMailButtonPressed:(id)sender;

-(IBAction)sendMessageButtonPressed:(id)sender;
@end
