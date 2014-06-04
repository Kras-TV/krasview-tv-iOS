//
//  List.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 21.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "List.h"
#import "AuthController.h" 
#import "RecordList.h"
#import "ListCell1.h"
#import "VDLViewController.h"
#import "MainListParser.h"

@interface List ()

@end

@implementation List

@synthesize responseData = _responseData;
@synthesize dishs = _dishs;
@synthesize star = _star;
@synthesize currentArray= _currentArray;
@synthesize tableView = _tableView;
@synthesize playIndex = _playIndex;
@synthesize dicImages_msg = _dicImages_msg;
@synthesize authDelegate;
@synthesize favButton = _favButton;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize tabBar = _tabBar;
@synthesize tabBarItem0 = _tabBarItem0;
@synthesize programArray = _programArray;
@synthesize favBarButton = _favBarButton;
@synthesize lpDelegate = lpDelegate;

#pragma mark - live cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Выход"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(showAuthForm)];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, nil];
        UIBarButtonItem* starButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"nonstar.png"]
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(favButtonClick)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:starButton, nil];
        self.favBarButton = starButton;
    }
    self.lpDelegate = [[ProgramLoader alloc] init];
    lpDelegate.tableDelegate=self;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(update)
                                                 name:@"update"
                                               object:nil];
    
    self.responseData = [NSMutableData new];
    self.dishs = [NSMutableArray array];
    self.star = [NSMutableArray array];
    _programArray = [[NSMutableDictionary alloc] init];
    _dicImages_msg = [[NSMutableDictionary alloc] init];
    
    [self.tabBar setSelectedItem:self.tabBarItem0];
    
    favSelected = YES;
    self.currentArray = _dishs;
    [self favButtonClick];
    
    [self update];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dealloc
{
    [_responseData release];
    [_dishs release];
    [_star release];
    [_currentArray release];
    [_tabBar release];
    [_tabBarItem0 release];
    [_tableView release];
    [_playIndex release];
    [_dicImages_msg release];
    [_programArray release];
    self.currentIndexPath = nil;
    self.lpDelegate = nil;
    [super dealloc];
}

#pragma mapk dop

-(void)update{
    self.dishs = nil;
    self.star = nil;
    self.dishs = [NSMutableArray array];
    self.star = [NSMutableArray array];
    [self loadList];
}

-(void)loadList{
    NSMutableString* urlString = [NSMutableString stringWithFormat:@"http://tv.kraslan.ru/api/tv/get.xml?login=%@&password=%@", [self.authDelegate authCtrlGetLogin] , [self.authDelegate authCtrlGetPass]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark - button actions

-(IBAction)favButtonClick{
    NSLog(@"currentArray %@", self.currentArray);
    favSelected = !favSelected;
    if (favSelected) {
        self.favButton.layer.backgroundColor = [[[[[UIApplication sharedApplication] delegate] window] tintColor] CGColor];
        [self.favButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.currentArray = _star;
        self.favBarButton.image = [UIImage imageNamed:@"star.png"];
    }else{
        self.favButton.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        [self.favButton setTitleColor:[[[[UIApplication sharedApplication] delegate] window] tintColor]  forState:UIControlStateNormal];
        self.currentArray = _dishs;
        self.favBarButton.image = [UIImage imageNamed:@"nonstar.png"];
    }
    [self.tableView reloadData];
}

-(IBAction)showListAction:(id)sender{
    NSLog(@"programArray %@", self.programArray);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //получить ячейку
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell1" owner:self options:nil];
        //cell = [nib objectAtIndex:0];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

    }
    //получить словарь, из которого будут браться данные
    NSDictionary *dic = [self.currentArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    //поставить иконку или начать загрузку
    if ([self.dicImages_msg valueForKey:[[self.currentArray objectAtIndex:indexPath.row]   valueForKey:@"image"]]) {
        cell.imageView.image = [self.dicImages_msg valueForKey:[[self.currentArray objectAtIndex:indexPath.row] valueForKey:@"image"]];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        [self.dicImages_msg setObject:[UIImage imageNamed:@"placeholder.png"] forKey:[[self.currentArray objectAtIndex:indexPath.row] valueForKey:@"image"]];
        [self performSelectorInBackground:@selector(downloadImage_3:) withObject:indexPath];
    }
    
    //поставить программу или начать загрузку
    if ([self.programArray valueForKey:[[self.currentArray objectAtIndex:indexPath.row]   valueForKey:@"id"]]) {
       /* cell.program1.text = [[self.programArray valueForKey:[[self.currentArray objectAtIndex:indexPath.row] valueForKey:@"id"]] valueForKey:@"name"];
        cell.time1.text = [[self.programArray valueForKey:[[self.currentArray objectAtIndex:indexPath.row] valueForKey:@"id"]] valueForKey:@"time"];
        cell.progress1.progress = [[[self.programArray valueForKey:[[self.currentArray objectAtIndex:indexPath.row] valueForKey:@"id"]] valueForKey:@"percent"] floatValue]/100.0;*/
    }else{
       /* cell.program1.text = @"";
        cell.time1.text = @"";
        cell.progress1.progress = 0;
        [self downloadProgram:indexPath];*/
    }
    
    //поставить индекатор в зависимости от того стоит воспроизведение или записи
    switch ([[self.tabBar items] indexOfObject:self.tabBar.selectedItem]) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark dop

//скачивание картинки
-(void)downloadImage_3:(NSIndexPath *)path{
    NSAutoreleasePool *pl = [[NSAutoreleasePool alloc] init];
    
    NSString *str ;
    str = [[self.currentArray objectAtIndex:path.row] valueForKey:@"image"];
    
    UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
    
    [self.dicImages_msg setObject:img forKey:str];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [pl release];
}

//скачивание программы передач
-(void)downloadProgram:(NSIndexPath *)path{
    [self.programArray setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"name", nil] forKey:[[self.currentArray objectAtIndex:path.row] valueForKey:@"id"]];
    [self.lpDelegate loadProgramForChannelID:[[self.currentArray    objectAtIndex:path.row] valueForKey:@"id"]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndexPath = indexPath;
    
    NSDictionary *dic = [self.currentArray objectAtIndex:indexPath.row];
    self.playIndex = indexPath;
    
    switch ([[self.tabBar items] indexOfObject:self.tabBar.selectedItem]) {
        case 0:
            [self play];
            break;
        case 1:
            [self showRecordList:[dic objectForKey:@"id"]];
            break;
        default:
            break;
    }
}

#pragma mark dop 

-(void)play{
    VDLViewController* playerController;
    playerController = [[[VDLViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    playerController.playDelegate = self;
    [self presentViewController:playerController animated:YES completion:nil];
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString* result = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] ;
    if([result isEqualToString: @"auth failed"]){
        [self showAuthError];
    }else{
        
        MainListParser* del = [[MainListParser alloc] init];
        del.list = self;
        NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData: self.responseData];
        rssParser.delegate = del;
        [rssParser parse];
        [rssParser release];
        [del release];
        
    }
    [result release];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Невозможно подключиться" message:@"Проверьте подключение, попробуйте еще раз" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Повторить", nil];
    [alert show];
    [alert release];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Нажата кнопка: %d", buttonIndex);
    if(buttonIndex == 1){
        [self update];
    }
}

#pragma mark dop

-(void)addElement:(NSDictionary*)dic{
    [self.dishs addObject:dic];
    if([[dic objectForKey:@"star"] isEqualToString:@"1"]){
        [self.star addObject:dic];
    }
    favSelected = !favSelected;
    [self favButtonClick];
}

#pragma mark - PlayerControllerDelegate

- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    NSDictionary *dic = [self.currentArray objectAtIndex:self.playIndex.row];
    return [NSURL URLWithString:[dic objectForKey:@"uri"]];
}

- (NSURL *)playCtrlGetNextMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    NSInteger i = [self tableView:self.tableView numberOfRowsInSection:1];
    if(self.playIndex.row >= i-1){
        self.playIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    }else{
        self.playIndex = [NSIndexPath indexPathForRow:self.playIndex.row+1 inSection:1];
    }
	return [self playCtrlGetCurrMediaTitle:nil lastPlayPos:0];
}

- (NSURL *)playCtrlGetPrevMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
    NSInteger i = [self tableView:self.tableView numberOfRowsInSection:1];
    if(self.playIndex.row <=0 ){
        self.playIndex = [NSIndexPath indexPathForRow:i-1 inSection:1];
    }else{
        self.playIndex = [NSIndexPath indexPathForRow:self.playIndex.row-1 inSection:1];
    }
    
	return [self playCtrlGetCurrMediaTitle:nil lastPlayPos:0];
}

- (NSString *)playCtrlGetCurrChannelTitle{
    NSDictionary *dic = [self.currentArray objectAtIndex:self.currentIndexPath.row];
    return[dic objectForKey:@"title"];
}
- (UIImage *)playCtrlGetCurrChannelImage{
    return [self.dicImages_msg valueForKey:[[self.currentArray objectAtIndex:self.currentIndexPath.row] valueForKey:@"image"]];
}

- (NSString *)playCtrlGetCurrChannelId{
    NSDictionary *dic = [self.currentArray objectAtIndex:self.currentIndexPath.row];
    return[dic objectForKey:@"id"];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [self reloadData];
}

#pragma mark - TableSyncProtocol

- (void)dataLoadFinishing{
    //NSLog(@"!!1");
};


-(void)reloadData{
    [self.tableView reloadData];
};


#pragma mark - List

-(void) showAuthError{
    [self showAuthForm];
}

-(void)showAuthForm{
    AuthController *authCtrl;
	authCtrl = [[[AuthController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self presentViewController:authCtrl animated:YES completion:nil];
}

-(void)finishDownload:(NSMutableDictionary*)dic withId:(NSString*)id{
    NSLog(@"Загружен словарь %@ - %@", id, dic);
    [self.programArray setObject:dic forKey:id];
    [self.tableView reloadData];
}

-(void)showRecordList:(NSString*) id{
    RecordList *newController = [[RecordList alloc] initWithNibName:nil bundle:nil];
    newController.title = @"Записи";
    newController.playerDelegate = self;
    newController.authDelegate = self.authDelegate;
    [self.navigationController pushViewController:newController animated:YES];
}

-(void)showFavoriteList{
    List *newController = [[List alloc] initWithNibName:nil bundle:nil];
    newController.title = @"Избранное";
    newController.authDelegate = self.authDelegate;
    [self.navigationController pushViewController:newController animated:YES];
}



@end
