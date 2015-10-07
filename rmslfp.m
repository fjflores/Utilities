function signal = rmslfp(lfp,epoch)

% compute rms values for a given lfp/eeg channel per epoch

nSampEpoch = floor(epoch*Fs); % number of samples in epoch
vEpochs = 1:floor(length(lfp)./nSampEpoch); % vector with number of epochs in the whole recording
subsPrim = repmat(vEpochs,nSampEpoch,1); % generate index matrix for accumarray
subs = subsPrim(:); % generate index vector for accumarray
clear subsPrim
remain = sigs(length(subs)+1:end); % save the lfp portion left out
lfp(length(subs)+1:end) = []; % erase non-stageable epoch
rms = zeros(vEpochs(end),1); % allocate memory for rms values per epoch
normLfp = accumarray(subs,sigs(:,i),[],@(x)norm(x));
rms = normLfp./sqrt(nSampEpoch).*ones(vEpochs(end),1);
clear normSigs
