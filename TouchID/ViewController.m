//
//  ViewController.m
//  TouchID
//
//  Created by 微知 on 2017/2/22.
//  Copyright © 2017年 Jame. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@property (nonatomic, strong) LAContext *context;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)touchIDClick:(id)sender
{
    self.context = [[LAContext alloc] init];
    NSError *error = nil;

    BOOL flag = [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (flag) {
        
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹" reply:^(BOOL success, NSError *error) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.statusLabel.text = @"验证成功，主线程处理UI";
                }];
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"系统取消授权，如其他APP切入";
                        }];
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"用户取消验证Touch ID";
                        }];
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"授权失败";
                        }];
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"系统未设置密码";
                        }];
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"设备Touch ID不可用，例如未打开";
                        }];
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"设备Touch ID不可用，用户未录入";
                        }];
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"用户选择输入密码，切换主线程处理";
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            self.statusLabel.text = @"其他情况，切换主线程处理";
                        }];
                        break;
                    }
                }
            }
        }];

    }else{
        NSString *errorString = [[NSString alloc] init];
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                errorString = @"TouchID is not enrolled";
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                errorString = @"A passcode has not been set";
                break;
            }
            default:
            {
                errorString = @"TouchID not available";
                break;
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.statusLabel.text = [NSString stringWithFormat:@"%@\n%@",errorString,error.localizedDescription];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
