function y = f1(x)
  y = x.^2;
  y(y < .1) = 0;
end
