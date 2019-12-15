// Based on the Layout by cools / Arcade Otaku (http://www.arcadeotaku.com)
// Amended and optimized for vertical screens
// Source: https://bit.ly/simpleVertical
///////////////////////////////////////////////////////// 

// Layout Constants
fe.layout.width=240;
fe.layout.height=320;
fe.layout.orient=RotateScreen.Right;
fe.layout.preserve_aspect_ratio=true;

local lw=fe.layout.width;
local lh=fe.layout.height;
local bgx=(lw/8)*-1;
local bgy=(lh/8)*-1
local bgw=(lw/4)*5;
local bgh=(lh/4)*5;

// Function Game name text
// We do this in the layout as the frontend doesn't chop up titles with a forward slash
function gamename( index_offset ) {
 local s = split( fe.game_info( Info.Title, index_offset ), "(/[" );
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
local bg = fe.add_artwork("snap", bgx, bgy, bgw, bgh);
local bgmask = fe.add_image ("bgmask.png", 0, 0, lw, lh);

// Game title background
local titlebg = fe.add_image ("titlemask.png", 0, 270, lw, lh-270);
titlebg.set_rgb (0,0,0);

// Flyer image
local flyeroutline = fe.add_artwork( "flyer", 110, 100, lw*0.5, lh*0.5);
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
local logoshadow = fe.add_artwork( "wheel", 7, 20, 200, 100);
logoshadow.preserve_aspect_ratio = true;
logoshadow.set_rgb(0,0,0);
logoshadow.alpha = 192;
local logo = fe.add_clone( logoshadow );
logo.set_rgb (255,255,255);
logo.x = logo.x - 2;
logo.y = logo.y - 2;
logo.alpha=255; 

// Game title text
local gametitleshadow = fe.add_text(gamename(0), 11, 271, lw - 10, 15 );
gametitleshadow.align = Align.Left;
gametitleshadow.set_rgb (0,0,0);
local gametitle = fe.add_text(gamename(0), 10, 270, lw - 10, 15 );
gametitle.align = Align.Left;

// Copyright text
local copy = fe.add_text(copyright(0), 12, 285, lw - 30, 10 );
copy.align = Align.Left;

// Category
local cat = fe.add_text("[Category]", 12, 295, lw - 12, 10 );
cat.align = Align.Left;

// Number entries
local entries = fe.add_text( "[ListEntry]/[ListSize]", 10, 255, 240, 15 );
entries.align = Align.Left;
entries.alpha = 32;

// Filter
local filter = fe.add_text( "[FilterName]", -20, 267, 280, 50 );
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