//
//  SetViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "SetViewController.h"

#import "KuaiKanViewController.h"
#import "IdeaViewController.h"


@interface SetViewController ()<UIAlertViewDelegate>

{
    UIAlertView *_alertView1;
    
    AppDelegate *_pp;
    
    NSString *_diskCachePath;//缓存路径
}

@property (weak, nonatomic) IBOutlet UIView *bgView1;

@property (weak, nonatomic) IBOutlet UIView *bgView2;

@property (weak, nonatomic) IBOutlet UIView *bgView3;

@property (weak, nonatomic) IBOutlet UIView *bgView4;

@property (weak, nonatomic) IBOutlet UIView *bgView5;

@property (weak, nonatomic) IBOutlet UIView *bgView6;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (weak, nonatomic) IBOutlet UILabel *MyNewLabel;

@property (weak, nonatomic) IBOutlet UILabel *cleanLabel;

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;


@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _MyNewLabel.alpha = 0;
    _cleanLabel.alpha = 0;
    
    _MyNewLabel.layer.masksToBounds = YES;
    _cleanLabel.layer.masksToBounds = YES;
    
    _MyNewLabel.layer.cornerRadius = _MyNewLabel.bounds.size.height/2;
    _cleanLabel.layer.cornerRadius = _cleanLabel.bounds.size.height/2;
    
    [self creatAlertView];
    
    [self viewAction];
}

-(void)creatAlertView{
    
    _alertView1 = [[UIAlertView alloc] initWithTitle:@"发送好评成功" message:@"亲,感谢您的好评哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:_alertView1];
    
}


//计算缓存大小
- (float)checkTmpSize
{
    float totalSize = 0;
    
    _diskCachePath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
//    NSLog(@"Library = %@",_diskCachePath);
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:_diskCachePath];
    
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [_diskCachePath stringByAppendingPathComponent:fileName];
        
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        unsigned long long length = [attrs fileSize];
        
        totalSize += length / 1024.0 / 1024.0;
    }
    
    return totalSize;
}

-(void)viewAction{
    
    for (int i = 0; i < 6; i++) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction:)];
        
        switch (i) {
            case 0:
                [_bgView1 addGestureRecognizer:tap];
                break;
            case 1:
                [_bgView2 addGestureRecognizer:tap];
                break;
            case 2:
                [_bgView3 addGestureRecognizer:tap];
                break;
            case 3:
                [_bgView4 addGestureRecognizer:tap];
                break;
            case 4:
                [_bgView5 addGestureRecognizer:tap];
                break;
            case 5:
                [_bgView6 addGestureRecognizer:tap];
                break;

        }
    }
}

-(void)gesAction:(UIGestureRecognizer *)ges{
    
    switch (ges.view.tag) {
        
        case 1:{
            
            [_alertView1 show];
        }break;
        case 2:{
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
            
            IdeaViewController *vc = [story instantiateViewControllerWithIdentifier:@"IdeaViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];

        }break;
        case 3:{
            
            [[HttpRequestManager shareInstance] myShareUrlString:@"http://www.kuaikanmanhua.com/comics/2169" andImage:@"http://kuaikan-data.qiniudn.com/image/150609/4fx7gsowd.jpg-w640" andController:self];
        }break;
        case 4:{
            
            _cleanLabel.frame = CGRectMake(_cleanLabel.frame.origin.x, _cleanLabel.frame.origin.y + 50, _cleanLabel.frame.size.width, _cleanLabel.frame.size.height);
            
            [UIView animateWithDuration:1.5 animations:^{
                
                _cleanLabel.alpha = 1;
                
                _cleanLabel.frame = CGRectMake(_cleanLabel.frame.origin.x, _cleanLabel.frame.origin.y - 30, _cleanLabel.frame.size.width, _cleanLabel.frame.size.height);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:1 animations:^{
                    
                    _cleanLabel.alpha = 0;
                    
                    _cleanLabel.frame = CGRectMake(_cleanLabel.frame.origin.x, _cleanLabel.frame.origin.y - 20, _cleanLabel.frame.size.width, _cleanLabel.frame.size.height);
                    
                }];
                
            }];
            
            //清除缓存
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            
            [fileManager removeItemAtPath:_diskCachePath error:nil];
            
            //从新计算缓存大小
            [[SDImageCache sharedImageCache] clearDisk];
            
            float tmpSize = [self checkTmpSize];
            
            NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2f MB",tmpSize] : [NSString stringWithFormat:@"%.2f KB",tmpSize * 1024];
            
            _cacheLabel.text = clearCacheName;

        }break;
        case 5:{
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyAnime" bundle:nil];
            
            KuaiKanViewController *vc = [story instantiateViewControllerWithIdentifier:@"KuaiKanViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 6:{
            
            _MyNewLabel.frame = CGRectMake(_MyNewLabel.frame.origin.x, _MyNewLabel.frame.origin.y + 50, _MyNewLabel.frame.size.width, _MyNewLabel.frame.size.height);
            
            [UIView animateWithDuration:1.5 animations:^{
                
                _MyNewLabel.alpha = 1;
                
                _MyNewLabel.frame = CGRectMake(_MyNewLabel.frame.origin.x, _MyNewLabel.frame.origin.y - 30, _MyNewLabel.frame.size.width, _MyNewLabel.frame.size.height);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:1 animations:^{
                
                    _MyNewLabel.alpha = 0;
                    
                    _MyNewLabel.frame = CGRectMake(_MyNewLabel.frame.origin.x, _MyNewLabel.frame.origin.y - 20, _MyNewLabel.frame.size.width, _MyNewLabel.frame.size.height);
                    
                }];
                
            }];
            
        }break;
 
        
    }
}

//退出登录
- (IBAction)exit:(id)sender {
        
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"是否要退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [self.view addSubview:view];
    
    [view show];

}

#pragma mark- UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        
        _pp.loginFlag = NO;

        //回调设置默认头像
        _block();
        
        self.tabBarController.tabBar.hidden = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//返回
- (IBAction)back:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    _pp = [UIApplication sharedApplication].delegate;
    
    //未登录隐藏退出登录的button
    if (_pp.loginFlag) {
        
        _exitButton.hidden = NO;
    }else{
        
        _exitButton.hidden = YES;
    }

    //计算缓存大小
    [[SDImageCache sharedImageCache] clearDisk];
    
    float tmpSize = [self checkTmpSize];
    
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1f MB",tmpSize] : [NSString stringWithFormat:@"%.1f KB",tmpSize * 1024];
    
    _cacheLabel.text = clearCacheName;

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
