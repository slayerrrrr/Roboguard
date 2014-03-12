//
//  SecondViewController.m
//  RoboGuard
//
//  Created by slayer on 8/15/13.
//  Copyright (c) 2013 slayer. All rights reserved.
//

#import "SecondViewController.h"

//@interface SecondViewController ()
//@interface SecondViewController: UIViewController <MFMailComposeViewControllerDelegate>

//@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)sendMessageButtonPressed:(id)sender{

    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil){
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            
            picker.messageComposeDelegate = self;
            picker.navigationBar.tintColor = [UIColor blackColor];
//            picker.body = [infoDictionary objectForKey:@"title"];
//            [self presentViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:nil];

        }
        else{
            UIAlertView * smsCheck = [[UIAlertView alloc] initWithTitle:@"请检查短信配置" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            smsCheck.frame = CGRectMake(50, 150, 100, 90);
            [smsCheck show];
//            [smsCheck release];
        }
    }
    else {
        UIAlertView * smsCheck = [[UIAlertView alloc] initWithTitle:@"已复制文章内容,可用短信发送" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        smsCheck.frame = CGRectMake(50, 150, 100, 90);
        [smsCheck show];
//        [smsCheck release];
    }



}
-(IBAction)sendMailButtonPressed:(id)sender{

    //判断是否可以发布mail
    if( [MFMailComposeViewController canSendMail] ){
        //用MFMailComposeViewController推进到发送电子邮件界面
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
//        //设定电子邮件的内容
//        [controller setMessageBody:sharedContent isHTML:NO];
//        [controller setSubject:[infoDic objectForKey:@"title"]];
//        [controller addAttachmentData:UIImageJPEGRepresentation(sharedImage, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
        
//        [self presentViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
//        [controller release];
    }
    else {
        //弹出警告框提示用户不能发布mail
        UIAlertView * mailAlert = [[UIAlertView alloc] initWithTitle:@"请确认邮箱配置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        mailAlert.frame = CGRectMake(50, 150, 100, 90);
        [mailAlert show];
//        [mailAlert release];
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	    [self dismissViewControllerAnimated:YES completion:nil];
}



//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
