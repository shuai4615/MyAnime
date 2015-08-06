//
//  TodayRecommendTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayRecommendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *topicTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UILabel *sharedLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

//  赞/已赞
@property (weak, nonatomic) IBOutlet UILabel *likeLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, strong) NSDictionary *dic;

//转发的背景
@property (weak, nonatomic) IBOutlet UIView *sharedBgView;

//赞的背景
@property (weak, nonatomic) IBOutlet UIView *likeBgView;

//评论的背景
@property (weak, nonatomic) IBOutlet UIView *commentsBgView;


@property (weak, nonatomic) IBOutlet UIButton *TheAlbumButton;


@property (nonatomic, copy) NSString *BL;

@property (nonatomic, copy) NSString *BL_1;

@end
