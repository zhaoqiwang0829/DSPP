% This script will call the f4.m file, which contains the ODE's for v4

%    the units we've decided to use are the same as in the Elias paper.
%Concentrations will be in micromolar (10^-6 mol/L. 1 mol = Avogadro?s # or 6.022*10^23 molecules) 
%and rate constants will likely be in min^-1. I say likely because they can take on different units,
%like M/min or M^-1*min^-1 depending on their order.
%function v4()
    % set plt = true to plot the graph
    plt = false;
    global single; single = true;
    %MUTATIONS - TODO - consider making a MUTATIONS structure
    RP.ARF_muta = $boolean(0.5),name= RP.ARF_muta$;
    genome1_key

    %note for octave compatibility, must install odepkg for octave and also execute the following line
    %every session.
    %pkg load odepkg
    %Alternately, make a file called .octaverc in your home directory, and put that line in the file.
    %we'll have to verify that this works when calling octave through python.


    %ENTITIES in the model:
    %These are the proteins, mRNA, etc., each of which has an ODE describing its dynamics, which we store in a file
    %so we can re-use in the ODE function.
    variableDefinition3

    %Initial conditions
    x0 = zeros(numEntities,1);
    %here any non-zero initial conditions
    %for now, we we are modeling our radiation blast as an exponetially decaying level, we just initialize
    %the radiation compartment.
%     x0(P_Apoptosome) = 0;
%     x0(O_BROKEN_ENDS) = 0;
%     x0(O_CAPS) = 0;
%     x0(O_CAPPED_ENDS) = 0;
%     x0(O_CAPPED_ENDS_READY) = 0;
%     x0(O_FIXED) = 0;
%     x0(O_ARRESTSIGNAL) = 0; 
%     x0(P_Apoptosis)= 0;
if RP.ARF_muta == 0
    x0(P_ARF) = 0.1;
end
    x0(O_CELLCYCLING) = 1;
	x0(P_ECDK2) = 1.5;
	x0(O_RADIATION) = 1;


    %Simulation time span. We will take the units of time to be MINUTES since that is what Elias paper uses.

    numDays=1;
    Tend_minutes = 24*60*numDays; %currently set for ___
                                      %simulation time.
    tspan=[0,Tend_minutes];

 %We start with all the parameters of those equations. We might want to think a little more
 %about an organized nomenclature for these. For example it would be nice to be able to tell from the name
 %basically what it is doing. But we also don't want to be cumbersome and have really long names (I think..).      %So for now we will go with this but we might come up with a more refined standard.

 %NOTE: RP is structure defining the values of the Rate Parameters
    RP.c_Kiri = $0.03$;
    RP.c_Kbe = $0.03$;
    RP.c_Kbec = $0.003,name= RP.c_Kbec $; %decreasinging this to slow down repair process
    RP.c_Kc = $0.02$;
    RP.c_Kcc = $0.01$; %caps clearance rate/halflife term
    RP.c_Mc = $0.01$;
    RP.c_Kcer = $uniform(0.002,0.5),name= RP.c_Kcer$;
    RP.c_Kf = $uniform(0.001,0.02),name= RP.c_Kf$;
    RP.ATMtot = $1.3$;

    RP.k3=$3$;
    RP.Katm=$0.1,name= RP.Katm$;
    RP.kdph1=7800; %craft: changing this to see if i can get
                      %p53nucphos to taper out faster. orig
                      %value: 78
    RP.Kdph1=$250,name= RP.Kdph1$; %try this one too
    RP.k1=$10$;
    RP.K1=$1.01$;
    RP.pp=$0.083$;
    RP.Vr=$10$;
    RP.pm=$0.04$;
    RP.deltam=$0.16$;
    RP.kSm=$0.005$;
    RP.kSpm=$1$;
    RP.KSpm=$0.1$;
    RP.pmrna=$0.083,name= RP.pmrna$;
    RP.deltamrna=$0.0001$;
    RP.ktm=$1$;
    RP.kS=$0.015$;
    RP.deltap=$0.2$;
    RP.pw=$0.083$;
    RP.deltaw=$0.2$;
    RP.kSw=$0.03$;
    RP.kSpw=$1$;
    RP.KSpw=$0.1$;
    RP.pwrna=$0.083$;
    RP.deltawrna=$0.001$;
    RP.ktw=$1$;
    % this next one to modify the radiation impact:
    RP.kph2=$uniform(15,150),name=RP.kph2$;
    RP.Kph2=$1$;

    RP.kdph2=$96$;
    RP.Kdph2=$26$;
    % nondimensionalisation of the variables is done so that the term relative to
    % the main bifurcation parameter E depends on as small possible number of
    % parameters as possible. Other choices are, of course, possible.
    %barE = E/Kph2;
    RP.ts=1/RP.kph2;
    RP.alpha1=RP.Katm; RP.alpha4=RP.alpha1; RP.alpha2=RP.kSpm/RP.k3; RP.alpha3=RP.alpha2;
    RP.alphav1=RP.Kph2; RP.alphav2=RP.alphav1;
    RP.alphaw1=RP.kSpw/RP.k3*10; RP.alphaw2=RP.alphaw1;
    RP.barkdph1 = RP.ts*RP.kdph1*(RP.alphaw1/RP.alpha1); RP.barKdph1 = RP.Kdph1/RP.alpha4;
    RP.bark1 = RP.ts*RP.k1*(RP.alpha2/RP.alpha1); RP.barK1 = RP.K1/RP.alpha1;

    RP.bark3 = RP.ts*RP.k3*(RP.alphav2/RP.alpha1); RP.barKatm = RP.Katm/RP.alpha1;
    RP.barpp=RP.ts*RP.pp; RP.barpm=RP.ts*RP.pm; RP.bardeltam=RP.ts*RP.deltam;
    RP.barkSm=RP.ts*RP.kSm/RP.alpha3; RP.barkSpm=RP.ts*RP.kSpm/RP.alpha3; RP.barKSpm=RP.KSpm/RP.alpha4;
    RP.barpmrna=RP.ts*RP.pmrna; RP.bardeltamrna=RP.ts*RP.deltamrna;
    RP.barpw=RP.ts*RP.pw; RP.bardeltaw=RP.ts*RP.deltaw;
    RP.barkSw=RP.ts*RP.kSw/RP.alphaw2; RP.barkSpw=RP.ts*RP.kSpw/RP.alphaw2; RP.barKSpw=RP.KSpw/RP.alpha4;
    RP.barpwrna=RP.ts*RP.pwrna; RP.bardeltawrna=RP.ts*RP.deltawrna;
    RP.barkdph2=RP.ts*RP.kdph2*(RP.alphaw1/RP.alphav2); RP.barKdph2=RP.Kdph2/(RP.alphav2^2);
    RP.barkS=RP.ts*RP.kS/RP.alpha1; RP.bardeltap=RP.ts*RP.deltap;
    RP.barktm=RP.ts*RP.ktm; RP.barktw=RP.ts*RP.ktw;
    RP.ATMtot=RP.ATMtot/RP.alphav1;

    %Apoptosis Rate Constants --> p53 to Cyt c model

    RP.c_KpB1 = $2,name= RP.c_KpB1 $;
    RP.c_KpB2 = $2,name= RP.c_KpB2$;%positive affect on cellcycling
    RP.c_KpB3 = $0.5$;
    RP.c_KpBX1 = $2.5,name= RP.c_KpBX1$;
    RP.c_KpBX2 = $1.7,name= RP.c_KpBX2$;
    RP.c_KpBX3 = $0.4$; %clearance term - slows if k > 2
    RP.c_KpF1 = $1.5,name=RP.c_KpF1 $; %affects apop reasonably if .1 < k < 10
    RP.c_KpF2 = $2,name=RP.c_KpF2 $; %affects apop reasonably if .01 < k < 5
    RP.c_KpF3 = $0.2,name=RP.c_KpF3 $; %clearance term - slows if k > 1, reasonably affects apop if 1 > k > .1
    RP.c_KpBa1 = $2,name= RP.c_KpBa1 $;
    RP.c_KpBa2 = $2$;
    RP.c_KpBa3 = $0.3,name=RP.c_KpBa3$;%clearance term - slows if k > 1
    RP.c_KBaxC1 = $1.3$;
    RP.c_KBaxC2 = $0.9$;
    RP.c_KBaxC3 = $1$;
    RP.c_KBcl2C1 = $1.3,name=RP.c_KBcl2C1$;
    RP.c_KBcl2C2 = $1.1,name=RP.c_KBcl2C2$;
    RP.c_KBcl2C3 = $1$;
    RP.c_KBclXC1 = $1.3,name=RP.c_KBclXC1$;
    RP.c_KBclXC2 = $1,name=RP.c_KBclXC2$;
    RP.c_KBclXC3 = $1$;
    RP.c_KCyt = $0.3$;%clearence term
    RP.c_Kapa1 = $2,name=RP.c_Kapa1$;
    RP.c_Kapa2 = $1$;
    RP.c_Kapa3 = $0.3$;
    RP.c_KAA = $0.7$;
    RP.c_KAA2 = $0.3$;%clearance term - DOES NOT slow, does not affect cell fate
    RP.c_KApop = $0.12,name= RP.c_KApop$;%increase Apoptosis - apop changes reasonably if .1 < k < 10
    RP.c_KApop2 = $0.11,name= RP.c_KApop2$;%increase Apoptosis maybe set this around 1 to make it resonalable
    RP.c_KApop3 = $0.2,name= RP.c_KApop3$;%reasonable changes in apop if  .08 < k < 5
    RP.c_Kpp1 = $0.3,name=RP.c_Kpp1$;%sig changes in cc and arrest if 1 < k < 100
    RP.c_Kpp2 = $0.6,name=RP.c_Kpp2$;%sig changes in cc & arrest if .1 < k < 2
    RP.c_Kpp3 = $0.2,name=RP.c_Kpp3$;%slow clearance term if k > 2 AND affects cell cycling and arrest signal if <1
    RP.c_KpE1 = $0.6,name=RP.c_KpE1$; %changes cc & arrest. .1 < k < 1
    RP.c_KpE2 = $1.3,name=RP.c_KpE2$; %changes cc & arrest 1 < k < 20 
    RP.c_KpE3 = $1,name=RP.c_KpE3$; %changes cc & arrest .1 < k < 1
    RP.c_KpE4 = $0.4,name=RP.c_KpE4$;%
    RP.K_Rb = $boolean(0.3), name=RP.K_Rb$;%1 <K_Rb < 28 affects cellcycling & arrestsignal symmetrically
    RP.c_Ka1 = $4$; %Cellcycling stops if >70; changes cc and arrest symmetrically;
    RP.c_Ka2 = $0.8$;% supress arrest signaling max 0.9 %Sig. changes in cc and arrest if 1 < k < 3
    RP.Kg = $0.8$;%Significant changes in cell cycling if 1 < Kg < 28
    RP.K_MYC = $uniform(0.5,3),name=RP.K_MYC$;
    RP.c_E2F1 = $1$; %clearance term - increases run time if k > 1
    RP.c_ARF1 = $1.5$;
    RP.c_ARF2 = $2$;
    RP.c_ARF3 = $0.4$; %clearance term - increases run time if k > 1
    RP.c_MDM2Nuc1 = $1$;
    RP.c_MDM2Nuc2 = $1$;
    RP.c_Kps = $1$;
    RP.c_Kps2 = $0.1$;
    RP.c_si = $0.4$; %clearance term -slows down run time if k > 1 
    RP.c_Kpr = $1.8$;
    RP.c_Kpr2 = $3$;
    RP.c_re = $0.2$;  %clearance term - slow if k > 1, no significant effect


    %Just using these default values. They seem fine for now, we might find it useful to adjust later. I'm also using the
    %low order solver ode23. We may need to change this later too.
    opts = odeset('AbsTol',1e-3,'RelTol',1e-5,'MaxStep',6,'InitialStep',.1);
    [t,x]=ode23(@f4,tspan,x0,opts, RP);
    if plt == true
        subplot(1,3,1)
        varsToPlot = [2 5 P_Apaf1];
        plot(t/60,x(:,varsToPlot));
        xlabel('Time [hrs]');
        legend(N(varsToPlot));

        %here replicate stuff plotted in Elias figure 4.8

        subplot(1,3,2)
        varsToPlot = [P_CytC P_ECDK2 P_Apoptosome ];
        % varsToPlot = [P_CytC P_Apaf1 P_Apoptosome P_ECDK2 P_FasL];

        %varsToPlot = [P_Siah P_Reprimo];
        h=plot(t/60,x(:,varsToPlot));  
        xlabel('Time [hrs]');
        legend(N(varsToPlot));

        subplot(1,3,3)
        %varsToPlot = [P_ATMNucPhos P_P53NucPhos P_MDM2Nuc P_WIP1Nuc];
        varsToPlot = [O_CELLCYCLING O_ARRESTSIGNAL O_Apoptosis];
        h=plot(t/60,x(:,varsToPlot));
        xlabel('Time [hrs]');
        legend(N(varsToPlot));
        

        
    else
        %here display the output value we will do machine learning on. for
        %now I'll just use the final value of cell cycling. this will not
        %be what we use eventually, just a placeholder for now. put
        %plt to false to see this printed out.
        x(end,O_CELLCYCLING);
        output = 0;% if output is 0 then it mean we did not cover all the cases which it should not happen. 
        if max(x(:,O_Apoptosis)) >= 0.8%Apoptosis occurs
            output = 3;
        else
            if max(x(:,O_ARRESTSIGNAL))>= 0.55%cell arrest occurs
             output = 1;
            elseif  x(end,O_CELLCYCLING)>= 0.7% cell cycling 
               output = 2;
            else
                output = 4;%other
            end
        end
      disp(strcat('[',int2str(output),']'));     
        
    end

