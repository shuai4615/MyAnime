//
//  DataDataTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *LeftImageView;

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (nonatomic, strong) NSDictionary *dic;

@end
