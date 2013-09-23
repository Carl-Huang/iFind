//
//  SQLManager.m
//  Fmdb_manipulate
//
//  Created by vedon on 23/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import "SQLManager.h"
#import "FMDatabase.h"
@implementation SQLManager
@synthesize db;

/*
 [self initDataBase];
 [self createTable];
 
 [self insertValueToExistedTableWithArguments:@[@"carl",@"carl",@"carl",@"carl",[NSNumber numberWithInt:24],[NSNumber numberWithInt:24],@"男",@"男",@"男"]];
 
 [self updateKey:@"alertDistance" value:@"3" withUUID:@"carl"];
 [self deleteDatabaseRowWithUUID:@"carl"];

 */

//创建数据库
-(void)initDataBase
{
    NSString *dataPath = [self initializationFilePath];
    NSLog(@"%@",dataPath);
    self.db = [FMDatabase databaseWithPath:dataPath];
    if (![db open]) {
        NSLog(@"Open db error");
        return;
    }else
    {
        NSLog(@"open db successfully");
    }
    
}
//创建数据表
-(void)createTable
{
    if ([db executeUpdate:@"create table if not exists iFindTable(uuid text primary key,name text,image text,alertDistance integer,alertTime integer,alertMusic text,phoneMode text,deviceMode text,blueMode text)"]) {
        NSLog(@"create table successfully");
    }else
    {
        NSLog(@"Failer to create table,Error: %@",[db lastError]);
    }
}

//插入数据到数据表

-(void)insertValueToExistedTableWithArguments:(NSArray *)array
{
    if ([db executeUpdate:@"insert into iFindTable values(?,?,?,?,?,?,?,?,?)" withArgumentsInArray:array]) {
        NSLog(@"Insert value successfully");
    }else
    {
        NSLog(@"Failer to insert value to table,Error: %@",[db lastError]);
    }
}

//更新数据库数据
-(void)updateKey:(NSString *)key value:(NSString *)value withUUID:(NSString *)uuid
{
    NSString *sqlStr = [NSString stringWithFormat:@"update iFindTable set %@=? where uuid=?",key];
    if ([db executeUpdate:sqlStr,value,uuid]) {
        NSLog(@"update value successfully");
    }else
    {
        NSLog(@"Failer to update value to table,Error: %@",[db lastError]);
    }
}

//删除行记录
-(void)deleteDatabaseRowWithUUID:(NSString *)uuid
{
    if ([db executeUpdate:@"delete from iFindTable where uuid=?",uuid]) {
        NSLog(@"update value successfully");
    }else
    {
        NSLog(@"Failer to update value to table,Error: %@",[db lastError]);
    }
}

//数据库文件路径
-(NSString *)initializationFilePath
{
    NSString * tempFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [tempFilePath stringByAppendingPathComponent:@"DataBase.db"];
    return filePath;
}

@end