% An example for using the server to acquire some data.
% Connect OUT1 with IN1!

% Add the client object to the path
addpath('../../client/matlab/')

% Connect to the Red Pitaya
rp = RedPitaya('rp-f00806.local');
rp.connect();

% Define acquisition parameters
dec = 8;
modulus = 4800;
frequency = 25000;
base_frequency = 125000000;
samples_per_period = floor(modulus/dec); %samples_per_period_base/dec
periods_per_frame = 1;

% Set acquisition parameters
rp.setDecimation(dec);
rp.setSamplesPerPeriod(samples_per_period);
rp.setPeriodsPerFrame(periods_per_frame);

rp.setDACMode("rasterized");
rp.reconfigureDACModulus(0, 0, 4800);
rp.setModulusFactor(0, 0, 1);

fprintf('DAC frequency is %fHz.\n\r', rp.getFrequency(0, 0))
rp.setAmplitude(0, 0, 7000);
rp.setPhase(0, 0, 0.33);
rp.setMasterTrigger(false);
rp.setRamWriterMode("triggered");

pause(0.1);

rp.setAcquisitionStatus(true);
rp.setMasterTrigger(true);

% Wait for valid frames
while (rp.getCurrentFrame() == -1)
    pause(0.01);
end

startFrame = rp.getCurrentFrame();
u = rp.readData(startFrame, 2);

rp.setAcquisitionStatus(false);
rp.setMasterTrigger(false);
rp.disconnect();

figure;
plot(u(1,:));

figure;
plot(u(2,:));