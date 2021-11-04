-------------------------------------------------------------------------------
;; * Main Loop - This should be the last section in the source code.
;
; Main Loop
;

main_loop:
               jsr memory_setup        ; Set-Up memory.
               jsr display_setup       ;  "  "  display.
               jsr char_setup          ;  "  "  custom character display.
               jsr music_setup         ;  "  "  music chip.
               jsr title_screen        ; Display the title screen.
               jsr select_input        ; Select Input Device.

level_loop:
               jsr play_music          ; Start the music playing.
               jsr setup_level         ; Setup the current level.

             - jsr alien_move          ; Move aliens
               jsr missle_move         ;  "   missles
               jsr player_move         ;  "   player
               jsr check_collision     ; Check for collisions
               ldx collision_flag      ; Check collision flag.
               beq -

               dex                     ; Decrease .X by 1 so if X was 1 then
               beq player_die          ;    it_s now 0 so we know player died.
               dex                     ; Decrease .X again so if X was 2 then
               beq alien_die_sound     ;    it_s now 0 so we make alien death.
               jsr end_level           ; If we got here - than end of level.
               jsr wait_next           ; Wait for next keypress.
               jsr increase_level      ; increase level #.
               sec                     ; And go back....
               bcs level_loop

alien_die_sound:
               jsr make_alien_sound    ; make alien sound.
               sec                     ; set carry
               bcs -                   ; and jump back.

player_die     jsr show_player_die     ; Show it on-screen.
               lda lives               ; Check # of lives.
               beq end_of_game         ; If 0 the end-of-game.
               bne level_loop          ; go back and re-start level.
               brk                     ; If we get here - than an error.

end_of_game    jsr end_game_screen     ; Show end-of-game screen.
               jsr high_score_update   ; Update the high score if need-be.
               jsr wait_next           ; Wait for next-game selection.
               lda quit
               beq +
               jsr setup_level_1       ; Set-Up first level.
               sec
               bcs level_loop          ; and start playing it.

             + jmp quit_game
;
; End of Main Loop
;
-------------------------------------------------------------------------------
