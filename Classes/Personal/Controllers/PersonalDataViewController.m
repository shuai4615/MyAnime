//
//  PersonalDataViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "SetHeadImageViewController.h"


//登录
#define UPLOAD_URL @"http://api.kuaikanmanhua.com/v1/phone/signin"

//上传头像链接
#define upData_URL @"http://api.kuaikanmanhua.com/v1/account/update"

@interface PersonalDataViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIAlertView *_AlertView;
    
    NSUInteger _num;
    
    NSString *_str;//用户名
}
@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}


-(void)creatUI{
    
    [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:_userHeadString]];
    
    _userHeadImageView.layer.masksToBounds = YES;
    
    _userHeadImageView.layer.cornerRadius = _userHeadImageView.bounds.size.height/2;
    
    _userNameTF.placeholder = _userNameString;
    
    _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction:)];
    
    [_userHeadImageView addGestureRecognizer:tap];
    
    _AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_AlertView];

}

-(void)gesAction:(UIGestureRecognizer *)ges{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    SetHeadImageViewController *vc = [story instantiateViewControllerWithIdentifier:@"SetHeadImageViewController"];
    
    //选择的默认头像
    vc.block = ^(NSInteger number){
        
        _userHeadImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",number]];
    };

    //从相册选取的图片
    vc.photoLibraryBlock = ^(UIImage *image){
      
        _userHeadImageView.image = image;
    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

//完成
- (IBAction)successAction:(UIButton *)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:UPLOAD_URL parameters:@{@"phone":_phoneString,@"password":_passwordString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![responseObject[@"message"] isEqualToString:@"bad_request"]) {
    
            
            [manager POST:upData_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                _str = nil;
                                
                if (_userNameTF.text.length == 0) {
                    
                    _str = _userNameString;
                }else{
                    
                    _str = _userNameTF.text;
                }
                
                
                
                //上传昵称
                [formData appendPartWithFormData:[_str dataUsingEncoding:NSUTF8StringEncoding] name:@"nickname"];
                
                
                //上传图片所转化的二进制
                NSData *imageData = UIImageJPEGRepresentation(_userHeadImageView.image, 0.01);
                [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"1.jpg" mimeType:@"image/jpeg"];
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"上传成功");
                
                [_AlertView show];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"上传失败,error=%@",error);
                
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [self.view addSubview:view];
                
                [view show];
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"登录失败");
    }];
    
}

//修改成功返回
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == _AlertView) {
        

        //调用代理的方法
        if (_delegate && [_delegate respondsToSelector:@selector(getUserData)]) {
            
            [_delegate getUserData];
        }
        
        
        self.tabBarController.tabBar.hidden = NO;
        
        [self.navigationController popViewControllerAnimated:YES];

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

//返回
- (IBAction)back:(UIButton *)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
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
