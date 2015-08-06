//
//  ResetPasswordViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "ResetPasswordViewController.h"

#import "RegisterViewController.h"

#define SendPassword_URl @"http://api.kuaikanmanhua.com/v1/account/reset_password/by_phone"

@interface ResetPasswordViewController ()<UITextFieldDelegate>
{
    UIAlertView *_alertView;
}
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"密码要大于等于8位,请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_alertView];
}

//完成
- (IBAction)successButton:(id)sender {
    
    if (_myTextField.text.length >= 8) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //提交密码
        [manager POST:SendPassword_URl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            //上传密码
            
            [formData appendPartWithFormData:[_myTextField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];

            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"上传重置密码成功 = %@",responseObject);
            
            //跳转到登录
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"上传重置密码失败error = %@",error);
            
            
        }];

    }else{
        
        [_alertView show];
    }
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
