//
//  IdeaViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "IdeaViewController.h"

#define Idea_URL @"http://api.kuaikanmanhua.com/v1/feedbacks"

@interface IdeaViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    NSInteger _number;
}
@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


//发送
- (IBAction)sendAction:(id)sender {
    
    NSString *str = _myTextView.text;
    
    if (str.length == 0) {
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"亲,写个反馈嘛" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [self.view addSubview:view];
        
        [view show];
        
        return;
    }else{
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dic = @{@"device":@"Xiaomi-mione_plus",@"os":@"16",@"resolution":@"480-854",@"version":@"2.1.3",@"contact":@""};
        
        [manager POST:Idea_URL parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
            //上传pinglun
            [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            _number = 9;
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"感谢亲给我们的意见^_^" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"意见反馈失败,error=%@",error);
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"反馈失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];
        }];
        
    }
    
}

- (void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [_textLabel setHidden:NO];
    }else{
        
        [_textLabel setHidden:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_number == 9) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
//    self.tabBarController.tabBar.hidden = YES;
}

//反回
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
