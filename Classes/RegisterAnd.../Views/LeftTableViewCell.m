//
//  LeftTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"cover_image_url"]]];
    
    _leftImageView.layer.masksToBounds = YES;
    
    _leftImageView.layer.cornerRadius = 5;
    
    _topictitle_Label.text = _dic[@"title"];
    
    _userNameLabel.text = _dic[@"topic"][@"user"][@"nickname"];
    
    
}

@end
