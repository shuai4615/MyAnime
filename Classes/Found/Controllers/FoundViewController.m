//
//  FoundViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "FoundViewController.h"

#import "FoundTableViewCell.h"
#import "AlbumViewController.h"
#import "ProjectViewController.h"
#import "TodayParticularsViewController.h"
#import "SearchViewController.h"


@interface FoundViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    
    NSMutableArray *_slidingArray;
    
    UIScrollView *_scrollView;//头部滑动视图
    
    NSTimer *_nextImageTimer;
    
    UIPageControl *_pageControl;
    
}
@end

@implementation FoundViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _dataArray = [[NSMutableArray alloc] init];
        
        _slidingArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self getData];
}

-(void)creatUI{
    
    [[HttpRequestManager shareInstance] getSlidingPritureSuccess:^(id object) {
        
        _slidingArray = [object mutableCopy];
        
        [self creatScrollView];

    } andFailure:^(NSError *error) {
        
        NSLog(@"获取滑动视图失败,error = %@",error);
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;

    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    
    [view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
    
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor yellowColor]];
    
    [view addSubview:_pageControl];
    
    _MyTableView.tableHeaderView = view;
    
}

-(void)getData{
    
    [[HttpRequestManager shareInstance] getFoundDataSuccess:^(id object) {
        
        _dataArray = [object mutableCopy];
        
        [_MyTableView reloadData];
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取发现信息失败,error = %@",error);
    }];
}

-(void)creatScrollView{
    
    _scrollView.contentSize = CGSizeMake((_slidingArray.count + 2)*320, 180);
    
    _scrollView.contentOffset = CGPointMake(320, 0);

    _pageControl.numberOfPages = _slidingArray.count;
    
    _pageControl.currentPage = 0;

    for (int i = 0; i < _slidingArray.count+2; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 180)];
        
        NSDictionary *dic = nil;
        
        if (i == 0) {
            
            imageView.tag = _slidingArray.count + 100;
            
            dic = [_slidingArray lastObject];
            
        }else if (i == _slidingArray.count + 1){
            
            imageView.tag = 101;
            
            dic = [_slidingArray firstObject];
        }else{
            
            imageView.tag = i + 100;
            
            dic = _slidingArray[i-1];
        }
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction:)];
        
        [imageView addGestureRecognizer:tap];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]]];
        
        [_scrollView addSubview:imageView];
    }
    
    _nextImageTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(slidingImageAction) userInfo:nil repeats:YES];
}

//点击滑动视图进入详情
-(void)gesAction:(UIGestureRecognizer *)ges{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];

    TodayParticularsViewController *vc = [story instantiateViewControllerWithIdentifier:@"TodayParticulars"];
    
    vc.idString = _slidingArray[ges.view.tag - 101][@"value"];
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)slidingImageAction{
    
    NSInteger num = _pageControl.currentPage + 1;
    
    if (num >= _slidingArray.count) {
        
        _pageControl.currentPage = 0;
                
        [_scrollView setContentOffset:CGPointMake(320, 0)];
    }else{
        
        _pageControl.currentPage = num;
        
        [_scrollView setContentOffset:CGPointMake((_pageControl.currentPage+1) * 320, 0) animated:YES];
    }
    
}

#pragma mark- 滑动视图
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger num1 = _scrollView.contentOffset.x;
    
    if (num1 == 320 * (_slidingArray.count+1)) {
        
        _pageControl.currentPage = 0;
        
        [_scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
    }else{
        
        _pageControl.currentPage = num1/320-1;
        
    }

}

#pragma mark- TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
      return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoundTableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.numberString = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    cell.dic = _dataArray[indexPath.row];
    
    cell.moreButton.tag = indexPath.row + 1;

    
    //block跳转
    cell.block = ^(NSString *idString){
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
        
        //跳向不同的页面(专辑/详情)
        if (indexPath.row == 1) {
            //详情
            
            TodayParticularsViewController *vc = [story instantiateViewControllerWithIdentifier:@"TodayParticulars"];
            
            vc.idString = idString;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //专辑
            
            AlbumViewController *vc = [story instantiateViewControllerWithIdentifier:@"Album"];
            
            vc.idString = idString;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    };

    return cell;
}

#pragma mark- 更多专题的跳转
- (IBAction)morePriject:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    ProjectViewController *vc = [story instantiateViewControllerWithIdentifier:@"ProjectViewController"];
    
    switch (sender.tag) {
            
        case 1:
            vc.urlString = Project_One_URl;
            break;
        case 2:
            vc.urlString = Project_Two_URl;
            break;
        case 3:
            vc.urlString = Project_Three_URl;
            break;
        case 4:
            vc.urlString = Project_Four_URl;
            break;
        case 5:
            vc.urlString = Project_Five_URl;
            break;

    }
    
    vc.number = sender.tag - 1;
    
    NSDictionary *dic = _dataArray[sender.tag - 1];
    
    vc.title_LabelString = dic[@"title"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 搜索按钮事件

- (IBAction)searchAction:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
    
    SearchViewController *vc = [story instantiateViewControllerWithIdentifier:@"SearchViewController"];
        
    [self.navigationController pushViewController:vc animated:YES];

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
