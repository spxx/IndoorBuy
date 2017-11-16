//
//  FMDBTools.h
//  FMDBTools
//
//  Created by gukai on 16/1/5.
//  Copyright © 2016年 gukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBTools : NSObject
/**
 *   在沙盒路径下 /Documents/ 创建数据库
 *
 *   @param dbname: 数据库名称
 *
 *   @return 创建成功返回ture, 否则返回fales
 */
+ (BOOL)createDataBase:(NSString *)dbname;

/**
 *  在对应的数据库中创建表
 *
 *  @param dbname: 数据库名称
 *
 *  @param tableName: 表名
 *
 *  @param value_map: 传入一个字典对象,将会对字典里面的所有key值在数据库中生成对应列字段
 *
 *
 *  @return 建表成功返回ture, 否则返回fales
 *
 *  注意: 此方法字典里面的key对应的value值必须是字符串，不能为其他类型
 */
+ (BOOL)createTableInDataBase:(NSString *)dbname tableName:(NSString *)tableName value_map:(NSDictionary *)value_map;
#warning 建表的操作里的 value_map 里面 Key值 必须是字符串,且建的表的对应列都是 string 类型 ,会自动生成id

/**
 *  在对应的数据库中进行查询
 *
 *  @param dbname: 数据库名称
 *
 *  @param  sql: SQL操作语句
 *
 *
 *  @return 根据查询的条件返回的结果
 */
+ (NSMutableArray *)execQuery:(NSString *)dbname sql:(NSString *)sql;
/**
 *  在对应的数据库中进行查询
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  column_list: 要查询的列,传入nil将会返回一个对象
 *
 *  @param  condition_map: 条件,根据条件查询，例如字典：@{age = 20},
            查询年龄为20的数据
 *
 *
 *  @return 根据查询条件返回结果
 */
+ (NSMutableArray *)executeQuery:(NSString *)dbname tableName:(NSString *)tableName column_list:(NSArray *)column_list condition_map:(NSDictionary *)condition_map;

/**
 *  在对应的数据库中进行增，删，改，查的操作，传入SQL语句即可
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  sql: SQL操作语句
 *
 *
 *  @return 操作成功返回ture,否则返回false
 */
+ (BOOL)execUpdate:(NSString *)dbname sql:(NSString *)sql;

/**
 *  在对应的数据库中对某表进行修改操作
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  value_map: 对应的新值，是一个字典，key为对应要修改的字段，value为新值（必须表中对应的 key 值列才会修改成功）
 *
 *  @param  condition_map: 条件，根据条件进行修改
 *
 *
 *  @return 操作成功返回ture,否则返回false
 */
+ (BOOL)executeUpdate:(NSString *)dbname tableName:(NSString *)tableName value_map:(NSDictionary *)value_map condition_map:(NSDictionary *)condition_map;

/**
 *  在对应的数据库中对某表进行插入一条新数据
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  value_map: 对应的对象，是一个字典，key为对应的字段，value为新值(传入一个具有该表所有字段为key值的对象)
 *
 *
 *  @return 插入成功返回ture,否则返回false
 */
+ (BOOL)executeInsert:(NSString *)dbname tableName:(NSString *)tableName value_map:(NSDictionary *)value_map;

/**
 *  在对应的数据库中对应某表进行删除数据
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  condition_map: 条件，根据条件删除
 *
 *
 *  @return 删除成功返回ture,否则返回false
 */
+ (BOOL)executeDelete:(NSString *)dbname tableName:(NSString *)tableName condition_map:(NSDictionary *)condition_map;

/**
 *  在对应的数据库中删除某表
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *
 *  @return 删除成功返回ture,否则返回false
 */
+ (BOOL)executeDeleteTable:(NSString *)dbname tableName:(NSString *)tableName;

@end
