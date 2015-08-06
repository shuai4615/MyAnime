//
//  SearchResultViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "SearchResultViewController.h"

#import "SearchResltTableViewCell.h"
#import "AlbumViewController.h"
#import "MJRefresh.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    
    NSInteger _offset;
    
    BOOL _flag;//判断刷新哪个
    
    BOOL _refreshFlag;//刷新标志
}

@property (nonatomic, strong) MJRefreshHeaderView *headView;

@property (nonatomic, strong) MJRefreshFooterView *footView;

@end

@implementation SearchResultViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
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
    
    [self getData:nil];
}

-(void)creatUI{
    
    _offset = 0;
    
    _flag = YES;
    
    _refreshFlag = YES;
    
    _title_Label.text = _keyString;
    
    [self.headView endRefreshing];
    
    [self.footView endRefreshing];

}

#pragma maek- 刷新
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    if (_dataArray.count < 20) {
        
        return;
    }
    
    if (refreshView == _headView) {
        
        _offset = 0;
        
        _refreshFlag = YES;
    }else{
        
        _offset += 20;
        
        _refreshFlag = NO;
    }
    
    [self getData:refreshView];
    
    [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];
}

-(void)endRefresh:(MJRefreshBaseView *)refreshView{
    
    [refreshView endRefreshing];
}

-(void)getData:(MJRefreshBaseView *)refreshView{
    
    if (_flag || _number == 1) {
        
        [[HttpRequestManager shareInstance] getSearchButtonDataNeedTag:_keyString andOffset:_offset andSuccess:^(id object) {
            
            if (_refreshFlag) {
                
                [_dataArray removeAllObjects];
                
                _dataArray = [object mutableCopy];
            }else{
                
                [_dataArray addObjectsFromArray:object];
            }
            
            [_MyTableView reloadData];
            
        } andFailure:^(NSError *error) {
            
            NSLog(@"获取刷新结果失败,error = %@",error);
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"加载失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];
            
            [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];
        }];
        
    }else{
        
        [[HttpRequestManager shareInstance] getSearchDataNeedKey:_keyString andOffset:_offset andSuccess:^(id object) {
            
            if (_refreshFlag) {
                
                [_dataArray removeAllObjects];
                
                _dataArray = [object mutableCopy];
            }else{
                
                [_dataArray addObjectsFromArray:object];
            }

            [_MyTableView reloadData];

        } andFailure:^(NSError *error) {
            
            NSLog(@"获取刷新结果失败,error = %@",error);
            
            [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];
        }];

    }
}

#pragma mark- TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResltTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResltTableViewCell"];
    
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

- (IBAction)back:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
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
