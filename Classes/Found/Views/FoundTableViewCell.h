//
//  FoundTableViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UICollectionView *MyFoundCollectionView;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, copy) NSString *numberString;

@property (nonatomic, copy) void (^block)(NSString *idString);


@property (weak, nonatomic) IBOutlet UIButton *moreButton;



@end
