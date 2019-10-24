#import <Foundation/Foundation.h>



@interface CoreBridge : NSObject {
    
}

- (int)sendParser:(NSString*)theCommand;
- (void)startCore;

@end
