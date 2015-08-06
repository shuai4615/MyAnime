//
//  SetPasswordViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "SetPasswordViewController.h"

#import "PersonalViewController.h"

//上传昵称和密码
#define UpLoadNameAndPassword_URL @"http://api.kuaikanmanhua.com/v1/phone/signup"

@interface SetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *userPasswordTF;



@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)successButton:(UIButton *)sender {
    
    if (_userNameTF.text.length >= 3 && _userPasswordTF.text.length >= 8) {
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:UpLoadNameAndPassword_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            //上传昵称
            [formData appendPartWithFormData:[_userNameTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"nickname"];
            
            //上传密码
            [formData appendPartWithFormData:[_userPasswordTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"上传成功");
            
            //修改我的信息
            if (_block) {
                
                _block(responseObject[@"data"]);
            }
            
            self.tabBarController.tabBar.hidden = NO;
            
            //跳向登录页面
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"注册失败,error=%@",error);
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"此号码已注册,或输入信息有误!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];
        }];
        
    }
    
}

//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)back:(id)sender {
    
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
