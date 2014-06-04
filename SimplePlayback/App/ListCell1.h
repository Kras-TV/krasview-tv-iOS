//
//  ListCell.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 13.04.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell1 : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView* icon1;
@property (nonatomic, retain) IBOutlet UILabel* channel1;
@property (nonatomic, retain) IBOutlet UILabel* time1;
@property (nonatomic, retain) IBOutlet UILabel* program1;
@property (nonatomic, retain) IBOutlet UIProgressView* progress1;

@end
