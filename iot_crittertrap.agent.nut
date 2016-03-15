#require "Twitter.class.nut:1.2.1"

/**
 * @file    iot_crittertrap.agent.net
 * @brief   Agent code for the IoT Twitter Critter Trap
 * @author  John Mangan (ManganLabs.com)
 *
 * @copyright	This code is public domain but you buy me a beer if you use
 * this and we meet someday (Beerware license).
 *
 * This agent code is responsible for posting a Tweet to Twitter immediately
 * on start-up and every hour thereafter until the trap has been reset or
 * the batteries die.
 *
 * Relies on the Twitter library written by Electric Imp.
 */
 

/* INFO YOU NEED FROM TWITTER */
const API_KEY = "YOUR CONSUMER KEY (API KEY)";
const API_SECRET = "YOUR CONSUMER SECRET (API SECRET)";
const AUTH_TOKEN = "YOUR ACCESS TOKEN";
const TOKEN_SECRET = "YOUR ACCESS TOKEN SECRET";

twitter <- Twitter(API_KEY, API_SECRET, AUTH_TOKEN, TOKEN_SECRET);

local lastSaying = "";
local chooseSaying = "";

// Simple function to return a random number between 0 and "max"
function irand(max) {
    // Generate a pseudo-random integer between 0 and max
    local roll = (1.0 * math.rand() / RAND_MAX) * (max);
    return roll.tointeger();
}

// Build an array of sayings. A random saying will be chosen
// each time the trap is sprung. This way you won't get locked
// out of Twitter for posting the same thing over and over again.
local saying = ["Take it like a man, shorty.", 
                "Last one alive, lock the door!",
                "Another successful procedure.",
                "This is my world. You are not welcome in my world!",
                "Whoops... that was not medicine.",
                "Now is good time to run, cowards!",
                "I had me good eye on you the whole time.",
                "I told you not to touch that darned thing.",
                "KABOOOOM!!!",
                "Time to inform your next of kin!",
                "Another satisfied customer!"];
                

function sendTweet(time) {
    
     // Update the time using imp's RTC
    local now = date();
    local seconds = now.sec;
    local minutes = now.min;
    local hours = now.hour;
    local currenttime = hours + ":" + minutes + ":" + seconds;
    
    // Pick a random saying
    chooseSaying = saying[irand(saying.len())];
    
    while (lastSaying == chooseSaying) {
        server.log("DUPLICATE saying detected, selecting another.");
        chooseSaying = saying[irand(saying.len())];  
    }
    
    // Remember the last saying we posted so we can avoid duplicates
    lastSaying = chooseSaying;
    
    // Send the tweet
    twitter.tweet("Critter caught! " + chooseSaying + " - " + currenttime);    
    server.log(chooseSaying + " - " + currenttime);
    
    // Put the Imp to deep sleep for X seconds
    device.send("snooze", 3600);
    
}

// Enter our sendTweet function after Imp is connected to Wifi and happy
device.on("sendTweet", sendTweet);
