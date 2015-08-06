//
//  UserDataViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "UserDataViewController.h"

#import "UserHeadTableViewCell.h"
#import "UserTableViewCell.h"
#import "AlbumViewController.h"

@interface UserDataViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation UserDataViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
}

-(void)getData{
    
    [[HttpRequestManager shareInstance] getUserDataNeedID:_idString andSuccess:^(id object) {
        
        [self addUserData:object];
        
        _dataArray = object[@"topics"];
        
        [_MyTableView reloadData];
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取用户信息失败,error = %@",error);
    }];
}

-(void)addUserData:(id)object{
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:object[@"avatar_url"]]];
    
    _backButton.layer.masksToBounds = YES;
    
    _backButton.layer.cornerRadius = 15;
    
    _userImageView.layer.masksToBounds = YES;
    
    _userImageView.layer.cornerRadius = 25;
    
    _userNameLabel.text = object[@"nickname"];
    
    _introLabel.text = object[@"intro"];
}

#pragma mark- TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UserHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserHeadTableViewCell"];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
    
    cell.dic = _dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    AlbumViewController *vc = [story instantiateViewControllerWithIdentifier:@"Album"];
    
    vc.idString = _dataArray[indexPath.row][@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView ==_MyTableView)
    {
        CGFloat sectionHeaderHeight = 30;
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
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
