//
//  RecordList.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 19.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerControllerDelegate.h"
#import "AuthControllerDelegate.h"
#import "DateParser.h"
#import "ProgramParser.h"

@class DateParser;
@class ProgramParser;

@interface RecordList : UIViewController <PlayerControllerDelegate>

@property (nonatomic, retain) NSMutableData* responseData;

@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet UILabel* channelTitle;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UICollectionView* collectionView;

@property (nonatomic, assign) id<PlayerControllerDelegate> playerDelegate;
@property (nonatomic, assign) id<AuthControllerDelegate> authDelegate;

@property (nonatomic, retain) DateParser* dateParser;
@property (nonatomic, retain) ProgramParser* programParser;

-(void) loadListForDate:(NSString*) date;
-(void) play;

@end
