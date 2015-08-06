//
//  MyWillRegisterViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "MyWillRegisterViewController.h"


#import "ValidationViewController.h"

//发送验证码链接
#define SendSMS_URl @"http://api.kuaikanmanhua.com/v1/phone/send_code"

@interface MyWillRegisterViewController ()
{
    UIAlertView *_alertView;
}
@end

@implementation MyWillRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_titleString.length > 1) {
        
        _title_Label.text = _titleString;
    }else{
        
        _title_Label.text = @"注 册";
    }
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手机号码输入有误,请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_alertView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

//用正则表达式判断电话号
- (IBAction)buttonAction:(UIButton *)sender {
    
    NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:_myTextField.text];
    
    if (isMatch) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        
            //发送注册验证码
            [manager POST:SendSMS_URl parameters:@{@"phone":_myTextField.text,@"reason":@"register"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"发送验证码成功");
                
                //跳转到短信验证码输入
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
                
                ValidationViewController *vc = [story instantiateViewControllerWithIdentifier:@"ValidationViewController"];
                
                vc.phoneString =  _myTextField.text;
                
                vc.resetOrSetString = _titleString;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"发送验证码失败,error=%@",error);
            }];


    }else{
        
        [_alertView show];
    }
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
