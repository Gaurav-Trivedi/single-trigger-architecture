/**
* @Component Name   : AccountTrigger
* @Developed By     : Gaurav Trivedi
* @Created Date     : July 14, 2016
* @Description      : Account trigger with all events, change the object name as per the need to use in different objects
*/
trigger AccountTrigger on Account (before insert, after insert, before update, after update, after delete,before delete, after undelete) {
    AccountHelper handler = new AccountHelper(
            Trigger.isInsert , 
            Trigger.isUpdate ,
            Trigger.isDelete ,
            Trigger.isAfter ,
            Trigger.isBefore , 
            Trigger.isUndelete ,
            Trigger.size,
            'Account', //Change this if putting on different object
            Trigger.new ,
            Trigger.old ,
            Trigger.newMap,
            Trigger.oldMap
            );
        handler.processTrigger();
}