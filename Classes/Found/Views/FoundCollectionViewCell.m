//
//  FoundCollectionViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "FoundCollectionViewCell.h"


@implementation FoundCollectionViewCell

-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    _title_Label.text = _dic[@"title"];
    
    if ([_numberString isEqualToString:@"1"]) {
        
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"cover_image_url"]]];
        
//        _titleImageView.frame = CGRectMake(_titleImageView.frame.origin.x, _titleImageView.frame.origin.y, _titleImageView.frame.size.width, 110);
        
        _userNameLabel.text = _dic[@"topic"][@"user"][@"nickname"];
    }else{
        
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"vertical_image_url"]]];
        
        _userNameLabel.text = _dic[@"user"][@"nickname"];
    }
    
}

@end
