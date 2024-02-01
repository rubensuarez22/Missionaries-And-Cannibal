%Cannibals and Missionaries Puzzle


% Define the initial state
initial(state(3, 3, left, 0, 0)).
% Initializes the puzzle with three missionaries and three cannibals 
% on the left side of the river, and none on the right. The boat is 
% also on the left side.


% Define the final state
goal(state(0, 0, _, 3, 3)).
%Specifies the goal state where all missionaries and cannibals have
% successfully crossed to the right side of the river. The boat's 
% position (_) is irrelevant at this point.


% Move from left to right
move(state(ML, CL, left, MR, CR), state(ML2, CL2, right, MR2, CR2)) :-
    member(M, [0,1,2]), member(C, [0,1,2]),
    %The member predicate is used to iterate through the possible numbers of missionaries (M) and 
    %cannibals (C) that can be moved by the boat in each turn. The list [0,1,2] represents the 
    %allowed numbers of individuals (either 0, 1, or 2, though in practice the boat cannot move 
    %empty, so 0 is effectively excluded by other constraints). Obtained in a conversation with ChatGPT by OpenAI  (February 2nd, 2024).
    M + C =< 2, M + C > 0, % Boat capacity and non-empty condition
    ML >= M, CL >= C, % Ensure no negative results
    ML2 is ML - M, CL2 is CL - C, % Update left bank
    MR2 is MR + M, CR2 is CR + C, % Update right bank
    safe(ML2, CL2), safe(MR2, CR2). % Safety condition


% Defines a possible move from the left to the right side of the river. 
% It selects the number of missionaries (M) and cannibals (C) to move,
%  ensuring the boat's capacity is not exceeded and it's not empty. 
%  It updates the counts on both sides and checks the safety of the
%   new configuration.

% Move from right to left
move(state(ML, CL, right, MR, CR), state(ML2, CL2, left, MR2, CR2)) :-
    member(M, [0,1,2]), member(C, [0,1,2]),
    M + C =< 2, M + C > 0,
    MR >= M, CR >= C, % Ensure no negative results
    MR2 is MR - M, CR2 is CR - C,
    ML2 is ML + M, CL2 is CL + C,
    safe(ML2, CL2), safe(MR2, CR2).
%Similar to the above, but defines a move from the right side back to the left.
% It uses the same logic to ensure the move is valid and safe.

% Safety rule
safe(M, C) :- M >= C, !; M = 0.

%Defines the safety condition where missionaries are not outnumbered by cannibals 
%on either side of the river. If there are no missionaries (M = 0), the condition 
%is also considered safe.


% Solve the puzzle using depth-first search
solve(State, Solution) :- solve(State, [], Solution).

%Initiates the puzzle-solving process using an empty list to track visited states, 
%preventing cycles.


% This is used to avoid singletone variable warning
use_visited(Visited) :- length(Visited, _).

solve(State, Visited, [State]) :- goal(State), use_visited(Visited).
%Base case for the recursive solve predicate. If the current state matches the goal 
%state, the solution is found. use_visited is called to ensure the Visited list is
% utilized.

solve(State, Visited, [State | Steps]) :-
    move(State, NextState),
    \+ member(NextState, Visited),
    solve(NextState, [NextState | Visited], Steps), use_visited(Visited).
%The recursive step in the depth-first search. It tries a move to get a NextState,
% ensures this state hasn't been visited, and then continues to solve from this new state,
%  adding it to the Visited list. use_visited is called to manage the Visited list.

