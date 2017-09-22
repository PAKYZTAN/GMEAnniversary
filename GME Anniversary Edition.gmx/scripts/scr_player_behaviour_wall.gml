///scr_player_behaviour_wall()

/*
**  Usage:
**      scr_player_behaviour_wall()
**
**  Purpose:
**      Handles the actions of a player what they are in contact of a wall.
*/

if (yspeed > 0) 
&& (!crouch) 
&& (!flying)
&& (!stompstyle) 
&& (holding == 0) 
&& (global.mount = 0) 
&& (global.powerup != cs_frog)
&& (!instance_exists(obj_spinner)) {
        
    //If the 'Right' key is pressed and the player is facing right.
    if ((keyboard_check(vk_right)) && (xscale == 1)) {
        
        if (collision_line(bbox_right,bbox_top,bbox_right+2,bbox_bottom,obj_solid,0,1)) {
            
            wallkick = 1;
            wallready = 0;
        }            
        else
            wallkick = 0;
    }
    
    //Otherwise, if the 'Left' key is pressed and the player is facing left.
    else if ((keyboard_check(vk_left)) && (xscale == -1)) {
        
        if (collision_line(bbox_left-2,bbox_top,bbox_left,bbox_bottom,obj_solid,0,1))  {
            
            wallkick = 1;
            wallready = 1;
        }
        else
            wallkick = 0;
    }
    else
        wallkick = 0;
}

//Handle wall kick
if (wallkick == 1) {

    //End manually wall kick
    if ((state < 2) || (swimming))
        wallkick = 0;

    //If the player does have the cat powerup.
    if ((global.powerup == cs_cat)
    && (keyboard_check(vk_up))
    && (catclimbing < (global.cattime * 60))) {
            
        //Increase cat climb
        catclimbing++;    
        
        //Move up
        yspeed -= 0.5;
        
        //No grav
        ygrav = 0;
        
        //Prevent the playing from climbing too fast.
        if (yspeed < -1.5)
            yspeed = -1.5;  
    }
    else {
    
        //Slow down cat mario
        if (global.powerup == cs_cat) {
        
            if (yspeed < 1.5)
                yspeed += 0.025;
        }
    
        //Prevent the player from falling too fast.
        if (yspeed > 1.5)
            yspeed = 1.5;   
    }

    //If the 'Jump' key is being pressed.
    if (keyboard_check_pressed(vk_shift)) {
    
        //Set the vertical speed
        yspeed = jumpstr*-1.047;
        
        //Allow variable jump
        jumping = 1;
        
        //Allow wallkick
        alarm[7] = 20;
    
        //If the 'Right' key is pressed and the player is facing right.
        if ((xscale > 0) && (keyboard_check(vk_right)) && (!keyboard_check(vk_left))) {
        
            //Set the horizontal speed
            xspeed = xspeedmax*-0.8;
            
            //Move 2 pixels to the left
            x -= 2;
            
            //End walljump
            wallkick = 2;
            
            //Facing direction
            xscale = -1;
            
            //Play 'Stomp' sound
            audio_play_sound(snd_stomp,1,0);
            
            //Create effect
            with (instance_create(x+3,y+8,obj_smoke))
                sprite_index = spr_spinthump;
        }
        
        else if ((xscale < 0) && (keyboard_check(vk_left)) && (!keyboard_check(vk_right))) {
        
            //Set the horizontal speed.
            xspeed = xspeedmax*+0.8;
            
            //Move 2 pixels to the right
            x += 2;
                        
            //End walljump
            wallkick = 2;            
            
            //Facing direction
            xscale = 1;
            
            //Play 'Stomp' sound
            audio_play_sound(snd_stomp,1,0);
            
            //Create effect
            with (instance_create(x-9,y+8,obj_smoke))
                sprite_index = spr_spinthump;        
        }
    }
}
