function bob_setWheelSpeeds(connection,leftInRadPerSec,rightInRadPerSec)

    global isoctave;
    
    if ~isoctave
        signalValue=connection.vrep.simxPackFloats([leftInRadPerSec,rightInRadPerSec]);
        connection.vrep.simxSetStringSignal(connection.clientID,strcat('Bob_reqVelocities',num2str(connection.robotNb)),signalValue,connection.vrep.simx_opmode_oneshot);
    else
        signalValue=simxPackFloats([leftInRadPerSec,rightInRadPerSec]);
        simxSetStringSignal(connection.clientID,strcat('Bob_reqVelocities',num2str(connection.robotNb)),signalValue,connection.vrep.simx_opmode_oneshot);
    end
end