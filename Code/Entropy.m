function H = Entropy(X)

% Establish size of data
% [n ,m] = size(X);
% 
% % Housekeeping
% H = zeros(1,m);

    % Assemble observed alphabet
    Alphabet = unique(X(:));
	
    % Housekeeping
    Frequency = zeros(size(Alphabet));
	
    % Calculate sample frequencies
    for symbol = 1:length(Alphabet)
        Frequency(symbol) = sum(X(:) == Alphabet(symbol));
    end
	
    % Calculate sample class probabilities
    P = Frequency / sum(Frequency);
	
    % Calculate entropy in bits
    % Note: floating point underflow is never an issue since we are
    %   dealing only with the observed alphabet
    H = -sum(P .* log2(P));
end
