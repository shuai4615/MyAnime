//
//  SearchViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchResultViewController.h"

@interface SearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.testView.frame = CGRectMake(0, 20, 320, 49);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    
    self.tabBarController.tabBar.hidden = YES;
    
    _myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark- 输入框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    SearchResultViewController *vc = [story instantiateViewControllerWithIdentifier:@"SearchResultViewController"];

    vc.keyString = textField.text;
    
    vc.number = 2;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}

//单个的按钮搜索
- (IBAction)searchButton:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    SearchResultViewController *vc = [story instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    
    switch (sender.tag) {
        case 1:
            vc.keyString = @"少女";
            break;
        case 2:
            vc.keyString = @"新专栏";
            break;
        case 3:
            vc.keyString = @"恐怖";
            break;
        case 4:
            vc.keyString = @"日常";
            break;
        case 5:
            vc.keyString = @"HOT";
            break;
        case 6:
            vc.keyString = @"治愈";
            break;
        case 7:
            vc.keyString = @"奇幻";
            break;
            
    }
    
    vc.number = 1;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)back:(id)sender {
    
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
