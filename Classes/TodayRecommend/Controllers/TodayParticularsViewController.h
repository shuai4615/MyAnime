//
//  TodayParticularsViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayParticularsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UILabel *title_Label;



@property (nonatomic, copy) NSString *idString;

//第一组组头信息
@property (nonatomic, copy) NSString *userHeadString;

@property (nonatomic, copy) NSString *userNameString;

@property (nonatomic, copy) NSString *topicTitleString;

//top 和 bottom

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end
