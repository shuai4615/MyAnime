//
//  PersonalViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "PersonalViewController.h"

#import "RegisterViewController.h"
#import "SetViewController.h"
#import "PersonalDataViewController.h"
#import "SetPasswordViewController.h"
#import "TodayParticularsViewController.h"
#import "AlbumViewController.h"
#import "LeftTableViewCell.h"
#import "rightTableViewCell.h"

#import "GroupLastTableViewCell.h"

#define UPLOAD_URL @"http://api.kuaikanmanhua.com/v1/phone/signin"


@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    RegisterViewController *_vc;
    
    NSDictionary *_dic;
    
    AppDelegate *_pp;
    
    NSString *_phoneString;
    
    NSString *_passwordString;
    
    UITableView *_leftTAbleView;
    
    UITableView *_rightTableView;
    
    NSMutableArray *_leftArray;
    
    NSMutableArray *_rightArray;
    
    UIAlertView *_alertView;
    
    NSInteger _number;//判断删除成功后刷新哪个tableView
    
    UIAlertView *_leftAlertView;
    
    UIAlertView *_rightAlertView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@end

@implementation PersonalViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _dic = [[NSDictionary alloc] init];
        
        _leftArray = [[NSMutableArray alloc] init];
        
        _rightArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self logeAction];
    
    [self creatTableView];
    
    [_leftTAbleView reloadData];
    
    [_rightTableView reloadData];

}

-(void)creatTableView{
    
    //可视区域
    _myScrollView.contentSize = CGSizeMake(640, _myScrollView.bounds.size.height);
    
    _myScrollView.pagingEnabled = YES;
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
        
    //左tableView
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        
        _leftTAbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, _myScrollView.bounds.size.height-88)];
    }else{
        
        _leftTAbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, _myScrollView.bounds.size.height)];
        
    }
    
    
    _leftTAbleView.delegate = self;
    
    _leftTAbleView.dataSource = self;
    
    _leftTAbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _leftTAbleView.showsVerticalScrollIndicator = NO;
    
    [_leftTAbleView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftTableViewCell"];
    
    [_myScrollView addSubview:_leftTAbleView];
    
    //右tableView
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, _myScrollView.bounds.size.height-88)];
    }else{
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, _myScrollView.bounds.size.height)];
    }
    
    _rightTableView.delegate = self;
    
    _rightTableView.dataSource = self;
    
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _rightTableView.showsVerticalScrollIndicator = NO;
    
    [_rightTableView registerNib:[UINib nibWithNibName:@"rightTableViewCell" bundle:nil] forCellReuseIdentifier:@"rightTableViewCell"];
    
    [_myScrollView addSubview:_rightTableView];
    
    
}

-(void)getData{
    
    [_leftArray removeAllObjects];
    
    [_rightArray removeAllObjects];
    
    //2  单篇
    if ([[DataBase sharedManager] selectHomeDataandFlag:2]) {
        
        NSArray *array = [[DataBase sharedManager] getCollectDataandFlag:2];
        
        for (NSData *data in array) {
            
            [_leftArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        }
        
    }
    
    //3  专辑
    if ([[DataBase sharedManager] selectHomeDataandFlag:3]) {
        
        NSArray *array = [[DataBase sharedManager] getCollectDataandFlag:3];
        
        for (NSData *data in array) {
            
            [_rightArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        }
        
    }
    
    [_leftTAbleView reloadData];
    
    [_rightTableView reloadData];
    
}

-(void)logeAction{
    
    _leftAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空收藏单篇吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _rightAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空收藏专题吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction:)];
    
    [_userHeadImageView addGestureRecognizer:tap];
    
    _userHeadImageView.layer.masksToBounds = YES;
    
    _userHeadImageView.layer.cornerRadius = _userHeadImageView.frame.size.height/2;
    
    _userHeadImageView.layer.borderWidth = 1;
    
    _userHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark- TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView == _leftTAbleView) {
        
        return _leftArray.count;
    }else{
        
        return _rightArray.count;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    GroupLastTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupLastTableViewCell" owner:self options:0][0];
    
    if (tableView == _leftTAbleView) {
        
        //如果没数据,组尾不添加
        if (_leftArray.count == 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            
            return view;
            
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesLeftAction:)];
        
        [cell.cleanLabel addGestureRecognizer:tap];
        
    }else{
        
        //如果没数据,组尾不添加
        if (_rightArray.count == 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            
            return view;
            
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesRightAction:)];
        
        [cell.cleanLabel addGestureRecognizer:tap];
        
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTAbleView) {
        
        return 80;
    }else{
        
        return 70;
    }
    
}

//组头跟着表走
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView ==_leftTAbleView || scrollView == _rightTableView)
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTAbleView) {
        
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableViewCell"];
        
        cell.dic = _leftArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        rightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightTableViewCell"];
        
        cell.dic = _rightArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    if (tableView == _leftTAbleView) {
        
        //获取storyboard中的今日详情页面
        TodayParticularsViewController * vc = [story instantiateViewControllerWithIdentifier:@"TodayParticulars"];
        
        NSDictionary *dic = _leftArray[indexPath.row];
        
        vc.idString = [dic[@"id"] stringValue];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        //获取storyboard中的专辑页面
        AlbumViewController *vc = [story instantiateViewControllerWithIdentifier:@"Album"];
        
        NSDictionary *dic = _rightArray[indexPath.row];
        
        vc.idString = [dic[@"id"] stringValue];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//点击头像跳转
-(void)gesAction:(UIGestureRecognizer *)ges{
    
    //yes 已登录
    if (!_pp.loginFlag) {
        
        [self.navigationController pushViewController:_vc animated:YES];//登录页面
    }else{
        
        //设置用户信息界面
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
        
        PersonalDataViewController *vc = [story instantiateViewControllerWithIdentifier:@"PersonalDataViewController"];
        
        //设置代理
        vc.delegate = self;
        
        vc.userHeadString = _dic[@"avatar_url"];
        
        vc.userNameString = _dic[@"nickname"];
        
        vc.phoneString = _phoneString;
        
        vc.passwordString = _passwordString;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)creatUI{
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"删除收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"queding", nil];
    
    [self.view addSubview:_alertView];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    _vc = [story instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    
    __weak UIImageView *imgView = _userHeadImageView;
    
    __weak UILabel *nameLabel = _userNameLabel;
    
    //登录成功的回调
    _vc.block = ^(NSDictionary *dic,NSString *phone,NSString *passwordString){
        
        _phoneString = phone;
        
        _passwordString = passwordString;
        
        _dic = dic;
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar_url"]]];
        
        nameLabel.text = dic[@"nickname"];
        
    };
    
    //注册成功的回调
    SetPasswordViewController *vc = [story instantiateViewControllerWithIdentifier:@"SetPasswordViewController"];
    
    vc.block = ^(NSDictionary *dic){
        
        _dic = dic;
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar_url"]]];
        
        nameLabel.text = dic[@"nickname"];
        
    };
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    //获取收藏数据,刷新
    [self getData];
    
    [_leftTAbleView reloadData];
    
    [_rightTableView reloadData];
    
}

//点击收藏单篇
- (IBAction)leftBack:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _yellowLabel.frame = CGRectMake(0, _yellowLabel.frame.origin.y, _yellowLabel.frame.size.width, _yellowLabel.frame.size.height);
        
        _myScrollView.contentOffset = CGPointMake(0, 0);
    }];
}


//点击收藏专题
- (IBAction)rightBack:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _yellowLabel.frame = CGRectMake(160, _yellowLabel.frame.origin.y, _yellowLabel.frame.size.width, _yellowLabel.frame.size.height);
        
        _myScrollView.contentOffset = CGPointMake(320, 0);
    }];
    
}

//滑动事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _myScrollView) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _yellowLabel.frame = CGRectMake(scrollView.contentOffset.x/2, _yellowLabel.frame.origin.y, _yellowLabel.frame.size.width, _yellowLabel.frame.size.height);
            
        }];
        
    }
    
}

//清除事件
-(void)gesLeftAction:(UIGestureRecognizer *)ges{
    
    [_leftAlertView show];
}

-(void)gesRightAction:(UIGestureRecognizer *)ges{
    
    [_rightAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_number == 1) {
        
        [_leftTAbleView reloadData];
    }else{
        
        [_rightTableView reloadData];
    }
    
    //判断清除哪个收藏
    if (alertView == _leftAlertView && buttonIndex == 1) {
        
        [[DataBase sharedManager] deleteCollectDataFlag:2];//单篇
        
        [_leftArray removeAllObjects];
        
        _number = 1;
        
        [_leftTAbleView reloadData];
        
    }
    
    if (alertView == _rightAlertView && buttonIndex == 1) {
        
        [[DataBase sharedManager] deleteCollectDataFlag:3];//专题
        
        [_rightArray removeAllObjects];
        
        _number = 2;
        
        [_rightTableView reloadData];
        
    }
    
    
}

#pragma 遵守协议的代理方法

//修改个人信息,从新获取数据
-(void)getUserData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //登录
    [manager POST:UPLOAD_URL parameters:@{@"phone":_phoneString,@"password":_passwordString} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录成功 = %@",responseObject);
        
        [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"avatar_url"]]];
        
        _userNameLabel.text = responseObject[@"data"][@"nickname"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登录失败error = %@",error);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

//向block中传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SetViewController *vc1 = (SetViewController*)segue.destinationViewController;
    
    vc1.block = ^(void){
        _userHeadImageView.image = [UIImage imageNamed:@"user_Head.png"];
        
        _userNameLabel.text = @"未登录";
    };
    
}

@end
