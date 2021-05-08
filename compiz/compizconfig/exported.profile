[reflex]
s0_window = true

[cubeaddon]
s0_deformation = 2
s0_sphere_aspect = 0.500000

[put]
as_put_restore_key = Disabled
as_put_pointer_key = Disabled

[crashhandler]
as_start_wm = true
as_wm_cmd = dwm

[wall]
as_allow_wraparound = true
s0_mmmode = 1

[animation]
s0_open_effects = animation:Random;animation:Fade;animation:Fade;animation:None;
s0_open_durations = 200;150;150;50;
s0_open_matches = (type=Normal | Dialog | ModalDialog | Unknown) & !(name=mate-screensaver);(type=Menu | PopupMenu | DropdownMenu);(type=Tooltip | Notification | Utility) & !(name=compiz) & !(title=notify-osd);;
s0_open_options = ;;;;
s0_open_random_effects = animationaddon:Beam Up;animationaddon:Razr;
s0_close_effects = animation:Random;animation:Fade;animation:Fade;
s0_close_random_effects = animationaddon:Beam Up;animationaddon:Burn;animationaddon:Explode;animationaddon:Leaf Spread;animationaddon:Razr;animationaddon:Skewer;

[mag]
as_zoom_in_button = <Super>Button4
as_zoom_out_button = <Super>Button5
s0_zoom_factor = 3.000000
s0_radius = 206

[maximumize]
as_trigger_max_key = <Shift><Super>m
as_trigger_min_key = Disabled

[commands]
as_command0 = urxvt -geometry 200x50
as_command1 = st
as_command2 = dmenu_run_quick
as_run_command0_key = <Super>Return
as_run_command1_key = <Super>numbersign
as_run_command2_key = <Super>p

[switcher]
as_next_key = Disabled
as_prev_key = Disabled
as_next_all_key = <Alt>Tab
as_prev_all_key = <Shift><Alt>Tab
s0_size_multiplier = 2.000000
s0_saturation = 80
s0_brightness = 50
s0_auto_rotate = true

[wobbly]
as_snap_key = Disabled
as_snap_inverted = false
s0_maximize_effect = false

[expo]
as_expo_key = Disabled
as_expo_edge = TopRight
as_expo_immediate_move = true
as_hide_docks = true
as_mipmaps = true
as_multioutput_mode = 1

[move]
as_initiate_button = <Super>Button1
as_initiate_key = Disabled
as_constrain_y = false
as_offscreen_scroll = true
as_offscreen_scroll_down = Disabled
as_offscreen_scroll_up = Disabled
as_offscreen_scroll_right = Disabled
as_offscreen_scroll_left = Disabled

[resize]
as_initiate_button = <Super>Button3
as_initiate_key = Disabled

[workarounds]
as_firefox_menu_fix = true
as_ooo_menu_fix = false
as_java_fix = false
as_aiglx_fragment_fix = false

[core]
as_active_plugins = core;ccp;move;resize;place;decoration;mousepoll;regex;crashhandler;commands;text;snap;animation;animationaddon;cube;3d;ring;rotate;cubeaddon;mag;switcher;expo;
as_audible_bell = false
as_texture_filter = 2
as_click_to_focus = false
as_autoraise = false
as_close_window_key = <Super>c
as_raise_window_button = Disabled
as_lower_window_button = Disabled
as_unmaximize_window_key = Disabled
as_minimize_window_key = Disabled
as_maximize_window_key = Disabled
as_window_menu_button = Disabled
as_show_desktop_key = Disabled
s0_hsize = 3

[cube]
as_unfold_key = Disabled

[scale]
as_initiate_edge = 

[shift]
s0_mode = 1

[3d]
s0_manual_only = false
s0_width = 0.303000
s0_bevel = 4
s0_bevel_bottomleft = true
s0_bevel_bottomright = true

[place]
s0_mode = 5

[firepaint]
as_initiate_button = <Super>Button1

[ring]
as_next_key = Disabled
as_prev_key = Disabled
as_next_all_key = <Super>Tab
as_prev_all_key = <Shift><Super>Tab
s0_speed = 1.000000
s0_timestep = 0.200000
s0_inactive_opacity = 80
s0_select_with_mouse = true
s0_ring_clockwise = true

[decoration]
as_shadow_radius = 8.700000

[rotate]
as_edge_flip_pointer = true
as_raise_on_rotate = true
as_initiate_button = <TopEdge><Super>Button1
as_rotate_left_key = <Super>a
as_rotate_right_key = <Super>d
as_rotate_left_window_key = Disabled
as_rotate_right_window_key = Disabled
s0_sensitivity = 2.000000
s0_acceleration = 3.300000
s0_speed = 1.300000
s0_zoom = 0.300000

