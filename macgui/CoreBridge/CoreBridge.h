#import <Foundation/Foundation.h>


@interface CoreBridge : NSObject {
    
}

- (int)sendParser:(NSString*)theCommand;
- (void)startCore;
- (NSMutableArray*)readMatrixFrom:(NSString*)fileToRead;

@end
