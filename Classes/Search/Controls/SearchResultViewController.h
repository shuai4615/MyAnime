//
//  SearchResultViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;


@property (nonatomic, copy) NSString *keyString;

@property (nonatomic, assign) NSInteger number;

@end
