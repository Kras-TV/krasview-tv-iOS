//
//  ListCell.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 13.04.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "ListCell1.h"

@implementation ListCell1
@synthesize icon1=_icon;
@synthesize channel1=_channel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [_icon release];
    [_channel release];
    [super dealloc];
}

@end
