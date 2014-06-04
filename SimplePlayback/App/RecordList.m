//
//  RecordList.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 19.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "RecordList.h"
#import "MyCell.h"
#import "DateParser.h"
#import "ProgramParser.h"
#import "ProgramCell.h"
//#import "PlayerController.h"
#import "VDLViewController.h"

@interface RecordList ()

@end

@implementation RecordList

@synthesize responseData = _responseData;

@synthesize image = _image;
@synthesize channelTitle = _channelTitle;
@synthesize tableView = _tableView;
@synthesize collectionView = _collectionView;

@synthesize dateParser = _dateParser;
@synthesize programParser = _programParser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.channelTitle.text = [self.playerDelegate playCtrlGetCurrChannelTitle];
    self.image.image = [self.playerDelegate playCtrlGetCurrChannelImage];
    
    self.dateParser =[[DateParser alloc] init];
    self.dateParser.collectionView = self.collectionView;
    self.dateParser.recordList = self;
    self.collectionView.dataSource = self.dateParser;
    self.collectionView.delegate = self.dateParser;
    self.responseData = [NSMutableData new];

    
    self.programParser = [[ProgramParser alloc] init];
    self.programParser.tableView = self.tableView;
    self.programParser.recordList = self;
    self.tableView.dataSource = self.programParser;
    self.tableView.delegate = self.programParser;
    
    UINib *cellNib = [UINib nibWithNibName:@"MyCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"myCell"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadDateList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{

    [_image release];
    [_tableView release];
    [_channelTitle release];
    [_dateParser release];
    [_programParser release];
    [_responseData release];
    [super dealloc];
}


-(void)loadDateList{
    
    NSMutableString* urlString = [NSMutableString stringWithFormat:@"http://tv.kraslan.ru/api/program/days.xml?id=%@", [self.playerDelegate playCtrlGetCurrChannelId] ];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self.dateParser];
    
}

-(void) loadListForDate:(NSString*) date{

    NSMutableString* urlString = [NSMutableString stringWithFormat:@"http://tv.kraslan.ru/api/program/get.xml?id=%@&date=%@&login=%@&password=%@",
                                  [self.playerDelegate playCtrlGetCurrChannelId],
                                  date,
                                  [self.authDelegate authCtrlGetLogin],
                                  [self.authDelegate authCtrlGetPass]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self.programParser];
};


-(void)play{
    
    NSLog(@"play from RecordList");
    
	//PlayerController *playerCtrl;
	//playerCtrl = [[[PlayerController alloc] initWithNibName:nil bundle:nil] autorelease];
	//playerCtrl.delegate = self;
   // [self.view.window.rootViewController presentViewController:playerCtrl animated:YES completion:nil];
    
    
    VDLViewController* playerController;
    playerController = [[[VDLViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    playerController.playDelegate = self;
    [self presentViewController:playerController animated:YES completion:nil];

}

#pragma mark - PlayerControllerDelegate

- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    return [self.programParser playCtrlGetCurrMediaTitle:title lastPlayPos:lastPlayPos];
}

- (NSURL *)playCtrlGetNextMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    return [self.programParser playCtrlGetNextMediaTitle:title lastPlayPos:lastPlayPos];
}

- (NSURL *)playCtrlGetPrevMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    return [self.programParser playCtrlGetPrevMediaTitle:title lastPlayPos:lastPlayPos];
}

- (NSString *)playCtrlGetCurrChannelTitle{
    return [self.programParser playCtrlGetCurrChannelTitle];
}

- (UIImage *)playCtrlGetCurrChannelImage{
    return [self.programParser playCtrlGetCurrChannelImage];
}

- (NSString *)playCtrlGetCurrChannelId{
    return [self.programParser playCtrlGetCurrChannelId];
}




@end
