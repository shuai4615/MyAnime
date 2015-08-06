//
//  RegisterViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "RegisterViewController.h"

#import "MyWillRegisterViewController.h"



#define UPLOAD_URL @"http://api.kuaikanmanhua.com/v1/phone/signin"

@interface RegisterViewController ()<UIAlertViewDelegate>

{
    BOOL _flag;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (IBAction)back:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

//登录
- (IBAction)login:(id)sender {
    
    NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:_phoneTF.text];
    
    if (isMatch) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //登录
        [manager POST:UPLOAD_URL parameters:@{@"phone":_phoneTF.text,@"password":_passwordTF.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            if ([responseObject[@"message"] isEqualToString:@"invalid user or password "]) {
                
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"账号或密码输入有误,请从新输入!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [self.view addSubview:view];
                
                _flag = NO;
                
                [view show];

            }else{
                
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            _flag = YES;
            
            [self.view addSubview:view];
            
            AppDelegate *pp = [UIApplication sharedApplication].delegate;
            
            pp.loginFlag = YES;
            
            //登录成功修改用户头像
            if (_block) {
                
                _block(responseObject[@"data"],_phoneTF.text,_passwordTF.text);//获取到的用户数据
            }
            
            [view show];
            
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"登录失败error = %@",error);
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"账号或密码输入有误,请从新输入!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            _flag = NO;
            
            [view show];
            
        }];
    }else{
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"账号或密码输入有误,请从新输入!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [self.view addSubview:view];
        
        _flag = NO;
        
        [view show];

    }
    
}

//提示登录成功,点击确定
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_flag) {
        
        self.tabBarController.tabBar.hidden = NO;
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
}

//忘记密码按钮
- (IBAction)passWordButton:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    MyWillRegisterViewController *vc = [story instantiateViewControllerWithIdentifier:@"MyWillRegisterViewController"];
    
    vc.titleString = @"忘记密码";
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
