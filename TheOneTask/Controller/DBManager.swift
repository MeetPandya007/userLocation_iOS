//
//  DBManager.swift
//  TheOneTask
//
//  Created by Meet on 12/07/22.
//

import Foundation
import SQLite3
  
  
class DBManager
{
    init()
    {
        db = openDatabase()
        createTable()
    }
  
  
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
  
  
    func openDatabase() -> OpaquePointer?
    {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(dbPath)")
            return db
        }
    }
      
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Person(name TEXT,vicinity TEXT, lat TEXT, lng TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
      
      
    func insert(name:String, vicinity:String, lat:String, lng:String)
    {
        let insertStatementString = "INSERT INTO Person (name, vicinity, lat, lng) VALUES ('\(name)', '\(vicinity)', '\(lat)', '\(lng)');"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (vicinity as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (lat as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (lng as NSString).utf8String, -1, nil)
              
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
      
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM Person;"
        var queryStatement: OpaquePointer? = nil
        var person : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let vicinity = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lat = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lng = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                person.append(Person(name: name, vicinity: vicinity, lat: Double(lat)!, lng: Double(lng)!))
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return person
    }
   
}
