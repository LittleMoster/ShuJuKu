//
//  EncryptUtils.h
//  AS
//
//  Created by cguo on 2017/1/9.
//  Copyright © 2017年 vanward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptUtils : NSObject

/** encrypt sqlite database (same file) */
+ (BOOL)encryptDatabasePath:(NSString *)path encryptKey:(NSString *)encryptKey;

/** decrypt sqlite database (same file) */
+ (BOOL)unEncryptDatabasePath:(NSString *)path encryptKey:(NSString *)encryptKey;

/** encrypt sqlite database to new file */
+ (BOOL)encryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath encryptKey:(NSString *)encryptKey;

/** decrypt sqlite database to new file */
+ (BOOL)unEncryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath encryptKey:(NSString *)encryptKey;

/** change secretKey for sqlite database */
+ (BOOL)changeKey:(NSString *)dbPath originKey:(NSString *)originKey newKey:(NSString *)newKey;

@end
