#import <Foundation/Foundation.h>


@interface CoreBridge : NSObject {
    
}

- (NSMutableArray*)getPalletItems;
- (NSMutableArray*)readMatrixFrom:(NSString*)fileToRead;
- (int)sendParser:(NSString*)theCommand;
- (void)startCore;

@end
