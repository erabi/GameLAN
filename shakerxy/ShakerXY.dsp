declare name "ShakerXY";
declare author "Développement Grame - CNCM par Elodie Rabibisoa et Romain Constant.";

import ("stdfaust.lib");

shake_type = hslider("[1]Shakers[style:radio {'25 bpm':0;'50 bpm':1;'100 bpm':2}]", 0, 0, 2, 1);

shake_x = hslider("Shaker X [acc: 0 0 -13 0 13][hidden:1]", 0, -100, 100, 0.001);
shake_y = hslider("Shaker Y [acc: 1 0 -14 0 14][hidden:1]", 0, -100, 100, 0.001);

shaker_sound(0,n) = so.loop(soundfile("Shaker X [url:{'Shakerxy_percutom_25bpm.flac';'Shakerxy_springmetal_50bpm.flac'; 'Shakerxy_808_kicksnare_100bpm.flac'}]", 1), n);
shaker_sound(1,n) = so.loop(soundfile("Shaker Y [url:{'Shakerxy_triangle_25bpm.flac';'Shakerxy_glupsdrum_50bpm.flac'; 'Shakerxy_808_hh_100bpm.flac'}]", 1), n);

well(0) = +((abs(shake_x + shake_x')) > 100) ~ *(0.99) : min(1) : max(0);
well(1) = +((abs(shake_y + shake_y')) > 120) ~ *(0.99) : min(1) : max(0);

env(n) = en.smoothEnvelope(0.05, well(n));

on_off = checkbox("[0]ON / OFF");

process = par(i, 2, shaker_sound(i, shake_type) * env(i)) :> _ * on_off <: _,_;