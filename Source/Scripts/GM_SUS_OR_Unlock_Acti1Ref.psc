Scriptname GM_SUS_OR_Unlock_Acti1Ref extends ObjectReference  
{This is used on the GM_SUS_Unlock_Acti1Ref1. It uses the GM_SUS_Unlock_Qust1 to find the nearest locked object.}

; =============================================================
; VARIABLES
; =============================================================

; Properties -----------------------------------------------------

Actor                   Property        _PLAYERREF          Auto
{Set this to the player reference.}

EffectShader            Property        _EFFECT1            Auto
{This effect applies to the locked object when the script unlocks it.}

Perk[]                  Property        _PERK_ARRAY         Auto
{Check if the player has the alteration cost reduction perk.}

Quest                   Property        _QUEST1             Auto
{The GM_SUS_Unlock_Qust1 is used to fill the aliases.}

ReferenceAlias          Property        _REFALIAS1          Auto
{The LockedTarget alias that the quest uses to select the nearest locked object.}

Sound                   Property        _SOUND1             Auto
{Sound effect that plays when the object is unlocked.}
Sound                   Property        _SOUND2             Auto
{Sound effect that plays if the player does not have enough magicka.}

; Private -----------------------------------------------------

ObjectReference         _locked_or

; =============================================================
; EVENTS
; =============================================================

Event OnActivate(ObjectReference a_activator)
    
    If (!GetState()) ;make sure it isn’t already running to prevent a ctd from a double spell cast

        GotoState("Moved")

    EndIf

EndEvent

; =============================================================
; FUNCTIONS
; =============================================================

Function UnlockTarget(bool a_bool = false, float a_mag = 0.0, float a_skill = 0.0) ;performs the unlock procedure on the LockedTarget object
    
    float _skill_f  = _PLAYERREF.GetActorValue("Alteration")
    float _mod_f    = _PLAYERREF.GetActorValue("AlterationMod")

    If (_mod_f < 100) ;if the player has an alteration magicka cost reduction modifier that is at 100% or greater, set the magicka cost to 0
        
        a_mag *= ( 1 - ( _mod_f / 100 ) ) * ( 1 - Math.Pow( ( _skill_f / 400 ), 0.65 ) ) ;performs a similar magicka cost calculation to the base game since the spell doesn’t have a cost associated with it

        If (a_bool) ;halves the magicka cost if the player has the corresponding alteration perk
        
            Debug.Trace("player has reduction perk!")
            a_mag /= 2

        EndIf

    Else
        
        a_mag = 0

    EndIf

    If (a_mag > _PLAYERREF.GetActorValue("Magicka")) ;ensures the player has enough magicka to unlock the object

        _SOUND2.Play(_PLAYERREF)
        Debug.Notification("You need at least " + a_mag as int + " magicka to alter this lock.")
    
    Else
        
        Debug.Trace("magicka cost = " + a_mag)
        _PLAYERREF.DamageActorValue("Magicka", a_mag)
        _locked_or.Lock(false)
        _SOUND1.Play(_locked_or)
        _EFFECT1.Play(_locked_or, 1.0)
        Game.AdvanceSkill("Alteration", a_skill)
            
    EndIf
    
EndFunction

Function CheckLockLvl(int a_value) ;checks the lock level of the object and executes the UnlockTarget function with the appropriate parameters
    
    If (a_value < 2)            ;Novice
        
        UnlockTarget(_PLAYERREF.HasPerk(_PERK_ARRAY[0]) , 80 , 20)
    
    ElseIf (a_value < 26)       ;Apprentice
        
        UnlockTarget(_PLAYERREF.HasPerk(_PERK_ARRAY[1]) , 160 , 40)

    ElseIf (a_value < 51)       ;Adept
        
        UnlockTarget(_PLAYERREF.HasPerk(_PERK_ARRAY[2]) , 240 , 60)

    ElseIf (a_value < 76)       ;Expert
        
        UnlockTarget(_PLAYERREF.HasPerk(_PERK_ARRAY[3]) , 320 , 80)

    ElseIf (a_value < 255)      ;Master
        
        UnlockTarget(_PLAYERREF.HasPerk(_PERK_ARRAY[4]) , 400 , 100)

    Else                        ;Key
        
        Debug.Notification("This lock cannot be altered. It requires a key to open.")

    EndIf

EndFunction

; =============================================================
; STATES
; =============================================================

State Moved
    ;go to this state when activated to start opening a lock

    Event OnBeginState()

        _QUEST1.Start()
        _locked_or = _REFALIAS1.GetReference()

        If (!_locked_or) ;stop the script if the quest doesn’t fill the LockedTarget alias

            GotoState("")
            return

        EndIf

        Debug.Trace("LockedTarget = " + _locked_or)
        CheckLockLvl(_locked_or.GetLockLevel())
        GotoState("")

    EndEvent



    Event OnEndState()

        Debug.Trace("finished!")
        _QUEST1.Stop()

    EndEvent

EndState