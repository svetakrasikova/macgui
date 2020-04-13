#import <Foundation/Foundation.h>


@interface CoreBridge : NSObject {
    
}

- (NSMutableArray*)getPalletItems;
- (NSMutableArray*)getVariablesFromCore;
- (NSMutableArray*)readMatrixFrom:(NSString*)fileToRead;
- (int)sendParser:(NSString*)theCommand;
- (void)startCore;

@end
