// based on Apple's SoundEffect.m

#import "BFSoundEffect.h"

@implementation BFSoundEffect

+ (id)soundEffectWithContentsOfFile:(NSString *)aPath
{
    if (aPath)
	{
        return [[BFSoundEffect alloc] initWithContentsOfFile:aPath];
    }
    return nil;
}

- (id)initWithContentsOfFile:(NSString *)path
{
    self = [super init];

    if (self != nil)
	{
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
        if (aFileURL != nil)
		{
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &aSoundID);
            
            if (error == kAudioServicesNoError)
			{ // success
                _soundID = aSoundID;
            }
			else
			{
				NSLog(@"Error %ld loading sound at path: %@", error, path);
                self = nil;
            }
        }
		else
		{
            NSLog(@"NSURL is nil for path: %@", path);
            self = nil;
        }
    }
    return self;
}

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
}

-(void)playAudio
{
    AudioServicesPlaySystemSound(_soundID);
}

-(void)stopAudio
{
    AudioServicesDisposeSystemSoundID(_soundID);
}

@end