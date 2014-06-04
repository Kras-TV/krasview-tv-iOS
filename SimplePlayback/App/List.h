//
//  List.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 21.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthControllerDelegate.h"
#import "PlayerControllerDelegate.h"
#import "ProgramLoader.h"
#import "TableSyncProtocol.h"
#import "ProgramLoaderProtocol.h"

@class ProgramLoader;


@interface List : UIViewController    <UITableViewDelegate,
                                            UITableViewDataSource,
                                            UITabBarDelegate,
                                            PlayerControllerDelegate,
                                            TableSyncProtocol>{
    
    Boolean favSelected;
    ProgramLoader *lpDelegate;
    
}

-(IBAction)favButtonClick;
-(IBAction)showListAction:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIButton* favButton;

@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarItem *tabBarItem0;

@property (nonatomic, assign) id<AuthControllerDelegate> authDelegate;
@property (nonatomic, retain) id<ProgramLoaderProtocol, NSURLConnectionDelegate> lpDelegate;

@property (nonatomic, retain) NSMutableData* responseData;

@property (nonatomic, retain) NSMutableArray* dishs;
@property (nonatomic, retain) NSMutableArray* star;
@property (nonatomic, retain) NSArray* currentArray;

@property (nonatomic, retain) NSIndexPath* playIndex;

@property (nonatomic, retain) NSMutableDictionary* dicImages_msg;
@property (nonatomic, retain, readonly) NSMutableDictionary* programArray;

@property (nonatomic, retain) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) UIBarButtonItem* favBarButton;



-(void)loadList;
//-(void)reloadData;

//-(void)finishDownload:(NSMutableDictionary*)dic withId:(NSString*)id;

-(void)addElement:(NSDictionary*)dic;

@end
