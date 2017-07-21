//
//  SemesterViewController.m
//  MUSTPlus
//
//  Created by Cirno on 26/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "SemesterViewController.h"

@interface SemesterViewController ()

@end

@implementation SemesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.semester.week;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 60)];
    [cell addSubview:label];
    label.text = [NSString stringWithFormat:@"Cell: %li", (long)indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    //UILabel *label = (UILabel *)[cell viewWithTag:100];
    [self.menuDelegate didSelectMenuItem:[NSString stringWithFormat:@"%ld",(long)cell.tag]];
}



@end
