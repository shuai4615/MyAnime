//
//  MoreCommentsViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "MoreCommentsViewController.h"

#import "MoreCommentTableViewCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

#define SendCommentData_URL @"http://api.kuaikanmanhua.com/v1/comics/%@/comments"

#define like_URL @"http://api.kuaikanmanhua.com/v1/comments/%@/like"

@interface MoreCommentsViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView *_leftTableView;
    
    UITableView *_rightTableView;
    
    NSMutableArray *_leftDataArray;
    
    NSMutableArray *_rightDataArray;

    NSInteger _leftOffset;
    
    NSInteger _rightOffset;
    
    BOOL _leftFlag;
    
    BOOL _rightFlag;
    
    UIAlertView *_alertView;
    
    BOOL _rightTapFlag;//记录右侧点击的次数
}

@property (nonatomic, strong) MJRefreshHeaderView *leftheadView;

@property (nonatomic, strong) MJRefreshFooterView *leftfootView;

@property (nonatomic, strong) MJRefreshHeaderView *rightheadView;

@property (nonatomic, strong) MJRefreshFooterView *rightfootView;

@property (nonatomic, copy) void (^cellBlock)(BOOL flag);

@end

@implementation MoreCommentsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _leftFlag = YES;
        
        _rightFlag = YES;
        
        _leftDataArray = [[NSMutableArray alloc] init];
        
        _rightDataArray = [[NSMutableArray alloc] init];

        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)dealloc{
    
    [_leftheadView free];
    
    [_leftfootView free];
    
    [_rightheadView free];

    [_rightfootView free];
    
}

//左上刷新
-(MJRefreshHeaderView *)leftheadView{
    
    if (_leftheadView == nil) {
        
        _leftheadView = [[MJRefreshHeaderView alloc] init];
        
        _leftheadView.delegate = self;
        
        _leftheadView.scrollView = _leftTableView;
        
    }
    return _leftheadView;
}

//右上刷新
-(MJRefreshHeaderView *)rightheadView{
    
    if (_rightheadView == nil) {
        
        _rightheadView = [[MJRefreshHeaderView alloc] init];
        
        _rightheadView.delegate = self;
        
        _rightheadView.scrollView = _rightTableView;
        
    }
    return _rightheadView;
}

//左下加载
-(MJRefreshFooterView *)leftfootView{
    
    if (_leftfootView == nil) {
        
        _leftfootView = [[MJRefreshFooterView alloc] init];
        
        _leftfootView.delegate = self;
        
        _leftfootView.scrollView = _leftTableView;

    }
    return _leftfootView;
}

//右下加载
-(MJRefreshFooterView *)rightfootView{
    
    if (_rightfootView == nil) {
        
        _rightfootView = [[MJRefreshFooterView alloc] init];
        
        _rightfootView.delegate = self;
        
        _rightfootView.scrollView = _rightTableView;
        
    }
    return _rightfootView;
}

//键盘回收的时候
-(void)keyBoardHide:(NSNotification *)not{
    
    //归位
    self.view.frame = self.view.bounds;
    
}

//键盘出现的时候
-(void)keyBoardShow:(NSNotification *)not{
    
    //取出包含有键盘frame信息的NSRect
    //NSValue专门用于转换结构体
    NSValue * value = [not.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    //转换回结构体CGRect
    CGRect keyboardRect = [value CGRectValue];
    
    //判断输入框是否被挡住了
    if (_TFbgView.frame.origin.y +_TFbgView.frame.size.height > keyboardRect.origin.y) {
        
        //差值
        CGFloat tempNum = _TFbgView.frame.origin.y +_TFbgView.frame.size.height - keyboardRect.origin.y;
        
        //整个视图向上移动tempNum
        self.view.frame = CGRectMake(0, -tempNum,self.view.frame.size.width , self.view.frame.size.height);
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self getLeftData];
    
    [self getRightData];
    
    //监听键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘回收的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];

    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"亲,请先登录哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_alertView];

}

#pragma mark- textFieldDid的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //设置指向正在编辑的输入框
    _MyTextField = textField;
    
}

-(void)getLeftData{
    
    [[HttpRequestManager shareInstance] getMoreNewCommentsDataNeedID:_idString andOffset:_leftOffset andSuccess:^(id object) {
        
        NSMutableArray *array = [self calculateLabelSize:object];
        
        if (_leftFlag) {
            
            [_leftDataArray removeAllObjects];
            
            _leftDataArray = array;
        }else{
            
            [_leftDataArray addObjectsFromArray:array];
        }
        
        [_leftTableView reloadData];
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取最新评论失败,error = %@",error);
    }];
    
}

-(void)getRightData{
    
    [[HttpRequestManager shareInstance] getMoreHotCommentsDataNeedID:_idString andOffset:_leftOffset andSuccess:^(id object) {
        
        NSMutableArray *array = [self calculateLabelSize:object];
        
        if (_rightFlag) {
            
            [_rightDataArray removeAllObjects];
            
            _rightDataArray = array;
        }else{
            
            [_rightDataArray addObjectsFromArray:array];
        }
        
        [_rightTableView reloadData];
        
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取最热评论失败,error = %@",error);
    }];

}

//计算评论信息label的高度
-(NSMutableArray *)calculateLabelSize:(NSArray *)object{
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in object) {
        
        NSDictionary *mutableDic = [dic mutableCopy];
        
        NSString *str = dic[@"content"];
        
        CGFloat height = [str boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height + 45;
        
        [mutableDic setValue:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
        
        [mutableArray addObject:mutableDic];
    }
    
    return mutableArray;
}


-(void)creatUI{
    
    _leftOffset = 0;
    
    _rightOffset = 0;
    
    //滑动视图设置
    _MyScrollView.contentSize = CGSizeMake(640, 455);
    
    _MyScrollView.pagingEnabled = YES;
    
    _MyScrollView.delegate = self;
    
    //左tableView
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 455)];
    
    _leftTableView.delegate = self;
    
    _leftTableView.dataSource = self;
    
    _leftTableView.showsVerticalScrollIndicator = NO;
    
    [_MyScrollView addSubview:_leftTableView];
    
    //右tableView
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 455)];
    
    _rightTableView.delegate = self;
    
    _rightTableView.dataSource = self;
    
    _rightTableView.showsVerticalScrollIndicator = NO;
    
    [_MyScrollView addSubview:_rightTableView];

    [self.leftheadView endRefreshing];
    
    [self.leftfootView endRefreshing];

    [self.rightheadView endRefreshing];
    
    [self.rightfootView endRefreshing];

    _MyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma maek- 刷新
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
        if (refreshView == _leftheadView) {
            
            _leftOffset = 0;
            
            _leftFlag = YES;
            
            [self getLeftData];

        }else if(refreshView == _leftfootView){
            
            _leftOffset += 20;
            
            _leftFlag = NO;
            
            [self getLeftData];

        }else if (refreshView == _rightheadView) {
            
            _rightOffset = 0;
            
            _rightFlag = YES;
            
            [self getRightData];

        }else{
            
            _rightOffset += 20;
            
            _rightFlag = NO;
            
            [self getRightData];

        }
    
    [self performSelector:@selector(endRefresh:) withObject:refreshView afterDelay:1.0];
}

-(void)endRefresh:(MJRefreshBaseView *)refreshView{
    
    [refreshView endRefreshing];
}

#pragma mark- TableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == _leftTableView){
        
       return _leftDataArray.count;
    }else{
        
        return _rightDataArray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _leftTableView){
        
        return [_leftDataArray[indexPath.row][@"height"] floatValue];
    }else{
        
        return [_rightDataArray[indexPath.row][@"height"] floatValue];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MoreCommentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCommentTableViewCell" owner:self options:nil] firstObject];
    
    
    if (tableView == _leftTableView) {
        
        cell.dic = _leftDataArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }else{
        
        cell.dic = _rightDataArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return cell;
}

//点击赞
-(void)gesAction:(UIGestureRecognizer *)ges{
    //暂无
}

//滑动事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView == _MyScrollView){
        
        if (scrollView.contentOffset.x == 320) {
            
            _MyStepper.selectedSegmentIndex = 1;
        }else{
            
            _MyStepper.selectedSegmentIndex = 0;
        }

    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//分段事件
- (IBAction)segmentedAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 1) {
        
        [_MyScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    }else{
        
        [_MyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


//发送按钮
- (IBAction)sendAction:(id)sender {
    
    AppDelegate *pp = [UIApplication sharedApplication].delegate;
    
    if (pp.loginFlag == NO) {
        
        [_alertView show];
        
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *str = [NSString stringWithFormat:SendCommentData_URL,_idString];
        
        [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            //上传pinglun
            [formData appendPartWithFormData:[_MyTextField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"评论成功");
            
            [self getLeftData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"评论失败,error=%@",error);
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"评论失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [self.view addSubview:view];
            
            [view show];
        }];
        
        [self.view endEditing:YES];//收键盘
        
        _MyTextField.text = @"";

    }
    
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
