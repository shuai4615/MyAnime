//
//  AlbumViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "AlbumViewController.h"

#import "SynopsisDataTableViewCell.h"
#import "SynopsisHeadTableViewCell.h"
#import "DataDataTableViewCell.h"
#import "DataHeadTableViewCell.h"
#import "UserDataViewController.h"
#import "TodayParticularsViewController.h"


@interface AlbumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    
    NSString *_descriptionString;//简介的描述
    
    CGFloat _height;//简介的组高
    
    NSDictionary *_objectDic;
    
    BOOL _flag;
    
    NSInteger _number;
    
}

@end

@implementation AlbumViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _number = 1;
        
        _dataArray = [[NSMutableArray alloc] init];
        
        _objectDic = [[NSDictionary alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self getData];
}

-(void)creatUI{
    
    _flag = NO;
    
    _backButton.layer.masksToBounds = YES;
    
    _collectButton.layer.masksToBounds = YES;
    
    _backButton.layer.cornerRadius = 15;
    
    _collectButton.layer.cornerRadius = 15;
}

-(void)getData{
    
    [[HttpRequestManager shareInstance] getTheAlbumRecommentNeedIDString:_idString andSort:@"0" andSuccess:^(id object) {
        
        [self headInformation:object];
        
        _objectDic = object;
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取专辑信息失败,error = %@",error);
    }];
}

//头部数据
-(void)headInformation:(id)object{
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:object[@"cover_image_url"]]];
    
    _title_Label.text = object[@"title"];
    
    _likeCountLabel.text = [object[@"likes_count"] stringValue];
    
    _commentsCountLabel.text = [object[@"comments_count"] stringValue];
    
    NSString *str = object[@"description"];
    
    _height = [str boundingRectWithSize:CGSizeMake(290, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height + 20;
    
    _descriptionString = str;
    
    _MyTableView.tableHeaderView = _bgView;
    
    [self refreshUI:object];
}

-(void)refreshUI:(id)object{
    
    [_dataArray removeAllObjects];
    
    if (_flag) {
        
        NSDictionary *dic = object[@"user"];
        
        [_dataArray addObject:dic];
    }else{
        
        _dataArray = [object[@"comics"] mutableCopy];
    }
    
    [_MyTableView reloadData];

}

#pragma mark- tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(_flag){
        
        return _height;
    }else{
        
        return 26;
    }
    
}

//组头跟着表走
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView ==_MyTableView)
    {
        CGFloat sectionHeaderHeight = 50;
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_flag) {
        
        SynopsisHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SynopsisHead"];
        
        cell.descriptionLabel.text = _descriptionString;
        
        cell.descriptionLabel.frame = CGRectMake(cell.descriptionLabel.frame.origin.x, cell.descriptionLabel.frame.origin.y, 290, _height - 10);
        
        return cell;
    }else{
        
        DataHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataHead"];
        
        if (_number == 2) {
            
            [cell.sortButton setTitle:@"正序" forState:UIControlStateNormal];
        }else{
            
            [cell.sortButton setTitle:@"倒序" forState:UIControlStateNormal];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_flag) {
        
        return 30;
    }else{
        
        return 70;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_flag){
        
        SynopsisDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SynopsisData"];
        
        cell.dic = _dataArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        
        DataDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataData"];
        
        cell.dic = _dataArray[indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    if (_flag) {
        
        //转到用户详情
        UserDataViewController *vc = [story instantiateViewControllerWithIdentifier:@"UserDataViewController"];

        vc.idString = [_dataArray[indexPath.row][@"id"] stringValue];
        
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        
        //漫画详情
        TodayParticularsViewController *vc = [story instantiateViewControllerWithIdentifier:@"TodayParticulars"];
        
        vc.idString = _dataArray[indexPath.row][@"id"];
                
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- 各个按钮的事件
- (IBAction)back:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

//简介按钮
- (IBAction)synopsisAction:(id)sender {
    
    _flag = YES;
    
    [self refreshUI:_objectDic];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _yellowLabel.frame = CGRectMake(0, _yellowLabel.frame.origin.y, _yellowLabel.frame.size.width, _yellowLabel.frame.size.height);
    }];
    
}

//内容按钮
- (IBAction)DataAction:(id)sender {
    
    _flag = NO;
    
    [self refreshUI:_objectDic];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _yellowLabel.frame = CGRectMake(160, _yellowLabel.frame.origin.y, _yellowLabel.frame.size.width, _yellowLabel.frame.size.height);
    }];

}

//排序按钮
- (IBAction)sortAction:(id)sender {
    
    if (_number == 2) {
        
        _number = 1;
        
        NSMutableArray *array = [_dataArray mutableCopy];
        
        [_dataArray removeAllObjects];
        
        _dataArray = [[[array reverseObjectEnumerator] allObjects] mutableCopy];

    }else if(_number == 1) {
        
        _number = 2;
        
        NSMutableArray *array = [_dataArray mutableCopy];
        
        [_dataArray removeAllObjects];
        
        _dataArray = [[[array reverseObjectEnumerator] allObjects] mutableCopy];

    }
    
    [_MyTableView reloadData];
}

//收藏按钮
- (IBAction)collectAction:(id)sender {
        
        
        //判断是否已经收藏
        if([[DataBase sharedManager] selectCollectDataandID:_objectDic[@"id"]]){
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"亲,已经收藏过了哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];
        }else{
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_objectDic];
            
            [[DataBase sharedManager] insertHomeData:data andFlag:3 andIDString:_objectDic[@"id"]];//添加数据
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];

        }
    
    
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
