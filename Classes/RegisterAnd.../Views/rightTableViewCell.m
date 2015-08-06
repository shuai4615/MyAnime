//
//  rightTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "rightTableViewCell.h"

@implementation rightTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    [_LeftImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"cover_image_url"]]];
    
    _LeftImageView.layer.masksToBounds = YES;
    
    _LeftImageView.layer.cornerRadius = 5;
    
    _title_Label.text = _dic[@"title"];
    
    _likeCountLabel.text = [_dic[@"likes_count"] stringValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_dic[@"created_at"] integerValue]];
    
    NSString *str = [formatter stringFromDate:date];
    
    _timeLabel.text = [str substringWithRange:NSMakeRange(5, 12)];
}

@end
