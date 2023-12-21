function SID = load_imetronic_data(filepath)

SID(1).name = 'LIGHT';
SID(1).num(1).name = 'HLED';
SID(1).num(2).name = 'LED1';
SID(1).num(3).name = 'LED2';
SID(1).num(4).name = 'LED3';
SID(1).num(5).name = 'LED4';
SID(1).num(6).name = 'LED5';
SID(1).num(7).name = 'LED6';

SID(2).name = 'LEVIER';
SID(2).num(1).name = 'L1';
SID(2).num(2).name = 'L2';
SID(2).num(3).name = 'L3';
SID(2).num(4).name = 'L4';
SID(2).num(5).name = 'L5';
SID(2).num(6).name = 'L6';

SID(3).name = 'NOSE POKE';
SID(3).num(1).name = 'NP1';
SID(3).num(2).name = 'NP2';
SID(3).num(3).name = 'NP3';
SID(3).num(4).name = 'NP4';
SID(3).num(5).name = 'NP5';

SID(4).name = 'DISTRIBUTEUR';
SID(4).num(1).name = 'D1';
SID(4).num(2).name = 'D2';
SID(4).num(3).name = 'D3';
SID(4).num(4).name = 'D4';
SID(4).num(5).name = 'D5';

SID(5).name = 'ABREUVOIR';
SID(5).num(1).name = 'LK1';
SID(5).num(2).name = 'LK2';
SID(5).num(3).name = 'LK3';
SID(5).num(4).name = 'LK4';
SID(5).num(5).name = 'LK5';

SID(6).name = 'DIVERS CA';
SID(6).num(1).name = 'INJ1';
SID(6).num(2).name = 'SND';
SID(6).num(3).name = 'WN';
SID(6).num(4).name = 'SHK';
SID(6).num(5).name = 'PUSH';
SID(6).num(6).name = 'TOP';
SID(6).num(7).name = 'INJ2';
SID(6).num(8).name = 'ADC';
SID(6).num(9).name = 'SNDpP';
SID(6).num(10).name = 'FL';
SID(6).num(11).name = 'RD';
SID(6).num(12).name = 'OD';
SID(6).num(13).name = 'BUL';
SID(6).num(14).name = 'WH';
SID(6).num(15).name = 'DISK';

SID(7).name = 'PORTE';
SID(7).num(1).name = 'G1';
SID(7).num(2).name = 'G2';
SID(7).num(3).name = 'G3';
SID(7).num(4).name = 'G4';
SID(7).num(5).name = 'G5';
SID(7).num(6).name = 'G6';

SID(8).name = '';

SID(9).name = 'ZONE';
SID(9).num(1).name = 'Z1';
SID(9).num(2).name = 'Z2';
SID(9).num(3).name = 'Z3';
SID(9).num(4).name = 'Z4';
SID(9).num(5).name = 'Z5';
SID(9).num(6).name = 'Z6';

SID(10).name = 'DIVERS';
SID(10).num(1).name = 'ON';
SID(10).num(5).name = 'EVT';

SID(11).name = 'DIVERS NON STOCKE';

SID(12).name = 'RFID';
SID(12).num(1).name = 'I1';
SID(12).num(2).name = 'I2';
SID(12).num(3).name = 'I3';


SID(13).name = 'MESSAGE';
SID(13).num(1).name = 'STR1';
SID(13).num(2).name = 'STR2';
SID(13).num(3).name = 'STR3';

SID(14).name = 'REARING';
SID(14).num(1).name = 'R1';
SID(14).num(2).name = 'R2';
SID(14).num(3).name = 'R3';
SID(14).num(4).name = 'R4';
SID(14).num(5).name = 'R5';
SID(14).num(6).name = 'R6';


data = dlmread(filepath,'\t',13,0);

n1 = size(SID,2);
for i1=1:n1
    n2=size(SID(i1).num,2);
    if n2
        for i2=1:n2
            l1 = (data(:,2)==i1);
            l2 = (data(:,3)==i2);
            SID(i1).num(i2).ts=data(l1&l2,1);
            SID(i1).num(i2).info=data(l1&l2,:);
            x = SID(i1).num(i2).ts;
        end
    end
end

    

end

