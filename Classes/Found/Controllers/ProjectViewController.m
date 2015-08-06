//
//  ProjectViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "ProjectViewController.h"

#import "ProjectTableViewCell.h"
#import "AlbumViewController.h"
#import "TodayParticularsViewController.h"
#import "MJRefresh.h"

@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    
    NSInteger _offset;
    
    BOOL _flag;//判断刷新
}

@property (nonatomic, strong) MJRefreshHeaderView *headView;

@property (nonatomic, strong) MJRefreshFooterView *footView;


@end

@implementation ProjectViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _offset = 0;
        
        _flag = YES;
        
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
    
    [self.headView endRefreshing];
    
    [self.footView endRefreshing];

}

-(void)creatUI{
    
    self.tabBarController.tabBar.hidden = YES;
    
    _title_Label.text = _title_LabelString;
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
    
    [self getData:refreshView];
    
    [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];
}

-(void)endRefresh:(MJRefreshBaseView *)refreshView{
    
    [refreshView endRefreshing];
}

-(void)getData:(MJRefreshBaseView *)refreshView{
    
    NSString *str = [NSString stringWithFormat:@"%@%d",_urlString,_offset];
    NSLog(@"str = %@",str);
    [[HttpRequestManager shareInstance] getProjectDataNeddUrl:str andSuccess:^(id object) {
        
        if (_number == 1) {
            
            
            if (_flag) {
                
                [_dataArray removeAllObjects];
                
                _dataArray = [object[@"comics"] mutableCopy];
            }else{
                
                //如果没值就不添加
                if ([object[@"comics"] count] == 0) {
                    
                    
                }else{
                    
                    [_dataArray addObjectsFromArray:object[@"comics"]];
                }
                
            }
            
            
        }else{
            
            
            if (_flag) {
                
                [_dataArray removeAllObjects];

                _dataArray = [object[@"topics"] mutableCopy];
            }else{
                
                if ([object[@"topics"] count] == 0) {
                    
                    
                }else{
                    
                    [_dataArray addObjectsFromArray:object[@"topics"]];
                }
                
            }

            
        }
        
        [_MyTableView reloadData];
        
    } andFailure:^(NSError *error) {
        NSLog(@"获取专题分类失败,error = %@",error);
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [self.view addSubview:view];
        
        [view show];
        
        [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];

    }];
}

#pragma mark- TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell"];
    
    cell.number = _number;
    
    cell.dic = _dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    TodayParticularsViewController *vc = [story instantiateViewControllerWithIdentifier:@"TodayParticulars"];
    
    vc.idString = _dataArray[indexPath.row][@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)backAction:(id)sender {
    
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
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
