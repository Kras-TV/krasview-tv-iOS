/* Copyright (c) 2013, Felix Paul Kühne and VideoLAN
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, 
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. */

#import "VDLViewController.h"
#import "MobileVLCKit.h"
#import "VSegmentSlider.h"

@interface VDLViewController ()
{
    VLCMediaPlayer      *_mediaplayer;
    NSTimer             *mSyncSeekTimer;
    BOOL isSlided;
}

@property (nonatomic, assign) IBOutlet VSegmentSlider *progressSld;
@property (nonatomic, assign) IBOutlet UILabel *timeCurrent;
@property (nonatomic, assign) IBOutlet UILabel *timeEnd;

@end

@implementation VDLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isSlided = NO;

    /* setup the media player instance, give it a delegate and something to draw into */
    _mediaplayer = [[VLCMediaPlayer alloc] init];
    _mediaplayer.delegate = self;
    _mediaplayer.drawable = self.movieView;

    /* create a media object and give it to the player */
    NSURL *url = [self.playDelegate playCtrlGetCurrMediaTitle:nil lastPlayPos:0];
    _mediaplayer.media = [VLCMedia mediaWithURL:url];
    //_mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://CA9CA6A22FAA619F:@t.kraslan.ru/rentv?krasview.ru"]];
    [_mediaplayer play];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self.view selector:@selector(hide) userInfo:nil repeats:NO];
    [timer fire];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

-(IBAction)goBackButtonAction:(id)sender
{
	[_mediaplayer stop];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)previous:(id)sender{
    [_mediaplayer stop];
    NSURL *url = [self.playDelegate playCtrlGetPrevMediaTitle:nil lastPlayPos:0];
    NSLog(@"%@", url);
    _mediaplayer.media = [VLCMedia mediaWithURL:url];
    [_mediaplayer play];
}
- (IBAction)next:(id)sender{
    [_mediaplayer stop];
    NSURL *url = [self.playDelegate playCtrlGetNextMediaTitle:nil lastPlayPos:0];
    _mediaplayer.media = [VLCMedia mediaWithURL:url];
    [_mediaplayer play];
}

- (IBAction)playandPause:(id)sender
{
    if (_mediaplayer.isPlaying)
        [_mediaplayer pause];
    
    [_mediaplayer play];
}

-(IBAction)progressSliderDownAction:(id)sender
{
    isSlided = YES;
   // NSLog(@"progressSliderDownAction");
}

-(IBAction)progressSliderUpAction:(id)sender
{
   // NSLog(@"progressSliderUPAction");
    isSlided = NO;
	UISlider *sld = (UISlider *)sender;
    [_mediaplayer setPosition:(float)(sld.value)];
}

-(IBAction)dragProgressSliderAction:(id)sender
{
   // NSLog(@"dragProgressSliderAction");
}

-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
     //NSLog(@"progressSliderTapped");
}

#pragma mark - Sync UI Status

-(void)syncUIStatus
{
    self.progressSld.value = [_mediaplayer position];
    self.timeCurrent.text = [NSString stringWithFormat:@"%@",[_mediaplayer time]];
   // NSLog(@"%@",_mediaplayer.remainingTime);
    self.timeEnd.text=@"";
}

#pragma mark - VLCMediaPlayerDelegate

/**
 * Sent by the default notification center whenever the player's state has changed.
 * \details Discussion The value of aNotification is always an VLCMediaPlayerStateChanged notification. You can retrieve
 * the VLCMediaPlayer object in question by sending object to aNotification.
 */
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    //NSLog(@"mediaPlayerStateChanged");
};

/**
 * Sent by the default notification center whenever the player's time has changed.
 * \details Discussion The value of aNotification is always an VLCMediaPlayerTimeChanged notification. You can retrieve
 * the VLCMediaPlayer object in question by sending object to aNotification.
 */
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
    if(!isSlided){
        [self syncUIStatus];
    }else{
    }
};


@end
