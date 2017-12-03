//
//  SimonGameViewController.h
//  SimonSays
//
//  Created by Bret Williams on 12/3/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SimonGameViewController : UIViewController<AVAudioPlayerDelegate>

@property NSMutableArray *guessList;
@property NSInteger roundNumber;
@property NSString *gameState;
@property NSTimer *playListTimer;

@property (strong, nonatomic) IBOutlet UILabel *guessLabel;
@property (strong, nonatomic) IBOutlet UIImageView *highlightImageView;

- (IBAction)triggerButtonSound:(id)sender;
- (IBAction)exitGame:(id)sender;

@end
