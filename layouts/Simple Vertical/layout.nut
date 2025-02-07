// Based on the Layout by cools / Arcade Otaku (http://www.arcadeotaku.com)
// Amended and optimized for vertical screens
// Source: https://bit.ly/simpleVertical
///////////////////////////////////////////////////////// 

// Layout User Options
class UserConfig {
 </label="Rotate",help="Change screen rotation left or right",options="Left,Right"/>uc_rotate="Right";
 </label="Show Sets",help="Show set names in title",options="Yes,No"/>uc_show_sets="Yes";
}
local my_config=fe.get_config();

// Layout Constants
fe.layout.width=480;
fe.layout.height=640;
fe.layout.preserve_aspect_ratio=true;

local lw=fe.layout.width;
local lh=fe.layout.height;

// Set screen rotation according user config
if(my_config["uc_rotate"] == "Right")
    fe.layout.orient=RotateScreen.Right;
else
    fe.layout.orient=RotateScreen.Left; 

// Function Game name text
// Return original or remove the set names according to user configuration
// We do this in the layout as the frontend doesn't chop up titles with a forward slash
function gamename( index_offset ) {

 if(my_config["uc_show_sets"]=="Yes")
    return fe.game_info(Info.Title, index_offset)

 local s = split( fe.game_info(Info.Title, index_offset), "(/[" );
 if ( s.len() > 0 ) return s[0];
 return "";
}

// Function Copyright text
function copyright( index_offset ) {
 local s = split( fe.game_info( Info.Manufacturer, index_offset ), "(" );
 if ( s.len() > 0 ) return "© " + fe.game_info( Info.Year, index_offset ) + " " + s[0];
 return "";
}

// Background Image
local bgx=(lw/8)*-1;
local bgy=(lh/8)*-1
local bgw=(lw/4)*5;
local bgh=(lh/4)*5;
local bg = fe.add_artwork("snap", bgx, bgy, bgw, bgh);
local bgmask = fe.add_image("bgmask.png", bgx, bgy, bgw, bgh);

// Game title background
local titlebg_x = (lh/6)*5;
local titlebg_h = (lh-titlebg_x)*1.5
local titlebg = fe.add_image("titlemask.png", 0, titlebg_x, lw, titlebg_h);
titlebg.set_rgb (0,0,0);

// Flyer image
local flyeroutline = fe.add_artwork( "flyer", lw/2.1, lh/3.5, lw*0.5, lh*0.5);
flyeroutline.preserve_aspect_ratio=true;
flyeroutline.rotation = 5
local flyer = fe.add_clone( flyeroutline );
flyeroutline.x = flyeroutline.x - 1;
flyeroutline.y = flyeroutline.y - 1;
flyeroutline.width = flyeroutline.width + 2;
flyeroutline.height = flyeroutline.height + 2;
flyeroutline.set_rgb (0,0,0);
flyeroutline.alpha = 192;

// Logo image
local logoshadow = fe.add_artwork( "wheel", lw*0.05, lh*0.02, lw*0.85, lh*0.4);
logoshadow.preserve_aspect_ratio = true;
logoshadow.set_rgb(0,0,0);
logoshadow.alpha = 192;
local logo = fe.add_clone( logoshadow );
logo.set_rgb (255,255,255);
logo.x = logo.x - 2;
logo.y = logo.y - 2;
logo.alpha=255; 

// Game title text
local text_y = lw*0.02;
local text_h1 = lh*0.04;
local gametitle_x = titlebg_x+text_y/2;
local gametitleshadow = fe.add_text(gamename(0), text_y+1, gametitle_x+1, lw-text_y, text_h1);
gametitleshadow.align = Align.Left;
gametitleshadow.set_rgb (0,0,0);
local gametitle = fe.add_text(gamename(0), text_y, gametitle_x, lw-text_y, text_h1);
gametitle.align = Align.Left;

// Number entries
local entries_x = titlebg_x-text_h1;
local entries = fe.add_text("[ListEntry]/[ListSize]", text_y, entries_x, lw-text_y, text_h1);
entries.align = Align.Left;
entries.alpha = 60;

// Copyright text
local text_h2 = lh*0.03;
local copyright_x = gametitle_x+text_h1;
local copy = fe.add_text(copyright(0), text_y, copyright_x, lw-text_y, text_h2);
copy.align = Align.Left;

// Category
local category_x = copyright_x+text_h2;
local cat = fe.add_text("[Category]", text_y, category_x, lw-text_y, text_h2);
cat.align = Align.Left;

// Filter
local filter = fe.add_text( "[FilterName]", 0, titlebg_x, lw*1.1, lh-titlebg_x);
filter.align = Align.Right;
filter.alpha = 32;

// Transitions
// Update game title and copyright text
fe.add_transition_callback( "fade_transitions" );
function fade_transitions( ttype, var, ttime ) {
 switch ( ttype ) {
  case Transition.ToNewList:
   var = 0;
  case Transition.ToNewSelection:
   gametitleshadow.msg = gamename ( var );
   gametitle.msg = gametitleshadow.msg;
   copy.msg = copyright ( var );
   break;
  }
 return false;
}