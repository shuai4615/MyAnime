//
//  ToDayRecommendViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "ToDayRecommendViewController.h"

#import "TodayRecommendTableViewCell.h"
#import "MJRefresh.h"
#import "AlbumViewController.h"
#import "SearchViewController.h"
#import "UserDataViewController.h"
#import "RegisterViewController.h"
#import "MoreCommentsViewController.h"
#import "TodayParticularsViewController.h"

@interface ToDayRecommendViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray * _dataArray;
    
    NSInteger _offset;
    
    UIStoryboard *_story;
    
    BOOL _flag;//判断刷新
    
    BOOL _likeflag;//判断是否已经点赞
    
    NSInteger _counT;
    
    NSString *_shareUrl;//分享链接
    
    NSString *_shareImage;//分享图片
    
    UIAlertView *_AlertView;//提示请先登录
    
    AppDelegate *_pp;//为真已登录
}

@property (nonatomic, strong) MJRefreshHeaderView *headView;

@property (nonatomic, strong) MJRefreshFooterView *footView;

@property (nonatomic, copy) void (^block)(NSInteger number);

@property (nonatomic, copy) void (^shareBlock)(NSInteger row);

@end

@implementation ToDayRecommendViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _flag = YES;
        
        _likeflag = YES;
        
        _offset = 0;
        
        _counT = 0;
        
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)dealloc{
    
    [_headView free];
    
    [_footView free];
}

-(MJRefreshHeaderView *)headView{
    
    if (_headView == nil) {
        
        _headView = [[MJRefreshHeaderView alloc] init];
        
        _headView.delegate = self;
        
        _headView.scrollView = _MyTableView;
    }
    return _headView;
}

-(MJRefreshFooterView *)footView{
    
    if (_footView == nil) {
        
        _footView = [[MJRefreshFooterView alloc] init];
        
        _footView.delegate = self;
        
        _footView.scrollView = _MyTableView;
    }
    return _footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self getDataFromDataBase];
    
    [self getData];
}

//获取数据库中的数据
-(void)getDataFromDataBase{
    
    if ([[DataBase sharedManager] selectHomeDataandFlag:1]) {
     
        //获取数据库中的数据
        [_dataArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[DataBase sharedManager] getHomeDataandFlag:1]]];
        
        [_MyTableView reloadData];
    }
    
}


-(void)creatUI{
        
    _story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];

    _AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"亲,请先登录哦!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_AlertView];
    
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:220.0/255.0 green:185.0/255.0 blue:10.0/255.0 alpha:1];

    [self.headView endRefreshing];
    
    [self.footView endRefreshing];
}

#pragma maek- 刷新
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    if (refreshView == _headView) {
        
        _offset = 0;
        
        _flag = YES;
    }else{
        
        _offset += 20;
        
        _flag = NO;
    }
    
    [self getData];
    
    [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];
}

-(void)endRefresh:(MJRefreshBaseView *)refreshView{
    
    [refreshView endRefreshing];
}

//获取数据
-(void)getData{
    
    
    [[HttpRequestManager shareInstance] getTodayRecommendNeedOffset:[NSString stringWithFormat:@"%d",_offset] andSuccess:^(id object) {
        
        if (_flag) {
            
            [_dataArray removeAllObjects];
            
            _dataArray = [object mutableCopy];
        }else{
            
            [_dataArray addObjectsFromArray:object];
        }
        
        [_MyTableView reloadData];
        
        //对数据进行归档
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataArray];
        
        //判断数据库中是否存在这个数据
        if ([[DataBase sharedManager] selectHomeDataandFlag:1]) {
            
            [[DataBase sharedManager] upDataHomeData:data andFlag:1];//更新
        }else{
            
            [[DataBase sharedManager] insertHomeData:data andFlag:1 andIDString:nil];//插入
        }
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取今日推荐数据失败,error = %@",error);
    }];
}

#pragma mark- tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取storyboard中的今日详情页面
    TodayParticularsViewController * vc = [_story instantiateViewControllerWithIdentifier:@"TodayParticulars"];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    
    vc.idString = [dic[@"id"] stringValue];
        
    [self.navigationController pushViewController:vc animated:YES];
    
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodayRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayCell"];
    
    cell.TheAlbumButton.tag = indexPath.row + 1;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesUserAction:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesUserAction1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesUserAction2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesUserAction3:)];

    cell.userHeadImageView.tag = indexPath.row + 1000;
    cell.sharedBgView.tag = indexPath.row + 10000;
    cell.likeBgView.tag = indexPath.row + 20000;
    cell.commentsBgView.tag = indexPath.row + 30000;
    
    [cell.userHeadImageView addGestureRecognizer:tap];
    [cell.sharedBgView addGestureRecognizer:tap1];
    [cell.likeBgView addGestureRecognizer:tap2];
    [cell.commentsBgView addGestureRecognizer:tap3];
    
    //_counT 判断是否是刷新一行
    if (_counT) {
        
        cell.BL = @"1";//cell中判断是否是单行刷新
        
        cell.BL_1 = @"1";//点赞

    }else{
        
        cell.BL = @"1";

        cell.BL_1 = @"0";//取消赞

    }
    
    cell.dic = _dataArray[indexPath.row];

    
    self.block = ^(NSInteger number){
       
        NSIndexPath *index=[NSIndexPath indexPathForRow:number inSection:0];

        TodayRecommendTableViewCell *cll = [_MyTableView cellForRowAtIndexPath:index];

        //真就增加,再点就减少
        if (_likeflag) {    //判断是第几次点击(赞)
            
            _counT = 1;
            
            _likeflag = NO;
            
        }else{              //(取消赞)
            
            _counT = 0;

            _likeflag = YES;
        }
        
        [_MyTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];

    };
    
    
    //分享的block
    
    _shareBlock = ^(NSInteger row){
        
        _shareUrl = _dataArray[row][@"url"];//网页链接
        
        _shareImage = _dataArray[row][@"cover_image_url"];//图片

        
    };

    return cell;
}

//点击用户头像事件
-(void)gesUserAction:(UIGestureRecognizer *)ges{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    UserDataViewController *vc = [story instantiateViewControllerWithIdentifier:@"UserDataViewController"];
    
    vc.idString = _dataArray[ges.view.tag - 1000][@"topic"][@"user"][@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//点击转发
-(void)gesUserAction1:(UIGestureRecognizer *)ges{
    
    //为真已登录
    if (_pp.loginFlag) {
        
        //分享
        
        if (_shareBlock) {
            
            _shareBlock(ges.view.tag - 10000);
        }
        
        [[HttpRequestManager shareInstance] myShareUrlString:_shareUrl andImage:_shareImage andController:self];

        
    }else{
        
        [_AlertView show];

    }
    
}

//点击赞
-(void)gesUserAction2:(UIGestureRecognizer *)ges{
    
    //为真显示提示信息
    if (_pp.loginFlag) {
        
        //刷新cell
        if (_block) {
            
            _block(ges.view.tag - 20000);
        }

        
    }else{
        
        [_AlertView show];

    }

}

//点击评论
-(void)gesUserAction3:(UIGestureRecognizer *)ges{
    
    MoreCommentsViewController *vc = [_story instantiateViewControllerWithIdentifier:@"MoreCommentsViewController"];
    
    vc.idString = [_dataArray[ges.view.tag - 30000][@"id"] stringValue];
    
    [self.navigationController pushViewController:vc animated:YES];

}


//点击专辑
- (IBAction)buttonAction:(UIButton *)sender {
    
    AlbumViewController *vc = [_story instantiateViewControllerWithIdentifier:@"Album"];
    
    NSDictionary *dic = _dataArray[sender.tag - 1];
    
    vc.idString = dic[@"topic"][@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 搜索按钮
- (IBAction)searchAction:(UIButton *)sender {
    
    SearchViewController *vc = [_story instantiateViewControllerWithIdentifier:@"SearchViewController"];
        
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    _pp = [UIApplication sharedApplication].delegate;

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
