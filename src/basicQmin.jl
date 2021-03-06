function basicQmin{M<:AbstractMatrix}(P::M, m = 100)
  T = eltype(P)
  n = size(P,1)

  Δ = I - spdiagm(ones(T,n-1), 1, n, n)
  H = Δ*P*Δ.'
  h = diag(H)

  c = typemax(T)
  β = one(T)
  λ = one(T)
  R = linspace(zero(T), one(T), m)
  for r in R
    w      = T[1/(r-r^2)/r^i for i in 0:n-1]
    w[end] = w[end]*(1-r)

    if n*log(dot(h,w)) + sum(map(log, 1./w)) < c
      c = n*log(dot(h,w)) + sum(map(log, 1./w))
      β = r
      λ = dot(h,w)/n
    end
  end

  return λ, β
end

function expQmin{M<:AbstractMatrix,T2<:Number}(P::M, ρ::T2, m = 100)
  T = promote_type(eltype(P),T2)
  n = size(P,1)

  Δ = I - spdiagm(ones(T,n-1), 1, n, n)
  H = Δ*P*Δ.'
  h = diag(H)

  c = typemax(T)
  β = one(T)
  λ = one(T)
  R = linspace(zero(T), one(T), m)
  for r in R
    w      = T[1/(r-r^2)/r^i for i in 0:n-1]
    w[end] = w[end]*(1-r)

    if n*log(dot(h,w)) + sum(map(log, 1./w)) < c
      c = n*log(dot(h,w)) + sum(map(log, 1./w))
      β = r
      λ = -(n+1)/2ρ + sqrt((n+1)^2/4ρ^2 + dot(h,w)/ρ)
    end
  end
  return λ, β
end
