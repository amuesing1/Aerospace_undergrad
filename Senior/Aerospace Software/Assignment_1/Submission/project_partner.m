% Jeremy Muesing
% ASEN 4057
% project_partner.m
% Created: 1/26/17
% Modified: 1/26/17
function [assignment] = project_partner(N,M)
%Places students into randomly assigned groups. No student ever works with
%each other a 2nd time on any other assignment. If there are an odd number
%of students, a group of 3 is made.

% Inputs: Number of students in the class (N), number of assignments (M)

% Outputs: Array of student pairings on each assignment given by student
% number

if (N-1)<M
    error('Impossible solution. Assignements exceed number of students')
end

if mod(N,2)==0
    assignment = zeros(2,N/2,M);
    students = zeros(1,M,N);
elseif mod(N,2)==1
    assignment = zeros(3,floor(N/2),M);
%     In the case a student is placed in a group of 3 every single project
    students = zeros(1,2*M,N);
end

for i = 1:M
    people = linspace(1,N,N); % all students available
    j=1;
    while j <= floor(N/2)
        if mod(N,2)==0 || j>1
            k=1;
            while k <= 2
                pick = 0;
                while pick==0
                    pick = people(randi(N)); %finds a non assigned student
                end
                assignment(k,j,i) = pick;
                if k==2
                    while any(students(1,:,assignment(1,j,i))==pick)==1 || pick==0
%                     Purly for checking if all numbers avilable have been
%                     used
                        [~,~,v] = find(people);
                        count=0;
                        for l=1:length(v)
                            check=v(l);
                            if any(students(1,:,assignment(1,j,i))==check)
                                count=count+1;
%                            If all numbers are invalid options, the whole
%                            assignment resets. This is quicker when the
%                            number of students is much higher than
%                            assignments, however it will eventuall work to
%                            the maximum M=N-1
                                if count==length(v)
                                    if mod(N,2)==0
                                        assignment(:,:,i)=zeros(2,N/2,1);
                                    elseif mod(N,2)==1
                                        assignment(:,:,i)=zeros(3,floor(N/2),1);
                                        students(1,possible_erase,:)=0;
                                    end
                                    people = linspace(1,N,N);
                                    students(1,i,:)=0;
                                    j=1;
                                    k=1;
                                end
                            end
                        end
                        pick = people(randi(N));
%                     This line is a duplicate but is needed in the case
%                     the whole assignment must be redone.
                        assignment(k,j,i) = pick;
                    end
                    assignment(k,j,i) = pick;
%                 Put into the student history their partner
                    students(1,i,pick)=assignment(1,j,i);
                    students(1,i,assignment(1,j,i))=pick;
                end
                people(pick) = 0; %the number cannot be picked again
                k=k+1; % used due to possible reset
            end
            j=j+1; % used due to possible reset
        elseif mod(N,2)==1 && j==1
            for k =1:3
                pick = 0;
                while pick==0
                    pick = people(randi(N)); %finds a non assigned student
                end
                assignment(k,j,i) = pick;
                if k==2
                    while any(students(1,:,assignment(1,j,i))==pick)==1 ...
                            || pick==0
                        pick = people(randi(N));
                    end
                    assignment(k,j,i) = pick;
                end
                if k==3
                    while any(students(1,:,assignment(1,j,i))==pick)==1 ||...
                            any(students(1,:,assignment(2,j,i))==pick)==1 ...
                            || pick==0
                        pick = people(randi(N));
                    end
                    assignment(k,j,i) = pick;
%                     If the array needs to be reset, the third member
%                     placed at the end of the array to prevent override
%                     must also be erased. This parameter might not be used
%                     but must be kept track of for later in the
%                     assignment.
                    [~,y,~]=size(students);
                    possible_erase = y-i;
%                 Put into the student history their partner
                    students(1,i,pick)=assignment(1,j,i);
%                     Impossible to overwrite given array size
                    students(1,end-i,pick)=assignment(2,j,i);
                    students(1,i,assignment(1,j,i))=pick;
                    students(1,i,assignment(2,j,i))=pick;
                    students(1,end-i,assignment(1,j,i))=assignment(2,j,i);
                    students(1,end-i,assignment(2,j,i))=assignment(1,j,i);
                end
                people(pick) = 0; %the number cannot be picked again
            end
            j=j+1; % used due to possible reset
        end
    end
end

end

