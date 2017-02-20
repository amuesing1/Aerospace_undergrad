function solver(inputfile, outputfile)
FID = fopen(inputfile);
words = fgets(FID);
forces_moments = fgets(FID);            %turns the forces and 
into_numbers = str2num(forces_moments); %moment amounts into numbers
numforces = into_numbers(1,1);
nummoments = into_numbers(1,2);
words = fgets(FID);
words = fgets(FID);
force_location = zeros(numforces, 3); %rows change with amount of forces
if numforces==0
    force_location = zeros(1,3);
    nothing=fgets(FID);
end
i=1;
while i <= numforces
    read1 = fgets(FID);
    save1 = str2num(read1);           %reads and transfers to numbers
    force_location(i,1) = save1(1,1); %stores numbers into arrays
    force_location(i,2) = save1(1,2); %in same format as given txt
    force_location(i,3) = save1(1,3);
    i=i+1;
end
words = fgets(FID);
words = fgets(FID);
mag_dir_force = zeros(numforces, 4); %same as above but with added mag column
if numforces==0                      %in event there are all moments
    mag_dir_force = zeros(1,4);
    nothing=fgets(FID);              %it will need to read a line of zero forces
end
i=1;
while i <=numforces
    read2 = fgets(FID);
    save2 = str2num(read2);
    mag_dir_force(i,1) = save2(1,1); %reads and stores same as above
    mag_dir_force(i,2) = save2(1,2);
    mag_dir_force(i,3) = save2(1,3);
    mag_dir_force(i,4) = save2(1,4);
    i=i+1;
end
words = fgets(FID);
words = fgets(FID);
moment_location = zeros(nummoments, 3); %creates variable array # of momemnts
i=1;
if nummoments==0                        %in event there are no moments
    moment_location = zeros(1,3);
    nothing=fgets(FID);                 %it will need to read a line of zero moments
end
while i <=nummoments
    read3 = fgets(FID);
    save3 = str2num(read3);
    moment_location(i,1) = save3(1,1);
    moment_location(i,2) = save3(1,2);
    moment_location(i,3) = save3(1,3);
    i=i+1;
end
words = fgets(FID);
words = fgets(FID);
mag_dir_moment = zeros(nummoments, 4);
i=1;
if nummoments==0
    mag_dir_moment = zeros(1,4);
    nothing=fgets(FID);
end
while i <=nummoments
    read4 = fgets(FID);
    save4 = str2num(read4);
    mag_dir_moment(i,1) = save4(1,1);
    mag_dir_moment(i,2) = save4(1,2);
    mag_dir_moment(i,3) = save4(1,3);
    mag_dir_moment(i,4) = save4(1,4);
    i=i+1;
end
words = fgets(FID);
words = fgets(FID);
supports = zeros(6,3); %one changing number not given in documtent here
i=1;
while i<=length(supports) %if amount of supports change
    read5=fgets(FID);
    save5=str2num(read5);
    supports(i,1)=save5(1,1);
    supports(i,2)=save5(1,2);
    supports(i,3)=save5(1,3);
    i=i+1;
end
words=fgets(FID);
words=fgets(FID);
reactions = zeros(length(supports),3);
types = zeros(1,length(supports)); %separate array for types of forces
i=1;
notenough=0;                       %decalring varriable if there are not
while i <=length(supports)         %enough supports
    read6=fgets(FID);
    if (read6(1,1)=='F') %enters 1 if it is a force
        types(1,i)=1;
        print_type(1,i)='F'; %for printing the output later on
    end
    if (read6(1,1)=='M') %enters 2 if it is a moment
        types(1,i)=2;
        print_type(1,i)='M'; %for printing the output later on
    end
    if (read6(1,1)=='0') %if there are not enough there will be a 0 in place
        notenough=1;
    end
    save6=str2num(read6(2:length(read6))); %skips first letter
    reactions(i,1)=save6(1,1);
    reactions(i,2)=save6(1,2);
    reactions(i,3)=save6(1,3);
    i=i+1;
end
sum_Fx = 0; %declaring tons of variables
sum_Fy = 0;
sum_Fz = 0;
sum_Mx = 0;
sum_My = 0;
sum_Mz = 0;
C=0;
Cx=0;
Cy=0;
Cz=0;
i=1;
while i<=numforces
mag_unit=sqrt((mag_dir_force(i,2).^2)+(mag_dir_force(i,3).^2)+(mag_dir_force(i,4).^2));
ux(i)= mag_dir_force(i,2)./mag_unit; %takes magnitude of direction vector
Fx(i)= ux(i).*mag_dir_force(i,1);    %and turns it into unit vector and unit
sum_Fx = sum_Fx + Fx(i);             %unit force vector of x for all forces
                                     %by summing them
uy(i)= mag_dir_force(i,3)./mag_unit;
Fy(i)= uy(i).*mag_dir_force(i,1);    %same process for y vector
sum_Fy = sum_Fy + Fy(i);

uz(i)= mag_dir_force(i,4)./mag_unit; %same process for z vector
Fz(i)= uz(i).*mag_dir_force(i,1);
sum_Fz = sum_Fz + Fz(i);


r=[force_location(i,1),force_location(i,2),force_location(i,3)];
F=[Fx(i),Fy(i),Fz(i)];
Cr=cross(r,F); %takes the cross product of the location and force vectors
C(i,1)=Cr(1); %separates componetns
C(i,2)=Cr(2);
C(i,3)=Cr(3);
Cx=Cx+C(i,1); %adds all moments from all forces
Cy=Cy+C(i,2); %for each direction
Cz=Cz+C(i,3);

i=i+1;
end
i=1;
if nummoments==0
    sum_Mx=Cx;
    sum_My=Cy;
    sum_Mz=Cz;
end
while i<=nummoments
mag_unit_mom=sqrt((mag_dir_moment(i,2).^2)+(mag_dir_moment(i,3).^2)+(mag_dir_moment(i,4).^2));
umx(i)=mag_dir_moment(i,2)./mag_unit_mom; %takes unit magnitude in each
Mx(i)=umx(i).*mag_dir_moment(i,1);        %direction same as force above
sum_Mx=sum_Mx+Mx(i)+Cx; %including moments calculated from forces above

umy(i)=mag_dir_moment(i,3)./mag_unit_mom; %same process for y moment
My(i)=umy(i).*mag_dir_moment(i,1);
sum_My=sum_My+My(i)+Cy;

umz(i)=mag_dir_moment(i,4)./mag_unit_mom; %same process for z moment
Mz(i)=umz(i).*mag_dir_moment(i,1);
sum_Mz=sum_Mz+Mz(i)+Cz;
i=i+1;
end

A=zeros(6,6); %declaring massive array to be filled
i=1;
while i<=length(supports)
    mag_rec=sqrt((reactions(i,1).^2)+(reactions(i,2).^2)+(reactions(i,3).^2));
    unit_recx(i)=reactions(i,1)./mag_rec; %takes unit vectors of reactions
    unit_recy(i)=reactions(i,2)./mag_rec; %in each direction
    unit_recz(i)=reactions(i,3)./mag_rec;
    A(1,i)=unit_recx(i); %assigning values going down by row
    A(2,i)=unit_recy(i); %incrmented for each force one column
    A(3,i)=unit_recz(i); %over
    i=i+1;
end
i=1;
r=0;
F=0;
if notenough==0 %if there are enough it will assign to A, there are aren't
while i<=length(supports) %there is no need to even run this code and it
    if types(1,i)==1 %prevents crashing
    r=[supports(i,1),supports(i,2),supports(i,3)]; %finds moments using
    F=[reactions(i,1),reactions(i,2),reactions(i,3)]; %force type
    mom_rec=cross(r,F);                               %reactions
    A(4,i)=mom_rec(1);
    A(5,i)=mom_rec(2);
    A(6,i)=mom_rec(3);
    i=i+1;
    else if types(1,i)==2
    A(4,i)=reactions(i,1); %continues until 6 F/M have been hit
    A(5,i)=reactions(i,2);
    A(6,i)=reactions(i,3);
    i=i+1;
    end
    end
end
end


b=[sum_Fx;sum_Fy;sum_Fz;sum_Mx;sum_My;sum_Mz]; %takes computations from
b=-b;                                          %from above to make b
x=A\b; %finds reaction forces
i=1;
Rec_F=0;
while i<=length(supports)
    Rec_F(i,1)=x(i,1); %creates array with force and direction of reactions
    Rec_F(i,2)=x(i,1)*A(1,i);
    Rec_F(i,3)=x(i,1)*A(2,i);
    Rec_F(i,4)=x(i,1)*A(3,i);
    i=i+1;
end
fileID = fopen(outputfile,'w'); %creates .txt but command goes by columns
if notenough==1 %there are not 6 support reactions
    fprintf(fileID,'There are not enough supports to solve this problem');
else
fprintf(fileID,'%5s %25s %12s %10s %10s\r\n','Type of reaction','Magnitude of reaction','dx','dy','dz');
fprintf(fileID,'%7s %30f %20f %10f %10f\r\n',print_type(1,1),Rec_F(1,1),Rec_F(1,2),Rec_F(1,3),Rec_F(1,4));
fprintf(fileID,'%7s %30f %20f %10f %10f\r\n',print_type(1,2),Rec_F(2,1),Rec_F(2,2),Rec_F(2,3),Rec_F(2,4));
fprintf(fileID,'%7s %30f %20f %10f %10f\r\n',print_type(1,3),Rec_F(3,1),Rec_F(3,2),Rec_F(3,3),Rec_F(3,4));
fprintf(fileID,'%7s %30f %20f %10f %10f\r\n',print_type(1,4),Rec_F(4,1),Rec_F(4,2),Rec_F(4,3),Rec_F(4,4));
fprintf(fileID,'%7s %30f %20f %10f %10f\r\n',print_type(1,5),Rec_F(5,1),Rec_F(5,2),Rec_F(5,3),Rec_F(5,4));
fprintf(fileID,'%7s %30f %20f %10f %10f\r\n',print_type(1,6),Rec_F(6,1),Rec_F(6,2),Rec_F(6,3),Rec_F(6,4));

end
fclose(fileID);

end

