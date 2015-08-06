//
//  MoreCommentTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "MoreCommentTableViewCell.h"

@implementation MoreCommentTableViewCell

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
    
    if ([_dic[@"content"] isKindOfClass:[NSString class]]) {
        
        _contentLabel.text = _dic[@"content"];
    }else{
        
        _contentLabel.text = [_dic[@"content"] stringValue];
    }
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, [_dic[@"height"] floatValue]-45);
    
    //时间戳转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_dic[@"created_at"] integerValue]];
    
    NSString *str = [formatter stringFromDate:date];
    
    _timeLabel.text = [str substringWithRange:NSMakeRange(5, 11)];
    
    //赞的刷新和判断
//    if (_cellFlag) {
//        
//        NSInteger num =[_dic[@"likes_count"] integerValue] + 1;
//        
//        _likeCountLabel.text = [NSString stringWithFormat:@"%ld",num];
//        
//        _goodLabel.text = @"已赞";
//
//    }else{
//        
//        _likeCountLabel.text = [_dic[@"likes_count"] stringValue];
//        
//        _goodLabel.text = @"赞";
//
//    }
}

@end
