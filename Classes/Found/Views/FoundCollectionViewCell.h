//
//  FoundCollectionViewCell.h
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, copy) NSString *numberString;

@end
