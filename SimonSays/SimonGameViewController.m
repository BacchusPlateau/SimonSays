//
//  SimonGameViewController.m
//  SimonSays
//
//  Created by Bret Williams on 12/3/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import "SimonGameViewController.h"

@interface SimonGameViewController ()

@end

@implementation SimonGameViewController

AVAudioPlayer *audioEffect;
AVAudioPlayer *backgroundMusic;
int currentSoundNo;
int guessNumber;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.gameState = @"Loading";
    self.guessList = [[NSMutableArray alloc] init];
    
    [self newGame];
    
}

- (void)newGame {
    
    self.roundNumber = 1;
    guessNumber = 0;
    
    [self.guessList removeAllObjects];
    [self addAGuess];
    [self playMusic: @"music"];
    
}

-(void)playMusic:(NSString *)musicName {
    
    if(backgroundMusic == nil) {
        
        NSURL *musicFile = [[NSBundle mainBundle] URLForResource:musicName withExtension:@"mp3"];
        backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
        [backgroundMusic prepareToPlay];
        backgroundMusic.numberOfLoops = -1;  //play forever
        backgroundMusic.volume = 0.25;
        [backgroundMusic play];
        
    }
    
}

-(void)addAGuess {
    
    self.gameState = @"GameTurn";
    currentSoundNo = 0;
    guessNumber = 0;
    int randEnemy =  (arc4random() % 4)+1;
    NSNumber *soundNo = [NSNumber numberWithInteger:randEnemy];
    [self.guessList addObject:soundNo];
    self.guessLabel.text = [NSString stringWithFormat:@"%ld", (long)self.roundNumber];
    self.playListTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playSoundList) userInfo:nil repeats:NO];
    
}

-(void)playSoundList {
    
    NSNumber *guessNo = self.guessList[currentSoundNo];
    [self playSound: (long)[guessNo integerValue]];
    currentSoundNo++;
    if(currentSoundNo < self.guessList.count) {
        
        self.playListTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(playSoundList) userInfo:nil repeats:NO];
        
    }
    else {
        
        self.gameState = @"Play";
        self.playListTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideButtonImage) userInfo:nil repeats:NO];
        
    }
}

-(void)hideButtonImage {
    
    [self.highlightImageView setImage:[UIImage imageNamed:@"empty.png"]];
    
}


-(void)playSound:(long)tag {
    
    NSString *soundName = NULL;
    
    switch(tag) {
            
        case 1:
            soundName = @"red";
            break;
        case 2:
            soundName = @"blue";
            break;
        case 3:
            soundName = @"yellow";
            break;
        case 4:
            soundName = @"green";
            break;
        default:
            soundName = @"error";
            break;
            
    }
    
    [self.highlightImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", soundName]]];
    [self playSoundEffect: soundName];
    
}

-(void)playSoundEffect: (NSString *) effectName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: effectName ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath: path];
    audioEffect = [[AVAudioPlayer  alloc] initWithContentsOfURL:pathURL error:nil];
    audioEffect.numberOfLoops = 0;
    [audioEffect prepareToPlay];
    [audioEffect play];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)triggerButtonSound:(id)sender {
    
    if(![self.gameState isEqualToString: @"Play"] ) return;
    
    if([self.guessList[guessNumber]intValue] != (long)[sender tag]) {
        
        self.roundNumber = 0;
        [self playSound: -1];
        [self newGame];
        return;
    } else
    {
     
        [self playSound: [sender tag]];
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(hideButtonImage) userInfo:nil repeats:NO];
        guessNumber++;
        if(guessNumber == self.roundNumber) {
            self.roundNumber++;
            [self addAGuess];
        }
    }
}

-(void)stopAllAudio {
    
    [self stopMusic];
    [self stopSound];
    
}

-(void) stopSound {
    
    [backgroundMusic stop];
    backgroundMusic = nil;
}

-(void) stopMusic {
    
    [audioEffect stop];
    audioEffect = nil;
    
}

- (IBAction)exitGame:(id)sender {
    
    [self.playListTimer invalidate];
    self.playListTimer = nil;
    [self stopAllAudio];
    
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    if(flags == AVAudioSessionInterruptionOptionShouldResume) {
        [self playMusic: @"music"];
    }
}

@end
