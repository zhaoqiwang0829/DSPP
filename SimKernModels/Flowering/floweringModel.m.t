%% Global variables
global	dataTotal...         			
	dataTotal_leaf...
	xdata...                			
	xdata_leaf...
	path...					
	ode_parameters...	
	SVP_expression...
	FLC_expression...
	SVP_expression_leaf...
	FLC_expression_leaf...
        MUT

%function ode_application_final

%this should point to ode_equations.m
path='/home/dcraft/PycharmProjects/DSPPcurrent/DSPP/FloweringModel';
%addpath(strcat(path,'equations'))
addpath(path)

%plotting
doPlots=0;
	   	   
time_begin = 5;              
time_end   = 17;             
interval = 0.0001;           
time_odes =     time_begin:interval:time_end;            

%for mutation stuff, knockdown, knockout, or overexpression (see
%notes file) we'll handle the dollar sign stuff this way.

MUT.knockdown = $boolean(0.5), name=B_MUT$;
MUT.which = $discrete([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]), name=D_MUT$;

%loading all the expression data [craft edit: do this right in the
%main file, no loading from separate files]
%dataset_qPCR_normalized_Meristem;	
%  xkData : Vector with the RT-PCR based expression levels of gene k in the time points 1...13
x1Data = [27.68908016 86.868032 52.38288058 81.95560382 113.4437417 105.4786908 194.1347636 225.3359405 317.057213 240.2159403 390.4797548 433.8997013 500.0005625];			% AGL24  - ME
x2Data = [33.30005455 48.84021011 61.41775839 43.79859259 119.2704892 52.62985466 75.432235 62.39276998 116.6058864 101.5051796 164.8018952 167.2073787 155.8591126];			% SOC1  - ME
x3Data = [0.67913 1.03361 1.00813 1.33864 1.23878 1.35655 1.78221 1.95718 2.76103 4.28990 3.49844 4.97946 5.92568];			% LFY  - ME
x4Data = [0.000562532 0.000562532 0.000562532 0.000562532 0.000562532 0.000562532 0.000562532 0.075609101 0.24929035 1.686199603 3.752859742 10.08278379 13.62463878];			% AP1  - ME
x5Data = [3.506938959 18.94436658 33.05664451 55.78817745  89.12788682 46.56064237 70.24339073 93.95679572 163.9769991 245.1451241 266.8434752 471.9778446 371.356198];			% SVP  - ME
x6Data = [0.422903278 0.868006408 1.297321506 1.59315081 2.525202888 1.481993471 2.025130173 2.0646296 3.30849556 4.43559897 4.156030893 7.590657802 6.969165106];		  		% FLC  - ME
x7Data = [0.000562532 0.000562532 0.880694278 1.011568421 0.523892 1.138003286 1.145914812 1.400916362 0.844841337 0.383662126 0.816082101 0.868577245 0.658394672];			% FT   - ME
x8Data = [0.431060498 1.335013712 1.440055784 2.811145452 7.932653407 3.442831595 6.86849123 8.703870671 12.92960204 15.4994735 22.47853033 30.51804137 26.198355];			% FD  - ME

xdata=[x1Data;x2Data;x3Data;x4Data;x5Data;x6Data;x7Data;x8Data]';


%dataset_qPCR_normalized_Leaf;	
%  xkData : Vector with the RT-PCR based expression levels of gene k in the time points 1...13
x1Data = [156.9469953 156.9469953 157.1280094 238.1612368 175.557038 214.6429804 273.5753373 281.2665711 211.6879348 32.1292781 173.1401001 238.1612368 271.6856183];			% SVP  - LEAVES
x2Data = [1.047221416 1.047221416 1.047221467 0.557578813 0.373186247 0.334070099 0.305332236 0.157231505 0.208726374 0.169644112 0.101099041 0.095018869 0.109064371];			% FLC   - LEAVES
x3Data = [0.000562532 0.000562532 0.880694278 1.011568421 0.523892 1.138003286 1.145914812 1.400916362 0.844841337 0.383662126 0.816082101 0.868577245 0.658394672];			% FT - LEAVES	

xdata_leaf=[x1Data;x2Data;x3Data]';



% ########## LOAD THE PARAMETER VALUES ################################################
MichaelisMenten_parameters = [$125.379$ ...
$1181.92$ ...
$694.643$ ...
$4.8303$ ...
$2.4305$ ...
$909.318$ ...
$501.047$ ...
$1010.66$ ...
$842.018$ ...
$346.107$ ...
$946.841$ ...
$10.11$ ...
$699.74$ ...
$100$ ...
$0.5223$ ...
$63.7029$ ...
$189.225$ ...
$0.787$ ...
$2.3908$ ...
$22.3667$ ...
$99.8146$ ...
$10$ ...
$5.0033$];

Decay_parameters		   = [$0.001$ ...
$0.105$ ...
$0.0167$ ...
$0.8576$];

Other_parameters		   = [0.4983];

FD_parameters		   = [$7.9$ ...
$8.5$ ...
$0.0075$];

ode_parameters=[MichaelisMenten_parameters Decay_parameters Other_parameters FD_parameters];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit FLC expression
FLC_expression(16)=-1.151618649491879e+003;
FLC_expression(15)=1.154358982837153e+003;
FLC_expression(14)=-5.083673796371651e+002;
FLC_expression(13)=1.303269284718195e+002;
FLC_expression(12)=-21.760709882600381;
FLC_expression(11)=2.512699005039366;
FLC_expression(10)=-0.208037619654221;
FLC_expression(9)=0.012630096859507;
FLC_expression(8)=-5.693916747403002e-004;
FLC_expression(7)=1.914208476296976e-005;
FLC_expression(6)=-4.778214433598770e-007;
FLC_expression(5)=8.727369278585306e-009;
FLC_expression(4)=-1.132558929532852e-010;
FLC_expression(3)=9.885128932383386e-013;
FLC_expression(2)=-5.201397833122582e-015;
FLC_expression(1)=1.246470626086996e-017;

% Fit SVP expression			
SVP_expression(16)=-5.523660050362068e+004;
SVP_expression(15)=5.828177432591093e+004;
SVP_expression(14)=-2.685354821464235e+004;
SVP_expression(13)=7.161567530925968e+003;
SVP_expression(12)=-1.237772249023380e+003;
SVP_expression(11)=1.473057791814383e+002;
SVP_expression(10)=-12.522714267250171;
SVP_expression(9)=0.778101634969475;
SVP_expression(8)=-0.035802708113345;
SVP_expression(7)=0.001225602226814;
SVP_expression(6)=-3.108942022337164e-005;
SVP_expression(5)=5.760684190005275e-007;
SVP_expression(4)=-7.572810025668374e-009;
SVP_expression(3)=6.687028309495522e-011;
SVP_expression(2)=-3.555881938702022e-013;
SVP_expression(1)=8.603372112575900e-016;

% Fit FT expression - removed by craft since doesn't appear to be used.
%ft in leaf is modeled as an ode, not a polyval


% ########## LOAD THE PARAMETER VALUES ################################################
% Load the values of Michaelis Menten parameters
MichaelisMenten_parameters_leaf = [$0.631497$ ...
$984.786$ ...
$50.5695$];

% Load the values of Decay parameters
Decay_parameters_leaf		   = [$0.0999998$];

% Put all parameter values in one single vector
ode_parameters_leaf=[MichaelisMenten_parameters_leaf Decay_parameters_leaf];


% Fit FLC expression
FLC_expression_leaf(1)=-0.000402201797134;
FLC_expression_leaf(2)=0.017789844737076; 
FLC_expression_leaf(3)=-0.270793095966113;   
FLC_expression_leaf(4)=1.551677713707717; 
FLC_expression_leaf(5)=-1.864067996948016;


% Fit SVP expression
SVP_expression_leaf(1)=-0.531536924525477;
SVP_expression_leaf(2)=15.426454188461598;  
SVP_expression_leaf(3)=1.006072065609388e+002; 

 
dataTotal    = xdata;       
dataTotal_leaf    = xdata_leaf; 


%craft addition
%for readability define the following constants [c for constant]
cAGL = 1;
cSOC = 2;
cLFY = 3;
cAP = 4;
cSVP = 5;
cFLC = 6;
cFT = 7;
cFD = 8;

%and for the leaf
leafSVP = 1;
leafFLC = 2;
leafFT = 3;

initAglValue=dataTotal(1,cAGL);
initSocValue=dataTotal(1,cSOC);
initLfyValue=dataTotal(1,cLFY);
initApValue=dataTotal(1,cAP);
initFtValue=dataTotal_leaf(1,leafFT);
initFdValue=dataTotal(1,cFD);

if MUT.knockdown==1
    if MUT.which==1

        initSocValue=dataTotal(1,cSOC)*0.3;
    elseif MUT.which==2

	initSocValue=dataTotal(1,cSOC)*0.25;	
    elseif MUT.which==3
        initAglValue=dataTotal(1,cAGL)*2;
    elseif MUT.which==4
        initAglValue=dataTotal(1,cAGL)*1;
%craft edit: remove krane's 5-7 and see ode_equations.m

%craft: 8,9, and 10 are KNOCKOUTS
elseif MUT.which==8 %"ft-10" -- knockout
        initFtValue=0;
        
    elseif MUT.which==9 %fd-3 knockout
        initFdValue=0;
    elseif MUT.which==10 %FLC-3 knockout
	%note this below is fine, but I also zeroed them out in ode_equations code.
        FLC_expression(1:16)=0;
        FLC_expression_leaf(1:5)=0;

%OVEREXPRESSION MUTANTS
    elseif MUT.which==11
        initAglValue=2500;
    elseif MUT.which==12
        initSocValue=2500;
    elseif MUT.which==13
        initLfyValue=2500;
    elseif MUT.which==14
        initApValue=2500;
    elseif MUT.which==15
        initFtValue=2500;
    elseif MUT.which==16
        initFdValue=2500;

%final three are DOUBLE MUTANTS

    elseif MUT.which==17 %SOC1-AGL DOUBLE KNOCKOUT [main text fig a]
        initAglValue=0;
        initSocValue=0;
  	%for 18 and 19 i'll do two, where each have one overexpressed and one knockdown
	%see figure supp info fig A panel c. i'm assuming based on main text that promoter 35s
	%is how they achieved over expression
    elseif MUT.which==18 %SOC1 overexpression, AGL24 knockout
        initAglValue=0;
        initSocValue=2500;
     elseif MUT.which==19 %AGL24 overexpression, SOC1 knockout
        initAglValue=2500;
        initSocValue=0;
     end

end


initial_Expression = [initAglValue initSocValue initLfyValue initApValue initFtValue initFdValue];

ode_option=odeset('NonNegative',[1 2 3 4 5 6]);
%floweringTime_WT_Col0=12.63;
simTime=30;
FT_range_time=[5:0.001:simTime];
[timeData,expData] = ode45(@ode_equations,FT_range_time,initial_Expression,ode_option,ode_parameters,ode_parameters_leaf);

%AP1_expression_flowering=expData(length(expData),4)
%grab the time that AP1 goes above 2.28.
%note if it never goes above 2.28 will have to fix this ode
AP1exp=expData(:,4); 
af = find(AP1exp>2.28);
floweringTime = timeData(af(1));
disp(strcat('[',num2str(floweringTime),']'));
output = floweringTime;

if doPlots
    plot(timeData, expData);
    xlabel('Time')
    ylabel('Levels')
    legend({'AGL24' 'SOC1' 'LFY' 'AP1' 'FT' 'FD'})
end
