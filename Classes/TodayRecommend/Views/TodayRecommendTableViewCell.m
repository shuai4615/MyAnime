//
//  TodayRecommendTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "TodayRecommendTableViewCell.h"


@implementation TodayRecommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"topic"][@"user"][@"avatar_url"]]];
    
    _userHeadImageView.layer.masksToBounds = YES;
    
    _userHeadImageView.layer.cornerRadius = 15;
    
    _userNameLabel.text = _dic[@"topic"][@"user"][@"nickname"];
    
    _topicTitleLabel.text = _dic[@"topic"][@"title"];
    
    [_topicImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"cover_image_url"]]];
    
    _title_Label.text = _dic[@"title"];
    
    _sharedLabel.text = [NSString stringWithFormat:@"%@",_dic[@"shared_count"]];
    
    _commentLabel.text = [NSString stringWithFormat:@"%@",_dic[@"comments_count"]];

    if ([_BL isEqualToString:@"1"]) {
        
            if ([_BL_1 isEqualToString:@"1"]) {
                
                NSInteger b = [_dic[@"likes_count"] integerValue] + 1;
                
                _likeLabel.text = [NSString stringWithFormat:@"%ld",b];
                
                _likeLeftLabel.text = @"已赞";

            }else{
                
                _likeLabel.text = [_dic[@"likes_count"] stringValue];
                
                _likeLeftLabel.text = @"赞";

            }
       
    }else{
        
        _likeLabel.text = [NSString stringWithFormat:@"%@",_dic[@"likes_count"]];
    }
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
