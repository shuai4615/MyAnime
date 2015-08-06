//
//  SynopsisDataTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SynopsisDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@property (nonatomic, strong) NSDictionary *dic;

@end
