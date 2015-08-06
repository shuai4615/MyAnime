//
//  MoreCommentTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCommentTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;



@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) NSDictionary *dic;


@property (nonatomic, assign) BOOL cellFlag;//刷新哪一种cell

@end
