/**
 * @file    iot_crittertrap.device.nut
 * @brief   Device code for the IoT Twitter Critter Trap
 * @author  John Mangan (ManganLabs.com)
 *
 * @copyright	This code is public domain but you buy me a beer if you use
 * this and we meet someday (Beerware license).
 *
 * This device code is responsible for putting the Imp into deep sleep
 * after each tweet it sends.  Doing this will conserve battery life
 * considerably.
 *
 * Relies on the Twitter library written by Electric Imp.
 */

function begin() {
    agent.send("sendTweet", 0);    
}

function sleepImp(sleepSeconds) {
    server.log("Sleeping for " + sleepSeconds + " seconds");
    
    // Disconnect from Wifi and go into deep sleep for x 
    // seconds then begin check again.
    // Make sure we are idle before attempting deep sleep
    imp.onidle(function() { imp.deepsleepfor(sleepSeconds)});
}

agent.on("snooze", sleepImp);

imp.onidle(begin);