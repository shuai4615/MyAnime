//
//  DataBase.m
//  MyAnime
//
//  Created by qianfeng on 15/6/14.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "DataBase.h"

#import "FMDatabase.h"

@implementation DataBase
{
    FMDatabase *_dataBase;
}

+ (instancetype)sharedManager{
    
    static DataBase *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[DataBase alloc] init];
    });
    
    return manager;
}

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        //获取沙盒路径
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/MyAnime.rdb"];
        NSLog(@"沙盒路径 = %@",path);
        _dataBase = [FMDatabase databaseWithPath:path];//创建数据库
        
        if (![_dataBase open]) {
            
            NSLog(@"打开数据库失败");
        }
        
        if (![_dataBase executeUpdate:@"create table if not exists Home(id integer primary key autoincrement,animeData BLOB,flag integer,idString text)"]) {
            
            NSLog(@"创建今日推荐数据表失败");
        }
        
    }
    return self;
}

//插入数据
-(void)insertHomeData:(NSData *)data andFlag:(NSInteger)flag andIDString:(NSString *)idString{
    
    if (![_dataBase executeUpdate:@"insert into Home(animeData,flag,idString) values(?,?,?)",data,@(flag),idString]) {
        
        NSLog(@"插入数据失败");
    }
}


//更新首页
-(void)upDataHomeData:(NSData *)data andFlag:(NSInteger)flag{
    

    if (![_dataBase executeUpdate:@"update Home set animeData = ? where flag = ?",data,@(flag)]) {
        
        NSLog(@"更新数据失败");
    }
}


//获取首页
-(NSData *)getHomeDataandFlag:(NSInteger)flag{
    
    FMResultSet *set = [_dataBase executeQuery:@"select * from Home where flag = ?",@(flag)];
    
    NSData *dt = nil;
    
    while ([set next]) {
        
        dt = [set dataForColumn:@"animeData"];
    }
    
    return dt;
}

//获取收藏
-(NSMutableArray *)getCollectDataandFlag:(NSInteger)flag{
    
    FMResultSet *set = [_dataBase executeQuery:@"select * from Home where flag = ?",@(flag)];
    
    NSData *dt = nil;
    
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    
    while ([set next]) {
        
        dt = [set dataForColumn:@"animeData"];
        
        [mutable addObject:dt];
    }
    
    return mutable;
}


//判断首页数据是否存在
-(BOOL)selectHomeDataandFlag:(NSInteger)flag{
    
    
    FMResultSet *set = [_dataBase executeQuery:@"select animeData from Home where flag = ?",@(flag)];
    
    while ([set next]) {
        
        return YES;
    }
    
    return NO;

}

//判断收藏数据是否存在
-(BOOL)selectCollectDataandID:(NSString *)idString{
    
    
    FMResultSet *set = [_dataBase executeQuery:@"select animeData from Home where idString = ?",idString];
    
    while ([set next]) {
        
        return YES;
    }
    
    return NO;
    
}

//删除收藏数据
-(void)deleteCollectDataFlag:(NSInteger)flag{
    
    if (![_dataBase executeUpdate:@"delete from Home where flag = ?",@(flag)]) {
        
        NSLog(@"删除失败");
    }
}



@end
