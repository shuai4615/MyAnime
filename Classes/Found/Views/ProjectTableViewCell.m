//
//  ProjectTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

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
    
    _title_Label.text = _dic[@"title"];
    
    if (_number == 1) {
        
        _userNameLabel.text = _dic[@"topic"][@"user"][@"nickname"];
    }else{
        
        _userNameLabel.text = _dic[@"user"][@"nickname"];
    }
    
    
}

@end
