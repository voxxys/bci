

lib = lsl_loadlib();
res = lsl_resolve_all(lib,5.0)

inlet_1 = lsl_inlet(res{1});
inf_1 = inlet_1.info();
fprintf([inf_1.as_xml() '\n']);

inlet_2 = lsl_inlet(res{2});
inf_2 = inlet_2.info();
fprintf([inf_2.as_xml() '\n']);


