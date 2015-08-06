//
//  FoundTableViewCell.m
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "FoundTableViewCell.h"

#import "FoundCollectionViewCell.h"

@interface FoundTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArray;
}
@end

@implementation FoundTableViewCell

- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    _title_Label.text = _dic[@"title"];
    
    [_dataArray removeAllObjects];
    
    if ([_numberString isEqualToString:@"1"]) {
        
        _dataArray = [_dic[@"comics"] mutableCopy];
    }else{
        
        _dataArray = [_dic[@"topics"] mutableCopy];
    }

    [_MyFoundCollectionView reloadData];
}

#pragma mark- collectionView- 代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FoundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoundCollectionViewCell" forIndexPath:indexPath];
    
    cell.numberString = _numberString;//下面要用numberString,所以要再之前赋值过去
    
    cell.dic = _dataArray[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        
    NSDictionary *dic = _dataArray[indexPath.row];
    
    if (_block) {
        
        _block([dic[@"id"] stringValue]);
    }
    
}


@end
