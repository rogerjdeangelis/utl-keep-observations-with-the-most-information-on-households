Keep observations with the most information on households                                                                   
                                                                                                                            
github                                                                                                                      
https://tinyurl.com/yxpsccm2                                                                                                
https://github.com/rogerjdeangelis/utl-keep-observations-with-the-most-information-on-households                            
                                                                                                                            
SAS Forum  (related to)                                                                                                     
https://tinyurl.com/y4w8mjuz                                                                                                
https://communities.sas.com/t5/SAS-Programming/How-to-select-the-more-comprehensive-row-by-a-key-column/m-p/591964          
                                                                                                                            
related to                                                                                                                  
github                                                                                                                      
https://tinyurl.com/yxs56kff                                                                                                
https://github.com/rogerjdeangelis/utl-remove-nulls-while-retaining-the-most-data-possible                                  
                                                                                                                            
*_                   _                                                                                                      
(_)_ __  _ __  _   _| |_                                                                                                    
| | '_ \| '_ \| | | | __|                                                                                                   
| | | | | |_) | |_| | |_                                                                                                    
|_|_| |_| .__/ \__,_|\__|                                                                                                   
        |_|                                                                                                                 
;                                                                                                                           
                                                                                                                            
* note if different houshold had another John then we would have John2;                                                     
* we are looking bachelor/ette before and after marriage;                                                                   
* these are first marriages;                                                                                                
                                                                                                                            
data have;                                                                                                                  
input spouse1$ spouse2$;                                                                                                    
datalines;                                                                                                                  
John1 .                                                                                                                     
John1 Mary1                                                                                                                 
Jake1 Kate1                                                                                                                 
Matt1 .                                                                                                                     
Matt1 .                                                                                                                     
James1 .                                                                                                                    
Marty1 James1                                                                                                               
James1 Marty1                                                                                                               
Marty1 .                                                                                                                    
;;;;                                                                                                                        
run;quit;                                                                                                                   
                                                                                                                            
                        | RULES                                                                                             
 WORK.HAVE total obs=9  | =====                                                                                             
                        |                                                                                                   
 SPOUSE1  SPOUSE2       |                                                                                                   
                        |                                                                                                   
  John1                 | Drop                                                                                              
  John1    Mary1        | Keep  John and Mary is more info than just John                                                   
                                                                                                                            
  Jake1    Kate1        | Keep it is the only one                                                                           
                                                                                                                            
  Matt1                 | Drop                                                                                              
  Matt1                 | Keep just one Matt                                                                                
                                                                                                                            
  James1                | Drop                                                                                              
  Marty1   James1       | Drop                                                                                              
  James1   Marty1       | Keep                                                                                              
                                                                                                                            
  Marty1                | DROP (Marty is in James Marty)                                                                    
                                                                                                                            
*            _               _                                                                                              
  ___  _   _| |_ _ __  _   _| |_                                                                                            
 / _ \| | | | __| '_ \| | | | __|                                                                                           
| (_) | |_| | |_| |_) | |_| | |_                                                                                            
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                           
                |_|                                                                                                         
;                                                                                                                           
                                                                                                                            
                                                                                                                            
WORKWANT total obs=4                                                                                                        
                                                                                                                            
Obs     SPOUSE2    SPOUSE1                                                                                                  
                                                                                                                            
 1      Kate1       Jake1                                                                                                   
 2      Mary1       John1                                                                                                   
 3      Matt1                                                                                                               
 4      Marty1      James1                                                                                                  
                                                                                                                            
*                                                                                                                           
 _ __  _ __ ___   ___ ___  ___ ___                                                                                          
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                                         
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                         
| .__/|_|  \___/ \___\___||___/___/                                                                                         
|_|                                                                                                                         
;                                                                                                                           
                                                                                                                            
                                                                                                                            
data havSwap(where=(hh=1));                                                                                                 
                                                                                                                            
  retain hh 0 spouse2 spouse1;                                                                                              
                                                                                                                            
  set have;                                                                                                                 
  array nams[2] spouse1 spouse2;                                                                                            
  call sortc(of nams[*]);                                                                                                   
                                                                                                                            
  if lag(spouse2) ne spouse2 then hh=1;                                                                                     
  else hh=hh+1;                                                                                                             
                                                                                                                            
run;quit;                                                                                                                   
                                                                                                                            
proc sql;                                                                                                                   
   create                                                                                                                   
       table want as                                                                                                        
   select                                                                                                                   
       spouse2                                                                                                              
      ,spouse1                                                                                                              
   from                                                                                                                     
       havSwap                                                                                                              
   where                                                                                                                    
       spouse2 not in (                                                                                                     
          select                                                                                                            
             spouse1                                                                                                        
          from                                                                                                              
             havSwap                                                                                                        
       )                                                                                                                    
;quit;                                                                                                                      
