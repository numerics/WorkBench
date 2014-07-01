// based on Apple's SoundEffect.m

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface BFSoundEffect:NSObject
{
    SystemSoundID _soundID;
}

+ (id)soundEffectWithContentsOfFile:(NSString *)aPath;
- (id)initWithContentsOfFile:(NSString *)path;
- (void)playAudio;
- (void)stopAudio;

@end