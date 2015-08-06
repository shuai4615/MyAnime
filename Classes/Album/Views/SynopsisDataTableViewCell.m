//
//  SynopsisDataTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "SynopsisDataTableViewCell.h"

@implementation SynopsisDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"avatar_url"]]];
    
    _userHeadImageView.layer.masksToBounds = YES;
    
    _userHeadImageView.layer.cornerRadius = 10;
    
    _userNameLabel.text = _dic[@"nickname"];
    
}

@end
