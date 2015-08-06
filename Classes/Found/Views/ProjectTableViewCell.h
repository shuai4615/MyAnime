//
//  ProjectTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, assign) NSInteger number;

@end
