//
//  MyCell.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 31.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

@synthesize day = _day;
@synthesize number = _number;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
