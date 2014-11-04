//
//  VisitCellTableViewCell.h
//  Visits
//
//  Created by 石田勝嗣 on 2014/11/04.
//  Copyright (c) 2014年 石田勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *record;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *accuracy;
@property (weak, nonatomic) IBOutlet UILabel *arrival;
@property (weak, nonatomic) IBOutlet UILabel *departure;
@end
