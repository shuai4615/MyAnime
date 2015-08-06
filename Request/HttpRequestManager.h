//
//  HttpRequestManager.h
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class HttpRequestManager;

typedef void (^httpRequesSuccess)(id object);

typedef void (^httpRequestFailure)(NSError *error);

@interface HttpRequestManager : NSObject

+ (instancetype)shareInstance;

//获取今日推荐数据
-(void)getTodayRecommendNeedOffset:(NSString *)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//获取发现滑动视图
-(void)getSlidingPritureSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//获取发现数据
-(void)getFoundDataSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//今日推荐详情内容
-(void)getTodayDataNeedIDString:(NSString *)idString andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//今日详情评论
-(void)getTodayCommentsIDString:(NSString *)idString andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//获取专辑内容
-(void)getTheAlbumRecommentNeedIDString:(NSString *)idString andSort:(NSString *)sort andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//各个专题信息
-(void)getProjectDataNeddUrl:(NSString *)url andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//搜索
//按钮搜索
-(void)getSearchButtonDataNeedTag:(NSString *)tagString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//自主搜索
-(void)getSearchDataNeedKey:(NSString *)keyString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//获取用户信息
-(void)getUserDataNeedID:(NSString *)idString andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//更多评论信息
//最新评论
-(void)getMoreNewCommentsDataNeedID:(NSString *)idString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;

//最热评论
-(void)getMoreHotCommentsDataNeedID:(NSString *)idString andOffset:(NSInteger)offset andSuccess:(httpRequesSuccess)success andFailure:(httpRequestFailure)failure;





//分享
-(void)myShareUrlString:(NSString *)urlString andImage:(NSString *)imageString andController:(UIViewController *)controller;


@end
