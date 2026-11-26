function [U, ok, info] = FindPhaseUnitaries(Tt, Rt, tol, verbose)
%FindPhaseUnitaries Recover per-mode diagonal-unitary phases relating T to R.
%   [U, OK] = FindPhaseUnitaries(T, R) finds, for an N-mode array T (complex)
%   and R (real, nonnegative, same size, same nonzero pattern and same
%   magnitudes), phase vectors U{1},...,U{N} (unit-modulus complex column
%   vectors, one per mode) such that at every nonzero entry (i1,...,iN):
%       T(i1,...,iN) = R(i1,...,iN) * U{1}(i1) * U{2}(i2) * ... * U{N}(iN)
%   OK is true if a consistent solution was found, false if T and R are
%   not related by diagonal unitaries (within TOL).
info = struct('cycle', NaN, 'final', NaN);
T = double(Tt);
R = double(Rt);

if nargin < 3 || isempty(tol),     tol = 1e-19;   end
if nargin < 4 || isempty(verbose), verbose = false; end
sz = size(R);
if ~isequal(size(T), sz)
    error('T and R must be the same size.');
end
N = length(sz);
 
suppTol = 1e-9;
idx_lin = find(R(:) > suppTol);
M = numel(idx_lin);
if M == 0
    error('R has no nonzero entries.');
end
 
% relative, per-entry magnitude check (not one global absolute threshold)
magR = R(idx_lin);
magDiff = abs(abs(T(idx_lin)) - magR);
relDiff = magDiff ./ max(magR, suppTol);
info.mag = max(relDiff);
if any(relDiff > tol)
    if verbose
        [worst, w] = max(relDiff);
        fprintf(['FindPhaseUnitaries: magnitude mismatch at support entry %d ' ...
                 '(|T|=%.6g, R=%.6g, relative diff=%.3g > tol=%.3g)\n'], ...
                 w, abs(T(idx_lin(w))), magR(w), worst, tol);
    end
    ok = false; U = {}; return
end
 
subs = cell(1,N);
[subs{:}] = ind2sub(sz, idx_lin);
Idx = zeros(M, N);
for d = 1:N
    Idx(:,d) = subs{d};
end
 
Q = T(idx_lin) ./ R(idx_lin);   % unit-modulus targets, exact, no logs needed here
 
% ---- Pass 1: fast propagation via direct complex division ----
Uvals = cell(1,N);
known  = cell(1,N);
for d = 1:N
    Uvals{d} = nan(sz(d),1);
    known{d} = false(sz(d),1);
end
for d = 1:N-1                      % gauge: anchor using the first entry
    known{d}(Idx(1,d)) = true;
    Uvals{d}(Idx(1,d)) = 1;
end
 
progress = true;
while progress
    progress = false;
    for r = 1:M
        kn = false(1,N);
        for d = 1:N
            kn(d) = known{d}(Idx(r,d));
        end
        if sum(kn) == N-1
            miss = find(~kn);
            p = 1;
            for d = 1:N
                if kn(d), p = p * Uvals{d}(Idx(r,d)); end
            end
            Uvals{miss}(Idx(r,miss)) = Q(r) / p;
            known{miss}(Idx(r,miss)) = true;
            progress = true;
        end
    end
end
 
all_touched_known = true;
for d = 1:N
    touched = false(sz(d),1);
    touched(unique(Idx(:,d))) = true;
    if any(touched & ~known{d})
        all_touched_known = false;
    end
end
 
if ~all_touched_known
    % ---- Pass 2: hidden cycles remain -> exact cycle-correction fallback ----
    D = sum(sz);
    offset = [0, cumsum(sz(1:end-1))];
    A = zeros(M, D);
    for r = 1:M
        for d = 1:N
            A(r, offset(d) + Idx(r,d)) = 1;
        end
    end
    rhs = angle(Q);
 
    Vperp = null_rational(A.');    % exact rational left-null-space basis
    L = size(Vperp, 2);
    rhs_fixed = rhs;
    info.cycle = 0;
    if L > 0
        [Vr, pivcols] = rref(Vperp.');
        for c = 1:L
            v  = Vr(c,:);
            pc = pivcols(c);
            cyc = v * rhs_fixed;
            k = round(cyc/(2*pi));
            info.cycle = max(info.cycle, abs(cyc - 2*pi*k));
            if abs(cyc - 2*pi*k) > max(tol, 1e-6)
                if verbose
                    fprintf(['FindPhaseUnitaries: cycle %d is inconsistent ' ...
                             '(wrapped sum = %.6g rad, nearest 2*pi*k = %.6g, ' ...
                             'residual = %.3g)\n'], c, cyc, 2*pi*k, cyc-2*pi*k);
                end
                ok = false; U = {}; return
            end
            if k ~= 0
                rhs_fixed(pc) = rhs_fixed(pc) - 2*pi*k / v(pc);
            end
        end
    end
 
    %sol = A \ rhs_fixed;
    sol = lsqminnorm(A, rhs_fixed);
    for d = 1:N
        Uvals{d} = exp(1i*sol(offset(d)+1 : offset(d)+sz(d)));
    end
end
 
% ---- final verification (authoritative pass/fail check) ----
ok = true;
residAll = zeros(M, 1);
for r = 1:M
    p = R(idx_lin(r));
    for d = 1:N
        p = p * Uvals{d}(Idx(r,d));
    end
    residAll(r) = abs(p - T(idx_lin(r))) / max(1, R(idx_lin(r)));
end
[info.final, w] = max(residAll);
ok = info.final <= max(tol, 1e-6);
if ~ok && verbose
    fprintf('FindPhaseUnitaries: final check failed at support entry %d (residual=%.3g)\n', w, info.final);
end
 
if ~ok
    U = {};
    return
end
 
U = cell(1,N);
for d = 1:N
    u = Uvals{d};
    u(isnan(u)) = 1;      % untouched indices: free choice, default to 1
    U{d} = u;
end
end
 
function Z = null_rational(M)
%NULL_RATIONAL Exact rational basis for the null space of M, via rref.
%   Works identically in MATLAB and Octave (unlike null(A,'r'), which is
%   MATLAB-only). Avoids floating-point SVD mixing overlapping cycles.
    [Rr, pivcols] = rref(M);
    ncols = size(M,2);
    freecols = setdiff(1:ncols, pivcols);
    nfree = length(freecols);
    Z = zeros(ncols, nfree);
    for k = 1:nfree
        fc = freecols(k);
        Z(fc, k) = 1;
        for p = 1:length(pivcols)
            Z(pivcols(p), k) = -Rr(p, fc);
        end
    end
end
