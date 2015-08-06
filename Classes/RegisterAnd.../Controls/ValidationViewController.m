//
//  ValidationViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "ValidationViewController.h"

#import "SetPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "RegisterViewController.h"

//验证短信的链接
#define Validation_URL @"http://api.kuaikanmanhua.com/v1/phone/verify"

//发送注册验证码
#define SendSMS_URl @"http://api.kuaikanmanhua.com/v1/phone/send_code"

//找回密码的验证码
#define ResetPassword_URL @"http://api.kuaikanmanhua.com/v1/phone/verify"

@interface ValidationViewController ()

{
    NSTimer *_timer;
    
    NSInteger _count;
    
    UIAlertView *_alertView;
    
    UIColor *_clolr;
}

@property (weak, nonatomic) IBOutlet UIButton *again_button;


@end

@implementation ValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _count = 59;
    
    _phoneLabel.text = [NSString stringWithFormat:@"已发送验证码短信至%@,请稍后...",_phoneString];
    
    _clolr = [UIColor colorWithRed:254/255.0 green:195/255.0 blue:8/255.0 alpha:1.0];
    
    _again_button.enabled = NO;//不可用
    
    [_again_button setTitle:@"59秒后重新发送" forState:UIControlStateDisabled];
    
    _again_button.backgroundColor = [UIColor lightGrayColor];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"验证码输入有误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_alertView];
}

-(void)timerAction{
    
    _count--;
    
    [_again_button setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_count] forState:UIControlStateDisabled];
    
    if (_count == 0) {
        
        _again_button.enabled = YES;//可用
        
        [_again_button setTitle:@"重新发送" forState:UIControlStateNormal];
        
        _again_button.backgroundColor = _clolr;
        
        _count = 59;
        
        [_timer invalidate];//停止计时
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

//重新发送
- (IBAction)againButton:(UIButton *)sender {
    
    [_again_button setTitle:@"59秒后重新发送" forState:UIControlStateDisabled];
    
    _again_button.backgroundColor = [UIColor lightGrayColor];
    
    _again_button.enabled = NO;

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];//开始计时
    
    
    //发送短信验证码
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:SendSMS_URl parameters:@{@"phone":_phoneString,@"reason":@"register"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"发送验证码成功");
        
        //跳转到短信验证码输入
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
        
        ValidationViewController *vc = [story instantiateViewControllerWithIdentifier:@"ValidationViewController"];
        
        vc.phoneString =  _myTextField.text;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送验证码失败,error=%@",error);
    }];

}



//下一步
- (IBAction)back:(id)sender {
    
    if (_myTextField.text.length == 6) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];

        if (![_resetOrSetString isEqualToString:@"忘记密码"]) {
            
        //跳向注册
        [manager POST:Validation_URL parameters:@{@"phone":_phoneString,@"code":_myTextField.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //跳转到短信验证码输入
            SetPasswordViewController *vc = [story instantiateViewControllerWithIdentifier:@"SetPasswordViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"验证失败error = %@",error);
            
            [_alertView show];
            
        }];
            
        }else{
            
            //跳向重置密码
            [manager POST:ResetPassword_URL parameters:@{@"phone":_phoneString,@"code":_myTextField.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //跳向重置密码
                ResetPasswordViewController *vc = [story instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
                
                vc.phoneString = _phoneString;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"验证失败error = %@",error);
                
                [_alertView show];
                
            }];

            
        }

    }else{
        
        [_alertView show];
    }
}


- (IBAction)back_1:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
