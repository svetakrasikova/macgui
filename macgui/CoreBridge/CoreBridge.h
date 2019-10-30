#import <Foundation/Foundation.h>



@interface CoreBridge : NSObject {
    
}

- (int)sendParser:(NSString*)theCommand;
- (void)startCore;
- (Boolean)readMatrixFrom:(NSString*)fileToRead;

@end
