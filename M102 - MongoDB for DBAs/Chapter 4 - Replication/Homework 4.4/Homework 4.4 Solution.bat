@REM ==============================================================================
@REM MIT License                                                                   
@REM                                                                               
@REM Copyright (c) 2017 Donato Rimenti                                             
@REM                                                                               
@REM Permission is hereby granted, free of charge, to any person obtaining a copy  
@REM of this software and associated documentation files (the "Software"), to deal 
@REM in the Software without restriction, including without limitation the rights  
@REM to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     
@REM copies of the Software, and to permit persons to whom the Software is         
@REM furnished to do so, subject to the following conditions:                      
@REM                                                                               
@REM The above copyright notice and this permission notice shall be included in    
@REM all copies or substantial portions of the Software.                           
@REM                                                                               
@REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    
@REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      
@REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   
@REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        
@REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
@REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
@REM SOFTWARE.                                                                     
@REM ==============================================================================
@REM																			   
@REM DESCRIPTION : Solution for MongoDB University M102's Homework 4-4. 
@REM AUTHOR : Donato Rimenti													   
@REM COPYRIGHT : Copyright (c) 2017 Donato Rimenti								   
@REM LICENSE : MIT																   
@REM																			   
@REM ==============================================================================

@REM Creates the data dirs.
mkdir 1
mkdir 2
mkdir 3

@REM Starts a server.
start mongod --dbpath 1

@REM Waits for the server.
timeout 5

@REM Inits the DB and shuts it down.
mongo admin --eval "load('../chapter_4_replication/replication.js'); homework.init(); db.shutdownServer(); quit();"

@REM Starts the replica set.
start mongod --port 27001 --dbpath 1 --replSet replSet
start mongod --port 27002 --dbpath 2 --replSet replSet
start mongod --port 27003 --dbpath 3 --replSet replSet

@REM Waits for the server.
timeout 5

@REM Prints the solution.
mongo replication --port 27001 --eval "load('../chapter_4_replication/replication.js'); rs.initiate({ _id: 'replSet', members:[{ _id : 0, host :'localhost:27001'}, { _id : 1, host : 'localhost:27002'}, { _id : 2, host : 'localhost:27003'}]}); sleep(20000); rs.stepDown();"

@REM Prints the solution.
mongo replication --port 27002 --eval "load('../chapter_4_replication/replication.js'); rs.reconfig({ _id : 'replSet', members:[{ _id : 1, host : 'localhost:27002'}, { _id : 2, host : 'localhost:27003'}]}, {force : true}); sleep(20000); print('Solution : ' + homework.d());"