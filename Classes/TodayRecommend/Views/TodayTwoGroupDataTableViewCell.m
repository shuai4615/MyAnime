//
//  TodayTwoGroupDataTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "TodayTwoGroupDataTableViewCell.h"


@implementation TodayTwoGroupDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    [_userHeadImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"user"][@"avatar_url"]]];
    
    _userHeadImageView.layer.masksToBounds = YES;
    
    _userHeadImageView.layer.cornerRadius = _userHeadImageView.frame.size.height/2;
    
    _userNameLabel.text = _dic[@"user"][@"nickname"];
    
    _likeCountLabel.text = [_dic[@"likes_count"] stringValue];
    
    if ([_dic[@"content"] isKindOfClass:[NSString class]]) {
        
        _contentLabel.text = _dic[@"content"];
    }else{
        
        _contentLabel.text = [_dic[@"content"] stringValue];
    }
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, [_dic[@"height"] floatValue]-45);
    
    _grayLineLabel.frame = CGRectMake(_grayLineLabel.frame.origin.x, [_dic[@"height"] floatValue]-1, _grayLineLabel.frame.size.width, _grayLineLabel.frame.size.height);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_dic[@"created_at"] integerValue]];
    
    NSString *str = [formatter stringFromDate:date];
    
    _timeLabel.text = [str substringWithRange:NSMakeRange(5, 11)];
}

@end
