// can we use pipe gates to valve the emergency coolant?

// can we bootload the main controller to recover from a fatal lua error?
    //and still recover from ctrl+T obviously

// need computers for refueling on/off and emergency coolant on/off still


// can the OTA loader stop an app thats using the parallels API?
// upgrade OTA loader to be able to replace messaging lib as well
    // upgrade OTA to be able to upgrade itself?!?

const messageSample = {
    Name = 'CP1',
    Data = 'OK', // 100% etc
    SentAt = 1234, // in CC time, set by sender. null if never seen
    ExpiresIn = 5, // in CC time, set by sender. null if never seen
    Expired = false, //comes as true from the network
}

const MessageRegister: Array<Message>;

function checkRegister() { //called in a loop
    // foreach message in MessageRegister 
        // check if expired
            // set to error state data (???) if expired and set expired to true 
}

function registerMessageListener(name: string) {
    // make a new message with ??? data and a null expiresAt and add it to MessageRegister
}

const MessagingProtocol = 'BigBoi' //same for all on network

function listener() {
    // if on protocol for reactor messages
        //get name from message
        //if message exists in register
            //replace data color and expiresAt
        // else noop
}

//the functions that read parameters send report messages seem too varied to standardize, but i'll think on it

function mainLoop(){
    while true {
        scanAndReportOne();
        scanAndReportTwo();
        scanAndReportN();
        checkRegister();
        actBasedOnState();
    }
}

function initMessages(modemSide: string) {
    //turn on modem
}

function sendMessage(name: string, data: any, expiresIn: int) //
{
    //calculate expiresAt from expiresIn
    //hydrate and send message on protocol
}



/* a program for reactor control might look like:

os.loadAPI("messages") //boilerplate: api contains above methods and fields and globals
initMessages("top"); //boilerplate for modem and such (top is modem side)

registerMessageListener(T01);
registerMessageListener(T02);
registerMessageListener(T03);
registerMessageListener(T04);

function manageReactorPower() {
    // consider T01,T02,T03&T04 here and emit redstone  as well as an on off message (message uses lib)
}

function loop(){ //all services will have a loop
    while true {
        checkRegister();
        manageReactorPower();
        sleep()
    }
}

parallel.any(listener,loop);
*/



/* where as a program for turbine health reports might look like: (doesnt need a listener it only emits data)

os.loadAPI("messages") //boilerplate: api contains above methods and fields and globals
initMessages("back"); //boilerplate for modem and such (top is modem side)

sensor = wrap("top"); //boilerplate for sensors

function findAndReport(location: <int,int,int>, name: string) {
    // get sensor data at location
    // calculate value from sensor data (block metadata to percent 0-100, no turbine = MIA)
    //send message with name and value
}

function loop(){ //all services will have a loop
    while true {
        findAndReport(<-1,0,1>, T01);
        findAndReport(<0,1,1>, T02);
        findAndReport(<-1,-1,1>, T03);
        findAndReport(<-1,1,1>, T04);
        sleep();
    }
}

loop();
*/