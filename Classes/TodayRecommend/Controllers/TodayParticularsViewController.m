//
//  TodayParticularsViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "TodayParticularsViewController.h"

#import "HttpRequestManager.h"
#import "TodayOneGroupHeadTableViewCell.h"
#import "TodayOneGroupDataTableViewCell.h"
#import "TodayOneGroupLastTableViewCell.h"
#import "TodayTwoGroupHeadTableViewCell.h"
#import "TodayTwoGroupDataTableViewCell.h"
#import "TodayTwoGroupLastTableViewCell.h"
#import "AlbumViewController.h"
#import "UserDataViewController.h"
#import "MoreCommentsViewController.h"
#import "RegisterViewController.h"

@interface TodayParticularsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    
    NSString *_oneGroupLastString;
    
    NSInteger _oldOffset;
    
    NSString *_previousString;//上一篇
    
    NSString *_nextString;//下一篇
    
    NSString *_nextIDString;//跳向全集的id
    
    NSString *_shareUrl;//分享链接
    
    NSString *_shareImage;//分享图片
    
    UIStoryboard *_story;
    
    BOOL _flag;//判断第几次点击
    
    UIAlertView *_AlertView;//提示请先登录
    
    BOOL _refreshCellFlag;//刷新组尾的标志
    
    AppDelegate *_pp;//为真已登录
        
    NSDictionary *_dic;//收藏
}

@property (weak, nonatomic) IBOutlet UIView *lakeBgView;


@property (nonatomic, copy) void (^groupLastBlock)(void);

@end

@implementation TodayParticularsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _oldOffset = 0;
        
        _dic = [[NSDictionary alloc] init];
        
        _dataArray = [[NSMutableArray alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cruatUI];
    
    [self getData];
}


-(void)cruatUI{

    _lakeBgView.frame = CGRectMake(0, self.view.bounds.size.height - 44, 320, 568);
    
    _AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"亲,请先登录哦!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_AlertView];
    
    _story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];

    
    [self.view bringSubviewToFront:_lakeBgView];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

//获取漫画内容
-(void)getData{
    
    //详情内容
    [[HttpRequestManager shareInstance] getTodayDataNeedIDString:_idString andSuccess:^(id object) {
        
        _dic = object;//收藏
        
        _shareUrl = object[@"url"];//分享
        
        _shareImage = object[@"cover_image_url"];//分享
        
        _title_Label.text = object[@"title"];
        
        _userHeadString = object[@"topic"][@"user"][@"avatar_url"];
        
        _userNameString = object[@"topic"][@"user"][@"nickname"];
        
        _topicTitleString = object[@"topic"][@"title"];
        
        _nextIDString = [object[@"topic"][@"id"] stringValue];
        
        _oneGroupLastString = [object[@"likes_count"] stringValue];
        
        if ((NSNull *)[object objectForKey:@"previous_comic_id"] == [NSNull null]) {
            
            _previousString = @"";
        }else{
            
            _previousString = [object[@"previous_comic_id"] stringValue];
        }
        
        if ((NSNull *)[object objectForKey:@"next_comic_id"] == [NSNull null]) {
            
            _nextString = @"";
        }else{
            
            _nextString = [object[@"next_comic_id"] stringValue];
        }
        
        //判断NSString 和 NSNumber
        if ([object[@"comments_count"] isKindOfClass:[NSString class]]) {
            
            [self commentsBadge:object[@"comments_count"]];
        }else{
            
            [self commentsBadge:[object[@"comments_count"] stringValue]];
        }
        
        NSArray *array = object[@"images"];
        
        [_dataArray addObject:array];
        
        [self getData_comment];
        
        [_myTableView reloadData];
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取今日详情信息失败,error = %@",error);
    }];
    
}

//获取评论
-(void)getData_comment{
    
    //评论内容
    [[HttpRequestManager shareInstance] getTodayCommentsIDString:_idString andSuccess:^(id object) {
        
        NSMutableArray *array = [self calculateLabelSize:object];
        
        [_dataArray addObject:array];
        
        [_myTableView reloadData];
        
        //跳转到第一行
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [_myTableView scrollToRowAtIndexPath:idxPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:YES];

        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取今日详情信息失败,error = %@",error);
    }];

}

//计算评论信息label的高度
-(NSMutableArray *)calculateLabelSize:(NSArray *)object{
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in object) {
        
        NSDictionary *mutableDic = [dic mutableCopy];
        
        NSString *str = dic[@"content"];
        
        CGFloat height = [str boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.height + 45;
        
        [mutableDic setValue:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
        
        [mutableArray addObject:mutableDic];
    }
    
    return mutableArray;
}

//评论角标
-(void)commentsBadge:(NSString *)commentString{
    
    CGSize size = [commentString boundingRectWithSize:CGSizeMake(100, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_commentsLabel.font} context:nil].size;
    
    _commentsLabel.frame = CGRectMake(_commentsLabel.frame.origin.x, _commentsLabel.frame.origin.y, size.width+10, size.height);
    
    _commentsLabel.text = commentString;
    
    _commentsLabel.layer.masksToBounds = YES;
    
    _commentsLabel.layer.cornerRadius = 5;
}

#pragma mark- uitableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

//组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        TodayOneGroupHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayOneGroupHead"];
        
        [cell.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:_userHeadString]];
        
        cell.userHeadImageView.layer.masksToBounds = YES;
        
        cell.userHeadImageView.layer.cornerRadius = 15;
        
        cell.userNameLabel.text = _userNameString;
        
        cell.topicTitleLabel.text = _topicTitleString;
        
        return cell;
    }else{
        
        TodayTwoGroupHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayTwoGroupHead"];
        
        return cell;
    }
    
}

//组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    //刷新组尾的block
    _groupLastBlock = ^{
      
        [tableView reloadData];
    };
    
    if (section == 0) {

        TodayOneGroupLastTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayOneGroupLast"];
        
        //登录就赞
        if (_refreshCellFlag) {
            //组尾处刷新赞
            
        }else{

        }

        [cell.likeCountButton addTarget:self action:@selector(gesAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.collectButton addTarget:self action:@selector(gesAction1:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        
        TodayTwoGroupLastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayTwoGroupLast"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesMoreCommentSAction:)];
        
        [cell.moreLabel addGestureRecognizer:tap];
        
        return cell;
    }
}

//点击组尾的收藏
-(void)gesAction1:(UIButton *)btn{
        
        
        //判断是否已经收藏(单篇)
        if ([[DataBase sharedManager] selectCollectDataandID:_dic[@"id"]]) {
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"亲,已经收藏过了哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];
            
        }else{
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dic];
            
            [[DataBase sharedManager] insertHomeData:data andFlag:2 andIDString:_dic[@"id"]];//添加数据
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];

        }
        
}

//点击组尾的赞
-(void)gesAction{
    
    //登录就赞
    if (_pp.loginFlag) {
        
        
    }else{
        
        //没登录就提示登录
        
        [_AlertView show];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = _dataArray[section];
    
    return array.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 260;
        
    }else{
        
        NSDictionary *dic = _dataArray[1][indexPath.row];
        
        return [dic[@"height"] floatValue];
    }
    
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 36;
    }else{
        
        return 30;
    }
}

//组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 80;
    }else{
        
        return 30;
    }

}

//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        NSArray *array = _dataArray[0];
        
        TodayOneGroupDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayOneGroupData"];
        
        [cell.pritureImageView sd_setImageWithURL:[NSURL URLWithString:array[indexPath.row]]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
     
    }else{
        
        NSArray *array = _dataArray[1];

        TodayTwoGroupDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayTwoGroupData"];
        
        cell.dic = array[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadImageAction:)];
        
        [cell.userHeadImageView addGestureRecognizer:tap];
        
        cell.userHeadImageView.tag = indexPath.row + 1;
        
        return cell;
    }
    
}

//跳转到用户信息
-(void)userHeadImageAction:(UIGestureRecognizer *)ges{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    UserDataViewController *vc = [story instantiateViewControllerWithIdentifier:@"UserDataViewController"];
    
    vc.idString = _dataArray[1][ges.view.tag - 1][@"user"][@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//返回
- (IBAction)back:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

//上一篇
- (IBAction)previous_comic:(id)sender {
    
    if ([_previousString isEqualToString:@""]) {
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"亲,已是第一篇了哦~~~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [view show];
        
    }else{
        
        [_dataArray removeAllObjects];
        
        _idString = _previousString;
        
        [self getData];

    }
    
}

//下一篇
- (IBAction)next_comic:(id)sender {
    
    if ([_nextString isEqualToString:@""]) {
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"亲,已是最后一篇了哦~~~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [view show];

    }else{
        
        [_dataArray removeAllObjects];

        _idString = _nextString;
        
        [self getData];
    }
}

//全集
- (IBAction)albumAction:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    AlbumViewController *vc = [story instantiateViewControllerWithIdentifier:@"Album"];
    
    vc.idString = _nextIDString;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//更多评论点击事件
-(void)gesMoreCommentSAction:(UIGestureRecognizer *)ges{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    MoreCommentsViewController *vc = [story instantiateViewControllerWithIdentifier:@"MoreCommentsViewController"];
    
    vc.idString = _idString;
    
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark 点击  赞
- (IBAction)likeButton:(UIButton *)sender {
    


}


#pragma mark 点击  评论
- (IBAction)buttonAction:(id)sender {
    
    MoreCommentsViewController *vc = [_story instantiateViewControllerWithIdentifier:@"MoreCommentsViewController"];
    
    vc.idString = _idString;
    
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark 点击  转
- (IBAction)shareButton:(UIButton *)sender {
    
    //登录就分享
    if (_pp.loginFlag) {
        
        [[HttpRequestManager shareInstance] myShareUrlString:_shareUrl andImage:_shareImage andController:self];

    }else{
    //没登录就提示登录
        
        [_AlertView show];

    }

}


-(void)viewWillAppear:(BOOL)animated{
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    
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
