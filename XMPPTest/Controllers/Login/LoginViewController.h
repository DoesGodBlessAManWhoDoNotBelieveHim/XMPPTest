//
//  LoginViewController.h
//  XMPPTest
//
//  Created by wrt on 15/8/24.
//  Copyright (c) 2015年 wrtsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *headIV;
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;



- (IBAction)loginAction;


- (IBAction)newCustomerAction;
@end
