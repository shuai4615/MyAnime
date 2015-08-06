//
//  TodayTwoGroupDataTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTwoGroupDataTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *grayLineLabel;


@property (nonatomic, strong) NSDictionary *dic;

@end
