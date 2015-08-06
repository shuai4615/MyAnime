//
//  HttpRequestManager.m
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "HttpRequestManager.h"
#import "AFNetworking.h"
#import "UMSocial.h"

@implementation HttpRequestManager

+ (instancetype)shareInstance{
    
    static HttpRequestManager *manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[HttpRequestManager alloc] init];
    });
    
    return manager;
}

//获取今日推荐数据
-(void)getTodayRecommendNeedOffset:(NSString *)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *path = [NSString stringWithFormat:TodayRecommend_URL,offset];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"][@"comics"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
}

//获取发现滑动视图
-(void)getSlidingPritureSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:SlidingPriture_URl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = responseObject[@"data"][@"banner_group"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//获取发现数据
-(void)getFoundDataSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:Found_URl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = responseObject[@"data"][@"topics"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//今日推荐详情内容
-(void)getTodayDataNeedIDString:(NSString *)idString andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{

    NSString * path = [NSString stringWithFormat:TodayData_URL,idString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        
        success(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
}

//今日详情评论
-(void)getTodayCommentsIDString:(NSString *)idString andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{

    NSString * path = [NSString stringWithFormat:TodayComments_URl,idString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"][@"comments"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//获取专辑内容
-(void)getTheAlbumRecommentNeedIDString:(NSString *)idString andSort:(NSString *)sort andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    NSString * path = [NSString stringWithFormat:TheAlbum_URL,idString,sort];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//各个专题信息
-(void)getProjectDataNeddUrl:(NSString *)url andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//搜索
//按钮搜索
-(void)getSearchButtonDataNeedTag:(NSString *)tagString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    NSString *str = [tagString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:SearchButton_URl,offset,str];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"][@"topics"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//自主搜索
-(void)getSearchDataNeedKey:(NSString *)keyString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    NSString *str = [keyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:Search_URl,str,offset];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"][@"topics"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//获取用户信息
-(void)getUserDataNeedID:(NSString *)idString andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    NSString *url = [NSString stringWithFormat:UserData_URL,idString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//最新评论
-(void)getMoreNewCommentsDataNeedID:(NSString *)idString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    NSString *url = [NSString stringWithFormat:MoreNewComments_URL,idString,offset];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"][@"comments"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}

//最热评论
-(void)getMoreHotCommentsDataNeedID:(NSString *)idString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure{
    
    NSString *url = [NSString stringWithFormat:MoreHotComments_URL,idString,offset];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"][@"comments"];
        
        success(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}









//分享
-(void)myShareUrlString:(NSString *)urlString andImage:(NSString *)imageString andController:(UIViewController *)controller{
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
    
    [UMSocialSnsService presentSnsIconSheetView:controller appKey:@"54c9e963fd98c5cc900000bd" shareText:urlString shareImage:data shareToSnsNames:@[UMShareToEmail,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToYXSession,UMShareToSina] delegate:nil];

}





@end





