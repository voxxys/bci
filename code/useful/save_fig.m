function save_fig(fpath_out, fmt, res)
% Usage: save_fig(fpath_out, fmt, res)

    init_var('fmt', '''bmp''');
    init_var('res', '192');

    fmt_str = ['-d' fmt];
    res_str = ['-r' num2str(res)];

    set(gcf, 'PaperPositionMode', 'auto');
    print(gcf, fpath_out, fmt_str, res_str);
    
end

