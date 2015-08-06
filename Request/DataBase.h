//
//  DataBase.h
//  MyAnime
//
//  Created by qianfeng on 15/6/14.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

+ (instancetype)sharedManager;


//更新首页
-(void)upDataHomeData:(NSData *)data andFlag:(NSInteger)flag;


//获取首页
-(NSData *)getHomeDataandFlag:(NSInteger)flag;
//获取收藏
-(NSMutableArray *)getCollectDataandFlag:(NSInteger)flag;


//插入数据
-(void)insertHomeData:(NSData *)data andFlag:(NSInteger)flag andIDString:(NSString *)idString;



//判断首页数据是否存在
-(BOOL)selectHomeDataandFlag:(NSInteger)flag;
//判断收藏数据是否存在
-(BOOL)selectCollectDataandID:(NSString *)idString;


//删除收藏数据
-(void)deleteCollectDataFlag:(NSInteger)flag;



@end
