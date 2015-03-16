function col = get_rich_color(n)

colors = [1 0 0; 0 0 1; 0 1 0; 1 0 1; 0 1 1; 1 1 0];
colors = [[0 0 0]; colors; colors/2];

ncolors = size(colors,1);

n = mod(n, ncolors);

col = colors(n,:);


end

