function [ii,idx] = isi(event1, varargin)
%ISI return intervals for every event
%
%  i=ISI(a) for each timestamp in vector a, returns the time interval to
%  the next timestamp. For the last timestamp NaN is returned.
%
%  i=ISI(a,b) for each timestamp in a, returns the time interval to the
%  next timestamp in b.
%
%  i=ISI(...,type) where type is one of 'pre', 'post', 'smallest',
%  'largest', will return the previous, next, smallest or largest interval.
%  (default='post'). Note that intervals with preceding timestamp are
%  negative.
%
%  [i,idx]=ISI(...) will also return for each timestamp in a the index of the
%  timestamp in a or b used to compute the interval.
%
%  Examples
%
%      e1 = cumsum( rand(100,1) );
%      e2 = cumsum( rand(150,1) );
%      i = isi( e1, e2, 'smallest');
%
%  See also CSI, INTERVALPRUNE
%

% Copyright 2005-2009 Fabian Kloosterman

if nargin<1 || nargin>3
    help(mfilename)
    return
end

% set default interval type
returntype = 'post';

% check event vector
if ~isnumeric(event1) || ~isvector(event1)
    error('isi:invalidArgument', 'Invalid event times vector')
end

n = numel(event1);

if n==0
    ii = [];
    idx = [];
    return
end

% check interval type
if nargin==3 || (nargin==2 && ischar(varargin{end}))
    returntype = varargin{end};
    if ~ismember( returntype, {'pre', '<', 'post', '>', 'smallest', 'largest'} );
        error('isi:invalidArgument', 'Invalid interval type')
    end
end

% check if second event vector is present
event2 = [];

if (nargin>1) && ~ischar(varargin{1})
    
    event2 = varargin{1};
    
    if ~isnumeric(event2) || ~isvector(event2)
        error('isi:invalidArgument', 'Invalid event times vector')
    end

    if isempty(event2)
        ii = NaN(size(event1));
        idx = NaN(size(event1));
        return
    end
    
end

m = numel(event2);

% compute intervals

if m==0
    
    % auto isi
    i_pre = [NaN ; -diff(event1(:))];
    ind_pre = [NaN 1:n-1]';
    i_post = [diff(event1(:)) ; NaN];
    ind_post = [2:n NaN]';

else 
    % cross isi
    ind_pre = floor( interp1(event2, 1:m, event1, 'linear') )';
    valids = find(~isnan(ind_pre));
    i_pre = NaN(n, 1);
    if ~isempty(valids)
        i_pre(valids) = event2(ind_pre(valids)) - event1(valids);
        i_pre((max(valids)+1):end) = event2(end) - event1((max(valids)+1):end);
        ind_pre((max(valids)+1):end) = m;
    end

    ind_post = ceil( interp1(event2, 1:m, event1, 'linear') )';
    valids = find(~isnan(ind_post));
    i_post = NaN(n, 1);
    if ~isempty(valids)
        i_post(valids) = event2(ind_post(valids)) - event1(valids);
        i_post(1:(min(valids)-1)) = event2(1) - event1(1:(min(valids)-1));
        ind_post(1:(min(valids)-1)) = 1;
    end

end

% assign outputs
switch returntype
    case {'pre','<'}
        ii = i_pre;
    case {'post','>'}
        ii = i_post;
    case 'smallest'
        ii = i_pre;
        m_ind = find( abs(i_post)<=abs(i_pre) );
        ii(m_ind) = i_post(m_ind);
        ii( isnan(i_pre) | isnan(i_post) ) = NaN;
    case 'largest'
        ii = i_pre;
        m_ind = find( abs(i_post)>abs(i_pre) );
        ii(m_ind) = i_post(m_ind);
        ii( isnan(i_pre) | isnan(i_post) ) = NaN;
end

if nargout>=2
    switch returntype
        case {'pre','<'}
            idx = ind_pre;
        case {'post','>'}
            idx = ind_post;
        case 'smallest'
            idx = ind_pre;
            m_ind = find( abs(i_post)<=abs(i_pre) );
            idx(m_ind) = ind_post(m_ind);
            idx( isnan(i_pre) | isnan(i_post) ) = NaN;
        case 'largest'
            idx = ind_pre;
            m_ind = find( abs(i_post)>abs(i_pre) );
            idx(m_ind) = ind_post(m_ind);           
            idx( isnan(i_pre) | isnan(i_post) ) = NaN;
    end
end
