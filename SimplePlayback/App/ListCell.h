//
//  ListCell.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 13.04.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView* icon;
@property (nonatomic, retain) IBOutlet UILabel* channel;
@property (nonatomic, retain) IBOutlet UILabel* time;
@property (nonatomic, retain) IBOutlet UILabel* program;
@property (nonatomic, retain) IBOutlet UIProgressView* progress;

@end
